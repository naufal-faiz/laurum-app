# 31 - Daftar dan Cek email
Rute: /daftar, /cek-email. Fase: R10. Frame Figma: `LAURUM · Daftar` (ID: 4294968748).
Template: hero gradient 230 + kartu putih mengambang (Stack + SingleChildScrollView).

## Paritas redesign (UI-7)

| Butir | Jenis | Centang | Catatan |
|---|---|---|---|
| `authFormProvider(signUp).name` | Data | ✅ | AuthNameFieldSection |
| `authFormProvider(signUp).email` | Data | ✅ | AuthEmailFieldSection |
| `authFormProvider(signUp).errors` | Data | ✅ | errors name/email/password/confirmation |
| `authFormProvider(signUp).visible` | Data | ✅ | Kedua field password |
| `authFormProvider(signUp).busy` | Data | ✅ | Semua field/tombol disabled |
| `authFormProvider(signUp).error` | Data | ✅ | BannerMessage di dalam kartu |
| `controller.name(v)` | Aksi | ✅ | onChanged field Nama |
| `controller.email(v)` | Aksi | ✅ | onChanged field Email |
| `controller.secret(password, v)` | Aksi | ✅ | onChanged field Password |
| `controller.secret(confirmation, v)` | Aksi | ✅ | onChanged field Konfirmasi |
| `controller.toggleVisible()` | Aksi | ✅ | Ikon mata per field |
| `controller.submit()` | Aksi | ✅ | Tombol Daftar + navigasi /cek-email |
| `controller.clearError()` + `signIn()` | Aksi | ✅ | Google (disetujui pengguna) |
| `context.go('/masuk')` | Nav | ✅ | Tombol kembali di hero + link Masuk |
| `context.go('/cek-email')` | Nav | ✅ | Setelah submit sukses |
| Keadaan normal (form kosong) | State | ✅ | golden r10_signup |
| Keadaan busy/loading | State | ✅ | Daftar disabled + status Google |
| Keadaan error validasi | State | ✅ | Error di bawah field |
| Keadaan error operasi | State | ✅ | BannerMessage di kartu |
| Keadaan Cek email (setelah submit) | State | ✅ | Halaman /cek-email tidak diubah |

## Komposisi baru (Figma → tata letak, SUDAH KODE)
Nilai dari FigCraft (Hero 4294968749, Kartu Daftar 4294968764, Trust 4294968803),
dengan skala font dinaikkan (revisi UX 9 Nov 2026).

**Hero (390x230, sudut bawah radius 32):**
- Gradient `#2E7FD8 → #1B5FA3`, ornamen ellipse putih 210 (10%) di (250,-90) dan
  110 (8%) di (320,120).
- Tombol kembali 36x36 lingkaran `#4A90DA` border `#8FBCEB` di (24,56), ikon panah
  putih 20 (`AppSvg` cursor-back di-`ColorFiltered` putih).
- "Daftar" Inter 28/700 putih di (24,110); sub 13/400 #DCEBF9 di (24,148).
- Tidak ada logo merek dan ilustrasi baju (sesuai frame).

**Kartu Daftar (342, x=24, y=200, radius 24, padding 18, gap 12, shadow auth):**
- Field Nama (ikon user, placeholder "Nama lengkap kamu").
- Field Email (ikon mail, placeholder "nama@email.com").
- Field Password (ikon gembok, hint "Minimal 8 karakter", ikon mata).
- Field Konfirmasi password (ikon gembok, hint "Ulangi password", ikon mata).
- Tombol Daftar 50 radius 14 `#2675C9` + ikon centang.
- Pemisah "atau", tombol Google (aset SVG Google), "Sudah punya akun? Masuk".
- **Persetujuan Syarat & Ketentuan**: TIDAK dibuat (proposal 004, pengingat 95%).

**Bawah kartu:** trust statis "Data kamu aman & terenkripsi".

## Selisih desain (status akhir)
1. Hero 230 + kartu mengambang diterapkan; tombol kembali menyatu di hero.
2. Persetujuan Syarat & Ketentuan ditunda sampai aplikasi 95% (proposal 004).
3. Tombol Google ditambahkan ke Daftar atas izin pengguna; aksinya `signIn()` yang
   sudah ada (tanpa state baru). Bila Google dipakai, akun langsung masuk.
4. Ikon mata tanpa kotak (revisi UX): eye = tersembunyi, eye-off = terlihat,
   area sentuh 40 (`AppIconButton.compact`, lapisan 3).
5. Trust bar dibuat sebagai teks statis (izin pengguna).
6. Ukuran font dinaikkan dari frame (label 12, input 14, tombol 15, body 12).

## Data dan provider
AuthService, authSessionProvider, authFormProvider(signUp). Nama/email adalah state
non-rahasia; password/konfirmasi hanya nilai input privat form dan dibuang saat dispose.
Data baru berasal dari input pengguna; tidak menambah atau mengganti fixture DATA MASTER.

## Interaksi
Nama wajib, email valid, password minimal 8 karakter, konfirmasi harus sama.
Kesalahan Indonesia di bawah field; error service aman di kartu. Daftar dinonaktifkan
selama menyimpan; klik ganda ditolak. Sukses maupun email duplikat membuka Cek email
dengan instruksi sama. Pendaftaran tidak langsung mengautentikasi.
Lanjut pada dummy menandai akun baru terverifikasi dan membuka onboarding Info Usaha,
lalu Beranda setelah disimpan. Lanjut untuk duplikat tidak mengambil alih akun lama;
pesan kegagalan tetap generik, tanpa membocorkan detail akun.
Kembali meninggalkan form dan membuang input password serta visibilitasnya.

## State, format, verifikasi
Kosong, validasi nama/email/password/konfirmasi, busy, error, Cek email, onboarding.
Tidak memformat ulang password. Email dinormalisasi hanya saat service dipanggil.
Tes daftar sampai Antrean, duplikat tidak mengambil alih akun, field reset setelah
navigasi, semua field/tombol di atas keyboard 300 dp (scrollPadding dense 330),
320 px/teks 2x dan golden. Tombol Lanjut hanya simulasi.
Android/iOS perangkat dan pengiriman email nyata belum diuji.

## Tes yang diubah (UI-18)
- `test/r10_registration_flow_test.dart` — tombol Tampilkan/Sembunyikan diganti ketukan
  ikon mata (`Ionicons.eyeOutline`/`eyeOffOutline`); assertion obscureText tetap.
- `test/r10_signup_validation_test.dart` — sama, ketukan ikon mata.
- `test/r10_auth_keyboard_test.dart` — finder simpan `/daftar` memakai `AuthSubmitSection`.
- `test/r10_signup_sections_test.dart` — tes widget baru untuk Section daftar.
- Golden `r10_signup` (390/320/2x) diperbarui.
