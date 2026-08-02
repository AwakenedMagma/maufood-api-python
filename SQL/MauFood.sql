-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Aug 01, 2026 at 05:48 AM
-- Server version: 8.0.40
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `MauFood`
--

-- --------------------------------------------------------

--
-- Table structure for table `detail_pesanan`
--

CREATE TABLE `detail_pesanan` (
  `id` int NOT NULL,
  `pesanan_id` int DEFAULT NULL,
  `menu_id` int DEFAULT NULL,
  `jumlah` int DEFAULT NULL,
  `subtotal` int DEFAULT NULL,
  `catatan` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `detail_pesanan`
--

INSERT INTO `detail_pesanan` (`id`, `pesanan_id`, `menu_id`, `jumlah`, `subtotal`, `catatan`) VALUES
(1, 1, 1, 1, 12000, NULL),
(2, 2, 1, 2, 24000, NULL),
(3, 3, 3, 1, 26000, NULL),
(4, 3, 4, 1, 25000, NULL),
(5, 3, 2, 1, 15000, NULL),
(6, 4, 3, 1, 26000, NULL),
(7, 4, 4, 1, 25000, NULL),
(8, 5, 1, 1, 12000, NULL),
(9, 6, 4, 5, 125000, NULL),
(10, 6, 1, 5, 60000, NULL),
(11, 6, 3, 2, 52000, NULL),
(12, 7, 3, 3, 78000, NULL),
(13, 7, 4, 3, 75000, NULL),
(14, 8, 1, 3, 36000, NULL),
(15, 8, 4, 1, 25000, NULL),
(16, 8, 3, 1, 26000, NULL),
(17, 9, 3, 1, 26000, NULL),
(18, 9, 4, 2, 50000, NULL),
(19, 10, 1, 3, 36000, NULL),
(20, 10, 4, 1, 25000, NULL),
(21, 10, 3, 1, 26000, NULL),
(22, 11, 7, 2, 30000, NULL),
(23, 11, 4, 1, 25000, NULL),
(24, 11, 1, 1, 12000, NULL),
(25, 11, 5, 1, 26000, NULL),
(26, 11, 6, 1, 35000, NULL),
(27, 12, 1, 1, 12000, NULL),
(28, 12, 5, 1, 26000, NULL),
(29, 12, 7, 1, 15000, NULL),
(30, 12, 4, 2, 50000, NULL),
(31, 13, 7, 1, 15000, NULL),
(32, 13, 4, 1, 25000, NULL),
(33, 13, 6, 1, 35000, NULL),
(34, 14, 7, 1, 15000, NULL),
(35, 14, 4, 1, 25000, NULL),
(36, 14, 6, 1, 35000, NULL),
(37, 15, 4, 1, 25000, NULL),
(38, 16, 4, 1, 25000, NULL),
(39, 16, 5, 1, 26000, NULL),
(40, 16, 3, 1, 35000, NULL),
(41, 17, 5, 1, 26000, NULL),
(42, 17, 4, 1, 25000, NULL),
(43, 17, 3, 1, 35000, NULL),
(44, 18, 3, 1, 35000, NULL),
(45, 18, 4, 1, 25000, NULL),
(46, 18, 5, 1, 26000, NULL),
(47, 19, 9, 1, 78000, 'Medium Well'),
(48, 19, 3, 1, 35000, ''),
(49, 20, 5, 1, 26000, 'susu nya banyakin'),
(50, 21, 6, 1, 35000, ''),
(51, 21, 4, 1, 25000, ''),
(52, 21, 3, 1, 35000, ''),
(53, 21, 9, 1, 78000, ''),
(54, 22, 6, 1, 35000, ''),
(55, 22, 4, 2, 50000, ''),
(56, 22, 3, 1, 35000, ''),
(57, 22, 9, 1, 78000, '');

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE `member` (
  `id` int NOT NULL,
  `nama` varchar(100) NOT NULL,
  `nomor_telepon` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `alamat` text,
  `total_pesanan` int DEFAULT '0',
  `total_pengeluaran` decimal(12,2) DEFAULT '0.00',
  `status` enum('aktif','nonaktif') DEFAULT 'aktif',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`id`, `nama`, `nomor_telepon`, `email`, `alamat`, `total_pesanan`, `total_pengeluaran`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Elva', '08123456789', 'elva@email.com', 'Jl. Merdeka No. 10, Jakarta', 2, 249000.00, 'aktif', '2026-06-30 12:13:08', '2026-07-16 09:24:06'),
(2, 'Kylian Mbappe', '08234567890', 'mbappe@email.com', 'Jl. Gatot Subroto No. 5, Jakarta', 2, 174000.00, 'aktif', '2026-06-30 12:13:08', '2026-07-16 09:24:43'),
(3, 'Ronaldo Siuu', '08345678901', 'ronaldo@email.com', 'Jl. Sudirman No. 20, Jakarta', 3, 213000.00, 'aktif', '2026-06-30 12:13:08', '2026-07-17 11:29:44'),
(4, 'Verdians', '081122334455', 'verdigans@gmail.com', 'Kutabumi, Tangerang', 5, 452000.00, 'aktif', '2026-07-12 15:09:25', '2026-07-30 10:04:40'),
(5, 'Maul', '0852112234736', '', 'Gundar Cengkareng', 2, 111000.00, 'aktif', '2026-07-17 03:30:05', '2026-07-17 04:56:35'),
(6, 'Ana', '08512374312', '', '', 2, 371000.00, 'aktif', '2026-07-31 12:34:48', '2026-07-31 12:38:15');

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `id` int NOT NULL,
  `nama_menu` varchar(100) DEFAULT NULL,
  `harga` int DEFAULT NULL,
  `deskripsi` text,
  `kategori` varchar(50) DEFAULT NULL,
  `bahan_baku` varchar(50) DEFAULT NULL,
  `rasa` enum('manis','pedas','gurih') DEFAULT NULL,
  `gambar` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`id`, `nama_menu`, `harga`, `deskripsi`, `kategori`, `bahan_baku`, `rasa`, `gambar`) VALUES
(1, 'Ayam Goreng', 24000, 'Ayam yang digoreng kriuk dengan bumbu enak membuat lidah terasa nyaman', 'Makanan Utama', 'Ayam', 'gurih', '1777478651_06c077e2768b.jpg'),
(2, 'Mie Ayam', 15000, '', 'Makanan Utama', 'Mie', 'gurih', '1782822613_e2d57249ea50.jpg'),
(3, 'Americano Espresso', 35000, '', 'Minuman', 'Kopi', NULL, '1782822745_1c3becefcf3d.jpg'),
(4, 'French Fries', 25000, '', 'Camilan', 'Sayuran', 'gurih', '1782822831_2250bea3a90a.jpg'),
(5, 'Salad Buah', 26000, '', 'Camilan', 'Sayuran', 'manis', '1784121373_b3fb84b171aa.jpg'),
(6, 'Ayam Lada Hitam', 35000, 'Ayam yang dihidangkan dengan lada hitam beserta bumbu yang membuat lidah terasa manis dan pedas.', 'Makanan Utama', 'Ayam', 'pedas', '1784121628_1066d41d5513.jpg'),
(7, 'Nasi Gurih', 15000, 'Nasi gurih dengan daun jeruk yang menggugah selera dibanding nasi biasa.', 'Makanan Utama', 'Nasi', 'gurih', '1784121808_719a2d364bea.jpg'),
(8, 'Nasi Goreng Spesial', 25000, 'Nasi goreng yang dibuat spesial seperti rasa cintaku padamu', 'Makanan Utama', 'Nasi', 'gurih', '1784297109_59b2d892eb03.jpg'),
(9, 'Steak Wagyu A5', 78000, 'Steak yang terbuat dari beef wagyu bagian A5', 'Makanan Utama', 'Daging', 'gurih', '1785405767_b6765c3c7394.jpeg');

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `tanggal` datetime DEFAULT CURRENT_TIMESTAMP,
  `total` int DEFAULT NULL,
  `status` enum('pending','diproses','selesai','dibatalkan') NOT NULL DEFAULT 'pending',
  `meja` varchar(20) DEFAULT NULL,
  `dibuat_oleh` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `member_id` int DEFAULT NULL,
  `tipe` enum('dine-in','delivery') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`id`, `user_id`, `tanggal`, `total`, `status`, `meja`, `dibuat_oleh`, `created_at`, `member_id`, `tipe`) VALUES
