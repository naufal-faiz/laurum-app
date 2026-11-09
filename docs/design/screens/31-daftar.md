# 31 - Daftar dan Cek email
Rute: /daftar, /cek-email. Fase: R10. Frame Figma: `LAURUM · Daftar` (ID: 4294968748).
Template: FormScaffold.

## Paritas redesign (UI-7)

| Butir | Jenis | Centang | Catatan |
|---|---|---|---|
| `authFormProvider(signUp).name` | Data | | Dibaca → AuthIdentitySection |
| `authFormProvider(signUp).email` | Data | | Dibaca → AuthIdentitySection |
| `authFormProvider(signUp).errors` | Data | | Validasi field |
| `authFormProvider(signUp).visible` | Data | | Visibilitas password |
| `authFormProvider(signUp).busy` | Data | | Semua aksi disabled |
| `authFormProvider(signUp).error` | Data | | BannerMessage di footer |
| `controller.name(v)` | Aksi | | onChanged field Nama |
| `controller.email(v)` | Aksi | | onChanged field Email |
| `controller.secret(password, v)` | Aksi | | onChanged field Password |
| `controller.secret(confirmation, v)` | Aksi | | onChanged field Konfirmasi |
| `controller.toggleVisible()` | Aksi | | Tombol Tampilkan/Sembunyikan |
| `controller.submit()` | Aksi | | Tombol Daftar + navigasi /cek-email |
| `context.go('/masuk')` | Nav | | onBack + link "Sudah punya akun? Masuk" |
| `context.go('/cek-email')` | Nav | | Setelah submit sukses |
| Keadaan normal (form kosong) | State | | |
| Keadaan busy/loading | State | | Tombol Daftar disable |
| Keadaan error validasi (Nama/Email/Pw/Konfirmasi) | State | | Error di bawah field |
| Keadaan error operasi | State | | BannerMessage footer |
| Keadaan Cek email (setelah submit) | State | | Instruksi generik, tidak sebut email |

## Komposisi (desain lama)
- AppBarSub Daftar, kembali ke Masuk.
- AuthIdentitySection: LabeledField Nama/Email, AppTextField.
- AuthPasswordsSection: AuthSecretFieldSection Password/Konfirmasi password,
  AppTextField obscure default, AppButton Tampilkan/Sembunyikan password.
- Footer AppButton Daftar; BannerMessage error operasi pada summary footer.
- Cek email: AppText instruksi generik, AppButton Lanjut, Kembali ke Masuk,
  BannerMessage gagal/rate limit. Tidak menampilkan informasi email sudah terdaftar.

## Komposisi baru (Figma → tata letak, belum kode)
Frame `LAURUM · Daftar` (390x844 dp) memiliki dua zona utama:

**Hero (atas, 390xhug, sudut bawah radius 32):**
- Latar: gradient biru sama dengan layar Masuk (token belum ada).
- Ornamen dekoratif: 2 ellipsis putih opacity (sama dengan Masuk).
- Tombol kembali: ikon panah kiri (putih, 24x24) di kiri atas.
- Judul "Daftar" (Inter, putih, besar).
- Sub "Buat akun untuk mulai mengelola usaha" (Inter, #DCEBF9).
- (Tidak ada logo Laurum di hero Daftar, tidak ada ilustrasi baju).

**Kartu Daftar (342xhug, x=24, radius 24, bayangan biru tipis):**
- Padding: 18 dp semua sisi, gap antar elemen 12 dp.
- Field Nama: label "Nama" (#7C8DA3) + input box (radius 12, border #DDE3E8, h=48,
  ikon user kiri 16x16, placeholder "Nama lengkap kamu" Inter 10.5 #B7C2CF).
- Field Email: label "Email" + input box (sama dengan Masuk).
- Field Password: label "Password" + input box (ikon gembok kiri, tombol mata kanan
  28x28, placeholder "Minimal 8 karakter").
- Field Konfirmasi password: label "Konfirmasi password" + input box (ikon gembok kiri,
  tombol mata kanan 28x28, placeholder "Ulangi password").
- **Persetujuan Syarat & Ketentuan**: Checkbox + "Saya setuju dengan" + "Syarat & Ketentuan"
  (link, #2675C9). [BARU di Figma — tidak ada di PRD/state. Jangan dibuat. Dicatat UI-9]
- Tombol Daftar: lebar penuh, h~50, radius 14, fill #2675C9, teks "Daftar" + ikon panah.
- Pemisah "atau" + Tombol Google: sama persis dengan layar Masuk.
- Ke Masuk: "Sudah punya akun?" + "Masuk" (#2675C9) centered.

**Bawah kartu:**
- Trust bar: "Data kamu aman & terenkripsi" #7C8DA3. [JANGAN dibuat — UI-9]
- Home indicator. [Bagian OS]

## Selisih desain
1. **Hero baru** — Sama dengan layar Masuk: zona hero gradient biru besar.
   Tidak ada AppBarSub. Tombol kembali menyatu di dalam hero.
   **BERHENTI dan tanya sebelum implementasi** (UI-20).
2. **Kartu putih mengambang** — Sama pola dengan layar Masuk.
3. **Tombol mata di dalam field** — Tombol 28x28 di ujung kanan input, bukan AppButton
   terpisah di bawah field. Perubahan tata letak AuthPasswordsSection (1 baris per field).
4. **Persetujuan Syarat & Ketentuan** (Checkbox + link) — BARU di Figma, tidak ada di
   PRD/state/router. Jangan dibuat (UI-9).
5. **Tombol Google di halaman Daftar** — Figma menyertakan tombol Google juga di Daftar.
   Saat ini SignUpPage tidak memiliki Google sign-in. Butuh PRD sebelum menambahkan.
   Dicatat (UI-9).
6. **Trust bar** — BARU di Figma, tidak ada di PRD (UI-9).

## Token/ikon/font yang belum punya padanan
| Elemen Figma | Nilai | Status |
|---|---|---|
| Latar hero (gradient) | biru diagonal | ❌ Sama dengan Masuk. Proposal diperlukan. |
| Warna tagline hero | #DCEBF9 | ❌ Belum ada token. |
| Shadow kartu | rgba(biru, 12.5%) | ❌ Belum ada token shadow auth card. |
| Font hero | Inter | ❌ Proposal font baru wajib (aturan 10, UI-14). |
| Ikon user (Nama) | VECTOR (outline) | ⚠️ Periksa padanan di AppIcons (Ionicons). |
| Tombol mata dalam field | VECTOR (eye outline) | ⚠️ AppIcons.visible sudah ada — cocok. |

## Data dan provider
AuthService, authSessionProvider, authFormProvider(signUp). Nama/email adalah state
non-rahasia; password/konfirmasi hanya nilai input privat form dan dibuang saat dispose.
Data baru berasal dari input pengguna; tidak menambah atau mengganti fixture DATA MASTER.

## Interaksi
Nama wajib, email valid, password minimal 8 karakter, konfirmasi harus sama.
Kesalahan Indonesia di bawah field; error service aman di footer. Daftar dinonaktifkan
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
navigasi, semua field/tombol di atas keyboard 300 dp, 320 px/teks 2x dan golden.
Selisih .pen: layar baru sesuai R10, hanya memakai registry dan Section sefitur.
Tombol Lanjut hanya simulasi; produksi harus memverifikasi tautan/email dari server.
Android/iOS perangkat dan pengiriman email nyata belum diuji.

## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
