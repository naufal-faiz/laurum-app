# R2 - Navigasi tengah dan Beranda antrean aktif (revisi 9, 11)
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: R1 SELESAI. Baca: docs/revisi/REVISI-01.md (item 9, 11), spec 01, component_catalog entri BottomNavBar dan RootScaffold, acuan gambar navigasi (docs/revisi/nav-referensi.png bila ada; deskripsi di bawah).

## Spesifikasi navigasi
Lima slot: Antrean, Pelanggan, [Transaksi], Laporan, Lainnya. Slot tengah BUKAN tab: lingkaran hijau (primary) berisi ikon AppIcons.add (ikon FAB lama), terangkat sekitar sepertiga di atas garis nav, bercincin warna surface supaya menyatu, warna datar tanpa gradien, label "Transaksi" di bawahnya. Ketuk membuka /transaksi/baru (push). Semantics: "Transaksi baru". Tidak pernah berstatus aktif. Teks 2x dan layar 320 px tidak overflow. Tab lain tetap seperti sekarang.

## IZIN TERTULIS (25 Okt 2026)
- BottomNavBar: activeIndex menjadi indeks dari EMPAT tab (0 Antrean, 1 Pelanggan, 2 Laporan, 3 Lainnya); tambah onCreate (VoidCallback) dan createLabel (default 'Transaksi'). Perbarui entri katalog, use-case Widgetbook, tes.
- RootScaffold: hapus fabLabel/onFab dan seluruh kode FAB (kode FAB dipindah ke SubScaffold pada R3, jangan dibuang dulu dari riwayat git); terima onCreate dan meneruskannya.
- core/theme/app_dimensions.dart: tambah token ukuran tombol tengah dan tinggi angkat (dua konstanta). Tanpa warna baru.
- StatefulShellRoute menjadi 4 cabang: /antrean, /pelanggan, /laporan, /lainnya. Hapus '/transaksi' dari tabRoutes dan cabang, TETAPI jangan hapus berkas Riwayat Nota (dipindah di R6).

## Langkah
1. Tes lebih dulu: BottomNavBar (5 slot, tengah memanggil onCreate, tab memanggil onSelected dengan indeks 0..3), RootScaffold tanpa FAB.
2. Terapkan BottomNavBar baru, perbarui RootShellPage (onAccount: goBranch(3), onCreate: push '/transaksi/baru'), placeholder_routes.tabRoutes, dan semua pemakai indeks lama (cari: goBranch, activeIndex:, tabRoutes).
3. Perbaikan terkait: OutstandingPage memakai BottomNavBar(activeIndex: 3) tanpa onSelected sehingga nav tidak berfungsi. Ubah menjadi Laporan aktif (2) dengan onSelected menuju cabang yang dipilih (context.go ke path tab) dan onCreate yang sama.
4. Beranda (Antrean): judul "Antrean aktif" dengan jumlah order aktif (tanpa teks "hari ini" dan tanpa tanggal, karena daftar tidak difilter hari). Isi tetap hanya order berstatus menunggu jemput/diproses/siap (sudah demikian di antreanDataProvider; pertahankan dan tambahkan tes bahwa selesai dan dibatalkan tidak muncul). Chip dan bagian "Perlu dicek" (usulan AI menunggu) dipertahankan. Hapus FAB dari Beranda; state kosong tetap punya tombol "Transaksi baru". Perbarui spec 01.
5. Jangan mengubah perilaku lain.

Prompt berikutnya: R3-transaksi.md.
