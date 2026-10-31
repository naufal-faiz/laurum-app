# Nav dan Transaksi: animasi + revisi tampilan (SELESAI otomatis)
Diperbarui: 31 Oktober 2026.

## Masalah
Tombol tengah BottomNavBar hanya GestureDetector tanpa umpan tekan, dan rute
/transaksi/baru memakai transisi bawaan GoRouter yang terasa kaku.

## Perubahan
- BottomNavBar: lingkaran primary 56 dp kini Material + InkWell (ripple/highlight
  bawaan tema). Tanpa state internal, tanpa warna/token baru, semantics tetap.
  Permukaan putih mengisi penuh sampai garis atas; tombol tengah menempel garis,
  tanpa cincin, sehingga tidak ada celah di kiri/kanannya.
- transaction_routes.dart (baru): /transaksi/baru, /layanan, /bayar memakai
  CustomTransitionPage fade + lift 4%, 280 ms easeOutCubic; balik 200 ms
  easeInCubic. app_router memakai ...transactionRoutes.
- Ukuran berkas: bottom_nav_bar 100 baris, app_router 92, transaction_routes 37.

## Revisi tampilan 31 Okt (permintaan pengguna)
- Nav: celah/area kosong di samping tombol dihapus; garis atas nav menjadi batas
  tunggal, tombol menempel padanya.
- Daftar Pelanggan: 'Impor kontak' dan 'Pelanggan baru' sama tinggi 56 dp
  (SizedBox ctaHeight) di layout satu baris maupun bertumpuk.
- AppIconButton tidak lagi berlatar putih; tombol profil, kembali, menu, telepon,
  dan tutup sheet menjadi transparan. Tap target 48 dp dan tooltip tetap.
- Golden terdampak diperbarui: nav, app bar, scaffold, transaksi, laporan,
  antrean, icon button.

## Bukti
- Tes baru: InkWell tengah ada dan satu ketukan memanggil onCreate tepat sekali;
  ketukan Transaksi dari /antrean membuat opasitas FadeTransition di antara 0..1
  pada 140 ms lalu selesai; ukuran dua tombol Pelanggan identik; AppIconButton
  tanpa backgroundColor.
- check_all: 449 tes hijau, REPO_MAP 553 berkas.

## Tinjauan di HP
- Rasakan ripple tombol tengah dan transisi masuk/keluar alur transaksi.
- Transisi rute lain (detail order, pelanggan, laporan) sengaja belum diubah.

## Koreksi lanjutan pengguna 31 Okt
- Pengguna menegaskan tombol Transaksi tetap mengambang; revisi meratakan latar
  hingga puncak tombol di atas dibatalkan. Garis bar melewati tengah lingkaran.
- RootScaffold extendBody, padding bawah halaman dikurangi separuh tombol (28 dp).
  Padding tab di luar area interaksi; sudut luar lingkaran meneruskan sentuhan.
- Tes regresi membuktikan batas halaman di tengah lingkaran, empat titik samping
  menerima tap halaman, scroll dari samping berjalan, puncak tombol tetap aktif.
- Golden Antrean ditinjau visual: konten terlihat di samping tonjolan tombol.
  Tinjauan perangkat Android/iOS untuk koreksi ini belum dilakukan.
- Bukti `dart run tool/check_all.dart`: format 486 files (0 changed),
  flutter analyze dan dart analyze tanpa masalah, check_arch OK,
  +450: All tests passed!, REPO_MAP 554 berkas, check_all: SEMUA HIJAU.

## Revisi cincin, ruang scroll, dan aksi pelanggan
- Permintaan pengguna: cincin putih 4 dp di dalam batas lingkaran 56 dp,
  memakai surface/smallGap yang tersedia; area luar lingkaran tetap milik halaman.
- Padding akhir scroll Pelanggan, Laporan, Lainnya ditambah 28 dp (separuh tombol),
  sehingga elemen terakhir tidak tertutup. Antrean sudah punya spacer akhir 64 dp.
- Aksi pelanggan tetap sama tinggi, diperkecil 56 -> 48 dp; Pelanggan baru memakai
  action agar proporsi teks/radius mengikuti tombol aksi ringkas yang ada.
- Tes tombol 320 px/teks 2x dan callback lulus; tes akhir scroll tiga tab lulus.
- check_all akhir: format 488 files (0 changed), flutter analyze/dart analyze
  bersih, check_arch OK, +454: All tests passed!, REPO_MAP 556 berkas,
  check_all: SEMUA HIJAU. Tinjauan perangkat untuk revisi ini belum dilakukan.
