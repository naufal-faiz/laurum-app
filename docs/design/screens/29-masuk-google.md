# 29 - Masuk email/password dan Google (dummy)
Rute: /masuk. Prompt: R10. Frame Figma: `LAURUM · Masuk` (ID: 4294968692).
Template: hero gradient 340 + kartu putih mengambang (Stack + SingleChildScrollView).
Tidak ada tombol kembali di frame ini (Figma hanya hero + kartu + feature bar + trust).

## Paritas redesign (UI-7)

| Butir | Jenis | Centang | Catatan |
|---|---|---|---|
| `authFormProvider(signIn).email` | Data | ✅ | AuthEmailFieldSection (AppTextField value) |
| `authFormProvider(signIn).errors` | Data | ✅ | errors['email'], errors['password'] |
| `authFormProvider(signIn).visible` | Data | ✅ | AuthPasswordFieldSection obscureText |
| `authFormProvider(signIn).busy` | Data | ✅ | Semua field/tombol disabled |
| `authFormProvider(signIn).error` | Data | ✅ | BannerMessage di dalam kartu |
| `authSessionProvider.busy` | Data | ✅ | Dikombinasi → busy |
| `authSessionProvider.signedIn` | Data | ✅ | restoring → "Memulihkan data..." |
| `authSessionProvider.error` | Data | ✅ | Dikombinasi → error |
| `controller.email(v)` | Aksi | ✅ | onChanged field Email |
| `controller.secret(password, v)` | Aksi | ✅ | onChanged field Password |
| `controller.toggleVisible()` | Aksi | ✅ | Tombol mata dalam field |
| `controller.submit()` | Aksi | ✅ | Tombol Masuk biru |
| `controller.clearError()` | Aksi | ✅ | Sebelum signIn Google |
| `authSessionProvider.notifier.signIn()` | Aksi | ✅ | Tombol "Lanjutkan dengan Google" |
| `context.go('/lupa-password')` | Nav | ✅ | Link "Lupa password?" baris label |
| `context.go('/daftar')` | Nav | ✅ | Link "Daftar" |
| Keadaan normal (form kosong) | State | ✅ | golden r10_signin |
| Keadaan busy/loading | State | ✅ | memulihkan/memproses + disabled |
| Keadaan error validasi | State | ✅ | Error di bawah field |
| Keadaan error operasi | State | ✅ | BannerMessage di kartu |
| Keadaan restoring (session aktif) | State | ✅ | Teks Memulihkan data... |

## Komposisi (desain lama)
- AppBarSub Masuk; kembali nonaktif di rute akar.
- AppText Laurum, tagline Kasir laundry untuk usaha rumahan.
- AuthIdentitySection: LabeledField Email + AppTextField keyboard email.
- AuthPasswordsSection/AuthSecretFieldSection: LabeledField Password, AppTextField
  tersembunyi secara default dan AppButton Tampilkan/Sembunyikan password.
- AppButton Lupa password? ke /lupa-password; AppText atau.
- SignInSection: status proses/pemulihan dan Lanjutkan dengan Google.
- AppButton Belum punya akun? Daftar ke /daftar.
- Footer Masuk; BannerMessage error operasi di summary footer agar tetap terlihat.
  Validasi isian tampil di bawah field. Semua aksi masuk disabled selama proses.

## Komposisi baru (Figma → tata letak, SUDAH KODE)
Frame `LAURUM · Masuk` (390x844 dp, latar putih). Nilai diambil 1:1 dari FigCraft
(node Hero 4294968693, Kartu Masuk 4294968715, Fitur 4294968807, Trust 4294968744).

**Hero (390x340, sudut bawah radius 32):**
- Gradient top-left → bottom-right `#2E7FD8` → `#1B5FA3` (`AppColors.authHeroGradient*`).
- Ornamen: ellipse putih 210 di (236,-80) 10%; 120 di (300,120) 8%; 3 dot 4x4 di
  (250,96), (266,112), (284,130) 50%.
