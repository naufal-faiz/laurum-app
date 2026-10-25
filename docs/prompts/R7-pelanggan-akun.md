# R7 - Pelanggan: tombol di atas; Akun: tombol Keluar (revisi 12, 15)
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: R6 SELESAI. Baca: docs/revisi/REVISI-01.md (item 12, 15), spec 12 dan 19; customer_directory_page.dart, customer_directory_list_page.dart, settings_account_page.dart, settings_page.dart.

## Perilaku
- Daftar Pelanggan: FooterBar "Pelanggan baru" dihapus. Di bagian atas daftar, sejajar dengan tombol Impor kontak, tampil "Pelanggan baru" (cta, ikon add). Dua tombol satu baris (Impor kontak actionOutline, Pelanggan baru cta), tidak overflow di 320 px dan teks 2x (bila sempit, tumpuk vertikal). Perilaku lama setelah simpan (filter Semua, pencarian dikosongkan) dipertahankan.
- Keluar: diagnosis dari kode: baris "Keluar" berupa MenuRow biasa dengan ikon panah kembali (AppIcons.back) di dalam kartu yang sama dengan baris terkunci, jadi terlihat seperti menu navigasi, bukan aksi keluar. Perbaikan: pindahkan keluar dari kartu; di bawah kartu AKUN tampilkan AppButton destructiveOutline "Keluar" dengan ikon logout; ConfirmModal "Keluar dari akun?" memakai tombol destruktif dan ikon logout (bukan lock). Bila setelah ini tampilan di HP masih terlihat cacat, minta pengguna tangkapan layar sebelum mengubah lagi.

## IZIN TERTULIS (25 Okt 2026)
- core/icons/app_icons.dart: tambah entri logout (Ionicons.logOutOutline).
- Tanpa perubahan atoms/molecules/organisms lain.

## Langkah
1. Tes lebih dulu (tombol atas ada dan membuka AddCustomerSheet, footer hilang, keluar memakai ConfirmModal dan memanggil signOut, tidak ada MenuRow Keluar).
2. Terapkan; potongan layar baru sebagai Section (aturan 14).
3. Perbarui spec 12 dan 19. Tes keyboard bila sheet tambah pelanggan dibuka dari sini.
4. Penutup R-seri: perbarui STATE (R0-R7 selesai) dan jalankan check_all penuh; laporkan "Yang perlu ditinjau" di HP: nav tengah, keyboard di tiap sheet, mode status order, rentang tanggal Laporan.

Prompt berikutnya: 71-lainnya-b.md.
