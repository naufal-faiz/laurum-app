# STATE Laurum
Diperbarui: 2026-11-17 | Cabang ui/akun-usaha (dasar 60e3297, merge dari newdesign)

## Sesi aktif
Irisan layar 33 Kelola akun dan 22 Info usaha. Frame: `LAURUM · Kelola Akun`
(ID 4294968821) dan `LAURUM · Info Usaha` (ID 4294968909). Spec 33 dan 22 memuat
tabel paritas + selisih desain; figma_map baris 22/33 terisi.

## Status irisan
- Kelola akun: SubScaffold detail + subtitle 'Profil & keamanan akun'; 4 Section
  baru/ubah: AccountIdentitySection (avatar inisial, nama, email, pil
  'Tertaut dengan Google' memakai assets/icons/google.svg asli),
  AccountProfileSection (PROFIL: Nama, Email baca-saja + keterangan, No. telp),
  AccountSecuritySection (KEAMANAN: Ganti password atau keterangan Google,
  baris Akun Google + status), AccountDangerSection (Keluar outline + kartu
  ZONA BERBAHAYA ber-rail merah).
- Info usaha: FormScaffold detail + subtitle 'Data toko di struk & profil';
  BusinessPreviewSection (pratinjau struk dari draf), BusinessFormSection
  (DETAIL USAHA, 4 field + helper lama), BusinessNoteSection (banner info).
  Footer Simpan dan alur simpan tidak berubah.
- Tidak ada perubahan state, repository, skema, migrasi, token, atom/molecule,
  atau dependensi. Data/aksi/provider/Key tetap sama.
- Berkas: 3 Page/2 Page bisnis+auth, 5 Section baru, 2 Section dirombak,
  6 tes, 1 tes golden baru, 7 golden, spec 22/33, figma_map, STATE.

## Keputusan pengguna terbaru
- Desain diterapkan di kode aplikasi (bukan mengulang FigCraft), patokan frame di atas.
- Logo Google memakai `assets/icons/google.svg`, bukan huruf "G".
- Baris 'Struk & Printer' pada frame Info Usaha tidak dibuat (tidak menambah perilaku).
- Status Tertaut tampil sebagai teks berwarna karena AppBadge belum punya varian hijau.
- Pengguna mengizinkan merge irisan ini ke `newdesign` dan stash sementara 3 berkas
  WIP di worktree utama, lalu dipulihkan.

## Belum di-commit
Tidak ada di worktree ini; seluruh irisan masuk satu commit feat(ui).

## Langkah berikutnya
1. Merge commit irisan ke newdesign, lalu pulihkan stash WIP worktree utama.
2. Pengguna meninjau `r10_account.png`, `info_usaha.png`, atau `flutter run -t lib/main_dummy.dart`.
3. Sisa selisih visual (pil Tertaut, MenuRow berikon, LabeledField bold, isi field
   abu muda, ikon tombol) hanya bisa ditutup lewat proposal komponen bersama.
4. Jangan push ke remote tanpa izin pengguna.

## Blocker
Tidak ada.

## Bukti terakhir
- dart run tool/check_all.dart ui/akun-usaha: SEMUA HIJAU, 1323 tes lulus, 2 skip.
- dart analyze lib/features/auth lib/features/business: No issues found. check_arch: OK.
- Golden diperbarui: r10_account, r10_account_320_2x, r10_name, r10_phone,
  r10_password, r10_password_320_2x; golden baru info_usaha.png.
- Visual belum diverifikasi manual di perangkat; verifikasi lewat golden.
