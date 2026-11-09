# B2d — pemicu sinkron, retry, dan status koneksi

SELESAI 9 Nov 2026. Rencana: docs/plans/B2d-trigger-sinkron.md.
Prasyarat: B2a/B2b/B2c. Tanpa UI baru, Auth nyata, cloud, push, atau merge.

## Hasil
- `core/sync/sync_timing.dart`: debounce 2 dtk, backoff 2 dtk → 15 mnt, periodik 15 mnt.
- `core/sync/sync_scheduler.dart`: satu siklus pada satu waktu, hentikan timer saat offline,
  langsung mencoba lagi saat koneksi pulih, `triggerNow` meneruskan galat untuk aksi manual.
- `core/sync/sync_trigger.dart` + `SyncCycle`: menjalankan push/pull, melaporkan
  online/running/failed; tanpa siklus tidak ada timer atau panggilan jaringan.
- `core/sync/connection_monitor.dart` + `connectivity_connection_monitor.dart`:
  nilai awal saat listen lalu perubahan; default `NoopConnectionMonitor` (senyap) untuk tes.
- `core/persistence/sync_bindings.dart`: one-shot binding koneksi + `AppLifecycleListener`
  (resume memicu sync). Dipasang lewat `syncBindingsProvider` di akar aplikasi.
- `SyncService` bertambah `canSync`, `notifyForeground`, `setConnection`. `FakeSyncService`
  memetakan offline/pulih ke status; `DriftSyncService` memakai trigger, menyimpan
  `sync_last_at` di `local_settings` (keadaan perangkat, aturan 20).
- Gerbang B3 tetap tertutup: `AccountStore` membuat `DriftSyncService(db)` tanpa
  `SyncCycle`, jadi tidak ada timer/jaringan; `syncNow` hanya menyegarkan hitungan outbox.
- `connectivity_plus ^7.3.2` (izin B2 butir 4) dan `fake_async ^1.3.3` (dev) dipasang.
- `main.dart`/`main_dummy.dart` memakai monitor koneksi nyata; tes memakai default senyap
  supaya status offline awal buatan tes tidak ditimpa.

## Bukti
- Tes baru: `test/sync/sync_scheduler_test.dart` (7), `test/sync/sync_bindings_test.dart`
  (1), `test/persistence/drift_sync_service_test.dart` (6).
- `dart run tool/check_all.dart` HIJAU 943 tes, 1 tes integrasi dilewati, archOK,
  REPO_MAP953, exit0.

## Catatan / tindak lanjut
- Sinkron latar `workmanager` ditunda ke B3: worker butuh sesi Auth, inisialisasi Supabase,
  dan bootstrap database di isolate. Periodik B2d hanya saat aplikasi aktif.
- `SyncCycle` disuntikkan ke `DriftSyncService` saat B3 menyiapkan `SyncCoordinator`.
- Aksi manual saat offline melempar galat (UI menampilkan status offline); saat gerbang
  B3 belum terbuka, aksi manual hanya menghitung ulang outbox.
