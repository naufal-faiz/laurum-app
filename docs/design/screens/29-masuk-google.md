# 29 - Masuk email/password dan Google (dummy)
Rute: /masuk. Prompt: R10. Frame .pen: Auth - Masuk.
Template: FormScaffold (body gulir, footer Masuk tetap di atas keyboard).

## Komposisi
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
