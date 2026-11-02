# R10 - Email, pendaftaran dan Kelola akun

1. Baseline R9 dan penelusuran auth/guard/widget; tidak mengubah API atom.
2. Tes service dummy: email benar/salah, daftar/duplikat/konfirmasi, reset, profil/password.
3. Tambah akun uji dummy, interface auth dan store in-memory dengan checkpoint R8.
4. Validator murni email/password/konfirmasi/telepon, pesan error aman, cooldown 60 detik.
5. Form auto-dispose: state tampilan hanya data non-rahasia; input password privat
   sebatas nilai field, dibersihkan saat dispose; tidak masuk snapshot UI/log/error.
6. Masuk/Daftar/Cek email/Lupa password memakai Page/Section dan registry yang ada.
7. Guard public auth routes; signup baru lanjut konfirmasi lalu onboarding yang ada.
8. Kelola akun, sheet nama/telepon/password; Google tidak dapat mengganti password.
9. Hapus akun eksklusif Kelola akun, dua konfirmasi tetap; Pengaturan membuka Kelola akun.
10. Tes alur, keamanan error, rollback, semua keyboard 300 dp, 320 px/teks 2x dan golden.
11. Spec 19/29 + 31/32/33, katalog, catatan backend SMTP sesuai izin, STATE/INDEX.
12. check_all hijau, commit, berhenti sebelum prompt 100.

Tampil/sembunyi password memakai AppButton/AppIcon yang sudah ada di luar field.
Tidak menambah suffix/controller ke AppTextField, dependency, registry atau tema.
