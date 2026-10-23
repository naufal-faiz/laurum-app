# 13 - Organisms bagian 2 (8 widget) dan ReceiptFormatter
Ikuti _COMMON.md bagian A, B, D, E, F. Prasyarat: prompt 12 SELESAI. Baca: PRD A bagian 5, tokens.md, receipt_template.md, frame .pen terkait.

Urutan: ReceiptFormatter (fungsi murni di core/domain/receipt_formatter.dart), lalu ReceiptPreview, ReceiptToggleList, Numpad, AppBottomSheet, ConfirmModal, ReportSummary, TopServices, WeeklyBarChart.

Catatan:
- ReceiptFormatter menghasilkan List<String> 32 kolom persis seperti receipt_template.md, termasuk baris kondisional dan status. Tes golden-text untuk nota A-0143 dan variasi (lunas tabungan, DP, belum bayar, tanpa catatan). ReceiptPreview HANYA merender hasilnya (mono 11/16, tepi bergerigi).
- ReceiptToggleList: baris terkunci (Nomor nota dan tanggal, Rincian item dan diskon) tanpa saklar; sisanya memakai ToggleRow.
- Numpad: varian default (000, 0, hapus) dan desimal (koma, 0, hapus), baris NominalChips opsional. Tanpa "Reset (C)".
- AppBottomSheet.show dan ConfirmModal.show: static method dalam kelas widget; ConfirmModal punya varian tombol utama biasa dan destruktif.
- WeeklyBarChart: komposisi Row/Container tanpa paket chart; batang hari belum terjadi memakai gaya kosong. Catat selisih bila .pen memakai garis putus-putus.
- ReportSummary: kartu angka (Pendapatan, Pengeluaran, laba, Kas masuk, Tabungan pelanggan, Piutang aktif) sesuai .pen.

Titik simpan setelah ReceiptPreview, setelah Numpad, dan di akhir.
