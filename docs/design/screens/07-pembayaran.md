# 07 - Pembayaran
Rute: /transaksi/baru/bayar. Frame .pen: Transaksi - Pembayaran.
Template: FormScaffold, body gulir dan dua tombol footer sticky.

## R9 (2 Nov 2026)
- PaymentSummarySection: pelanggan, jumlah layanan, total dan hanya dua pilihan:
  Bayar sekarang (default) / Bayar nanti (COD). Tidak ada pilihan PayStatus.
- PaymentSavingsSection: saldo, Pakai tabungan, pemakaian, sisa bayar/saldo.
  Tabungan boleh dipakai sebagian atau seluruhnya pada kedua pilihan.
- PaymentMethodSection: Tunai/QRIS/Transfer dan Uang diterima lewat CashInputSheet.
  Nilai awal = sisa setelah tabungan; nilai nol yang sengaja dimasukkan tetap nol.
  Bayar sekarang tanpa pembayaran positif tidak dapat disimpan; pesan
  'Isi jumlah atau pilih Bayar nanti (COD)'. Tagihan tertutup tabungan boleh disimpan.
- Kurang dari tagihan: 'Sisa Rp X masuk piutang'. Metode non-tunai tidak menerima
  jumlah melebihi tagihan; tunai menampilkan Kembalian (default) / Simpan ke tabungan.
  Kelebihan bukan omzet; simpan membuat SavingsEntry setor terkait order/ID pembayaran.
- COD menyembunyikan metode dan input jumlah, menampilkan BannerMessage:
  'Pelanggan membayar saat struk/barang diterima. Order tetap di antrean sampai pembayaran dicatat.'
- Footer Cetak struk: simpan lalu /transaksi/nota/:id; tidak otomatis mencetak/menyelesaikan.
- Footer Ke antrean: simpan lalu /antrean; banner 'Nota {nomor} tersimpan' hilang
  sesudah empat detik dan tidak diputar ulang. Kembali tidak menyimpan.
- Kedua tombol nonaktif saat menyimpan, saat draf belum lengkap atau nominal tidak valid.

## Data dan state
transactionDraftProvider, checkoutControllerProvider, customerCatalogProvider,
customerBalanceProvider. received null berarti gunakan terutang sebagai nilai awal;
received 0 adalah input eksplisit, bukan fallback ke total. PayTerm disimpan di Order,
PayStatus tetap dihitung dari pembayaran. saveCheckout memakai TransactionRunner R8
untuk nota/item/payment/event dan pemakaian/setoran tabungan.
Section Stateless menerima data/callback dari Page. CashInputSheet tetap AppBottomSheet;
Numpad: angka pertama mengganti nilai awal, backspace awal mengosongkan, tanpa nol depan.

## Verifikasi dan selisih .pen
R9 mengganti tiga chip status serta dua tombol lama; menambah pilihan kelebihan tunai.
Ringkasan pelanggan/total dan saldo disusun vertikal agar teks besar tetap terbaca.
Spec R9 menang atas frame lama. Fixture DATA MASTER tidak diubah.
Tes domain/state, alur dua tujuan tombol, COD, kelebihan dan rollback; tampilan 320 px
teks 2x dan inset keyboard 300 dp untuk halaman serta CashInputSheet.
Belum diuji manual di Android/iOS; printer tetap dummy.
