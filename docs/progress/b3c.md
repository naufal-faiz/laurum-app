# B3c — hapus akun nyata dan gerbang sinkron

SELESAI 9 Nov 2026. Rencana: docs/plans/B3-auth.md.
Prompt: docs/prompts/B3c-hapus-akun-sinkron.md. Prasyarat: B3a SELESAI.
Dikerjakan sebelum B3b karena prioritas pengguna adalah sinkron; gerbang hanya
butuh sesi B3a, bukan UX konfirmasi/pemulihan B3b. Tanpa push/merge, tanpa
mengubah proyek cloud, tanpa upload foto (B2e).

## Hasil

### Hapus akun lewat Edge Function
- `AuthGateway.deleteAccount` baru; `SupabaseAuthGateway` memanggil Edge
  `delete-account` (`const deleteAccountFunction`), memetakan
  `FunctionException.status` ke `AuthException`, lalu menutup sesi lokal.
  Respons sukses tidak diperiksa isinya, jadi tidak ada token/body yang masuk log.
- `SupabaseAuthService.deleteAccount` memakai mixin `SupabaseAccountActions`,
  memetakan galat lewat `failureFor` (429 → `requestLimit`, jaringan/5xx →
  `unavailable`), lalu mereset flag sesi. Alur dua konfirmasi, `TransactionRunner`,
  `deleteLocalData`/`finishDelete`, draf reset, dan cooldown tetap dari R10/B1f;
  sekarang jalur hapus akun benar-benar memanggil server lebih dulu.

### Gerbang sinkron nyata
- `lib/core/sync/supabase_sync_cycle.dart`: `supabaseSyncCycle(db, client, owner)`
  merakit `SyncCoordinator(SyncEngine(DriftSyncOutboxStore, SupabaseSyncTransport),
  SyncPullRunner(DriftSyncCursorStore, DriftSyncRemoteApplier))`; JWT sesi Supabase
  membatasi baris lewat RLS.
- `supabaseSyncCycleFromSession()` menjadi pabrik gerbang untuk `main.dart`, supaya
  `main.dart` tidak mengimpor `supabase_flutter` (aturan 19).
- `AccountStorage`/`AccountStore` menerima `SyncCycle` opsional;
  `syncCycleFactoryProvider` (default `null`) di-override di `main.dart` hanya saat
  Auth nyata aktif. Tanpa itu tidak ada timer/jaringan dan `syncNow` tetap hanya
  menghitung ulang outbox (mode dummy utuh).
- "Sinkron sekarang", debounce, retry, foreground, dan periodik B2d kini berjalan
  di atas transport nyata.

### Registrasi perangkat
- `lib/core/persistence/device_registrar.dart` menyimpan identitas tetap di
  `local_settings` (`device_identity`, UUID v4) dan menulis satu baris `devices`
  lewat `OutboxWriter` per akun; `last_seen_at` diisi saat pendaftaran.
- Dipanggil dari `AccountStore.start()` hanya bila gerbang sinkron terbuka;
  kegagalan didiamkan agar akun tetap bisa dibuka. Mode dummy tidak menulis baris
  perangkat, sehingga outbox contoh tetap bersih.
- Kunci `device_code` sengaja TIDAK dipakai: kunci itu milik prefiks nomor nota
  (`A-0143`) yang divalidasi `OrderNumberGenerator`; memakainya untuk UUID
  mematahkan checkout (ditemukan lewat tes Drift lalu diperbaiki).

### Sinkron latar (workmanager)
- Dependensi `workmanager 0.10.10` dipasang lewat `flutter pub add` (disetujui
  pengguna 9 Nov 2026).
- `lib/core/sync/background_sync.dart`: task periodik `laurum.sync.periodic`
  tiap 15 menit dengan kendala jaringan; dispatcher `@pragma('vm:entry-point')`
  memulihkan Supabase, membaca owner dari sesi, membuka database akun, menjalankan
  satu siklus push-lalu-pull, lalu menutup database. Gagal → `false` agar
  WorkManager mencoba ulang; tanpa sesi → `true` tanpa kerja.
- Dijadwalkan di `main.dart` hanya pada Android/iOS saat Auth nyata aktif;
  kegagalan penjadwalan tidak menahan frame pertama.
- `AppDatabaseFactory` memasang `PRAGMA busy_timeout = 5000` agar isolate latar
  dan aplikasi bisa menulis bergantian tanpa langsung `SQLITE_BUSY`.

## Bukti
- Tes baru/berubah (28 tes terarah, semuanya lulus):
  - `test/sync/sync_gate_wiring_test.dart` (2): gerbang terbuka menjalankan siklus
    dan mendaftarkan perangkat; gerbang tertutup tidak menelepon jaringan dan tidak
    menulis `devices`.
  - `test/persistence/device_registrar_test.dart` (2): satu baris per install,
    kode stabil, satu entri outbox `devices`; akun kedua di install yang sama
    memakai kode yang sama.
  - `test/auth/supabase_auth_service_test.dart`: hapus akun memanggil gateway,
    membersihkan sesi, dan memetakan 429/500; gagal tidak mengaku terhapus.
- `dart run tool/check_all.dart` → **SEMUA HIJAU**: format 908 berkas, analyze +
  Riverpod lint tanpa isu, check_arch OK, **965 tes lulus** (1 integrasi Supabase
  lokal dilewati tanpa env), REPO_MAP 975 berkas, exit 0.
- Pemeriksaan cloud (hanya baca, 9 Nov 2026): `migration list --remote` menunjukkan
  kelima migrasi `remote` = `local` pada proyek `laurumdb`
  (`iczxtytiomlrpngitdlf`). Agen tidak mengubah proyek cloud.

## Batasan (belum diverifikasi)
- `workmanager` tidak bisa diuji di unit test: jadwal, isolate, dan perilaku OEM
  Android perlu dijalankan di perangkat. iOS butuh `BGTaskScheduler`/Info.plist
  (belum dikerjakan, belum diuji).
- Sinkron ujung-ke-ujung ke cloud belum diamati di perangkat; kode sudah menyalakan
  gerbang, tetapi bukti nyata butuh login lalu ubah satu data dan lihat baris di
  tabel cloud.
- `GOOGLE_WEB_CLIENT_ID` masih kosong di `.env.local`; login Google dan SHA-1
  Android belum dikonfirmasi.
- B3b tetap BELUM: konfirmasi email, penyegaran sesi via deep link, dan layar
  password baru belum ada; belum ada akun uji/peti surat untuk verifikasi manual.

## Cara menguji di perangkat
```
flutter run -t lib/main.dart --dart-define-from-file=.env.local
```
Masuk dengan akun cloud, buat satu pelanggan/nota, tekan "Sinkron sekarang", lalu
periksa baris `devices` dan data terkait di dashboard Supabase. Sinkron latar
dapat diperiksa dengan menutup aplikasi dan menunggu jadwal WorkManager (15 menit,
bergantung pada kebijakan baterai OEM).