- Logo 38x38 radius 12 putih di (24,58) + ikon tetes #2675C9 18.
- "LAURUM" Inter 15/700 putih di (72,60); "LAUNDRY MANAGEMENT" Inter 7/600 #DCEBF9 di (72,80).
- "Masuk" Inter 26/700 putih di (24,140); sub Inter 10/400 #DCEBF9 di (24,174).
- Ilustrasi lingkaran 118 fill #4A90DA di (244,150) + ikon baju putih 44.
- TIDAK ada tombol kembali (frame tidak memilikinya).

**Kartu Masuk (342x348, x=24, y=320, radius 24, padding 18, gap 12):**
- Shadow `0 14 32 #174B83@12.5%` (`AppShadows.authCard`).
- Field Email: label Inter 8.5/600 #7C8DA3 + gap 4 + field 48 radius 12 border
  #DDE3E8, ikon envelope 16 #7C8DA3, placeholder Inter 10.5 #B7C2CF.
- Field Password: baris label (Password + "Lupa password?" #2675C9) + field yang
  sama dengan ikon gembok kiri dan tombol mata 28x28 radius 9 fill #F4F6F8 border
  #E9EEF4 (ikon #174B83).
- Tombol Masuk 50 radius 14 fill #2675C9, teks Inter 11/600 putih + panah 14.
- Pemisah "atau": garis #E7EDF4 + teks Inter 8.5 #7C8DA3.
- Google: 48 radius 14 putih border #DDE3E8, shadow `0 3 10 #174B83@5%`, kotak G
  24x24 border #E3E9F0 dengan "G" Inter 12/700 #4285F4, teks Inter 10.5/600 #26364A.
- Ke Daftar: "Belum punya akun?" Inter 9 #7C8DA3 + "Daftar" Inter 9/600 #2675C9.

**Bawah kartu:**
- Fitur bar (x=24, y=700, 342x46, radius 12, #F4F6F8, padding horizontal 14):
  3 item ikon 13 #2675C9 + teks Inter 8/600 #26364A — Antrean rapi, Struk otomatis,
  Laporan harian. **Tampilan saja** (keputusan pengguna 9 Nov 2026).
- Trust (y=764): ikon perisai 12 #7C8DA3 + "Data usaha kamu aman & terenkripsi"
  Inter 8.5 #7C8DA3. Teks statis.
- Home indicator: bagian OS.

## Revisi UX (9 Nov 2026, izin pengguna)
- Ukuran font dinaikkan: hero 28/16/13, label 12, input 14, tombol 15, body 12,
  meta 11, chip 10.5 (nilai frame 26/15/10, 8.5, 10.5, 11, 9, 8.5, 8 terlalu kecil).
  Hierarki dan tata letak frame tetap; hanya skala baca yang naik.
- Kotak tombol mata dihapus; kini ikon mata polos 22 dengan area sentuh 32.
  Ikon berubah keadaan: `eye` saat password tersembunyi, `eye-off` saat terlihat.
- Huruf "G" diganti `AppSvg(AppSvgs.google)` (aset `assets/icons/google.svg`).

## Selisih desain (status akhir)
1. **Tombol kembali dihapus** — frame `LAURUM · Masuk` tidak punya back button.
   AppBarSub lama diganti hero; tidak ada elemen yang menabrak logo.
2. **Hero + kartu mengambang** — diterapkan `Stack` (hero tetap) +
   `SingleChildScrollView` (padding atas 320). Bukan FormScaffold lagi.
3. **"Lupa password?"** pindah ke baris label Password (kiri label, kanan link).
4. **Tombol Masuk di dalam kartu** — footer FormScaffold tidak dipakai; keyboard
   ditangani `scrollPadding` 240 pada field dense (tes 16e tetap lulus).
5. **Fitur bar** — dibuat sebagai tampilan statis (izin pengguna), bukan fungsi.
6. **Trust bar** — teks statis (izin pengguna).
7. **Ilustrasi lingkaran + ikon baju** — dibuat; ikon memakai `AppIcons.service`
   (Ionicons shirt), bukan SVG custom.
8. **Tombol mata dalam field** — 28x28 radius 9 di dalam field; menyembunyikan/
   menampilkan password lewat `controller.toggleVisible()` yang sama.

## Token/ikon/font yang dipakai
| Elemen | Token |
|---|---|
| Gradient hero | `AppColors.authHeroGradientStart/End`, blob/dot tokens |
| Tagline hero | `AppColors.authHeroTagline` (#DCEBF9) |
| Shadow kartu/Google | `AppShadows.authCard`, `AppShadows.authGoogle` |
| Warna link/label/placeholder/border | `authPrimary` #2675C9, `authLabel` #7C8DA3, `authPlaceholder` #B7C2CF, `authFieldBorder` #DDE3E8 |
| Font hero & kartu | Inter 400/600/700 (`assets/fonts/Inter-*.otf`) via `AppAuthTextStyles` |
| Ikon | `AppIcons.droplet`, `service`, `mail`, `lock`, `visible`, `arrowForward`, `queue`, `receipt`, `reports`, `privacy` |
| Field | `AppFieldStyles` (radius 12, 48 dp) |


## Data dan provider
AuthService, authSessionProvider, authFormProvider(signIn). State tampilan form berisi
email, error dan status/visibilitas saja. Nilai password hanya input field sementara
pada buffer privat form, tidak dikirim sebagai value Section/AppTextField, tidak masuk
state provider yang ditampilkan/log/error, dan dibuang saat sukses atau dispose.
Tombol visibilitas memakai AppIcons.visible di dalam field (`trailing` AppTextField).

## Interaksi dan guard
Email dinormalisasi trim/lowercase; password dipertahankan persis. Salah email/password
memberi Email atau password tidak cocok.; request limit memberi pesan Indonesia seragam.
Google yang ada tetap berfungsi. Login lama mencoba sinkron; gagal sync tetap boleh
memakai data lokal. Selama pemulihan, rute Masuk dipertahankan dan aksi terkunci.
Akun baru wajib Info Usaha onboarding; form usaha tidak memakai draf login sebelumnya.
Rute publik hanya Masuk/Daftar/Lupa password/Cek email; data terlindungi tetap diguard.

## Fixture dan batas
Demo awal Bu Ratna/ratna@example.com terautentikasi lewat Google (owner-001).
Kredensial uji email dummy di dummy_account_data: ratna@example.com / Laundry123!.
Ini bukan akun nyata dan tidak tersimpan ke disk/keychain/log. Profil dan kredensial
runtime hanya in-memory; belum ada Google/SMTP/server/secure storage nyata.

## Verifikasi dan selisih .pen
Frame Masuk baru (hero + kartu) menggantikan FormScaffold; field dan tombol Masuk
tetap terlihat saat keyboard 300 dp (scrollPadding field dense 240, tes 16e lulus).
Error operasi tampil di BannerMessage dalam kartu; input error di bawah field.
Teks 320 px/2x, login salah/benar, Google/pemulihan, dan disposal password diuji.
PRD A bagian 11 masih mencatat keputusan Google-only lama; tidak diubah tanpa izin
perubahan PRD A pada R10. Spec R10 dan layar ini menjadi acuan implementasi auth terbaru.
Android/iOS dan integrasi autentikasi nyata belum diuji manual.

## Tes yang diubah (UI-18)
- `test/r10_test_host.dart` — `tapAuthButton`: pakai `AppButton` bila ada, jika tidak
  `find.text(label)` (tombol Masuk baru bukan AppButton). Assertion perilaku tetap.
- `test/r10_auth_keyboard_test.dart` — finder tombol simpan `/masuk` jadi
  `SignInSubmitSection` + teks; assertion keyboard 300 dp tidak berubah.
- `test/auth_restore_test.dart` — cek tombol Google nonaktif lewat `InkWell.onTap`
  (bukan `AppButton.onPressed`); assertion perilaku sama.
- `test/auth_sync_sections_test.dart` — sama: status busy dicek lewat `InkWell.onTap`.
- Golden diperbarui: `r10_signin`, `r10_signin_error`, `r10_signin_error_320_2x`,
  `auth_signin`, `auth_signin_error`, `app_icon` (entri AppIcons baru).

## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
