# 06 - Printer dan Struk
Rute: /lainnya/printer   Fase: 4   Frame .pen: "Lainnya - Printer dan Struk"
Template: FormScaffold (AppBarSub + body gulir + FooterBar sticky)

Komposisi:
- AppBarSub(title: 'Printer dan struk', backLabel: 'Kembali').
- PrinterConnectionSection: BannerMessage warning 'Printer belum terhubung.' + AppButton
  'Cari printer'; atau AppCard berisi nama printer + 'Terhubung dan siap mencetak' + Ganti.
- PrinterSettingsSection: AppChip '58 mm'/'80 mm' (mengetuk '80 mm' hanya
  menampilkan BannerMessage 'Printer 80 mm masih coming soon...' dan ukuran tetap
  58 mm), AppChip 'Normal'/'Besar',
  ReceiptToggleList (alamat, pelanggan, tabungan, catatan; dua baris terkunci),
  LabeledField + AppTextField 'Teks penutup struk' dan 'Catatan khusus nota'.
- PrinterPreviewSection: ReceiptPreview (lebar 320 untuk 58 mm, 384 untuk 80 mm) memakai
  receiptLines dari ReceiptFormatter; teks 'belum diuji' ke printer asli.
- Footer: AppButton('Simpan pengaturan') + AppButton('Cetak uji').

Data dan provider:
- printerSettingsProvider (AsyncNotifier) memuat ReceiptSettings lewat
  ReceiptSettingsRepository dan BusinessProfile lewat BusinessRepository.
  Edit langsung mengubah state; save menulis keduanya lewat TransactionRunner.
- Printer yang dipilih disimpan di LocalSettingsRepository (printer_id/printer_name),
  hanya lokal di perangkat dan tidak masuk outbox sinkron. Saat halaman Printer dibuka,
  `printerRestoreProvider` mencoba menyambung ulang printer tersimpan secara diam
  (tanpa banner error bila printer mati).
- printerConnectionProvider (Notifier) memegang status, devices, connected, notice.
- printServiceProvider: build backend memakai EscPosPrintService + BlePrinterTransport
  (BLE nyata); build dummy/tes memakai FakePrintService yang dapat disetel gagal/tidak
  terhubung.
- demoReceiptLines memakai A-0143 DATA MASTER.

Interaksi:
- Cari printer -> discover; jika Bluetooth mati buka BluetoothSheet 'Aktifkan Bluetooth',
  lalu daftar printer (MenuRow) -> connect. Build dummy menampilkan daftar palsu; build
  backend memakai hasil pindai BLE.
- Mengubah kertas/huruf/toggle/teks langsung memperbarui pratinjau; Simpan menulis
  ReceiptSettings dan BusinessProfile (footer/note) secara atomik; memakai profil
  terbaru agar perubahan nama/status order setelah form dibuka tetap dipertahankan.
- Cetak uji mengirim List<String> 32 kolom + paperMm/fontSize ke PrintService;
  sukses menampilkan notice, gagal menampilkan BannerMessage error.
- Ganti membuka daftar printer lagi.

State: memuat skeleton, gagal memuat + Coba lagi, belum terhubung, Bluetooth mati,
daftar printer kosong, cetak gagal, cetak sukses.

Skeleton hanya untuk pemuatan awal; pembaruan pengaturan di latar belakang tetap
menampilkan kontrol yang sudah terpasang. Penulisan preferensi printer dan metadata
sinkronisasi tidak memuat ulang query bisnis (DriftChangeMonitor).

Format: ReceiptFormatter 32 kolom; ReceiptPreview mono 11/16; Formatters untuk tanggal.

Selisih terhadap .pen: tanpa tab Printer/Tampilan struk (satu halaman gulir), tanpa
pengaturan perataan header, pilihan ukuran huruf hanya Normal/Besar (11/13),
pratinjau 80 mm tetap 32 kolom, dan status koneksi hanya berasal dari BLE nyata pada
build backend (dummy memakai printer palsu).
iOS: printer thermal banyak memakai Bluetooth Classic (SPP) yang tidak tersedia untuk
aksesori non-MFi; adapter hanya memakai BLE (`flutter_blue_plus`) sehingga Classic
tidak didukung. Fitur ini **belum diuji di iOS**.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
