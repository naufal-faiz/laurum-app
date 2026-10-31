# Animasi masuk Transaksi (SELESAI otomatis)
Diperbarui: 31 Oktober 2026.

## Masalah
Tombol tengah BottomNavBar hanya GestureDetector tanpa umpan tekan, dan rute
/transaksi/baru memakai transisi bawaan GoRouter yang terasa kaku.

## Perubahan
- BottomNavBar: lingkaran primary 56 dp kini Material + InkWell (ripple/highlight
  bawaan tema) di dalam Container; cincin surface 4 dp dipindah ke foreground
  ShapeDecoration. Tanpa state internal, tanpa warna/token baru, semantics tetap.
- transaction_routes.dart (baru): /transaksi/baru, /layanan, /bayar memakai
  CustomTransitionPage fade + lift 4%, 280 ms easeOutCubic; balik 200 ms
  easeInCubic. app_router memakai ...transactionRoutes.
- Ukuran berkas: bottom_nav_bar 109 baris, app_router 92, transaction_routes 37.

## Bukti
- Tes baru: InkWell tengah ada dan satu ketukan memanggil onCreate tepat sekali;
  ketukan Transaksi dari /antrean membuat opasitas FadeTransition di antara 0..1
  pada 140 ms lalu selesai.
- Golden bottom_nav_bar dan root_scaffold diperbarui setelah ditinjau; selisih
  hanya anti-aliasing tepi lingkaran (0,26%).
- check_all: 449 tes hijau, REPO_MAP 553 berkas.

## Tinjauan di HP
- Rasakan ripple tombol tengah dan transisi masuk/keluar alur transaksi.
- Transisi rute lain (detail order, pelanggan, laporan) sengaja belum diubah.
