# 014 — Loader Laurum

Status: diterapkan 10 Nov 2026 setelah koreksi Antrean (016); check_all hijau.
Gerbang: koreksi Beranda dan redesign Antrean frame 408 selesai serta ditinjau.

Referensi pengguna:
- docs/design/laurum_loader.dart.txt — contoh wrapper Lottie, ukuran bawaan 96.
  Berkas pengguna dipertahankan isinya dan diberi ekstensi .txt agar tidak ikut
  dianalisis sebagai kode aplikasi sebelum dependensi Lottie disetujui.
- docs/design/laurum-loader.json — animasi asli.
- docs/design/laurum-loader-refined.json — varian refined, 400×400, 30 fps,
  180 frame (6 detik), judul Laurum seamless laundry loader.

Alasan: identitas merek saat pemuatan yang membutuhkan indikator animasi.
Komponen bersama baru perlu persetujuan aturan 2; contoh bukan kode siap salin.

Sketsa API atom AppLoader({double size = 96, String label = 'Sedang memuat'}).
Ukuran default dipetakan ke token global yang disetujui; dukung Semantics,
reduce motion/disableAnimations (tampilan statis), dan lifecycle animasi.
Tidak menambah durasi tunggu, provider, atau state bisnis.

Usulan implementasi: aset terpilih di assets/animations/, deklarasi pubspec,
dependensi lottie melalui flutter pub add SETELAH persetujuan pengguna.
Permintaan membuat loader memakai Lottie menjadi izin implementasi/dependensi.
Implementasi memilih varian refined; sumber asli tetap utuh di docs/design.
flutter pub add meresolusikan lottie 3.8.2; API terdaftar sebagai atom AppLoader.
Aset pengguna disalin utuh; ukuran 96 menjadi AppDimensions.loader. Tidak ada font baru.

Layar terdampak: Beranda dan Antrean pada keadaan loading; pertahankan skeleton
untuk placeholder struktur bila lebih sesuai. Layar auth/sync atau tombol busy
dibahas terpisah sebelum mengganti indikator global.
Tes: aset termuat, semantics, reduce motion, ukuran, tidak menghalangi aksi,
golden loading terkait; check_all dan pemeriksaan Android. iOS belum diuji.
