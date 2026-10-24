# 08 - Nota Tersimpan
Rute: /transaksi/nota/:id   Fase: 3   Frame .pen: "Transaksi - Nota Tersimpan"
Template: SubScaffold (AppBarSub, tanpa nav)

Komposisi:
- ReceiptStatusPage: AppCard Nomor nota, AppStatusText Lunas/DP/Belum bayar,
  'Pembayaran tersimpan.', status printer (nama + Terhubung / belum terhubung).
- BannerMessage error 'Struk gagal dicetak. Pastikan printer menyala dan Bluetooth aktif.'
  + AppButton 'Coba lagi' dan 'Pengaturan printer'.
- ReceiptPreview dari receiptLines data tersimpan; lebar 320/384 sesuai ReceiptSettings.
- AppButton 'Cetak struk', 'Kirim lewat WhatsApp', 'Transaksi baru', 'Lihat order'.

Data dan provider:
- receiptViewProvider(:id): Order, OrderItem, Payment, Customer, BusinessProfile,
  ReceiptSettings, saldo tabungan; nota tidak ditemukan -> EmptyState.
- receiptPrintProvider: printing/error/notice; PrintService.printReceipt(ReceiptData).
- ExternalLauncher.launchWhatsApp (palsu) untuk kirim nota.

Interaksi:
- Cetak struk mengirim 32 kolom + paperMm/fontSize; sukses notice, gagal banner + retry.
- Pengaturan printer membuka /lainnya/printer.
- Kirim lewat WhatsApp memakai nomor pelanggan dan teks struk; gagal menampilkan banner.
- Transaksi baru ke /transaksi/baru; Lihat order ke /order/:id (placeholder prompt 40).
- Kembali ke /antrean bila tidak ada tumpukan rute.

State: loading skeleton, gagal memuat, nota tidak ditemukan, cetak sukses/gagal,
WhatsApp sukses/gagal, printer belum terhubung.

Format: struk identik ReceiptFormatter 32 kolom; pelanggan memakai nama lengkap kecuali
fixture nota yang memang menyimpan nama pendek.

Selisih terhadap .pen: struk tidak dicetak otomatis saat nota dibuka (tombol Cetak struk);
status printer berasal dari FakePrintService, bukan Bluetooth nyata. iOS belum diuji;
printer Bluetooth Classic tidak didukung iOS non-MFi.
