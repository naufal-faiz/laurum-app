# STATE Laurum
Diperbarui: 2026-11-16 | Cabang ui/pengeluaran (dari newdesign, worktree terpisah)

## Sesi aktif
Redesign layar 23 Daftar Pengeluaran, dasar 2918491.
Tidak ada frame Pengeluaran di FigCraft; tangkapan layar lama `Pasted image`
(ID 4294969796) hanya acuan data. Konsep mengikuti layar terbaru.
Paritas dan selisih di docs/design/screens/23-daftar-pengeluaran.md.

## Status irisan
- Header Page memakai AppPageHeader: LAURUM + 'Pengeluaran' + subjudul jumlah
  transaksi + SyncIndicator; RootScaffold tanpa appBar (pageHeader slot).
- Ringkasan total dipindah ke Section baru expense_summary_section: bulan, kartu
  primary bergradasi bubble, total, jumlah transaksi, rincian per kategori.
- Bulan, ChipBar, DateGroupHeader, ExpenseRow, detail sheet, state memuat/gagal/
  kosong, footer 'Catat pengeluaran', dan bottom nav tidak berubah.
- Tombol akun di header lama dihapus; tujuan yang sama tetap lewat tab Lainnya.
- Berkas: expense_directory_page, expense_list_section, expense_summary_section,
  spec 23, figma_map, golden expense_directory, expense_sections_test.

## Keputusan pengguna terbaru
- Lanjut redesign halaman pengeluaran; screenshot lama hanya referensi data.
- Desain harus sekonsep dengan layar lain; tanpa frame Figma baru.

## Belum di-commit
(Irisan di-commit bersama STATE.md ini.)

## Langkah berikutnya
1. Pengguna meninjau golden expense_directory.png atau menjalankan
   flutter run -t lib/main_dummy.dart (visual belum diverifikasi manual).
2. Koreksi tata letak sebagai commit fix(ui) berikutnya.
3. Merge ui/pengeluaran ke newdesign setelah persetujuan pengguna.
4. Layar 24 Catat Pengeluaran belum disentuh.

## Blocker
Tidak ada.

## Bukti terakhir
- flutter analyze lib/features/expenses: No issues found.
- flutter test expense_sections/pages/failures/golden: 12 tes lulus;
  golden expense_directory.png diperbarui (form tidak berubah).
- dart run tool/check_all.dart: SEMUA HIJAU, 1316 tes lulus, 2 skip.
