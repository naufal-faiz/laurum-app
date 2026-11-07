# B2c — adapter Supabase dan pull seluruh tabel (selesai 7 Nov 2026)

Kelanjutan B2 yang disetujui pengguna. Lingkup: adapter Supabase untuk push/pull,
penyimpanan kursor, pemetaan seluruh tabel owner saat pull, dan koordinator push-lalu-pull.
Tanpa UI, Auth nyata, upload foto, cloud, push, atau merge.

## Hasil

- `SupabaseSyncTransport` mengimplementasikan `SyncTransport` dan `SyncPullTransport`
  lewat RPC `sync_push`/`sync_pull`. Respons diurai di `supabase_sync_wire.dart`:
  receipt per perubahan, kursor `(updated_at,id)`, dan `has_more`.
- Galat Supabase dipetakan ke kode aman yang diizinkan (`not_allowed`,
  `request_rejected`, `authentication_required`, `network_failure`, atau kode kontrak).
  Pesan SQL mentah dan PII tidak pernah diteruskan ke pemanggil.
- `SyncPullRunner` menarik tabel dalam urutan dependensi:
  businesses → customers → services → expense_categories → receipt_settings → devices →
  entitlements → orders → order_items → payments → savings_entries → order_events →
  expenses. Halaman diulang sampai `has_more=false`; kursor yang tidak maju menghentikan
  loop dengan `StateError`, bukan berputar selamanya.
- `DriftSyncCursorStore` menyimpan kursor pasangan `(updated_at,id)` di `sync_cursors`.
  Tabel di luar daftar pull ditolak sebelum menyentuh SQL.
- `DriftSyncRemoteApplier` memetakan baris wire ke 13 tabel lokal dengan upsert per `id`:
  - baris dengan entri outbox untuk `(table,row_id)` yang sama TIDAK ditimpa pull;
  - `owner_id` wajib sama dengan akun aktif, `id` wajib UUID;
  - timestamp dinormalkan ke UTC enam digit; nilai integer nonbulat ditolak;
  - `name_key`/`phone_key` pelanggan dan `created_key` tabungan dihitung ulang;
  - tombstone (`deleted_at`) ikut diterapkan; `sync_state` menjadi `synced`.
  Kegagalan apply terjadi di dalam transaksi dan kursor tidak dimajukan, sehingga
  siklus berikutnya mengulang halaman yang sama.
- `DriftSyncAckWriter` (dipakai `DriftSyncOutboxStore`): ack hanya menghapus change ID
  yang benar-benar dikirim dan menandai baris `synced` hanya bila tidak ada entri outbox
  tersisa; konflik menandai baris lokal `conflict`.
- `SyncEngine` mencatat `SyncTransportException.code` sebagai `last_error`, bukan pesan
  transport mentah.
- `SyncCoordinator` menjalankan push lebih dulu; bila push terblokir (legacy/konflik/
  gagal), pull tidak dijalankan.
- Dependensi `supabase_flutter ^2.18.3` dipasang lewat `flutter pub add` (sesuai izin B2).
  `shared_preferences` hanya masuk sebagai dependensi transitif; proyek tidak
  mengimpor atau mendeklarasikannya, dan `check_arch`/aturan 20 tetap hijau.

## Bukti

```powershell
powershell -NoProfile -Command '$env:BOT="true"; $env:FLUTTER_SUPPRESS_ANALYTICS="true"; . ./tool/windows_native_sdk.ps1; dart run tool/check_all.dart'
# format 874 berkas, analyze/Riverpod lint tanpa isu, check_arch OK
# 926 tes lulus, 1 tes integrasi dilewati
# REPO_MAP 941 berkas
# check_all: SEMUA HIJAU (exit 0)
```

Tes B2c baru:

- `test/sync/sync_pull_wire_test.dart` — parsing receipt dan halaman pull, penolakan
  respons tabel lain/kursor rusak.
- `test/sync/sync_pull_runner_test.dart` — urutan dependensi, paginasi, kursor macet,
  galat transport mempertahankan kursor terakhir yang baik.
- `test/sync/sync_coordinator_test.dart` — push dulu lalu pull; push terblokir tidak
  menyentuh transport pull.
- `test/persistence/drift_sync_cursor_store_test.dart` — kursor tuple dan tabel asing.
- `test/persistence/drift_sync_remote_applier_test.dart` — ke-13 tabel, tombstone,
  apply idempoten, baris dengan outbox tidak tertimpa, owner/ID tidak sah ditolak.
- `test/persistence/drift_sync_outbox_store_test.dart` — perluasan `sync_state`:
  ack selektif, tetap pending bila grup lain masih antre, konflik.
- `test/sync/supabase_sync_local_test.dart` — tes integrasi dua akun, digerbangi env
  lokal (lihat di bawah).

## Tes integrasi lokal: BELUM DIJALANKAN

Tes dua akun nyata sudah dikompilasi tetapi **dilewati** karena daemon Docker tidak
aktif saat pengerjaan:

```
failed to connect to the docker API at npipe:////./pipe/dockerDesktopLinuxEngine
```

Docker Desktop terpasang di `C:\Users\Naufal\AppData\Local\Programs\DockerDesktop`.
Untuk menjalankannya (kunci hanya di env proses, jangan ditulis ke repo):

```powershell
# Terminal 1, dari root repo
& ./supabase/node_modules/.bin/supabase.cmd start --workdir .
& ./supabase/node_modules/.bin/supabase.cmd db reset --workdir .

# Terminal 2
$env:LAURUM_LOCAL_SUPABASE_URL="http://127.0.0.1:54321"
$env:LAURUM_LOCAL_PUBLIC_KEY="<anon key dari supabase status>"
$env:LAURUM_LOCAL_SERVICE_KEY="<service_role key dari supabase status>"
flutter test test/sync/supabase_sync_local_test.dart
```

Tes membuat dua akun sintetis, menulis satu grup lengkap di akun A, memastikan akun B
tidak melihat data A, mem-pull ke database baru, lalu menghapus akun dan baris uji.
Jangan dijalankan pada proyek cloud.

## Batas dan langkah berikutnya

- Indikator/aksi sinkron, retry, debounce, koneksi, dan periodik tetap B2d.
- Antrean foto dan upload privat tetap B2e.
- Auth nyata, pemulihan sesi, dan hapus akun lintas perangkat tetap B3.
- Langkah berikutnya: jalankan tes integrasi lokal saat Docker aktif, tinjau B2c,
  lalu tulis B2d.
