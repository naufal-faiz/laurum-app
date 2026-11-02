# 33 - Kelola akun
Rute: /lainnya/akun. Fase: R10. Frame .pen: tidak ada frame Kelola akun.
Template: SubScaffold; sheet melalui AppBottomSheet + SheetScaffold.

## Komposisi
- AppBarSub Kelola akun; AccountProfileSection (AppCard, MenuRow, AppText, InfoRow):
  Nama (ubah), Email hanya baca + Ganti email belum tersedia, No. telp (ubah/opsional),
  Ganti password dan Akun Google (Tertaut/Tidak tertaut).
- AccountDangerSection: Keluar destructiveOutline di luar kartu profil,
  SectionHeader Zona berbahaya, AppText penjelasan dan AppButton Hapus akun.
- AccountEditSheet/AccountEditFieldSection: LabeledField Nama atau No. telp,
  AppTextField selectAllOnFocus dan footer Simpan profil.
- ChangePasswordSheet: AuthPasswordsSection (lama/baru/konfirmasi, tersembunyi default),
  tombol tampil/sembunyi, footer Simpan password dan BannerMessage error yang tetap terlihat.

## Data dan provider
AuthService/accountView, authSessionProvider, accountEditProvider, authFormProvider(password),
shellSyncProvider. Profil akun terpisah dari nama/alamat/telepon usaha pada struk.
Tidak menyimpan password/token di state tampilan. Nilai input rahasia dibuang saat sheet ditutup.

## Interaksi
Nama wajib. No. telp opsional, 08xx/+62; simpan menormalisasi pemisah, tampilan lewat Formatters.
Tidak ada OTP atau metode masuk dengan telepon. Email tidak dapat diubah.
Ganti password hanya untuk sesi email/password: validasi lama, baru minimal 8, konfirmasi sama.
Sesi Google menampilkan keterangan Ganti password tidak tersedia, bukan aksi aktif.
Keluar mempertahankan data HP dan memperingatkan pending seperti R7.
Hapus akun hanya tersedia di halaman ini, disabled offline/busy, dan wajib dua ConfirmModal
lama; berhasil membersihkan repository/draf/histori/cooldown/kredensial dummy. Kegagalan
cleanup mengembalikan sesi, profil dan kredensial melalui TransactionRunner R8.

## State, format, verifikasi
Readonly, profil kosong, validasi, busy, request limit/error, offline, konfirmasi keluar/hapus.
Email/nama ditampilkan apa adanya; telepon lewat Formatters.telepon.
Tes edit nama/telepon, password benar/salah dan login ulang, Google nonaktif,
hapus dua tahap hanya dari Kelola, rollback, seluruh sheet keyboard 300 dp, 320 px/2x.
Selisih .pen: halaman baru sesuai R10; Email dan label panjang disusun vertikal agar
teks besar tetap terbaca. Tidak mengubah atom/molecule/tema/registry.
Android/iOS dan perubahan profil/autentikasi nyata belum diuji manual.
