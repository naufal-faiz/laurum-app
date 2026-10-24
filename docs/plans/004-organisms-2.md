# Prompt 13 — organisms 2 dan ReceiptFormatter

- Lingkup: ReceiptFormatter, ReceiptPreview, ReceiptToggleList, Numpad, AppBottomSheet,
  ConfirmModal, ReportSummary, TopServices, WeeklyBarChart. Tanpa perubahan atoms/molecules.
- ReceiptFormatter: `receiptLines(...)` murni, 32 kolom, memakai Formatters; tambah
  `Formatters.tanggalStruk` (d MMM yyyy) karena format struk belum tersedia.
- Status struk: LUNAS, LUNAS (TABUNGAN), DP Rp..., BELUM BAYAR; baris kondisional sesuai
  receipt_template.md dan flag ReceiptSettings.
- ReceiptPreview hanya merender `List<String>`; tepi bergerigi lewat clipper di core/theme.
- ReceiptToggleList: ToggleRow untuk alamat, pelanggan, tabungan, catatan; LockedRow untuk
  nomor/tanggal dan rincian item.
- Numpad: varian standar (000) dan desimal (,), memakai AppNumpadKey; NominalChips opsional.
- AppBottomSheet.show/ConfirmModal.show static; ConfirmModal biasa vs destruktif.
- ReportSummary memakai ReportTotals; TopServices memakai ServiceRevenue; WeeklyBarChart
  menerima label + nominal (null = belum terjadi, batang putus-putus).
- Setiap widget: satu use-case semua varian, tes kontrak/callback, golden, katalog, progress.
- Titik simpan: setelah ReceiptPreview, setelah Numpad, lalu akhir; check_all hijau tiap titik.
