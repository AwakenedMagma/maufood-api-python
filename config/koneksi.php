<?php


$host     = "localhost:8889";
$user     = "root";
$pass     = "root";           
$dbname   = "MauFood";

$conn = mysqli_connect($host, $user, $pass, $dbname);

if (!$conn) {
    die("<div style='color:red;padding:20px;font-family:sans-serif;'>
        <h3>Koneksi Database Gagal</h3>
        <p>" . mysqli_connect_error() . "</p>
        <p>Pastikan MySQL berjalan dan database <b>MauFood</b> sudah dibuat.</p>
    </div>");
}

mysqli_set_charset($conn, "utf8mb4");
?>
