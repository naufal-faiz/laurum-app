```
Baca AGENTS.md, docs/prd/prd-a-ui.md (bagian 4, 6, 10) dan docs/prd/prd-b-backend.md (hanya bagian 3). Kerjakan HANYA sisa Fase 0 (langkah BELUM di docs/prompts/fase-0.md). Jangan mengulang langkah yang sudah selesai.

1b. Ganti application ID dari com.example.laurum menjadi com.cashier.laurum atau laurum_cashier di: android/app/build.gradle.kts (namespace dan applicationId), folder dan package MainActivity.kt di android/app/src/main/kotlin, dan PRODUCT_BUNDLE_IDENTIFIER di ios/Runner.xcodeproj/project.pbxproj (3 tempat, termasuk .RunnerTests). Jalankan flutter clean lalu build ulang untuk memastikan.
2. Pasang dependensi PRD A bagian 4 dengan flutter pub add (jangan menebak versi). Laporkan versi yang ter-resolve dan kompatibilitas plugin analyzer native riverpod_lint dengan Dart/Flutter proyek ini. custom_lint dihapus sesuai izin migrasi 22 Oktober 2026; lint Riverpod berjalan melalui flutter analyze. Buktikan dengan pelanggaran sengaja, lalu hapus pelanggaran.
3. Bundel font Plus Jakarta Sans dan IBM Plex Mono di assets/fonts dan daftarkan di pubspec.yaml.
4. Buat lib/core/theme dari docs/design/tokens.md, core/formatters, core/icons/app_icons.dart (pemetaan di Kit Agen bagian 8), dan kerangka folder lib/shared/widgets/{atoms,molecules,organisms,templates} dan lib/features.
6. Ganti lib/main.dart (demo counter bawaan) dan test/widget_test.dart. Isi lib/app.dart (widget akar) dan lib/main_dummy.dart yang menampilkan satu layar kosong bertema. Siapkan skeleton Widgetbook di folder widgetbook/.

Jangan membuat widget registry atau layar apa pun. Selesai bila dart run tool/check_all.dart hijau. Laporkan, termasuk hal yang belum bisa diuji di iOS.
```
