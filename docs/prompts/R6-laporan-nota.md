# R6 - Laporan: daftar nota per periode dan hapus Riwayat Nota (revisi 7, 8 bagian nota, 13)
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: R5 SELESAI. Baca: docs/revisi/REVISI-01.md (item 7, 8, 13), spec 11-riwayat-nota, 18-laporan-ringkasan; features/orders (nota_history_*).

## Perilaku
- Di bawah ringkasan Laporan, untuk SEMUA periode (Hari ini, Minggu ini, Bulan ini, rentang kustom): bagian "Nota (n)" berisi pencarian nomor nota/nama pelanggan, ChipBar filter (Semua, Belum lunas, Selesai, Dibatalkan; chip "Hari ini" dihapus karena sudah diganti periode), DateGroupHeader per tanggal, NotaCard per nota. Ketuk membuka /order/:id. Ini menjawab "siapa saja yang order di tanggal terpilih".
- Halaman Riwayat Nota dihapus total: rute /transaksi (sudah dilepas dari tab di R2), NotaHistoryPage, tombol "Transaksi baru" di dasarnya, dan spec 11. Nota dilihat hanya lewat Laporan.
- Mode status order NONAKTIF (R4): label status mengikuti pengaturan.

## IZIN TERTULIS (25 Okt 2026)
- Memindahkan logika filterNota dan data nota dari orders/ ke reports/state/ (ubah nama menjadi report_orders_*), serta NotaHistoryListPage menjadi ReportOrdersSection di reports/widgets/. Menghapus berkas Riwayat Nota yang tersisa dan tes lamanya (tes dipindah, bukan dibuang: cakupan filter, pencarian, dan urutan harus tetap).
- Memperbarui docs/prd/prd-a-ui.md bagian 9 (baris Riwayat Nota diganti keterangan "dilihat lewat Laporan") dan README/REPO_MAP otomatis.

## Langkah
1. Tes lebih dulu: filter berdasarkan rentang aktif, pencarian, urutan terbaru dahulu, rekonsiliasi: jumlah dan total nota yang tampil untuk Minggu ini cocok dengan angka DATA MASTER yang sudah ada; untuk rentang kustom, jumlah omzet di ringkasan = jumlah dari daftar nota (di luar nota dibatalkan).
2. Migrasi kode (git mv), tampilkan ReportOrdersSection di ReportPage.
3. Hapus Riwayat Nota (rute, halaman, spec, tes usang). Pastikan tidak ada tautan mati: cari '/transaksi' dan nota_history.
4. Ekspor CSV memuat daftar nota (lanjutan R5 langkah 4).
5. Keyboard: pencarian di Laporan lulus tes keyboard (AGENTS 16e).

Prompt berikutnya: R7-pelanggan-akun.md.
