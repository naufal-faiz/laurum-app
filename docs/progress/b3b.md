# B3b — sesi Auth dari deep link, Cek email nyata, dan layar password baru

SELESAI 12 Nov 2026. Rencana: docs/plans/B3-auth.md butir 2. Prasyarat: B3a,
B3c SELESAI. Tanpa push/merge, tanpa Figma.

## Hasil

1. Deep link menyegarkan state. `AuthGateway` menambah `sessionChanges` (Stream) dan
   `refreshUser()`; implementasi Supabase memakai `onAuthStateChange` dan `getUser()`.
   `AuthSession.build()` berlangganan `sessionChanges`: deep link
   `laurum://auth-callback` menyegarkan state (signedIn/needsSetup/awaitingEmail) dan
   `accountIdentityProvider`, sehingga router refresh dan gerbang penyimpanan ikut
   bereaksi.
2. Cek email memakai sesi nyata. `confirmEmail()` lewat
   `SupabaseAccountActions.confirmedSession()` membaca sesi server lebih dulu. Galat
   jaringan jatuh ke identitas cache, jadi offline tidak mengaku terkonfirmasi maupun
   menghapus sesi.
3. Layar "Buat password baru" ada di `/password-baru` (`NewPasswordPage` +
   `NewPasswordSection`). Tautan pemulihan (cold start lewat `recoveryLinkAtStartup`,
   warm lewat `recoveryEvents`) menandai `AuthService.recovering`; `authRedirect`
   memaksa layar ini selama sesi recovery. Form memakai `AuthFormKind.recovery`:
   password + konfirmasi, minimal 8 karakter, error di bawah field, tombol nonaktif
   saat busy. Sukses menampilkan "Password berhasil diperbarui" + tombol "Lanjut" ke
   `/beranda`.
4. Alur pemulihan tidak menanyakan password lama. `setRecoveredPassword` memakai sesi
   yang sudah membuktikan kepemilikan tautan; `change_password_sheet` tetap meminta
   password lama. Pesan gagal seragam dan aman.
5. Tampilan sementara tanpa Figma: frame `LAURUM · Password Baru` (ID 4294969106) sudah
   terdaftar di `docs/design/redesign/figma_map.md`, disusun dari widget registry yang
   ada (FormScaffold, AuthPasswordsSection, BannerMessage).

## Bukti

- `flutter test test/auth/auth_config_test.dart test/auth/supabase_auth_service_test.dart
  test/r10_new_password_section_test.dart test/b3b_new_password_test.dart` → 21 lulus.
- `flutter analyze lib test/auth test/b3b_new_password_test.dart
  test/r10_new_password_section_test.dart` → tanpa isu.
- `dart run tool/check_all.dart` → lihat STATE.md bagian "Bukti terakhir".

## Batasan

- Perubahan tampilan menunggu redesign; UI saat ini sementara dan belum dibandingkan
  frame Figma. Visual belum diverifikasi manual di perangkat.
- Konfirmasi email/deep link/pemulihan belum diuji ujung-ke-ujung di perangkat: butuh
  akun uji, kotak surat nyata, dan SMTP (prasyarat pemilik proyek di rencana B3).
