# R10 - Akun: Masuk email/password, Daftar, Lupa password, Kelola akun (revisi 3, 4, 5)
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: R9 SELESAI. Baca: AGENTS.md aturan 14-18, docs/revisi/REVISI-02.md, spec 19-pengaturan-akun, 29-masuk-google, 30-sinkronisasi, PRD B bagian auth; kode: auth/pages/{sign_in_page,account_flow,auth_routes}.dart, auth/widgets/sign_in_section.dart, auth/state/auth_session.dart, core/services/auth_service.dart, features/auth/data/*, settings/widgets/settings_account_section.dart, settings/pages/settings_page.dart.

## Keputusan pengguna (2 Nov 2026) dan batas
- Metode masuk: email + password, dan Google (yang sudah ada). Nomor telepon BUKAN metode masuk (konfirmasi nomor butuh penyedia SMS berbayar); no. telp hanya kolom profil opsional tanpa OTP.
- Hapus akun TIDAK disembunyikan; dipindah ke halaman Kelola akun (kewajiban hapus akun dari dalam aplikasi untuk aplikasi yang memungkinkan pendaftaran; verifikasi kebijakan Google Play terbaru saat rilis).
- Semua masih simulasi in-memory (tanpa server). Rancang lewat AuthService agar nanti diganti Supabase; catat di PRD B: konfirmasi email dan reset password produksi butuh SMTP kustom (layanan email bawaan sangat dibatasi).

## IZIN TERTULIS (2 Nov 2026)
- AuthService: tambah signInWithPassword(email, password), signUp(email, password, name), sendPasswordReset(email), updateProfile(name, phone), changePassword(current, next). Implementasi dummy in-memory (akun uji di dummy_account_data; password tidak disimpan di luar memori, tidak di-log, tidak dikirim ke state UI selain nilai field yang dihapus saat dispose).
- Berkas rute baru di auth_routes.dart: /masuk (diperluas), /daftar, /lupa-password, dan /lainnya/akun (Kelola akun). Guard router tetap.
- AppTextField sudah mendukung obscureText: tambah tombol tampil/sembunyi password HANYA bila bisa lewat atom yang ada; bila butuh parameter baru (suffix), ajukan proposal; jangan membuat widget.
- core/icons/app_icons.dart: tambah ikon yang diperlukan (mail, lock, eye, eyeOff) bila belum ada. docs/prd/prd-b-backend.md: satu paragraf metode masuk dan SMTP. Tanpa dependensi baru, tema, registry.

## Layar
1. Masuk: email, password (default tersembunyi, tombol tampil), tombol "Masuk"; "Lupa password?"; pemisah "atau"; "Lanjutkan dengan Google"; tautan "Belum punya akun? Daftar".
2. Daftar: nama, email, password, konfirmasi password (minimal 8 karakter; pesan kesalahan Bahasa Indonesia di bawah field), tombol "Daftar"; sukses -> layar "Cek email Anda" (dummy: tombol "Lanjut" menandai terverifikasi) lalu alur onboarding usaha yang ada. Email sudah terdaftar: pesan umum, tanpa membocorkan detail.
3. Lupa password: email -> "Kirim tautan reset"; selalu tampilkan pesan sama ("Jika email terdaftar, tautan dikirim") agar tidak membocorkan akun. Batas kirim ulang 60 detik (jam bisa diatur oleh businessClock).
4. Kelola akun (/lainnya/akun): baris Nama (sheet ubah), Email (hanya baca; catatan "Ganti email belum tersedia"), No. telp (sheet ubah, opsional, validasi 08xx/+62 tanpa OTP), Ganti password (sheet: lama, baru, konfirmasi; tidak tersedia bila masuk lewat Google, tampilkan keterangan), Akun Google (status tertaut), tombol Keluar (destruktif, pola R7), dan bagian bawah "Zona berbahaya" berisi Hapus akun dengan dua konfirmasi yang sudah ada. Di Pengaturan > AKUN hapus baris/tombol Hapus akun dan ganti dengan baris "Kelola akun".
- Semua error: pesan Indonesia, tanpa teks mentah pengecualian; kasus terlalu banyak permintaan ditangani ("Terlalu banyak percobaan. Coba lagi nanti").

## Langkah (tes lebih dulu)
1. Tes AuthService dummy: masuk benar/salah, daftar duplikat, reset, ganti password, update profil.
2. State/validator murni di auth/state/ (email, password, telepon) dengan tes tabel.
3. UI sebagai Page/Sheet/Section sesuai AGENTS 14-15; keyboard sesuai AGENTS 16e untuk SEMUA layar dan sheet baru; Semantics label; teks 2x dan 320 px tidak overflow.
4. Tes alur: daftar -> onboarding -> beranda; masuk email salah -> pesan; lupa password pesan seragam; Kelola akun menampilkan semua baris; Hapus akun hanya dari Kelola akun dan tetap dua konfirmasi; tidak ada tombol Hapus akun di Pengaturan utama.
5. Perbarui spec 19 dan 29 (tambah spec baru 31-daftar.md, 32-lupa-password.md, 33-kelola-akun.md memakai _TEMPLATE.md), STATE, dan INDEX.

Prompt berikutnya: 100-penyelesaian.md.
