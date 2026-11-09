# 29 - Masuk email/password dan Google (dummy)
Rute: /masuk. Prompt: R10. Frame Figma: `LAURUM · Masuk` (ID: 4294968692).
Template: FormScaffold (body gulir, footer Masuk tetap di atas keyboard).

## Paritas redesign (UI-7)

| Butir | Jenis | Centang | Catatan |
|---|---|---|---|
| `authFormProvider(signIn).email` | Data | | Dibaca → AuthIdentitySection |
| `authFormProvider(signIn).errors` | Data | | Validasi field |
| `authFormProvider(signIn).visible` | Data | | Visibilitas password |
| `authFormProvider(signIn).busy` | Data | | Semua aksi disabled |
| `authFormProvider(signIn).error` | Data | | BannerMessage di footer |
| `authSessionProvider.busy` | Data | | Dikombinasi → `busy` |
| `authSessionProvider.signedIn` | Data | | Restoring mode |
| `authSessionProvider.error` | Data | | Dikombinasi → `error` |
| `controller.email(v)` | Aksi | | onChanged field Email |
| `controller.secret(password, v)` | Aksi | | onChanged field Password |
| `controller.toggleVisible()` | Aksi | | Tombol Tampilkan/Sembunyikan |
| `controller.submit()` | Aksi | | Footer tombol Masuk |
| `controller.clearError()` | Aksi | | Sebelum signIn Google |
| `authSessionProvider.notifier.signIn()` | Aksi | | Google sign in |
| `context.go('/lupa-password')` | Nav | | Tombol Lupa password? |
| `context.go('/daftar')` | Nav | | Tombol Belum punya akun? Daftar |
| Keadaan normal (form kosong) | State | | |
| Keadaan busy/loading | State | | Semua aksi disable |
| Keadaan error validasi | State | | Error di bawah field |
| Keadaan error operasi | State | | BannerMessage footer |
| Keadaan restoring (session aktif) | State | | Teks Memulihkan data... |

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

## Komposisi baru (Figma → tata letak, belum kode)
Frame `LAURUM · Masuk` (390x844 dp, latar putih) memiliki dua zona utama:

