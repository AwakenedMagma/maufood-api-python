<?php
/**
 * model_rekomendasi.php
 * -----------------------------------------------------------------
 * FILE INI SUDAH DEPRECATED — jangan di-include lagi.
 *
 * Ini adalah prototipe awal jembatan PHP -> Flask ML yang punya 3 masalah:
 *   1. Memanggil port 8888 padahal Flask (config/app.py) waktu itu jalan
 *      di port 5000.
 *   2. User ID di-hardcode ($loggedInUserIdInt = 1), bukan dari session.
 *   3. Tidak pernah di-include di halaman manapun, jadi tidak pernah
 *      benar-benar aktif.
 *
 * Semua sudah diperbaiki & digantikan oleh:
 *   -> config/rekomendasi_ml_service.php
 *
 * Pakai seperti ini dari halaman pemesanan:
 *
 *   include '../config/rekomendasi_ml_service.php';
 *   $rekomendasi = getRekomendasiUntukMember($conn, $memberId, $limit, $idDiKeranjang);
 *   // $rekomendasi['items']        -> daftar menu (sudah gabungan hasil ML + fallback populer)
 *   // $rekomendasi['sumber_utama'] -> 'ai' | 'campuran' | 'populer'
 *   // $rekomendasi['catatan']      -> pesan status utk ditampilkan ke pelayan (opsional)
 *
 * Sudah terpasang di pelayan/pesan_dengan_member.php.
 *
 * File ini sengaja dibiarkan ada (tidak dihapus) sebagai catatan riwayat,
 * tapi TIDAK dipanggil dari mana pun dalam aplikasi.
 * -----------------------------------------------------------------
 */
