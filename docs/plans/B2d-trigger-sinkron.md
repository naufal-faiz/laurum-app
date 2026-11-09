# B2d — pemicu sinkron, retry, dan status koneksi

Status: dikerjakan 9 Nov 2026. Dasar: PRD B §7, docs/plans/B2-kontrak-sinkronisasi.md
butir B2d, B2c selesai.

## Ruang lingkup
- Mesin pemicu murni: debounce 2 dtk setelah tulis lokal, retry backoff eksponensial
  maks 15 mnt, satu siklus berjalan pada satu waktu, periodik 15 mnt saat aplikasi aktif.
- Koneksi: `ConnectionMonitor` (connectivity_plus) memberi status online/offline ke
  `SyncService`; pulih dari offline memicu percobaan lagi.
- Foreground: `AppLifecycleListener` memicu sync saat aplikasi kembali aktif.
- `DriftSyncService` memakai `SyncScheduler`; status `offline`/`gagal` nyata dan
  `lastSyncedAt` disimpan di `local_settings` (keadaan perangkat, aturan 20).
- Indikator dan halaman Sinkronisasi yang ada tidak diubah; hanya sumber statusnya.
- Gerbang: koordinator push/pull belum ada sampai B3 (Auth/Supabase belum diinisialisasi).
  Selama gerbang tertutup TIDAK ada timer/koneksi jaringan; `syncNow` tetap refresh lokal.

## Keputusan
- `workmanager` (sinkron latar isolate) ditunda ke B3: worker butuh sesi Auth nyata,
  inisialisasi Supabase, dan bootstrap database di isolate. Periodik B2d berjalan saat
  aplikasi aktif; PRD B §7 untuk latar tetap dicatat sebagai B3.
- `connectivity_plus` dipasang sesuai izin B2 butir 4; implementasi nyata hanya
  dipasang di `main.dart`/`main_dummy.dart`, sedangkan default provider `Noop` agar
  tes tidak menyentuh plugin.

## Berkas
- Baru: `core/sync/sync_timing.dart`, `sync_scheduler.dart`, `connection_monitor.dart`,
  `core/persistence/sync_bindings.dart`.
- Ubah: `SyncService` (+`notifyForeground`, `setConnection`, `canSync`),
  `FakeSyncService`, `DriftSyncService`, `app.dart`, `main.dart`, `main_dummy.dart`.

## Urutan
1. Tes timing/backoff + scheduler (fake_async) lebih dulu.
2. ConnectionMonitor + binding + tes provider; sambungkan ke app/main.
3. DriftSyncService: gerbang koordinator, status, lastSyncedAt + tes.
4. check_all, docs progress/b2d.md, INDEX/STATE, commit, berhenti.
