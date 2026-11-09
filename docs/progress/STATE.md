# STATE Laurum
Diperbarui: 2026-11-09 | Cabang dev2backend

## Posisi
UI100/R0-R10, BP0, B1a-f, B0, **B2a, B2b, B2c, B2d, dan B3a SELESAI**; B3b, B3c, B2e+ menunggu.
B2 disetujui pengguna 6 Nov 2026. Bukti B2a/B2b/B2c/B2d: docs/progress/b2a.md, b2b.md,
b2c.md, b2d.md. B3 dibagi B3a/B3b/B3c: docs/plans/B3-auth.md; bukti B3a: docs/progress/b3a.md.
Bukti B1f: docs/progress/b1f.md dan b1f-benchmark.json; tanpa push/merge.
B0 SELESAI: docs/prompts/B0-supabase.md; rencana docs/plans/B0-supabase-lokal.md.
Berkas/bukti/selisih rinci: docs/progress/b0.md, b2a.md, b2b.md, b2c.md, b2d.md, b3a.md
dan supabase/README.md.

## Aset merek dan ikon launcher (9 Nov 2026)
- `assets/icons/` didaftarkan di pubspec; `AppSvgs` memuat `google`, `facebook`,
  `whatsapp`, `cursorBack`. Ikon merek berwarna tetap (bukan currentColor).
- `AppButton`/`AppIconButton` menerima `iconAsset` selain `icon` (saling eksklusif,
  API lama tetap jalan). Dipakai di tombol Google, ikon Hubungi daftar pelanggan,
  serta tombol Buka WhatsApp pada detail pelanggan dan detail order.
- `facebook.svg` dan `cursor-back.svg` belum dipakai UI: PRD A hanya menetapkan login
  Google; fitur login Facebook tidak ada dan tidak ditambahkan.
- Ikon launcher: PNG legacy + adaptive (back/fore) berdimensi benar; XML
  `mipmap-anydpi-v26/ic_launcher.xml` merujuk lapisan adaptive. Pratinjau komposit
  menunjukkan kartu putih + logo "LAURUM" mengisi area terlihat mask; latar hitam hanya
  di margin crop. Terpasang dan diperiksa di SM-N975F (Android, wireless).
- Golden yang berubah karena ikon merek sudah diperbarui: customer_row, auth_signin(+error),
  r10_signin(+error,320_2x), r4_order_detail, order_detail_actions_1x.


## Hasil B3a (9 Nov 2026)
- Konfigurasi publik lewat `--dart-define`/`--dart-define-from-file=.env.local`:
  `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `GOOGLE_WEB_CLIENT_ID`
  (`core/services/auth_config.dart`). Tanpa konfigurasi aplikasi tetap mode dummy
  dan tidak menyentuh jaringan.
- Sesi Supabase disimpan di `flutter_secure_storage` (`SecureSessionStorage`,
  `SecurePkceStorage`) — aturan 20; `shared_preferences` tetap transitif dan tidak
  diimpor. `initializeSupabase` memulihkan sesi sebelum UI dan menerima deep link
  `laurum://auth-callback` (intent filter Android dipasang).
- `SupabaseAuthService` (+ `SupabaseAuthGateway`, `SupabaseAccountActions`,
  `GoogleSignInTokenSource`) mengimplementasikan `AuthService`: masuk email+password,
  daftar dengan konfirmasi email, Google id-token, profil `user_metadata`, ganti
  password dengan verifikasi password lama, reset seragam, keluar. Galat Supabase
  dipetakan ke `AuthFailure`; kredensial salah/duplikat memakai pesan seragam.
  `deleteAccount` sengaja `unavailable` sampai B3c.
- `main.dart`: Auth nyata hanya bila build Drift + konfigurasi tersedia.
- check_all HIJAU 960 tes (+17 tes Auth), 1 integrasi dilewati tanpa env lokal,
  archOK, REPO_MAP970. Tanpa UI baru, cloud diubah, push, atau merge.
