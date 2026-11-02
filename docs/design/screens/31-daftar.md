# 31 - Daftar dan Cek email
Rute: /daftar, /cek-email. Fase: R10. Frame .pen: tidak ada frame Daftar.
Template: FormScaffold.

## Komposisi
- AppBarSub Daftar, kembali ke Masuk.
- AuthIdentitySection: LabeledField Nama/Email, AppTextField.
- AuthPasswordsSection: AuthSecretFieldSection Password/Konfirmasi password,
  AppTextField obscure default, AppButton Tampilkan/Sembunyikan password.
- Footer AppButton Daftar; BannerMessage error operasi pada summary footer.
- Cek email: AppText instruksi generik, AppButton Lanjut, Kembali ke Masuk,
  BannerMessage gagal/rate limit. Tidak menampilkan informasi email sudah terdaftar.

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
