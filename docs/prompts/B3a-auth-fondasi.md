# B3a — fondasi Auth nyata

Ikuti _COMMON.md. Rencana: docs/plans/B3-auth.md. Prasyarat: B2d SELESAI.
Izin dependensi: PRD B §4 (`google_sign_in`) dan §4/§8 + aturan 20
(`flutter_secure_storage`).

## Hasil yang diminta
1. Konfigurasi publik dari `--dart-define`/`--dart-define-from-file=.env.local`:
   `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `GOOGLE_WEB_CLIENT_ID`. Tanpa kunci
   rahasia di repo/log/pesan galat. Tanpa konfigurasi → mode dummy tetap jalan.
2. Bootstrap Supabase saat start: sesi dipulihkan sebelum UI, `detectSessionInUri`
   aktif, `LocalStorage` memakai `flutter_secure_storage` (bukan SharedPreferences).
3. `SupabaseAuthService` mengimplementasikan `AuthService`: masuk email+password,
   daftar (konfirmasi email wajib, pesan seragam), Google lewat id-token,
   perbarui profil (`user_metadata` name/phone), ganti password (verifikasi
   password lama), kirim reset, keluar, dan cek konfirmasi dari sesi nyata.
4. Galat Supabase dipetakan ke `AuthFailure` yang ada; kredensial salah bukan
   galat, batas permintaan/jaringan/invalid ditampilkan aman.
5. Intent filter Android untuk `laurum://auth-callback`.
6. Tes unit: config, adapter secure storage (dengan store palsu), pemetaan galat,
   seluruh alur service dengan `AuthGateway` palsu, dan isi manifest.
7. check_all hijau, docs/progress/b3a.md, INDEX/STATE, commit, berhenti.

## Batas
- Tanpa layar baru, tanpa layar password baru, tanpa hapus akun Edge, tanpa
  `SyncCoordinator`/`workmanager`, tanpa cloud produksi. Semua itu B3b/B3c.
- Jangan mengubah PRD, registry, tema, atau lint. Jangan menguji jaringan di
  `flutter test`; gateway nyata hanya dipakai aplikasi.
