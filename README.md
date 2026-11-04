# Laurum

Aplikasi kasir laundry untuk usaha rumahan, satu basis kode Flutter untuk Android dan iOS. Aplikasi masih memakai repository dan layanan dummy in-memory. Fondasi SQLite/Drift disiapkan terpisah; penyambungan ke aplikasi dilakukan pada B1f. Sinkron server, Google/SMTP, WhatsApp dan printer nyata masih tahap backend.

## Status
UI dummy, R0–R10 dan koreksi pembayaran/struk selesai. Prompt 100 lulus `check_all` (688 tes), audit 34 rute pada 320 px/teks 1,3, dan smoke APK pada Samsung Android 12. Lihat [STATE](docs/progress/STATE.md) serta [audit UI dan catatan tersisa](docs/progress/fase-ui.md). BP0 selesai; fondasi B1a dicatat di docs/progress/b1a-drift-fondasi.md. Status terbaru dan bukti pemeriksaan ada di STATE.

UI meliputi kasir, COD/piutang, tabungan pelanggan, laporan/pengeluaran, pengaturan printer, usulan AI, serta akun email/password dan Google dummy. Data berubah selama aplikasi berjalan dan kembali ke fixture saat proses dimulai ulang. Nominal menggunakan int rupiah dan berat int gram.

## Menjalankan
```
flutter pub get
flutter run -t lib/main_dummy.dart     # mode data dummy
dart run tool/check_all.dart           # format, analyze, lint, arsitektur, test
flutter build apk --debug -t lib/main_dummy.dart
flutter devices
flutter run --debug -t lib/main_dummy.dart -d <id-android>
```

APK debug: `build/app/outputs/flutter-apk/app-debug.apk`. Akun uji publik untuk simulasi email: `ratna@example.com` / `Laundry123!`; bukan akun nyata. Alur Cek email dan reset tidak mengirim email. Ponsel Android dan pengaturan printer dapat diuji dengan layanan palsu; iOS serta integrasi perangkat/layanan produksi belum diverifikasi.

## SQLite dan pengujian backend

Fondasi persistensi memakai skema versi 2, berkas `laurum_<ownerId>.db` per akun,
outbox dan LocalSettings. Tidak memerlukan Supabase cloud, key, atau Docker.
Tes SQLite berjalan dengan `NativeDatabase.memory()` dan berkas sementara pada
Windows; integrasi database pada Android/iOS belum diuji. Tidak perlu menyalin DLL manual.

Pada Windows dengan path SDK mengandung spasi, aktifkan helper sebelum perintah
Flutter/Dart dalam sesi PowerShell tersebut:

```powershell
. ./tool/windows_native_sdk.ps1
flutter test test/persistence
dart run tool/check_all.dart
```

Helper membuat junction Flutter dan salinan Dart SDK di Temp (sekitar 588 MB pada
SDK sesi ini), lalu mengatur PATH/FLUTTER_ROOT untuk proses PowerShell itu saja.
Instalasi asli tidak dipindahkan. Ini mengatasi kegagalan build hook native pada
SDK Windows di path berspasi. Sesi PowerShell baru memakai lingkungan awal lagi.

Regenerasi kode dan snapshot migrasi:

```text
dart run build_runner build
dart run drift_dev schema dump lib/core/persistence/app_database.dart test/persistence/schema
dart run drift_dev schema generate --data-classes --companions test/persistence/schema test/persistence/generated
```

Snapshot v1 dan v2 dibekukan; perubahan skema berikutnya wajib menaikkan versi, menulis
migrasi dan menambah tes. Timestamp disimpan sebagai teks ISO-8601 untuk menjaga
presisi subdetik; jangan mengubah opsi tersebut tanpa migrasi. Lihat
[dokumentasi DateTime Drift](https://drift.simonbinder.eu/guides/datetime-migrations/).

## Dokumen
- `docs/prd/prd-a-ui.md`: PRD tampilan
- `docs/prd/prd-b-backend.md`: PRD sistem dan backend
- `docs/design/`: `laurum-ready.pen` (acuan visual), `tokens.md`, `widget_registry.yaml`, `data_master.md`, `receipt_template.md`, `screens/` (spec layar), `proposals/`
- `docs/prompts/`: prompt kerja agen per fase
- `AGENTS.md`: aturan wajib untuk agen kode
