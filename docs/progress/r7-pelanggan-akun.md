# R7 - Aksi Pelanggan dan tombol Keluar (SELESAI otomatis)
Diperbarui: 31 Oktober 2026.

## Perilaku
- Daftar Pelanggan tanpa FooterBar. CustomerDirectoryActionsSection di atas daftar:
  Impor kontak (actionOutline) + Pelanggan baru (cta, ikon add), satu baris pada
  lebar normal; tumpuk vertikal bila lebar < 360 atau skala teks >= 1,3x.
- Simpan pelanggan baru tetap mereset filter ke Semua dan mengosongkan pencarian.
- Section daftar pelanggan dimigrasikan dari ConsumerWidget ke StatelessWidget:
  data/filter/pencarian/callback dari Page; utang Riverpod Section berkurang 1.
- AKUN: MenuRow Keluar dihapus dari kartu. Di bawah kartu tampil AppButton
  destructiveOutline 'Keluar' dengan AppIcons.logout (Ionicons.logOutOutline).
- ConfirmModal 'Keluar dari akun?' memakai destructive true dan ikon logout.

## Bukti
- Tes: footer tidak ada, dua tombol aksi atas, varian/ikon benar; layout 320 px
  teks 2x tanpa overflow; Keluar bukan MenuRow, tombol destruktif, modal destruktif
  berikon logout; signOut tetap menuju /masuk.
- Golden app_icon dan r4_settings diperbarui setelah ditinjau (ikon logout muncul;
  tombol Keluar di bawah kartu AKUN).

## Tindak lanjut / yang perlu ditinjau di HP
- Nav tengah, keyboard tiap sheet, mode status order, dan rentang tanggal Laporan
  belum diuji ulang di perangkat setelah seri R.
- Android/iOS perangkat dan pembaca layar belum diuji; signOut masih placeholder.

## Validasi penuh
Perintah: dart run tool/check_all.dart, 31 Oktober 2026.
```text
Formatted 484 files (0 changed)
flutter analyze: No issues found!
dart analyze: No issues found!
check_arch: OK
+447: All tests passed!
REPO_MAP diperbarui: 552 berkas
check_all: SEMUA HIJAU
```
