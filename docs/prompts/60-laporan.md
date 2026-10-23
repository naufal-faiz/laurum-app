# 60 - Laporan
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: prompt 51 SELESAI. Baca: frame "Laporan - Ringkasan", "Daftar Piutang" dan varian State.

- Ringkasan (tab Laporan): PeriodTabs (Hari ini, Minggu ini, Bulan ini), ReportSummary, WeeklyBarChart, TopServices (berdasar pendapatan, bukan volume), kartu "Piutang aktif" yang bisa diketuk ke Daftar Piutang, satu tombol "Ekspor ke Excel" memakai ExportService palsu. Angka Minggu ini PERSIS data_master.md (Pendapatan Rp1.800.000, Pengeluaran Rp850.000, laba Rp950.000, kas masuk Rp1.699.500, tabungan Rp430.000, piutang Rp400.500). State kosong untuk periode tanpa data.
- Daftar Piutang (/laporan/piutang, BottomNavBar dengan Laporan aktif): header "Total piutang usaha Rp400.500 / 5 nota belum lunas - 5 pelanggan", ChipBar (Semua 5, Belum bayar 2, DP 3), lima PiutangCard urut tertua. "Catat bayar" membuka sheet Numpad dan memperbarui order; "Ingatkan" membuka ExternalLauncher dengan teks siap kirim (aplikasi tidak mengirim otomatis). State: tidak ada piutang. TANPA jatuh tempo.
- Alur: membuat nota di prompt 32 harus mengubah angka Hari ini dan Minggu ini; mencatat pembayaran piutang mengubah total piutang.
