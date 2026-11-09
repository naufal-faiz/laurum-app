# B3 — Auth nyata, pemulihan, hapus akun

Status: dirancang 9 Nov 2026, dikerjakan bertahap B3a → B3c. **B3a dan B3c SELESAI
9 Nov 2026** (B3c lebih dulu atas permintaan pengguna); **B3b BELUM**. Dasar: PRD B §4, §8,
§9, §14; docs/backend/ROADMAP.md baris B3; B2d selesai.

## Ruang lingkup
Tiga irisan supaya tiap sesi berhenti di titik hijau:

1. **B3a — fondasi Auth nyata.** Konfigurasi Supabase dari `--dart-define`
   (`SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `GOOGLE_WEB_CLIENT_ID`), bootstrap
   Supabase saat start, sesi disimpan di `flutter_secure_storage`, layanan
   `SupabaseAuthService` (email+password, Google id-token, profil, ganti password,
   reset, keluar), intent filter Android `laurum://auth-callback`, pemetaan galat
   aman, dan tes dengan gateway palsu. Tanpa UI baru.
2. **B3b — konfirmasi email dan pemulihan.** Sesi dari deep link menyegarkan state
   Auth; "Lanjut" pada Cek email memeriksa sesi nyata; layar "Buat password baru"
   untuk tautan pemulihan; pesan seragam; tes.
3. **B3c — hapus akun dan sinkronisasi nyata.** Panggilan Edge `delete-account`
   (dua konfirmasi yang ada), pembersihan lokal, registrasi `devices`,
   `SyncCoordinator` disuntikkan ke `DriftSyncService` (gerbang B2d terbuka), dan
   `workmanager` untuk sinkron latar — **disetujui pengguna 9 Nov 2026** (pasang
   `workmanager`, jangan tunda), dengan bootstrap Auth + database di isolate.

Irisan ini tidak mengubah PRD, registry, tema, atau lint. Tanpa push/merge.

## Keputusan
- Kredensial hanya lewat `--dart-define`/`--dart-define-from-file=.env.local`.
  `.env.local` sudah gitignored; tidak ada kunci di repo, log, atau pesan galat.
- Tanpa konfigurasi Supabase, aplikasi tetap berjalan dengan `FakeAuthService`
  (mode dummy) dan gerbang sinkron tetap tertutup. Ini menjaga `flutter test` dan
  APK dummy tidak menyentuh jaringan.
- Sesi memakai `flutter_secure_storage` (aturan 20) lewat adapter `LocalStorage`
  milik `supabase_flutter`; `shared_preferences` tetap transitif dan tidak diimpor.
- Layanan Auth di `features/auth/data/` memakai gateway sempit (`AuthGateway`)
  supaya bisa diuji tanpa jaringan. Implementasi nyata membungkus
  `Supabase.instance.client.auth`; galat Supabase dipetakan ke `AuthFailure` yang
  sudah ada, bukan pesan SQL/HTTP.
- `needsBusinessSetup` tetap ditentukan database lokal (profil usaha kosong);
  Auth hanya menyimpan `name`/`phone` di `user_metadata`.
- `awaitingEmail` hanya state proses (bukan disimpan). Setelah aplikasi ditutup,
  pengguna masuk lewat tautan atau login biasa; dicatat di dokumen.
- Deep link memakai skema `laurum://auth-callback`, sudah menjadi `site_url`
  Supabase lokal dan harus sama di proyek cloud. `detectSessionInUri` aktif.

## Prasyarat pemilik proyek
- Migrasi `supabase/migrations` diterapkan ke proyek cloud (saat ini `app_config`
  dan `orders` belum ada → sinkron dan hapus akun cloud belum bisa diuji).
- Google OAuth: Web client ID + SHA-1 Android terdaftar; `GOOGLE_WEB_CLIENT_ID`
  publik di `.env.local`; provider Google aktif di Supabase.
- SMTP Gmail: sudah diisi pemilik; verifikasi kirim butuh kotak surat nyata.
- Akun uji email+password (atau izin mendaftar) untuk uji konfirmasi/reset.

## Berkas utama (B3a)
- Baru: `core/services/auth_config.dart`,
  `core/persistence/secure_session_storage.dart`,
  `core/persistence/supabase_bootstrap.dart`,
  `features/auth/data/{auth_gateway,auth_user,auth_error_mapping,google_token_source,supabase_auth_gateway,supabase_auth_service}.dart`.
- Ubah: `main.dart`, `lib/features/shell/pages/auth_routes.dart` (bila perlu),
  `android/app/src/main/AndroidManifest.xml`, `pubspec.yaml`.
- Tes: `test/auth/*` (config, storage, pemetaan galat, service dengan gateway palsu,
  intent filter manifest).

## Urutan
1. Tulis prompt/index, pasang dependensi lewat `flutter pub add`.
2. Config + secure storage + bootstrap + intent filter, tes unit.
3. Gateway nyata + service + pemetaan galat, tes gateway palsu.
4. Sambungkan `main.dart`; pastikan mode tanpa konfigurasi tetap dummy.
5. check_all hijau, docs progress/b3a.md, STATE/INDEX, commit, berhenti.