(1, 1, '2026-04-29 23:07:03', 12000, 'selesai', NULL, NULL, '2026-06-30 06:19:37', NULL, 'dine-in'),
(2, 1, '2026-06-30 13:23:10', 24000, 'dibatalkan', 'A3', 1, '2026-06-30 06:23:10', NULL, 'dine-in'),
(3, 1, '2026-06-30 19:35:58', 66000, 'dibatalkan', 'A8', 1, '2026-06-30 12:35:58', NULL, 'dine-in'),
(4, 1, '2026-07-03 08:14:22', 51000, 'selesai', 'A8', 1, '2026-07-03 01:14:22', 3, 'dine-in'),
(5, 1, '2026-07-03 08:19:49', 12000, 'selesai', 'A4', 1, '2026-07-03 01:19:49', 1, 'dine-in'),
(6, 1, '2026-07-12 21:30:33', 237000, 'selesai', 'A4', 1, '2026-07-12 14:30:33', 1, 'dine-in'),
(7, 1, '2026-07-12 21:35:45', 153000, 'diproses', 'B4', 1, '2026-07-12 14:35:45', NULL, 'dine-in'),
(8, 1, '2026-07-12 22:08:11', 87000, 'selesai', 'C4', 1, '2026-07-12 15:08:11', 2, 'dine-in'),
(9, 1, '2026-07-12 22:11:30', 76000, 'selesai', 'B3', 1, '2026-07-12 15:11:30', 3, 'dine-in'),
(10, 1, '2026-07-12 22:11:45', 87000, 'pending', 'C2', 1, '2026-07-12 15:11:45', 2, 'dine-in'),
(11, 8, '2026-07-15 21:22:15', 128000, 'selesai', 'A1', 8, '2026-07-15 14:22:15', NULL, 'dine-in'),
(12, 8, '2026-07-15 21:59:13', 103000, 'selesai', 'B5', 8, '2026-07-15 14:59:13', 4, 'dine-in'),
(13, 8, '2026-07-15 22:01:27', 75000, 'dibatalkan', 'A10', 8, '2026-07-15 15:01:27', 4, 'dine-in'),
(14, 8, '2026-07-15 22:22:42', 75000, 'selesai', 'A4', 8, '2026-07-15 15:22:42', 4, 'dine-in'),
(15, 8, '2026-07-17 10:30:52', 25000, 'selesai', 'A5', 8, '2026-07-17 03:30:52', 5, 'dine-in'),
(16, 8, '2026-07-17 11:56:35', 86000, 'selesai', 'B5', 8, '2026-07-17 04:56:35', 5, 'dine-in'),
(17, 8, '2026-07-17 18:28:18', 86000, 'selesai', 'A11', 8, '2026-07-17 11:28:18', 4, 'dine-in'),
(18, 8, '2026-07-17 18:29:44', 86000, 'pending', 'A8', 8, '2026-07-17 11:29:44', 3, 'dine-in'),
(19, 8, '2026-07-30 17:04:40', 113000, 'selesai', 'A5', 8, '2026-07-30 10:04:40', 4, 'dine-in'),
(20, 1, '2026-07-31 19:32:03', 26000, 'selesai', 'A5', 1, '2026-07-31 12:32:03', NULL, 'dine-in'),
(21, 1, '2026-07-31 19:35:24', 173000, 'selesai', 'B2', 1, '2026-07-31 12:35:24', 6, 'dine-in'),
(22, 1, '2026-07-31 19:38:15', 198000, 'selesai', 'A7', 1, '2026-07-31 12:38:15', 6, 'dine-in');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` enum('admin','pelayan') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pelayan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `password`, `role`) VALUES
(1, 'Verdi', 'verdi@gmail.com', 'eb78a1f20d8bb250940d9b74fa51ba46', 'pelayan'),
(7, 'Admin', 'admin@gmail.com', '0192023a7bbd73250516f069df18b500', 'admin'),
(8, 'Nevera', 'nevera@gmail.com', 'b2effd44c141117dec58d4f07deac12f', 'pelayan');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pesanan_id` (`pesanan_id`),
  ADD KEY `idx_menu_id` (`menu_id`);

--
-- Indexes for table `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nomor_telepon` (`nomor_telepon`),
  ADD KEY `idx_nomor_telepon` (`nomor_telepon`),
  ADD KEY `idx_nama` (`nama`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_member_id` (`member_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `member`
--
ALTER TABLE `member`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD CONSTRAINT `detail_pesanan_ibfk_1` FOREIGN KEY (`pesanan_id`) REFERENCES `pesanan` (`id`),
  ADD CONSTRAINT `detail_pesanan_ibfk_2` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`);

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `pesanan_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