- Pemeriksaan cloud baca-saja: `/auth/v1/settings` 200 (Google + email aktif,
  `mailer_autoconfirm=false`), `/auth/v1/health` 200 dengan kunci publik.
- BELUM BISA DIUJI: migrasi cloud belum diterapkan (`app_config`/`orders` PGRST205),
  belum ada akun uji/peti surat, `GOOGLE_WEB_CLIENT_ID` + SHA-1 Android belum ada.
- LANGKAH BERIKUTNYA: tinjauan pengguna, lalu B3b (konfirmasi/pemulihan) —
  docs/prompts/B3b-konfirmasi-pemulihan.md. Jangan mulai B3c sebelum B3b selesai.
- Keputusan 9 Nov 2026: pengguna menyetujui dependensi `workmanager` untuk sinkron
  latar di B3c (pasang, jangan tunda). Sinkron "Sinkron sekarang" masih hanya
  menghitung ulang outbox karena `AccountStore` membuat `DriftSyncService(db)`
  tanpa `SyncCycle`; gerbang baru dibuka di B3c.

## Hasil B2d (9 Nov 2026)
- Mesin pemicu murni: debounce 2 dtk, backoff eksponensial 2 dtk → 15 mnt, periodik
  15 mnt saat aplikasi aktif, satu siklus pada satu waktu; offline menghentikan timer
  dan koneksi pulih langsung mencoba lagi. `triggerNow` meneruskan galat ke aksi manual.
- `SyncCycle` (dipenuhi `SyncCoordinator`) disuntikkan ke `DriftSyncService`; selama
  gerbang B3 belum ada (Auth/Supabase belum diinisialisasi) tidak ada timer/jaringan,
  `syncNow` hanya menghitung ulang outbox.
- `ConnectionMonitor`/`ConnectivityConnectionMonitor` (connectivity_plus ^7.3.2) memberi
  nilai awal lalu perubahan; default `NoopConnectionMonitor` senyap agar tes tidak
  menyentuh plugin. `syncBindingsProvider` menyambungkan koneksi + `AppLifecycleListener`
  (resume memicu sync) dan dipasang di akar aplikasi; main memakai monitor nyata.
- `DriftSyncService` menyimpan `sync_last_at` di `local_settings` (aturan 20) dan status
  offline/gagal/tersimpan/menyimpan berasal dari trigger + jumlah outbox.
- `workmanager` (sinkron latar isolate) sengaja ditunda ke B3: butuh sesi Auth,
  inisialisasi Supabase, dan bootstrap database di isolate.
- check_all HIJAU 943 tes (+14 dari B2c), 1 tes integrasi dilewati tanpa env lokal,
  archOK, REPO_MAP953, exit0. Tes baru: scheduler 7, binding 1, Drift service 6.
  Tanpa UI baru, cloud, push, atau merge.
- LANGKAH BERIKUTNYA: tinjauan pengguna, lalu B3 (Auth nyata). Butuh kredensial Google
  OAuth, SMTP, dan URL/kunci publik Supabase lewat `--dart-define`. Jangan mulai B3
  tanpa itu.

## Hasil B2c (7 Nov 2026)
- Adapter `SupabaseSyncTransport` (push+pull RPC), parsing wire, dan pemetaan galat aman.
- Pull per tabel dengan kursor `(updated_at,id)` di `sync_cursors`, urutan dependensi,
  maks 500 per halaman, kursor tidak maju = berhenti.
- `DriftSyncRemoteApplier` memetakan 13 tabel owner: upsert, tombstone, timestamp UTC6,
  `name_key`/`phone_key`/`created_key`, `sync_state=synced`; baris yang masih punya
  entri outbox tidak pernah ditimpa pull.
- Ack hanya menghapus ID `ok` dan menandai `synced` bila outbox bersih; konflik menandai
  baris lokal `conflict`. `SyncEngine` mencatat kode galat transport yang aman.
- `SyncCoordinator` push dulu; pull dilewati bila push terblokir.
- `supabase_flutter ^2.18.3` dipasang lewat `flutter pub add`; `shared_preferences`
  hanya transitif dan tidak diimpor (aturan 20 tetap hijau).
