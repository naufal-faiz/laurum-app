# 016 � Koreksi Antrean dan integrasi loader 014

Diminta pengguna 10 Nov 2026. Frame 408 dibaca ulang melalui MCP FigCraft.
Izin sesi: jarak ringkasan, warna subjudul, modal filter di atas navigasi,
serta implementasi loader Lottie dari docs/design sesuai proposal 014.

- Token: AppDimensions.loader = 96 mengikuti contoh pengguna (014).
- Atom: AppLoader StatelessWidget terdaftar; aset refined disalin tanpa perubahan
  ke assets/animations/laurum-loader.json; paket melalui flutter pub add lottie.
  Semantics Sedang memuat; animasi mengikuti reduced motion dan TickerMode.
- Molekul: SectionHeader.titleColor opsional null, hanya Antrean memakai primary.
- Organisme: AppBottomSheet.show.useRootNavigator default false; filter Antrean
  memakai true agar modal/barrier berada di atas bottom navigation dan Transaksi.
- Template: tinggi slot header Antrean kembali 64, cocok header label pengguna.
- Page/Section: hapus padding vertikal ringkasan, sisakan padding daftar 16
  sebelum chip. Loading Beranda/Antrean memakai AppLoader; aksi/data tetap.
- Perubahan manual header label pengguna dipertahankan, tidak ditimpa.

Paritas: provider/query/filter/status/COD, akun di Lainnya, kosong/error/retry,
Key order dan pencarian tetap. Loader hanya mengganti presentasi loading.
Tes: jarak dan warna, hit target filter di atas nav, pemilihan status,
aset Lottie termuat, gerakan normal/statis, hilang setelah data selesai,
keyboard 300 dp, golden, check_all, Android. iOS belum diuji.

Golden yang diperkirakan berubah (sebelum pembaruan):
antrean_normal/proses/kosong/filter_kosong/loading/error/whatsapp,
r4_antrean_sederhana, r9_cod_queue. Warna/jarak header dan loading baru.
Beranda normal dan galeri SectionHeader/AppBottomSheet tetap pada default lama.

Pembaruan auth diizinkan pengguna setelah perubahan auth dinyatakan final.
Kode auth yang sudah ada: hapus ikon tombol submit, kecilkan tagline hero ke label;
penyesuaian parameter tes milik pengguna dipertahankan. Perilaku submit tetap.
Golden auth yang berpotensi bergeser sebelum pembaruan: auth_hero,
auth_scaffold_hero, auth_signin, auth_signin_error, r10_signin, r10_signin_error,
r10_signin_error_320_2x, r10_signup, r10_signup_320_2x, r10_reset, r10_verify.
Hanya berkas yang benar-benar berbeda akan disertakan; daftar akhir dicatat.


Hasil pembaruan auth: sembilan golden berubah, yaitu auth_hero, auth_scaffold_hero,
auth_signin, auth_signin_error, r10_signin, r10_signin_error,
r10_signin_error_320_2x, r10_signup, r10_signup_320_2x. Total 18 bersama Antrean.
36 tes auth terkait lulus sesudah pembaruan. Tidak ada assertion perilaku dihapus
oleh tugas ini. Tes signup menyesuaikan parameter ikon yang dihapus dan assertion
visual menjadi tanpa centang; callback, validasi dan busy tetap diuji. Berkas
tes dipadatkan dari 121 menjadi 110 baris tanpa mengurangi tes perilaku.
API Lottie: https://pub.dev/documentation/lottie/3.8.2/lottie/Lottie-class.html

Bukti akhir 10 Nov 2026: check_all exit 0; format 977 (0 berubah), analyzer dan
Riverpod bersih, check_arch OK, 1040 tes lulus/1 skip, REPO_MAP 1055 berkas.
Log lokal: TEMP/laurum-loader-check-all-complete.log. Android SM-N975F:
ringkasan/warna, kelima opsi filter di atas nav/Transaksi, field dan tutup saat
keyboard terbuka diperiksa. Loader diperiksa lewat golden dan tes gerakan/statis.
Diff zona beku: state/data/domain/repository, persistensi/sync, rute, tool, lint,
PRD dan supabase tidak berubah. Pengecualian diminta pengguna: paket Lottie,
registrasi atom AppLoader dan token ukuran 96. iOS belum diuji.
