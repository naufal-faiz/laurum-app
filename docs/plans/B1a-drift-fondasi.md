# B1a — Fondasi Drift lokal

Prasyarat: BP0 selesai, baseline check_all hijau. Tanpa wiring aplikasi atau cloud.

1. Verifikasi dokumentasi Drift/SQLite native dan versi melalui flutter pub add.
2. Tes lebih dahulu: skema v1, isolasi/penghapusan akun, outbox atomik,
   kontrak LocalSettings dan TransactionRunner dari BP0.
3. Definisikan tabel PRD B 5, order_events dari domain/B1d, dan tiga tabel lokal.
4. Implementasikan AppDatabase, migrasi create-v1 dan snapshot skema yang diuji.
5. Implementasikan AppDatabaseFactory dengan direktori platform/injeksi direktori tes,
   nama berkas per akun, penutupan dan penghapusan berkas beserta sidecar SQLite.
6. Implementasikan runner: transaksi native/savepoint, kegagalan nested membatalkan
   transaksi luar sesuai kontrak; exception asli dilempar ulang.
7. Implementasikan DriftLocalSettingsRepository dan OutboxWriter; tanpa sync engine.
8. Uji SQLite NativeDatabase.memory dan berkas nyata di Windows; catat kebutuhan native.
9. Self-review batas baris, impor, data negatif koreksi, FK/index dan snapshot v1.
10. check_all hijau, README/progres/STATE/INDEX, commit lalu berhenti sebelum B1b.

Sumber teknis: dokumentasi resmi drift.simonbinder.eu/setup, /testing,
/dart_api/transactions, /migrations/tests. Tidak ada perubahan tampilan atau .pen.
