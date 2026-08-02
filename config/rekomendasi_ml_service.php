<?php
/**
 * rekomendasi_ml_service.php
 * -----------------------------------------------------------------
 * Service layer untuk menghubungkan aplikasi PHP dengan model ML
 * hybrid filtering (Flask, config/app.py + web_model_artifacts/hybrid_model.pkl).
 *
 * KENAPA FILE INI ADA (bukan langsung panggil API dari halaman pesan):
 * Model ML dilatih dari dataset SINTETIS (synthetic_fooddelivery_dataset
 * + nutrition.csv), BUKAN dari data transaksi/menu asli MauFood. Artinya:
 *   - Nama menu yang dikembalikan model (mis. "Ayam goreng Kentucky paha",
 *     "Martabak india") hampir pasti TIDAK ADA di tabel `menu` MauFood.
 *   - ID pelanggan yang dikenal model (CUST_001..CUST_500) BUKAN member_id
 *     asli MauFood, sehingga tidak boleh disamakan begitu saja.
 *
 * Karena itu file ini WAJIB melakukan:
 *   1. Pencocokan nama menu hasil ML terhadap tabel `menu` asli (bukan
 *      asumsi semua hasil valid).
 *   2. Fallback otomatis ke rekomendasi berbasis popularitas dari data
 *      transaksi ASLI jika hasil ML tidak cukup/tidak nyambung/API mati.
 *
 * Dengan begitu fitur tetap aman dipakai di produksi meski modelnya
 * belum dilatih ulang dengan data MauFood yang sesungguhnya.
 * -----------------------------------------------------------------
 */

// Samakan dengan port di config/app.py (app.run(..., port=ML_API_PORT))
if (!defined('ML_API_BASE_URL')) {
    define('ML_API_BASE_URL', 'http://localhost:8888');
}
// Timeout pendek supaya jika Flask mati, halaman pesan tidak ikut lambat/hang
if (!defined('ML_API_TIMEOUT_SECONDS')) {
    define('ML_API_TIMEOUT_SECONDS', 2);
}
// Minimal jumlah menu hasil ML yang berhasil dicocokkan ke DB asli
// sebelum kita anggap hasil ML "layak tampil". Di bawah ini -> fallback.
if (!defined('ML_MIN_MATCHED_ITEMS')) {
    define('ML_MIN_MATCHED_ITEMS', 3);
}

/**
 * Cek apakah service Flask ML hidup dan modelnya berhasil dimuat.
 */
function mlServiceIsHealthy(): bool
{
    $ch = curl_init(ML_API_BASE_URL . '/health');
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, ML_API_TIMEOUT_SECONDS);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, ML_API_TIMEOUT_SECONDS);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    return $httpCode === 200 && !empty($response);
}

/**
 * Panggil endpoint /recommend di Flask.
 *
 * PENTING soal $identifier: JANGAN kirim member_id asli MauFood yang
 * diformat ulang jadi "CUST_XXX" berharap ketemu (mis. member_id=1 ->
 * "CUST_001"). Itu akan SALAH: CUST_001 di model adalah pelanggan
 * sintetis acak, bukan member MauFood dengan id=1 — hasilnya rekomendasi
 * "collaborative filtering" yang seolah-olah personal padahal ngawur.
 * Karena itu kita selalu pakai prefix "MEMBER_" yang dijamin TIDAK ADA
 * di data training model (index-nya cuma "CUST_001".."CUST_500"),
 * supaya model selalu jatuh ke jalur cold-start (popularity) yang jujur,
 * bukan collaborative filtering palsu.
 *
 * @return array|null  null jika gagal total (network/timeout/HTTP error)
 */
function callMlRecommend(int $memberId, int $topN = 10): ?array
{
    $identifier = 'MEMBER_' . $memberId;
    $url = ML_API_BASE_URL . '/recommend?user_id=' . urlencode($identifier) . '&top_n=' . (int) $topN;

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, ML_API_TIMEOUT_SECONDS);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, ML_API_TIMEOUT_SECONDS);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curlError = curl_error($ch);
    curl_close($ch);

    if ($curlError || $httpCode !== 200 || !$response) {
        error_log("[rekomendasi_ml_service] Panggilan ML API gagal (HTTP $httpCode): $curlError");
        return null;
    }

    $decoded = json_decode($response, true);
    if (!is_array($decoded)) {
        return null;
    }

    return $decoded;
}

/**
 * Cocokkan hasil rekomendasi ML (nama menu dari dataset sintetis) dengan
 * tabel `menu` asli MauFood. Pencocokan case-insensitive & trim spasi
 * karena beberapa nama di dataset training punya spasi ganda/trailing
 * (mis. "Martabak Telur ").
 *
 * @param array $mlResults  [['Menu' => string, 'Hybrid Score' => float], ...]
 * @return array  Baris menu asli (id, nama_menu, harga, gambar, kategori)
 *                yang berhasil dicocokkan, ditambah field 'hybrid_score' (0-100)
 */
