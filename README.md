# Laurum

Aplikasi kasir laundry untuk usaha rumahan, satu basis kode Flutter untuk Android dan iOS. Implementasi saat ini adalah UI dummy dengan repository dan layanan palsu in-memory; SQLite, sinkron server, Google/SMTP, WhatsApp dan printer nyata masih tahap backend.

## Status
UI dummy, R0–R10 dan koreksi pembayaran/struk selesai. Prompt 100 lulus `check_all` (688 tes), audit 34 rute pada 320 px/teks 1,3, dan smoke APK pada Samsung Android 12. Lihat [STATE](docs/progress/STATE.md) serta [audit UI dan catatan tersisa](docs/progress/fase-ui.md). Backend belum dimulai.

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

## Dokumen
- `docs/prd/prd-a-ui.md`: PRD tampilan
- `docs/prd/prd-b-backend.md`: PRD sistem dan backend
- `docs/design/`: `laurum-ready.pen` (acuan visual), `tokens.md`, `widget_registry.yaml`, `data_master.md`, `receipt_template.md`, `screens/` (spec layar), `proposals/`
- `docs/prompts/`: prompt kerja agen per fase
- `AGENTS.md`: aturan wajib untuk agen kode
