# 04 - Input Berat
Rute: sheet dari /transaksi/baru (TransactionLineSheet)   Fase: 3
Frame .pen: "Transaksi - Input Berat" -> "C/Sheet — Berat cuci setrika"
Template: AppBottomSheet + SheetScaffold (body gulir + footer sticky)

Komposisi:
- AppBottomSheet(title: 'Berat <layanan>' / 'Jumlah <layanan>', subtitle harga per satuan).
- AppText nilai (figure), AppText ringkasan '<qty> x <harga> = <total>'.
- Wrap AppChip '+0,5 kg', '+1 kg', '+5 kg' (hanya varian kg).
- Numpad desimal (kg) atau standar 000 (pcs).
- Footer AppButton('Simpan berat' / 'Simpan jumlah').

Data dan provider:
- weightEditProvider menyimpan serviceId + teks input; weightInputSheet membaca
  TransactionDraftProvider untuk harga/satuan.
- transactionDraftProvider.setQuantity(serviceId, qtyMilli) setelah simpan.

Interaksi:
- Ketuk kotak nilai StepperField membuka sheet; chip menambah 0,5/1/5 kg.
- Numpad mengetik angka/koma; hapus digit mengurangi satu karakter.
- Simpan memakai nilai terkini (minimal 0,5 kg atau 1 pcs) dan menutup sheet.
- Tutup sheet tanpa simpan tidak mengubah draf.

State: kg desimal, pcs standar, nilai kosong/koma, chip menambah.
Format: Formatters.berat/jumlah/rupiah; qtyMilli = gram/1000 untuk kg dan pcs*1000.

Selisih terhadap .pen: chip memakai AppChip (bukan NominalChips +Rp); tinggi sheet
mengikuti isi (numpad + footer), tanpa handle kustom karena AppBottomSheet standar.
