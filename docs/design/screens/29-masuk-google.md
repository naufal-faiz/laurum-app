# 29 - Masuk Google (dummy)
Rute: /masuk | Prompt: 90
Frame .pen: Auth - Masuk; PRD A bagian 11 mengganti form email/password dengan Google.
Template: AuthScaffold. Komposisi: SignInSection (AppText merek/tagline/Masuk,
BannerMessage error, status pemulihan, AppButton Lanjutkan dengan Google).
Tidak ada email/password input atau Lupa Kata Sandi.

AuthSession membaca AuthService palsu. Router redirect signed-out ke /masuk;
signed-in dari /masuk ke Antrean. Selama masuk/pemulihan tombol dinonaktifkan.
Akun lama mencoba sync lokal; gagal sync tetap boleh memakai data HP, status gagal/
offline terlihat di aplikasi. Masuk batal/gagal tidak melewati guard.
Akun baru wajib Info Usaha (/lainnya/info-usaha?onboarding=1); form awal kosong,
nama wajib. Simpan berhasil menuntaskan setup dan mencoba sync lalu ke Antrean.
Kembali saat setup membuka konfirmasi keluar, bukan membuka rute terlindungi.

DATA MASTER: sesi demo awal owner-001 terautentikasi; email contoh ratna@example.com.
Demo Google tidak memakai SDK/jaringan/token/penyimpanan kredensial nyata.
Pemulihan adalah status operasi fake SyncService, bukan unduhan backend sungguhan.
Selisih .pen: Google mengganti form lama sesuai PRD; ikon person netral dari registry.
Verifikasi: deep-link guard, signin batal/berhasil/pemulihan, onboarding/validasi,
keyboard Info Usaha 300 dp, golden signin/error dan layout 320 px/teks 2x.
Android/iOS, Google native, secure storage dan pemulihan nyata belum diuji.
