# STATE Laurum
Diperbarui: 2026-11-16 | Cabang ui/pengeluaran (dari newdesign, worktree terpisah)

## Sesi aktif
Redesign kode layar 23 Daftar Pengeluaran mengikuti frame FigCraft
`LAURUM · Pengeluaran` (ID 4294969797, x 2200 y 5302). Dasar commit 8265229.
Paritas dan selisih di docs/design/screens/23-daftar-pengeluaran.md.

## Status irisan
- Page pindah dari RootScaffold ke SubScaffold varian detail: tombol kembali,
  judul "Pengeluaran", sub jumlah transaksi, SyncIndicator trailing, tanpa nav.
- FAB "Catat pengeluaran" di kanan bawah (slot fabLabel SubScaffold) menggantikan
  FooterBar; invalidate draf lalu push /lainnya/pengeluaran/baru tetap.
- ExpenseSummarySection: kartu primary kini hanya total + jumlah transaksi;
  tiga sub-card AppCard berjejer untuk 3 kategori terbesar (urut nominal).
- ChipBar, DateGroupHeader, ExpenseRow, detail sheet, dan state memuat/gagal/
  kosong tidak berubah. Kembali pop, atau go /lainnya bila rute dibuka langsung.
- Berkas: expense_directory_page, expense_summary_section, expense_golden_test,
  spec 23, figma_map, STATE.

## Keputusan pengguna terbaru
- Hilangkan nav bawah, pakai header kembali seperti Layanan, CTA ringkas.
- Rincian kategori jadi sub-card berjejer maks 3 (kategori terbesar).
- Tombol tambah pengeluaran hanya di pojok kanan bawah.

## Belum di-commit
(Irisan ini di-commit bersama STATE.md.)

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
- tes sync + expense (section/page/failure/golden): lulus; golden diperbarui.
- dart run tool/check_all.dart: SEMUA HIJAU, 1316 tes lulus, 2 skip.
