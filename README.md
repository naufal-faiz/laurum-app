# Laurum

Aplikasi kasir laundry untuk usaha rumahan, satu basis kode Flutter untuk Android dan iOS. Entry point utama memakai SQLite/Drift dengan database per akun. Sinkron server, Google/SMTP, WhatsApp dan printer nyata masih menunggu fase backend berikutnya.

## Status
UI dummy, R0–R10 dan koreksi pembayaran/struk selesai. Prompt 100 lulus `check_all` (688 tes), audit 34 rute pada 320 px/teks 1,3, dan smoke APK pada Samsung Android 12. Lihat [STATE](docs/progress/STATE.md) serta [audit UI dan catatan tersisa](docs/progress/fase-ui.md). BP0 selesai; fondasi B1a dicatat di docs/progress/b1a-drift-fondasi.md. Status terbaru dan bukti pemeriksaan ada di STATE.

UI meliputi kasir, COD/piutang, tabungan pelanggan, laporan/pengeluaran, pengaturan printer, usulan AI, serta akun email/password dan Google dummy. Data bisnis di Drift bertahan setelah aplikasi ditutup. AI/usulan/WhatsApp dan autentikasi tetap in-memory sampai B7/B3; akun baru yang didaftarkan pada auth palsu belum dapat dipulihkan setelah proses berakhir. Nominal menggunakan int rupiah dan berat int gram.

## Menjalankan
```
flutter pub get
flutter run -t lib/main.dart           # Drift (default); debug/profile memakai demo
flutter run -t lib/main.dart --dart-define=LAURUM_STORE=memory
flutter run -t lib/main_dummy.dart     # mode data dummy
dart run tool/check_all.dart           # format, analyze, lint, arsitektur, test
flutter build apk --debug -t lib/main.dart
flutter devices
flutter run --debug -t lib/main.dart -d <id-android>
```

APK debug: `build/app/outputs/flutter-apk/app-debug.apk`. Akun uji publik untuk simulasi email: `ratna@example.com` / `Laundry123!`; bukan akun nyata. Alur Cek email dan reset tidak mengirim email. Ponsel Android dan pengaturan printer dapat diuji dengan layanan palsu; iOS serta integrasi perangkat/layanan produksi belum diverifikasi.

Kredensial tersebut berlaku untuk entry dummy dan mode demo Drift. Build utama memakai sesi auth palsu;
akun dan sandinya tidak disimpan ke SQLite. Release pertama tanpa `DEMO_SEED=true`
mulai dari Masuk lalu onboarding dengan database kosong. Demo memakai DATA MASTER
dengan UUID v5 deterministik, hanya pada akun demo yang kosong dan hanya sekali.
Seed tidak disisipkan ke bisnis yang sudah memiliki data. `main_dummy.dart` dan
override tes tetap memakai fixture in-memory; data di mode memory hilang saat restart.

Keluar menutup database dan mempertahankan berkas. Akun lain membuka berkas lain.
Hapus akun menghapus baris secara atomik dahulu, lalu menutup/menghapus database,
sidecar dan folder foto akun setelah commit. Pending sinkron = jumlah baris outbox;
Sinkron sekarang hanya menyegarkan penghitung lokal sampai mesin kirim B2 tersedia,
tidak menghapus antrean atau mengklaim sinkron berhasil.

## SQLite dan pengujian backend

Fondasi persistensi memakai skema versi 4, berkas `laurum_<ownerId>.db` per akun,
outbox dan LocalSettings. Tidak memerlukan Supabase cloud, key, atau Docker.
Tes SQLite berjalan dengan `NativeDatabase.memory()` dan berkas sementara pada
Windows. Benchmark SQLite pada Samsung Android 12 sudah dijalankan; peninjauan
APK utama dan pengukuran cold start akhir dicatat di docs/progress/b1f.md.
iOS belum diuji. Tidak perlu menyalin DLL manual.

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

Snapshot v1, v2, v3 dan v4 dibekukan; perubahan skema berikutnya wajib menaikkan versi, menulis
migrasi dan menambah tes. Timestamp disimpan sebagai teks ISO-8601 untuk menjaga
presisi subdetik; kolom rentang order/pembayaran memakai UTC enam digit pecahan
lewat sqlTimestamp. Jangan mengubah opsi tersebut tanpa migrasi. Lihat
[dokumentasi DateTime Drift](https://drift.simonbinder.eu/guides/datetime-migrations/).

## Dokumen
- `docs/prd/prd-a-ui.md`: PRD tampilan
- `docs/prd/prd-b-backend.md`: PRD sistem dan backend
- `docs/design/`: `laurum-ready.pen` (acuan visual), `tokens.md`, `widget_registry.yaml`, `data_master.md`, `receipt_template.md`, `screens/` (spec layar), `proposals/`
- `docs/prompts/`: prompt kerja agen per fase
- `AGENTS.md`: aturan wajib untuk agen kode
