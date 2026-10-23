# 11 - Data dummy dan repository
Ikuti _COMMON.md. Prasyarat: prompt 10 SELESAI. Baca: PRD A bagian 7, PRD B bagian 3 dan 5, data_master.md.

TUGAS
1. Antarmuka repository di lib/core/domain/repositories/: Business, Customer, Service, Order (termasuk item, pembayaran, event), Savings, Expense, Proposal, Report. Hanya antarmuka, tanpa Flutter.
2. Fixture di features/*/data/ yang isinya PERSIS data_master.md, satu berkas per entitas atau lebih (maksimal 100 baris per berkas). Antrean aktif 12 order (Jemput 3, Proses 5, Siap 4): tambahkan order pengisi yang konsisten (nama dari daftar pelanggan, layanan dari master) dan catat di data_master.md bagian "Order pengisi" (satu-satunya perubahan data_master yang diizinkan). Nomor nota berikutnya A-0143.
3. Implementasi InMemory* untuk semua repository, berbasis Notifier sehingga perubahan memperbarui UI. Report: baseline dari fixture (angka Minggu ini di data_master) ditambah delta dari data yang dibuat selama sesi lewat buildReport. Tambahkan baseline Hari ini (Jum Rp375.000) dan Bulan ini yang konsisten dengan Minggu ini, dan catat di data_master.md bagian "Baseline laporan tambahan".
4. Generator nomor nota (kode perangkat A, urut 4 digit).
5. Provider dasar untuk semua repository; di-override di main_dummy.dart dan main.dart (backend nyata menggantikannya nanti).
6. Antarmuka layanan platform dengan implementasi palsu di core/services/: PrintService, ExternalLauncher (buka tautan WhatsApp), ContactSource, PhotoPicker, ExportService, AuthService, SyncService. Hanya antarmuka dan Fake; semuanya mencatat panggilan agar bisa dites.
7. Tes integrasi data: antrean 12 (3+5+4), piutang Rp400.500 (5 nota), saldo tabungan Pak Dedi Rp50.000, mutasi tabungan sesuai urutan, kategori dan total pengeluaran, katalog layanan (6, 1 nonaktif).
