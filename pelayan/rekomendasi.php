<?php
/**
 * rekomendasi.php
 * -----------------------------------------------------------------
 * Helper algoritma rekomendasi menu untuk pelayan restoran.
 * VERSI BARU: Terintegrasi dengan Backend Python Flask (Machine Learning).
 *
 * Skrip ini bertugas sebagai API Client yang akan mengirim parameter
 * ke endpoint Flask (app.py) dan memproses hasil JSON-nya, lalu 
 * menggabungkannya dengan data riil dari database (seperti harga/gambar).
 * -----------------------------------------------------------------
 */

/**
 * Meminta rekomendasi menu dari API Python dan menggabungkannya dengan DB.
 *
 * @param mysqli $conn             Koneksi ke database MySQL
 * @param string $userId           ID pelanggan (misal: 'U001' untuk pelanggan lama, 'U_BARU' jika baru)
 * @param bool $isPelangganBaru    True jika pelanggan belum punya riwayat, False jika pelanggan lama
 * @param string|null $kategori    Filter kategori dari dialog (contoh: 'Makanan Utama')
 * @param string|null $bahan       Filter bahan dari dialog (contoh: 'Ayam')
 * @param string|null $rasa        Filter rasa dari dialog (contoh: 'Pedas')
 * @return array                   Daftar baris menu lengkap dengan skor dan metode dari API
 */
function rekomendasikanMenu(
    mysqli $conn,
    string $userId,
    bool $isPelangganBaru,
    ?string $kategori = '',
    ?string $bahan = '',
    ?string $rasa = ''
): array {
    // 1. Endpoint Backend Python (Sesuaikan host/port jika Python di-hosting terpisah)
    $apiUrl = 'http://localhost:5000/api/recommend';

    // 2. Siapkan Payload (Sesuai dengan yang dibutuhkan app.py)
    $payload = json_encode([
        'user_id' => $userId,
        'is_pelanggan_baru' => $isPelangganBaru,
        'kategori' => $kategori ?? '',
        'bahan' => $bahan ?? '',
        'rasa' => $rasa ?? ''
    ]);

    // 3. Setup & Eksekusi cURL untuk menembak API Python
    $ch = curl_init($apiUrl);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Accept: application/json'
    ]);
    curl_setopt($ch, CURLOPT_TIMEOUT, 5); // Timeout 5 detik agar web tidak hang jika Python mati

    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curlError = curl_error($ch);
    curl_close($ch);

    // 4. Validasi Respon API
    if ($response === false || $httpCode !== 200) {
        error_log("Error API Python: " . $curlError . " | HTTP Code: " . $httpCode);
        return []; // Kembalikan array kosong jika API Python mati/error
    }

    $responseData = json_decode($response, true);
    if (!isset($responseData['status']) || $responseData['status'] !== 'success') {
        error_log("API Python merespon dengan error: " . ($responseData['message'] ?? 'Unknown'));
        return [];
    }

    $rekomendasiAPI = $responseData['data'] ?? [];
    if (empty($rekomendasiAPI)) {
        return [];
    }

    // 5. Ekstraksi ID Menu dari API dan Ambil Detailnya dari Database MySQL
    $hasil = [];
    $ids = [];
    $skorMap = [];
    $metodeMap = [];

    // Mapping hasil dari Python (ID, Skor, Metode)
    foreach ($rekomendasiAPI as $item) {
        $mid = (int) $item['ID_Menu'];
        $ids[] = $mid;
        $skorMap[$mid] = $item['skor'];
        $metodeMap[$mid] = $item['metode'];
    }

    $idsEscaped = implode(',', $ids);
    if ($idsEscaped !== '') {
        // ORDER BY FIELD digunakan agar urutan ranking yang diberikan oleh Python tidak berantakan
        $query = "SELECT * FROM menu WHERE id IN ($idsEscaped) ORDER BY FIELD(id, $idsEscaped)";
        $result = mysqli_query($conn, $query);
        
        while ($row = mysqli_fetch_assoc($result)) {
            $mid = (int) $row['id'];
            
            // Tambahkan atribut dari Python ke dalam array hasil MySQL
            $row['skor_rekomendasi'] = $skorMap[$mid];
            $row['metode_rekomendasi'] = $metodeMap[$mid];
            
            $hasil[] = $row;
        }
    }

    return $hasil;
}
?>