function matchMlResultsToRealMenu(mysqli $conn, array $mlResults): array
{
    if (empty($mlResults)) {
        return [];
    }

    $result = mysqli_query($conn, "SELECT id, nama_menu, kategori, harga, gambar FROM menu");
    if (!$result) {
        return [];
    }

    // Index tabel menu asli by nama ternormalisasi (lower + trim) untuk lookup O(1)
    $menuByNormalizedName = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $normalized = strtolower(trim($row['nama_menu']));
        $menuByNormalizedName[$normalized] = $row;
    }

    $matched = [];
    foreach ($mlResults as $item) {
        if (!isset($item['Menu'])) {
            continue;
        }
        $normalized = strtolower(trim($item['Menu']));
        if (isset($menuByNormalizedName[$normalized])) {
            $row = $menuByNormalizedName[$normalized];
            $row['hybrid_score'] = round((float) ($item['Hybrid Score'] ?? 0) * 100, 1);
            $row['sumber'] = 'ai';
            $matched[] = $row;
        }
    }

    return $matched;
}

/**
 * Fallback: rekomendasi berbasis popularitas dari data transaksi ASLI
 * MauFood (bukan data sintetis). Dipakai kalau ML API mati, atau hasil
 * ML tidak cukup nyambung dengan menu asli.
 *
 * @param int[] $excludeMenuIds  Menu yang mau dikecualikan (mis. sudah di keranjang)
 */
function rekomendasiPopulerAsli(mysqli $conn, int $limit = 6, array $excludeMenuIds = []): array
{
    $excludeClause = '';
    if (!empty($excludeMenuIds)) {
        $ids = implode(',', array_map('intval', $excludeMenuIds));
        $excludeClause = "WHERE m.id NOT IN ($ids)";
    }

    $limit = (int) $limit;
    $sql = "
        SELECT m.id, m.nama_menu, m.kategori, m.harga, m.gambar,
               COALESCE(SUM(dp.jumlah), 0) AS total_terjual
        FROM menu m
        LEFT JOIN detail_pesanan dp ON dp.menu_id = m.id
        $excludeClause
        GROUP BY m.id
        ORDER BY total_terjual DESC, m.id ASC
        LIMIT $limit
    ";

    $result = mysqli_query($conn, $sql);
    if (!$result) {
        return [];
    }

    $rows = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $row['hybrid_score'] = null; // tidak relevan utk popularitas biasa
        $row['sumber'] = 'populer';
        $rows[] = $row;
    }

    return $rows;
}

/**
 * FUNGSI UTAMA — panggil ini dari halaman pemesanan.
 *
 * Alur:
 *   1. Cek Flask hidup. Jika tidak -> langsung fallback popularitas asli.
 *   2. Minta rekomendasi ML (selalu cold-start, lihat callMlRecommend()).
 *   3. Cocokkan nama menu hasil ML ke tabel menu asli.
 *   4. Jika hasil cocok >= ML_MIN_MATCHED_ITEMS -> pakai hasil ML.
 *      Jika kurang -> lengkapi sisanya dengan rekomendasi populer asli
 *      (supaya UI tidak pernah kosong / setengah-setengah).
 *
 * @return array{items: array, sumber_utama: string}
 *   sumber_utama: 'ai' | 'populer' — dipakai UI utk label singkat
 */
function getRekomendasiUntukMember(mysqli $conn, int $memberId, int $limit = 6, array $excludeMenuIds = []): array
{
    if (!mlServiceIsHealthy()) {
        return [
            'items' => rekomendasiPopulerAsli($conn, $limit, $excludeMenuIds),
            'sumber_utama' => 'populer',
            'catatan' => 'Layanan model ML tidak aktif, menampilkan menu terpopuler.',
        ];
    }

    $mlResults = callMlRecommend($memberId, max($limit * 3, 15)); // minta lebih banyak, krn banyak yg tak akan cocok

    if ($mlResults === null) {
        return [
            'items' => rekomendasiPopulerAsli($conn, $limit, $excludeMenuIds),
            'sumber_utama' => 'populer',
            'catatan' => 'Model ML gagal merespons, menampilkan menu terpopuler.',
        ];
    }

    $matched = matchMlResultsToRealMenu($conn, $mlResults);

    // Buang item yang sedang di keranjang
    if (!empty($excludeMenuIds)) {
        $excludeSet = array_flip($excludeMenuIds);
        $matched = array_values(array_filter($matched, fn($m) => !isset($excludeSet[(int) $m['id']])));
    }

    if (count($matched) >= ML_MIN_MATCHED_ITEMS) {
        return [
            'items' => array_slice($matched, 0, $limit),
            'sumber_utama' => 'ai',
            'catatan' => null,
        ];
    }

    // Hasil ML terlalu sedikit yang nyambung -> lengkapi dgn populer asli,
    // hindari duplikat id yang sudah ada di $matched
    $matchedIds = array_map(fn($m) => (int) $m['id'], $matched);
    $sisaLimit = $limit - count($matched);
    $pelengkap = rekomendasiPopulerAsli($conn, $sisaLimit, array_merge($excludeMenuIds, $matchedIds));

    return [
        'items' => array_merge($matched, $pelengkap),
        'sumber_utama' => count($matched) > 0 ? 'campuran' : 'populer',
        'catatan' => 'Hasil model ML terbatas (data latih model belum mencakup menu ini), dilengkapi dengan menu terpopuler.',
    ];
}
