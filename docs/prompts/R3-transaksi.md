# R3 - Transaksi: FAB Pilih Layanan dan tambah pelanggan (revisi 4, 5)
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: R2 SELESAI. Baca: docs/revisi/REVISI-01.md (item 4, 5), spec 02, 03, 05, screens untuk Form Layanan (21).

## IZIN TERTULIS (25 Okt 2026)
- SubScaffold: tambah fabLabel dan onFab opsional (pola sama dengan RootScaffold lama: FloatingActionButton.extended, primary, ikon AppIcons.add, teks onPrimary). Perbarui katalog dan tes.

## Langkah
1. Pilih Layanan (ServicePickerPage; dipakai dua rute, transaksi baru dan edit order): FAB "Layanan baru" membuka /lainnya/layanan/baru lewat push. Setelah simpan dan kembali, layanan baru langsung muncul di katalog (provider yang sama dengan Daftar Layanan; tambah tes). FAB disembunyikan saat keyboard terbuka dan tidak menutup baris terakhir (padding bawah).
2. Buat Transaksi, bagian Pelanggan (TransactionCustomerSection): bila belum ada pelanggan, tampilkan satu baris berisi tombol "Pilih pelanggan" (melebar) dan tombol "Baru" (ikon add, actionOutline) di sampingnya. "Baru" membuka AddCustomerSheet dengan forOrder: true; pelanggan yang tersimpan otomatis dipilih di draf. Bila sudah ada pelanggan terpilih, tampilan MenuRow tetap (ketuk untuk mengganti). Bila tombol atom yang ada terlihat janggal bersebelahan, ajukan proposal; jangan membuat widget.
3. Tes: FAB navigasi dan layanan baru muncul; pelanggan baru terpilih; keyboard (AGENTS 16e) pada sheet Tambah pelanggan dari alur ini.
4. Perbarui spec 02, 03, 05.

Prompt berikutnya: R4-status-order.md.
