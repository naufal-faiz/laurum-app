# B1a — Fondasi Drift per akun (4 Nov 2026)

Status: SELESAI; check_all 740 tes, kedua analyzer dan arsitektur hijau.
Cabang dev2backend; prasyarat BP0 pada 8e51cda. Baseline: 719 tes hijau.
Tidak ada wiring aplikasi, widget/layar baru atau perubahan .pen.

## Paket dan skema

Resolver `flutter pub add`: drift 2.35.3, sqlite3 3.8.0, path_provider 2.1.6,
drift_dev 2.35.2, build_runner 2.17.1. Tidak ada paket Supabase/sync.

SchemaVersion = 1; 16 tabel:
businesses, devices, customers, services, orders, order_items, payments,
savings_entries, expense_categories, expenses, receipt_settings, entitlements,
order_events, outbox, sync_cursors, local_settings.

- Kolom metadata sinkron: id/owner_id, created_at/updated_at, sync_state dan
  deleted_at; savings_entries tidak memiliki deleted_at. Tidak ada pay_status tersimpan.
- sync_state menerima synced/pending serta conflict sesuai PRD B 7; enum domain belum
  diubah. Resolusi konflik/penyambungan ke state aplikasi tetap pekerjaan B2.
- Uang/jumlah integer; pembayaran koreksi negatif diizinkan. Nomor telepon aktif
  berindeks unik (kecuali kosong), nomor nota unik per owner, FK aktif, indeks rentang.
- Selisih dokumen: PRD B 5 belum mencantumkan order_events. Tabel ini disediakan
  karena sudah menjadi domain R4/R8 dan disebut B1d; tidak mengubah PRD diam-diam.
- Timestamp ISO-8601 di build.yaml menjaga subdetik dan bentuk lokal/UTC. Generator
  manager tidak diaktifkan; repository memakai API query Drift biasa.

## Transaksi dan lifecycle

- Factory menggunakan application support directory, laurum_<ownerId>.db. Nama akun
  dibatasi ke karakter aman. Open/close/delete diserialkan per instance factory.
  Delete menutup koneksi lalu menghapus berkas akun dan sidecar SQLite saja.
- DriftTransactionRunner menggunakan transaksi/savepoint native. Error nested yang
  ditangkap tetap meracuni transaksi luar sesuai kontrak BP0; exception asli dilempar ulang.
- OutboxWriter membungkus callback mutasi dan insert outbox dalam runner yang sama,
  memeriksa database/target, menolak tabel lokal, memakai UUID v4 dan operasi upsert/delete.
- Pemetaan payload snake_case/timestamp wire-format dilakukan repository B1b-e;
  OutboxWriter hanya mengenkode JSON. JSON default data-class bukan kontrak server.
- DriftLocalSettingsRepository lulus suite BP0 tanpa menyalin kontrak. Tidak menyinkronkan
  preferensi perangkat. Penggantian tipe pada key yang sama menghapus nilai tipe lama.

## Migrasi

- onCreate membuat skema v1; upgrade yang belum didefinisikan ditolak.
- Snapshot beku test/persistence/schema/drift_schema_v1.json dan helper hasil generate
  test/persistence/generated dipakai SchemaVerifier. Helper dihasilkan dengan
  --data-classes --companions agar generik lengkap pada analyzer strict, tanpa ignore tambahan. Jangan menimpa v1 ketika skema berubah.
- Tes memeriksa fresh schema, ketidaksesuaian schema, pembukaan snapshot v1 dan data tetap.
- Drift tidak memverifikasi constraint dari spread/konstanta bersama; definisi memakai
  literal yang dapat dianalisis. Regenerasi terakhir tanpa peringatan constraint.

## SQLite Windows

20 tes fondasi hijau; snapshot + isolasi akun 4 tes hijau (3 kasus beririsan).
NativeDatabase.memory dan berkas nyata di Temp berjalan; tidak memasang DLL manual.
Hook native gagal pada path SDK E:/App Data karena spasi. Alias saja membantu Flutter,
tetapi Dart CLI memakai resolvedExecutable. Helper tool/windows_native_sdk.ps1 memakai
junction Flutter + salinan Dart SDK di Temp (~588 MB), PATH/FLUTTER_ROOT hanya per proses.
Instalasi asli dan konfigurasi global tetap; cara aktivasi/regenerasi ada di README.
Android/iOS untuk database belum diuji; aplikasi masih in-memory sampai B1f.

## Verifikasi akhir

Pemeriksaan penuh dengan helper SDK Windows aktif:

```
Formatted 702 files (0 changed)
flutter analyze: No issues found!
dart analyze / Riverpod lint: No issues found!
check_arch: OK
+740: All tests passed!
REPO_MAP diperbarui: 769 berkas
check_all: SEMUA HIJAU
```

719 tes sebelumnya + 21 tes B1a lolos. Semua Dart baru non-generated <=100 baris;
file generated dikecualikan sesuai aturan. Tidak mengubah lint/registry/tema/fixture.
PowerShell mengategorikan progres native hooks dari stderr sebagai NativeCommandError
pada redirect; itu bukan kegagalan checker. Probe CLI terpisah membuktikan kode keluar
Dart 0. Untuk otomasi, simpan `$LASTEXITCODE` segera dan `exit` dengan nilai tersebut.
Log penuh: `%TEMP%/laurum-b1a-check.log`; probe: `%TEMP%/laurum-b1a-exit-probe.log`.
Prompt berikutnya: B1b-drift-pelanggan.md. Supabase cloud/key belum dibutuhkan.

Sumber teknis: [setup](https://drift.simonbinder.eu/setup/),
[transaksi](https://drift.simonbinder.eu/dart_api/transactions/),
[migrasi](https://drift.simonbinder.eu/migrations/tests/),
[timestamp](https://drift.simonbinder.eu/guides/datetime-migrations/).
