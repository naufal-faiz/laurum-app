# 06 - Printer dan Struk
Rute: /lainnya/printer   Fase: 4   Frame .pen: "Lainnya - Printer dan Struk"
Template: FormScaffold (AppBarSub + body gulir + FooterBar sticky)

Komposisi:
- AppBarSub(title: 'Printer dan struk', backLabel: 'Kembali').
- PrinterConnectionSection: BannerMessage warning 'Printer belum terhubung.' + AppButton
  'Cari printer'; atau AppCard berisi nama printer + 'Terhubung dan siap mencetak' + Ganti.
- PrinterSettingsSection: AppChip '58 mm'/'80 mm', AppChip 'Normal'/'Besar',
  ReceiptToggleList (alamat, pelanggan, tabungan, catatan; dua baris terkunci),
  LabeledField + AppTextField 'Teks penutup struk' dan 'Catatan khusus nota'.
- PrinterPreviewSection: ReceiptPreview (lebar 320 untuk 58 mm, 384 untuk 80 mm) memakai
  receiptLines dari ReceiptFormatter; teks 'belum diuji' ke printer asli.
- Footer: AppButton('Simpan pengaturan') + AppButton('Cetak uji').

Data dan provider:
- printerSettingsProvider (AsyncNotifier) memuat ReceiptSettings + BusinessProfile;
  edit langsung mengubah state; save menulis ke BusinessRepository.
- printerConnectionProvider (Notifier) memegang status, devices, connected, notice.
- printServiceProvider / FakePrintService: discover, connect, printReceipt(ReceiptData),
  enableBluetooth; dapat disetel gagal/tidak terhubung.
- demoReceiptLines memakai A-0143 DATA MASTER.

Interaksi:
- Cari printer -> discover; jika Bluetooth mati buka BluetoothSheet 'Aktifkan Bluetooth',
  lalu daftar printer palsu (MenuRow) -> connect.
- Mengubah kertas/huruf/toggle/teks langsung memperbarui pratinjau; Simpan menulis
  ReceiptSettings dan BusinessProfile (footer/note).
- Cetak uji mengirim List<String> 32 kolom + paperMm/fontSize ke PrintService;
  sukses menampilkan notice, gagal menampilkan BannerMessage error.
- Ganti membuka daftar printer lagi.

State: memuat skeleton, gagal memuat + Coba lagi, belum terhubung, Bluetooth mati,
daftar printer kosong, cetak gagal, cetak sukses.

Format: ReceiptFormatter 32 kolom; ReceiptPreview mono 11/16; Formatters untuk tanggal.

Selisih terhadap .pen: tanpa tab Printer/Tampilan struk (satu halaman gulir), tanpa
pengaturan perataan header, pilihan ukuran huruf hanya Normal/Besar (11/13),
pratinjau 80 mm tetap 32 kolom, dan tidak ada status koneksi nyata.
iOS: printer thermal banyak memakai Bluetooth Classic (SPP) yang tidak tersedia untuk
aksesori non-MFi; perlu BLE/Wi-Fi sebelum rilis iOS. Fitur ini **belum diuji di iOS**.
