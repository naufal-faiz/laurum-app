# Laurum

Aplikasi kasir laundry untuk usaha rumahan (Flutter, Android dan iOS; saat ini hanya Android yang diuji). Offline-first (SQLite lokal, sinkron otomatis ke Supabase), login Google, dengan fitur AI pembaca pesan WhatsApp yang dikembangkan belakangan.

## Status
Tahap awal: tampilan Flutter di atas data dummy. Backend, AI, dan fitur Pro menyusul.

## Menjalankan
```
flutter pub get
flutter run -t lib/main_dummy.dart     # mode data dummy
dart run tool/check_all.dart           # format, analyze, lint, arsitektur, test
```

## Dokumen
- `docs/prd/prd-a-ui.md`: PRD tampilan
- `docs/prd/prd-b-backend.md`: PRD sistem dan backend
- `docs/design/`: `laurum-ready.pen` (acuan visual), `tokens.md`, `widget_registry.yaml`, `data_master.md`, `receipt_template.md`, `screens/` (spec layar), `proposals/`
- `docs/prompts/`: prompt kerja agen per fase
- `AGENTS.md`: aturan wajib untuk agen kode