- Tes integrasi dua akun lokal SUDAH dijalankan (7 Nov 2026): stack `--exclude studio`
  (health check Studio timeout), db reset exit0, pgTAP 219/219 PASS, tes dua akun lulus.
- Peninjauan menemukan dan memperbaiki dua masalah foto: path foto perangkat tidak lagi
  masuk payload (server menolak path non-`owner_id/`), dan pull dengan `photo_path` null
  tidak menghapus lampiran lokal. Upload/download foto tetap B2e.
- check_all HIJAU 928 tes (+22 dari B2b), 1 tes integrasi dilewati tanpa env lokal,
  archOK, REPO_MAP941, exit0.
- LANGKAH BERIKUTNYA: tinjauan pengguna, lalu tulis B2d (indikator/retry/koneksi).
  Jangan mulai B3.

## Hasil B2b (7 Nov 2026)
- Drift v5: outbox punya group_id/group_seq/requires_recovery/conflict_code;
  snapshot v5 ditambah, v1–v4 beku. Baris baru = satu grup per transaksi bisnis.
- Migrasi v4 tidak menebak grup: baris lama diblokir sampai pemulihan eksplisit.
- SyncOutboxStore (Drift+InMemory): ack selektif, attempts, konflik, legacy recovery.
- SyncEngine: hash kanonik SHA-256 (crypto disetujui), fragmen >50, receipt idempoten,
  retry setelah respons hilang, konflik/legacy memblokir grup berikutnya.
- check_all HIJAU 906 tes, archOK, REPO_MAP917, exit0. Tanpa UI/Supabase/network.
- LANGKAH BERIKUTNYA: tinjauan pengguna, lalu tulis prompt B2c (adapter Supabase,
  push/pull nyata dua akun lokal, pemetaan seluruh tabel). Jangan mulai B3.

## Hasil B2a (6 Nov 2026)
- Migrasi baru `20261106062912_b2a_sync_groups.sql`; empat migrasi B0 utuh.
  Wire schema5 (`app_config.min_schema_version=5`).
- Item nota mutable/soft-delete selama order belum final, immutable setelah final;
  id/owner/order_id tetap; tanpa DELETE klien.
- `sync_push` grup atomik: fragmen >50, hash kanonik SHA-256, receipt idempoten per
  owner, retry tidak memundurkan edit baru, rollback utuh bila satu anggota gagal.
- `sync_pull` tuple `(updated_at,id)` UTC6, maks500, tombstone, lock per owner;
  `private.owner_clock` menjaga updated_at monoton.
- `delete_my_account` membersihkan grup/fragmen/receipt; isolasi dua owner diuji.
- PRD B §6–8 direvisi terbatas; README memuat kontrak dan pemulihan antrean v4.
- db reset exit0; pgTAP219/219 PASS; runtime1 PASS; check_all HIJAU 882 tes,
  archOK, REPO_MAP895, exit0. Tidak ada paket Flutter/UI/cloud yang diubah.
- LANGKAH BERIKUTNYA: tinjauan pengguna, lalu tulis prompt B2b dari kontrak teruji
  (Drift v5, metadata grup outbox, receipt/konflik, SyncEngine transport palsu).
  Jangan mulai B2c/B3 sebelum B2b selesai.


## Hasil B0
- CLI npm Supabase3.0.0 terkunci di supabase/package-lock.json; Docker29.9.2/WSL2.
- Config/Auth/Mailpit, empat migrasi schema/RLS/triggers/RPC, Edge delete-account,
  pgTAP semua tabel/Storage, enam tes handler Node dan tes runtime nyata lulus.
- Tidak mengubah lib/pubspec/PRD, tidak mengakses/mengubah cloud, tanpa kunci repo.
- Docker dipindahkan pengguna ke E: setelah C: tinggal4,7MB dan extract gagal.
- db reset exit0; pgTAP140/140 PASS. 47 policy public +4 Storage terpasang.
  Cleanup role tanpa akses schema Auth, UID dari verified claims; RLS tetap auth.uid.
