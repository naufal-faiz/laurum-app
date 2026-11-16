# STATE Laurum
Diperbarui: 2026-11-16 | Cabang newdesign (merge ui/pengeluaran b55c22b)

## Sesi aktif
Irisan layar 24 Catat Pengeluaran dan penyesuaian 23 Daftar Pengeluaran dari cabang
ui/pengeluaran (commit b55c22b) sudah di-merge ke newdesign. Frame:
`LAURUM · Catat Pengeluaran` (ID 4294969900) dan `LAURUM · Pengeluaran` (ID 4294969797).
Spec 23 dan 24 memuat tabel paritas + selisih desain.

## Status irisan
- ExpenseAmountSection: nominal teks baca-saja di AppCard (key `expense-nominal`,
  '0' warna placeholder) + AppBadge Rupiah + Numpad; tidak ada field, tidak bisa
  diketuk, tidak membuka keyboard Android.
- ExpenseDetailsSection menyusun ExpenseCategorySection (chip AppChip membungkus +
  Kategori baru), AppCard tanggal/vendor/catatan, ExpenseAttachmentSection.
- Footer FormScaffold varian detail: Batal (outline, 3) + Simpan pengeluaran
  (ikon centang, 5); menumpuk vertikal di <288 dp atau skala teks >1,2.
- Daftar pengeluaran: ExpenseReportLinkSection di antara sub-card dan ChipBar
  (push /laporan, kembali ke daftar).
- Perbaikan sort immutable Drift (commit 760cdec) tetap berlaku; tidak ada perubahan
  state, repository, skema, atau migrasi pada irisan ini.
- Berkas: expense_form_page, expense_date_flow, 5 Section expenses, 2 Page,
  3 tes expense, 2 golden, spec 23/24, figma_map, REPO_MAP, STATE.

## Keputusan pengguna terbaru
- Nominal tidak clickable dan tanpa keyboard sistem; input hanya lewat numpad.
- Tambah tombol Batal di samping Simpan pada footer form.
- Tambah tautan ke halaman Laporan di daftar pengeluaran.
- Header tetap pola detail bersama seperti layar desain baru lain.
- Pengguna menyetujui merge ke newdesign (satu berkas WIP di-stash sementara).

## Belum di-commit
Revisi sesi lain di worktree ini masih belum di-commit (35 berkas): laporan
(report_page, report_range_sheet, report_body/orders/header, report_summary),
app_router, root_shell_page, icon_tile, AndroidManifest, tes navigasi/header,
golden Login/Beranda/Laporan, spec 20, figma_map, draf FigCraft, android/build.
Jangan di-discard atau di-commit tanpa izin pemiliknya.

## Langkah berikutnya
1. Pengguna meninjau golden expense_form.png/expense_directory.png atau menjalankan
   flutter run -t lib/main_dummy.dart dari worktree utama.
2. Koreksi tata letak pengeluaran: commit fix(ui) berikutnya.
3. Usulan widget bersama bila numpad 36 px diinginkan (frame lebih pendek).
4. Jangan push/merge ke cabang lain tanpa izin pengguna.

## Blocker
Tidak ada.

## Bukti terakhir
- dart run tool/check_all.dart di ui/pengeluaran: SEMUA HIJAU, 1317 tes lulus, 2 skip.
- flutter analyze lib/features/expenses: No issues found. check_arch: OK.
- Merge newdesign + b55c22b: konflik hanya docs/progress/STATE.md (diselesaikan).
