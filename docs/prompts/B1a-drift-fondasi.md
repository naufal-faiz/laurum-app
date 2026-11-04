# B1a - Drift fondasi (database, tabel, outbox, runner)
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: BP0 SELESAI. Baca: AGENTS aturan 19-22, PRD B bagian 3, 5, 7, docs/backend/ROADMAP.md, core/services/transaction_runner.dart dan in_memory_transaction_runner.dart.

## IZIN TERTULIS (4 Nov 2026)
- pubspec: tambah drift, drift_flutter (atau sqlite3 + path_provider sesuai dokumentasi terbaru), dev: drift_dev, build_runner. Versi terbaru lewat `flutter pub add`. Tanpa paket Supabase/sync.
- Folder baru lib/core/persistence/. Berkas hasil generate (*.g.dart) boleh melebihi 100 baris dan dikecualikan dari batas.
- Tanpa menyambungkan ke aplikasi (wiring di B1f). Tanpa perubahan layar, atoms, tema, registry.

## Isi
1. AppDatabase: semua tabel PRD B bagian 5 (kolom sama dengan Postgres + sync_state), tabel lokal `outbox`, `sync_cursors`, `local_settings`; schemaVersion = 1; strategi migrasi dengan tes migrasi (SchemaVerifier atau setara).
2. Satu berkas per akun: `laurum_<ownerId>.db` lewat `AppDatabaseFactory(ownerId)`; tes membuka dua akun dan memastikan datanya terpisah; fungsi hapus berkas untuk hapus akun.
3. `DriftTransactionRunner` (implementasi TransactionRunner): `db.transaction`, bersarang bergabung (savepoint), pengecualian dilempar ulang; lolos tes kontrak runner dari BP0.
4. `OutboxWriter`: menambah baris outbox (table, row_id, op, payload, created_at) di transaksi yang sama dengan data; dipakai repository di B1b-e. Tes: rollback ikut membatalkan baris outbox.
5. `DriftLocalSettingsRepository` lolos kontrak LocalSettings.
6. Pastikan SQLite berjalan di `flutter test` pada mesin pengembang (NativeDatabase.memory). Jika butuh pustaka native, tulis langkahnya di README.
7. check_arch: drift hanya di core/persistence dan features/*/data.

Laporkan: daftar tabel, versi paket, cara menjalankan tes SQLite, temuan. Prompt berikutnya: B1b-drift-pelanggan.md.
