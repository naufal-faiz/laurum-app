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
- weightEditProvider menyimpan serviceId, teks input, milli, dan penanda fresh;
  weightInputSheet membaca TransactionDraftProvider untuk harga/satuan.
- transactionDraftProvider.setQuantity(serviceId, qtyMilli) setelah simpan.

Interaksi:
- Ketuk kotak nilai StepperField membuka sheet; StepperField minus nonaktif saat
  qty sudah di minimum (0,5 kg atau 1 pcs).
- Setelah sheet dibuka, nilai awal baris (1 kg / 1 pcs) bertanda fresh: ketukan
  angka pertama MENGGANTI nilai, koma pertama menjadi '0,', Backspace pada nilai
  fresh mengosongkan field. Angka nol di depan tidak ditampilkan (0,5 bukan 00,5).
- Chip +0,5/+1/+5 kg menambah ke nilai yang sedang diketik, mematikan fresh, dan
  tidak membulatkan ke minimum.
- Layar menampilkan nilai apa adanya (0 kg saat kosong); di bawah minimum muncul
  pesan 'Minimal 0,5 kg' / 'Minimal 1 pcs' dan tombol simpan nonaktif. Tidak ada
  pembulatan diam-diam; simpan memakai nilai terkini dan menutup sheet.
- Angka utama mempertahankan koma dan nol desimal selama mengetik ('0,' / '0,50');
  ringkasan harga dan penyimpanan tetap memakai nilai gram numerik.
- Tutup sheet tanpa simpan tidak mengubah draf.

State: kg desimal, pcs standar (koma diabaikan), nilai kosong/'0,', chip menambah,
di bawah minimum (error + simpan nonaktif).
Format: Formatters.beratInput untuk draf, berat/jumlah/rupiah untuk ringkasan;
qtyMilli = gram untuk kg dan pcs*1000 untuk satuan.

Selisih terhadap .pen: chip memakai AppChip (bukan NominalChips +Rp); tinggi sheet
mengikuti isi (numpad + footer), tanpa handle kustom karena AppBottomSheet standar.