- Node handler6 PASS; runtime1 PASS: Auth min8/konfirmasi, Storage privat,
  purge A tanpa menyentuh B. Cleanup akhir auth_users/storage_objects/customers=0.
- check_all HIJAU:882 tes, dua analyzer tanpa isu, archOK, map895, exit0.
  BOT=true/FLUTTER_SUPPRESS_ANALYTICS=true hanya proses mencegah crash telemetry.
  Check terbaru persiapan B2: Temp/laurum-b2-preparation-check.log (882 tes, exit0).
- Snapshot Edge rusak: binary40MB, arsip resmi166.846.080byte. Dipulihkan dari
  arsip resmi ke image cache laurum-edge-runtime-recovered:v1.77.9, tag CLI lokal
  menunjuk recovered; digest berubah karena layer pemulihan, versi tetap1.77.9.
  Tidak publish image/ubah volume. Binary/runtime/HTTP lulus setelah pemulihan.
- Analytics opsional off (Vector host IPv6:2375 gagal); startup normal tanpa exclude
  exit0. Stack lokal aktif, tanpa ignore-health-check. Bukti Temp/laurum-b0-runtime.log.
- Cache SDK sementara kini E:\laurum-b0-native-dart-sdk (tanpa spasi), junction
  Temp/laurum-native-dart-sdk menunjuk ke sana. SDK asli tetap. Path berspasi
  mematahkan native hook; jangan pindah cache ini ke folder repo berspasi.
- B2a/B2b: kontrak server dan mesin lokal selesai; PRD B5/7/8 dan README sesuai
  kontrak grup. Antrean v4 memakai pemulihan eksplisit di mesin B2b.

## Hasil B1f dan batas yang tetap berlaku
- Main default Drift; memory/dummy untuk tes. Satu MaterialApp.router, root49baris.
  AccountStorage serial per akun, keluar menutup tanpa menghapus; draf dibersihkan.
- Monitor SQL owner dibatalkan sebelum close; stream salinan, paused tidak menahan.
- Antrean hanya order aktif dengan items/payments SQL, tanpa N+1/seluruh riwayat.
- Seed DATA MASTER atomik/outbox/marker UUIDv5 per akun; release normal kosong.
- Pending = COUNT outbox; syncNow hanya refresh, tidak mengaku terkirim.
- Account delete auth+SQL atomik, finishDelete menghapus DB/sidecar/foto setelah commit.
- Android SM-N975F profile5.000nota: cold728/614/622ms; p95 25,960/20,360/36,511ms.
  APK utama terpasang, restart mempertahankan checksum DB; iOS belum diuji.
- B1e ledger disetujui: omzet177.000/589.000/864.000; biaya145.000/850.000/1.850.000;
  laba32.000/-261.000/-986.000, kas130.500/500.000/868.500; piutang400.500/tabungan430.000.
- Drift v5/16tabel, snapshot v1–v4 beku + v5; created_key lokal; UTC6digit.
- Sebelum SEMUA Dart/Flutter: . ./tool/windows_native_sdk.ps1.
- Cloud/key belum diperlukan B0; Google OAuth+SMTP produksi perlu konfigurasi B3.
  Auth/sesi/AI/usulan/WhatsApp masih dummy sampai B3/B7. Printer/picker/ekspor belum.
- Foto lama dipertahankan untuk outbox sampai lifecycle/delete; upload B2.
- Payload snake_case/UTC ISO tanpa sync_state/pay_status/key lokal. Wire schema5 dan
  metadata grup tersedia di server + mesin lokal; adapter transport baru di B2c.
  Urutan master/order/ledger/selesaiCOD tetap wajib.
- order_events domain B1d disertakan server, ringkasan PRD B5 belum mencantumkan.
- PayStatus turunan, COD bersisa ditahan, transaksi multi-repo lewat TransactionRunner.
- Preferensi bisnis/struk sinkron, perangkat local_settings; tanpa shared_preferences.
- Registry60/60, Section debt14. Registry/tema/lint/fixture tidak diubah B0.
