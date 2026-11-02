# R10 - Masuk email, pendaftaran dan Kelola akun (2 Nov 2026)

## Hasil
- Masuk email/password dan Google melalui AuthService; nama/telepon profil terpisah
  dari Info Usaha/struk. Telepon opsional tanpa OTP, email hanya baca.
- Daftar memvalidasi nama/email/password minimal delapan karakter/konfirmasi,
  lalu Cek email. Lanjut dummy memverifikasi akun baru, mewajibkan onboarding,
  kemudian membuka Antrean. Email duplikat tidak mengambil alih akun.
- Reset memberi respons sama untuk email dikenal/tidak dikenal; kirim ulang 60 detik,
  dipertahankan saat berpindah rute. businessClock dapat diatur; tick timer menjaga
  demo tetap menghitung meskipun waktu fixture tetap.
- Kelola akun memuat sheet nama, telepon dan password. Ganti password memeriksa
  password lama; sesi Google menampilkan keterangan tanpa aksi password.
- Hapus akun hanya di Kelola akun, dengan dua konfirmasi dan larangan offline.
  Keluar destruktif tetap di Pengaturan dan Kelola akun sesuai R7.
- Hapus/cleanup memakai TransactionRunner R8; checkpoint kini mencakup akun,
  kredensial dan profil. Cleanup juga menghapus draf reset/cooldown.
- Password tidak menjadi bagian state tampilan, log, view-data Section atau pesan
  error. Input field sementara disimpan privat, dibuang saat sukses/dispose.
  Tampil/sembunyi menggunakan AppButton dan ikon yang sudah ada; atom tetap.
- Semua kegagalan memakai pesan Indonesia aman, termasuk terlalu banyak permintaan;
  tidak meneruskan teks mentah exception yang dapat berisi input sensitif.

## Struktur dan tinjauan
- Enam Page/Sheet baru: SignUpPage, CheckEmailPage, PasswordResetPage,
  ManageAccountPage, AccountEditSheet, ChangePasswordSheet. SignInPage diperluas.
- Tujuh Section baru: AuthIdentity, AuthSecretField, AuthPasswords, PasswordReset,
  AccountProfile, AccountDanger, AccountEditField; semuanya Stateless, input data
  dan callback, tanpa Riverpod/router, satu tes widget untuk setiap Section.
- Seluruh berkas Dart yang ditambah/disentuh maksimal 100 baris; tidak mengubah
  registry, tema/token, lint, dependensi, DATA MASTER maupun API widget bersama.
- AuthService dummy dipecah menjadi store akun/profil, operasi password dan sesi
  agar batas berkas tetap terpenuhi. Tidak menambah backend atau penyimpanan disk.
- Info Usaha mengamati perubahan kebutuhan onboarding agar draf akun sebelumnya
  tidak mengisi nama usaha akun baru. Kasus regresinya diuji.
- Satu paragraf PRD B auth/SMTP diperbarui sesuai izin R10. Keputusan Google-only
  lama di PRD A tidak diubah; spec 29 mencatat R10 sebagai acuan terbaru.
- Spec 19/29/31/32/33 dan component_catalog diperbarui. Selisih .pen tercatat.

## Verifikasi
Baseline check_all R9: 580 tes, REPO_MAP 663 berkas. Tes service/validator lebih dulu
membuktikan API R10 belum tersedia. Ditambahkan 59 kasus untuk service, form,
keamanan pesan, disposal, daftar/onboarding, login, reset, profil/password, cleanup,
Section, keyboard 300 dp pada 12 field, dan tampilan 320 px/teks 2x.

Regresi pertama: analyzer dan check_arch bersih; delapan golden perlu diperbarui
sesuai perubahan tampilan dan satu tes masih mengharapkan label Email Google lama.
Ekspektasi kini mengunci Email/Kelola akun serta tidak adanya Hapus akun di Pengaturan.
Pembaruan golden dan tes terkait: 32 tes lulus. Tiga golden lama diperbarui dan
13 golden R10 ditambahkan. Gambar normal/sheet/error dan layar sempit ditinjau;
email/label password disusun vertikal agar tidak terjepit saat teks diperbesar.

Verifikasi akhir `dart run tool/check_all.dart` (%TEMP%/laurum-r10-final.log):
```text
Formatted 637 files (0 changed)
No issues found! (flutter analyze)
No issues found! (dart analyze / Riverpod lint)
check_arch: OK
04:01 +639: All tests passed!
REPO_MAP diperbarui: 705 berkas
check_all: SEMUA HIJAU
```
Pemeriksaan cakupan indeks untuk 60 berkas Dart yang berubah tidak melaporkan
masalah atau metadata usang (sinyal best-effort). Git diff --check bersih.

## Batas dan tinjauan berikutnya
- Seluruh auth/email/reset/Google masih simulasi in-memory. Tombol Lanjut bukan
  bukti verifikasi produksi; tidak ada SMTP, token, server atau secure storage nyata.
- Kredensial demo publik ratna@example.com / Laundry123! hanya akun uji pada
  dummy_account_data. Tidak ada rahasia produksi. Data bisnis demo masih satu
  perangkat/owner, belum isolasi tenant backend untuk banyak akun.
- Tinjau di Android: semua alur akun, keyboard, teks besar dan dua konfirmasi hapus.
  Perangkat Android, iOS dan pengiriman email nyata belum diuji manual.
- Berikutnya prompt 100-penyelesaian setelah tinjauan; belum dimulai.
