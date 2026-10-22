# Fase 0 - Inisiasi (sisa pekerjaan)

Status diperbarui 22 Oktober 2026 berdasarkan implementasi lokal. Fase 0 belum ditutup: bukti lint Riverpod belum lulus dan build Android ditunda sampai SDK tersedia.

| # | Langkah | Status |
| --- | --- | --- |
| 1 | flutter create (Android + iOS), nama paket laurum | SELESAI |
| 1b | Ganti application ID dari com.example.laurum | ID SELESAI; build Android DITUNDA (SDK belum tersedia) |
| 2 | Pasang dependensi PRD A bagian 4 | TERPASANG; verifikasi lint Riverpod BELUM LULUS |
| 3 | Bundel font Plus Jakarta Sans dan IBM Plex Mono | SELESAI |
| 4 | lib/core/theme, core/formatters, core/icons/app_icons.dart, kerangka folder | SELESAI |
| 5 | analysis_options.yaml, tool/check_arch.dart, tool/check_all.dart, widget_registry.yaml | SELESAI |
| 6 | main_dummy.dart, app.dart, skeleton Widgetbook; ganti main.dart dan test bawaan | SELESAI (tes widget dan kompilasi bundle Widgetbook) |

Jalankan prompt di bawah HANYA untuk langkah berstatus BELUM. Perbarui tabel ini saat selesai.

## Catatan implementasi 22 Oktober 2026

- Application ID dipilih `com.cashier.laurum`; Android namespace, applicationId,
  path/package MainActivity, dan enam identifier iOS (tiga Runner + tiga
  RunnerTests) sudah diperbarui. `flutter clean` berhasil. Build APK berhenti
  karena Android SDK belum tersedia; pengguna meminta penundaan sambil memasang SDK.
- Font dibundel dari Google Fonts dengan lisensi OFL; tidak diunduh saat runtime.
  Sumber tercatat di `assets/fonts/README.md`.
- Tidak ada widget registry, layar fitur, fixture, provider bisnis, atau rute baru.
  `LaurumApp` adalah widget akar dengan Scaffold kosong. Kedua entry point memakai
  ProviderScope; override repository baru diperlukan ketika antarmukanya dibuat.
- Tema mengikuti tokens.md. Footer: `0 -4 14 #131B2E14`; modal tidak memiliki
  effect di frame C/Modal pada .pen, sehingga daftar bayangannya kosong.
- Ikon mengikuti Kit Agen bagian 8 yang diberikan pengguna. Ionicons 0.2.3
  memakai camelCase, misalnya `informationCircleOutline`, bukan snake_case.
  Bentuk ikon tidak diganti; ditambahkan varian fileTray terisi untuk tab antrean aktif.
  Tidak ada SVG kustom, sehingga konstanta AppSvgs belum diperlukan.
- Formatter tanggal/jam menerima waktu lokal usaha (WIB); tidak mengonversi
  berdasarkan zona waktu perangkat. Locale id_ID diinisialisasi saat startup.

### Versi hasil flutter pub add

Lingkungan: Flutter 3.47.7 stable, Dart 3.13.5.

| Paket | Versi |
| --- | --- |
| flutter_riverpod | 3.4.3 |
| go_router | 18.1.1 |
| equatable | 3.0.0 |
| intl | 0.20.3 |
| ionicons | 0.2.3 |
| flutter_svg | 2.3.0 |
| flutter_lints | 6.0.0 |
| widgetbook | 3.25.0 |
| riverpod_lint | 3.1.9 |

### Migrasi lint yang diizinkan

`custom_lint` 0.8.1 dan `riverpod_lint` 3.1.9 tidak dapat di-resolve bersama
karena batas analyzer_plugin berbeda. Resolver awal memilih custom_lint 0.5.11
+ riverpod_lint 3.0.0-dev.4, yang memakai konfigurasi plugin lama dan memicu
peringatan deprecated pada Dart 3.13. Kombinasi lama tidak dipertahankan.

Dengan izin pengguna, custom_lint dihapus. riverpod_lint 3.1.9 dipasang lewat
flutter pub add, lalu diaktifkan melalui `plugins` tingkat atas sesuai README
versi terpasang. Analyzer ter-resolve 14.6.0, analyzer_plugin 0.14.19,
analysis_server_plugin 0.3.25. Tidak ada dependency_overrides atau downgrade.
Langkah custom_lint dan mekanisme needs di check_all dihapus; lint Riverpod
seharusnya berjalan melalui flutter analyze. Aturan linter lainnya, check_arch,
batas baris, dan registry tidak diubah.

**Bukti negatif BELUM LULUS:** dua percobaan terpisah di lib/lint_probe.dart:

1. `runApp(const SizedBox.shrink())` tanpa ProviderScope: analyzer exit 0,
   `No issues found`, bukan missing_provider_scope.
2. Notifier<int> dengan properti mutable publik `int exposed = 0`: analyzer
   exit 0, `No issues found`, bukan avoid_public_notifier_properties.

Probe sudah dihapus. Paket native berhasil dipasang tetapi fungsionalitas lint
belum terbukti pada lingkungan ini. Sesuai instruksi pengguna, investigasi berhenti;
tidak memakai versi lama atau suppression. Hasil check_all yang hijau saja belum
cukup untuk menutup Fase 0 sampai uji negatif plugin benar-benar terdeteksi.

### Validasi dan batas pengujian

- `dart run tool/check_all.dart` selesai exit 0: format, flutter analyze, check_arch, dan seluruh tes hijau. Catatan: uji negatif plugin di atas tetap belum lulus.
- Lima tes lulus: layar kosong bertema dari entry point dummy, rupiah termasuk
  angka besar/negatif, gram, tanggal/jam Indonesia, dan telepon/nomor nota.
- Bundle skeleton Widgetbook berhasil dikompilasi dengan
  `flutter build bundle -t widgetbook/main.dart`.
- Format Widgetbook dan check_arch lulus. File lib terpanjang 79 baris.
- Tidak ada perbandingan layar terhadap .pen karena Fase 0 belum membuat layar.
- Android: APK belum berhasil dibangun dan belum dijalankan di perangkat.
- iOS: identifier sudah diubah; build, signing, dan perilaku runtime belum diuji
  di iOS karena lingkungan Windows tidak menyediakan Xcode.
