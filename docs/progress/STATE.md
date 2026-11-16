# STATE Laurum
Diperbarui: 2026-11-16 | Cabang ui/pengeluaran (dari newdesign, worktree terpisah)

## Sesi aktif
Irisan layar 24 Catat Pengeluaran (dan penyesuaian 23 Daftar Pengeluaran) mengikuti
frame FigCraft `LAURUM · Catat Pengeluaran` (ID 4294969900) dan `LAURUM · Pengeluaran`
(ID 4294969797). Dasar commit c3f7023. Spec 23 dan 24 memuat tabel paritas + selisih.

## Status irisan
- ExpenseAmountSection: nominal kini teks baca-saja di AppCard (AppText, key
  `expense-nominal`, '0' warna placeholder) + AppBadge Rupiah + Numpad; tidak ada
  field, tidak bisa diketuk, tidak membuka keyboard Android.
- ExpenseDetailsSection (99 baris) menyusun ExpenseCategorySection (chip AppChip
  membungkus + Kategori baru), AppCard tanggal/vendor/catatan, dan
  ExpenseAttachmentSection.
- Footer FormScaffold varian detail: Batal (outline, flex 3) + Simpan pengeluaran
  (ikon centang, flex 5); menumpuk vertikal di <288 dp atau skala teks >1,2.
- Daftar pengeluaran: ExpenseReportLinkSection (AppCard onTap) di antara sub-card
  dan ChipBar; Page push /laporan.
- Tes: expense_sections, expense_pages (push/pop laporan), expense_keyboard (baru),
  golden expense_directory + expense_form diperbarui.
- Berkas: expense_form_page, expense_date_flow (baru), 5 Section, 2 Page, 3 tes,
  2 golden, spec 23/24, figma_map, REPO_MAP, STATE.

## Keputusan pengguna terbaru
- Nominal tidak clickable, tanpa keyboard sistem; input hanya numpad.
- Tambah tombol Batal di samping Simpan pada footer form.
- Tambah tautan ke halaman Laporan di daftar pengeluaran.
- Header tetap pola detail bersama seperti layar desain baru lain.

## Belum di-commit
Tidak ada (irisan di-commit bersama STATE.md).

## Langkah berikutnya
1. Pengguna meninjau golden expense_form.png dan expense_directory.png, atau
   flutter run -t lib/main_dummy.dart (visual belum diverifikasi manual).
2. Koreksi tata letak: commit fix(ui) berikutnya.
3. Usulan widget bersama bila numpad 36 px diinginkan (frame lebih pendek).
4. Merge ui/pengeluaran ke newdesign setelah persetujuan pengguna.

## Blocker
Tidak ada.

## Bukti terakhir
- dart run tool/check_all.dart: SEMUA HIJAU, 1317 tes lulus, 2 skip.
- flutter analyze lib/features/expenses: No issues found.
- dart run tool/check_arch.dart: OK.