**Hero (atas, 390x340, sudut bawah radius 32):**
- Latar: gradient linear diagonal biru (#2E7BD9 → #1B5FA3 perkiraan, belum ada token).
- Ornamen dekoratif: 2 ellipsis putih opacity 10-8%, 3 dot putih opacity 50%.
- Logo LAURUM: kotak putih radius 12 (38x38) + ikon tetes biru di dalam, diikuti
  teks "LAURUM" (Inter 15, putih) dan "LAUNDRY MANAGEMENT" (Inter 7, #DCEBF9) di kanan.
- Judul "Masuk" (Inter 26, putih, x=24, y=140).
- Sub "Kasir laundry untuk usaha rumahan" (Inter 10, #DCEBF9, x=24, y=174).
- Ilustrasi: lingkaran biru radius 59 (118x118) + ikon baju (outline putih) di pojok
  kanan bawah hero (x=244, y=150).

**Kartu Masuk (342x~hug, x=24, y=320, radius 24, bayangan biru tipis):**
- Padding: 18 dp semua sisi, gap antar elemen: 12 dp (auto-layout vertikal).
- Field Email: label "Email" (Inter 8.5, #7C8DA3) + input box (radius 12, border
  #DDE3E8, h=48, padding kiri-kanan 14, ikon envelope 16x16, placeholder Inter 10.5 #B7C2CF).
- Field Password: baris label spaceBetween ("Password" kiri + "Lupa password?" kanan,
  #2675C9) + input box (radius 12, h=48, ikon gembok kiri, tombol mata kanan 28x28
  radius 9 fill #F4F6F8 border #E9EEF4).
- Tombol Masuk: lebar penuh, h=50, radius 14, fill #2675C9, teks "Masuk" Inter 11
  putih + ikon panah putih, centered, gap 8.
- Pemisah "atau": garis #E7EDF4 kiri-kanan + teks "atau" #7C8DA3 Inter 8.5.
- Tombol Google: lebar penuh, h=48, radius 14, fill putih, border #DDE3E8, bayangan
  ringan, ikon "G" #4285F4 dalam kotak 24x24 + teks "Lanjutkan dengan Google" Inter
  10.5 #26364A.
- Ke Daftar: "Belum punya akun?" (#7C8DA3) + "Daftar" (#2675C9) centered, gap 4.

**Bawah kartu (di luar kartu):**
- Fitur bar: #F4F6F8 radius 12 h=46 — 3 chip (Antrean rapi, Struk otomatis, Laporan harian). [JANGAN dibuat — UI-9]
- Trust bar: "Data usaha kamu aman & terenkripsi" #7C8DA3. [JANGAN dibuat — UI-9]
- Home indicator: 134x5, #DDE3E8. [Bagian dari sistem OS, bukan widget app]

## Selisih desain
1. **Hero baru** — Figma memiliki zona hero berwarna gradien besar dengan logo,
   ilustrasi, dan teks menyambut. Desain lama memakai FormScaffold + AppBarSub.
   Perlu diskusi template: apakah pakai CustomScrollView, atau struktur di luar
   FormScaffold. **BERHENTI dan tanya sebelum implementasi** (UI-20).
2. **Kartu putih mengambang** — form dalam kartu radius 24 mengambang di atas hero
   gradient, bukan scroll body biasa. Memengaruhi struktur widget utama.
3. **"Lupa password?" di baris yang sama dengan label Password** — saat ini sebagai
   AppButton terpisah. Figma menempatkannya di baris label (spaceBetween). Perubahan
   tata letak dalam AuthPasswordsSection.
4. **Tombol Masuk di dalam kartu** — saat ini di footer FormScaffold. Figma
   menempatkannya di dalam kartu (di atas tombol Google). Memengaruhi keyboard behavior.
5. **Fitur bar (Antrean rapi, Struk otomatis, Laporan harian)** — BARU di Figma,
   tidak ada di PRD/state. Jangan dibuat (UI-9).
6. **Trust bar "Data usaha kamu aman & terenkripsi"** — BARU di Figma, tidak ada di
   PRD. Jangan dibuat (UI-9).
7. **Ilustrasi lingkaran + ikon baju** — BARU di Figma, tidak ada di state/PRD.
   Jangan dibuat tanpa persetujuan PRD (UI-9).
8. **Tombol mata dalam field** — Figma memakai tombol mata 28x28 di ujung kanan input.
   Saat ini AppButton Tampilkan/Sembunyikan terpisah di bawah field. Perubahan tata letak.

## Token/ikon/font yang belum punya padanan
| Elemen Figma | Nilai | Status |
|---|---|---|
| Latar hero (gradient) | biru diagonal | ❌ Belum ada token gradient. Proposal diperlukan (UI-12). |
| Warna tagline hero | #DCEBF9 | ❌ Belum ada. Dekat `blueTint` (#E3EEFA). Catat selisih. |
| Shadow kartu masuk | rgba(biru, 12.5%) | ❌ Belum ada token shadow auth card. Proposal diperlukan. |
| Warna link (Lupa password?, Daftar) | #2675C9 | ⚠️ Mendekati `blue` (#1D5FA8). Catat selisih. |
| Warna placeholder | #B7C2CF | ⚠️ Berbeda dari token `placeholder`. Gunakan token terdekat. |
| Warna label field | #7C8DA3 | ⚠️ Mendekati `ink3` (#6E7977). Catat selisih. |
| Font hero (Judul "Masuk", LAURUM) | Inter | ❌ Tema memakai Plus Jakarta Sans. Font baru — proposal wajib (aturan 10, UI-14). |
| Ilustrasi baju (Shirt) | SVG custom | ❌ Tidak ada di assets/icons/. Belum punya PRD (UI-9). |
| Ikon fitur bar | 3 SVG custom | ❌ Tidak ada di AppIcons. Belum punya PRD (UI-9). |

## Data dan provider
AuthService, authSessionProvider, authFormProvider(signIn). State tampilan form berisi
email, error dan status/visibilitas saja. Nilai password hanya input field sementara
pada buffer privat form, tidak dikirim sebagai value Section/AppTextField, tidak masuk
state provider yang ditampilkan/log/error, dan dibuang saat sukses atau dispose.
Tombol visibilitas memakai AppButton + AppIcons.visible yang sudah ada; API atom tetap.

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
Frame Masuk awal memakai email/password; R10 menambah alternatif Google dan Daftar.
FormScaffold menggantikan AuthScaffold prompt 90 agar field dan aksi terlihat saat
keyboard 300 dp; error operasi ditempel pada footer, input error di bawah field.
Teks 320 px/2x, login salah/benar, Google/pemulihan, dan disposal password diuji.
PRD A bagian 11 masih mencatat keputusan Google-only lama; tidak diubah tanpa izin
perubahan PRD A pada R10. Spec R10 dan layar ini menjadi acuan implementasi auth terbaru.
Android/iOS dan integrasi autentikasi nyata belum diuji manual.

## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
