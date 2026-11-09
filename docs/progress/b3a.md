# B3a — fondasi Auth nyata (Supabase)

SELESAI 9 Nov 2026. Rencana: docs/plans/B3-auth.md. Prompt: docs/prompts/B3a-auth-fondasi.md.
Prasyarat: B2d. Tanpa UI baru, tanpa hapus akun Edge, tanpa gerbang sinkron dibuka.

## Hasil
- `core/services/auth_config.dart`: `AuthConfig` publik dari `--dart-define`
  (`SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `GOOGLE_WEB_CLIENT_ID`).
  `canUseSupabase` hanya untuk https (atau http localhost) + kunci terisi;
  `canUseGoogle` butuh Web client ID. `authCallbackUri = laurum://auth-callback`
  dan `isAuthCallbackUri` hanya menerima tautan skema/host itu yang membawa
  `code`/`access_token`/`error`.
- `core/persistence/token_store.dart`: antarmuka `TokenStore` + implementasi
  `flutter_secure_storage` supaya penyimpanan bisa diuji tanpa plugin.
- `core/persistence/secure_session_storage.dart`: `SecureSessionStorage`
  (LocalStorage Supabase) dan `SecurePkceStorage` (verifier PKCE) menulis ke
  keystore dengan awalan `laurum.supabase.*`; tidak ada `shared_preferences`.
- `core/persistence/supabase_bootstrap.dart`: `initializeSupabase` mengembalikan
  false tanpa konfigurasi (mode dummy tetap jalan, tanpa jaringan), memasang
  storage aman + `detectSessionInUriPredicate: isAuthCallbackUri`, dan hanya
  menginisialisasi sekali.
- `features/auth/data/`: `auth_identity.dart` (identitas sesi tanpa token),
  `auth_gateway.dart` (`AuthGateway` + `GoogleTokenSource`),
  `auth_error_mapping.dart` (429 → requestLimit, 400/422/403 → invalidInput,
  kredensial salah/duplikat → null sehingga UI memakai pesan seragam),
  `supabase_auth_gateway.dart` (GoTrueClient, normalisasi email, `user_metadata`
  name/phone, konfirmasi dari `email_confirmed_at`, provider dari `identities`),
  `google_token_source.dart` (`google_sign_in 7.2.0`, batal → null),
  `supabase_account_actions.dart` (profil, ganti password dengan verifikasi
  password lama, reset seragam), `supabase_auth_service.dart`
  (AuthService + TransactionParticipant; `deleteAccount` sengaja melempar
  `unavailable` sampai B3c), `supabase_auth_factory.dart`.
- `main.dart`: memakai Auth nyata hanya bila build Drift **dan** konfigurasi
  Supabase tersedia; selain itu `FakeAuthService` seperti sebelumnya.
- `android/app/src/main/AndroidManifest.xml`: intent filter VIEW/BROWSABLE
  `laurum://auth-callback` (samakan dengan `site_url` Supabase).
- Dependensi (lewat `flutter pub add`): `flutter_secure_storage 11.2.0`,
  `google_sign_in 7.2.0`. minSdk 24 sudah default Flutter; tanpa ubah Gradle.

## Bukti
- `flutter test test/auth` → 17 tes LULUS: config + manifest, adapter secure
  storage/PKCE (store palsu), pemetaan galat, dan seluruh alur service dengan
  gateway/Google palsu (masuk, kredensial salah, rate limit, jaringan,
  pendaftaran + konfirmasi, duplikat, Google batal/sukses, profil, ganti
  password, reset, keluar, hapus akun belum tersedia).
- `dart run tool/check_all.dart` → **SEMUA HIJAU**: format 903 berkas,
  analyze + Riverpod lint tanpa isu, check_arch OK, 960 tes lulus
  (1 integrasi dilewati tanpa env lokal), REPO_MAP 970 berkas.
- Pemeriksaan cloud (hanya baca): `/auth/v1/settings` 200 — Google + email aktif,
  `disable_signup=false`, `mailer_autoconfirm=false`; `/auth/v1/health` 200
  dengan kunci publik. Tidak ada perubahan pada proyek cloud.

## Batasan (belum diverifikasi)
- **Migrasi cloud belum diterapkan**: `app_config`/`orders` belum ada
  (PGRST205), jadi sinkron, pull pemulihan, dan `delete_my_account` belum bisa
  berjalan ke cloud. Skema hanya boleh lewat `supabase/migrations`.
- Belum ada akun uji/peti surat yang bisa dibuka: pendaftaran, kirim SMTP, dan
  tautan konfirmasi/reset belum diuji ujung-ke-ujung.
- `GOOGLE_WEB_CLIENT_ID` belum ada di `.env.local`; status SHA-1/OAuth Android
  belum dikonfirmasi, jadi login Google belum diuji di perangkat.
- Deep link belum menyegarkan UI Auth (B3b), belum ada layar password baru
  (B3b), `deleteAccount` nyata dan gerbang `SyncCoordinator` (B3c), dan
  `workmanager` belum dipasang.

## Cara menjalankan dengan Supabase
`flutter run -t lib/main.dart --dart-define-from-file=.env.local`
dengan isi `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `GOOGLE_WEB_CLIENT_ID`.
`.env.local` gitignored; tidak ada kunci di repo/log/pesan galat.
Tanpa berkas itu APK tetap mode dummy.
