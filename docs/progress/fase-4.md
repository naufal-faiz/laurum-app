# Fase 4 - Printer dan Struk (24 Oktober 2026)

- Baseline commit fb44c0d: check_all SEMUA HIJAU, 245 tes, 60/60 widget.
- Prompt 31: /lainnya/printer menjadi layar nyata; placeholder rute dihapus.
- PrintService diperluas: PrintStatus, PrinterDevice, ReceiptData (lines/paperMm/fontSize),
  discover, connect, printReceipt, enableBluetooth, disconnect. Fake dapat disetel
  sukses/gagal/bluetooth mati dan mencatat ReceiptData yang dicetak.
- Pengaturan: ReceiptSettings (58/80 mm, huruf 11/13, toggle alamat/pelanggan/tabungan/
  catatan) + BusinessProfile (teks penutup dan catatan) tersimpan lewat repository.
- Pratinjau memakai ReceiptFormatter 32 kolom dan A-0143; lebar 320/384 mengikuti kertas.
- State: belum terhubung, Bluetooth mati (AppBottomSheet + Aktifkan Bluetooth), daftar
  printer kosong, cetak sukses/gagal, loading/error pengaturan.
- 8 tes baru: 4 PrintService, 4 halaman printer (koneksi, ubah kertas/toggle/simpan,
  cetak gagal, Bluetooth) + 1 golden printer_page.
- Selisih: satu halaman gulir tanpa tab, tanpa perataan header, huruf hanya 11/13,
  pratinjau 80 mm tetap 32 kolom, koneksi/print masih palsu.
- iOS belum diuji. Risiko: printer murah umumnya Bluetooth Classic (SPP), sedangkan iOS
  hanya mengizinkan BLE untuk aksesori non-MFi; perlu BLE/Wi-Fi sebelum rilis iOS.
- Atom/token/registry/lint tidak diubah. ReceiptPreview mendapat parameter width opsional.
- check_all SEMUA HIJAU: 253 tes, kedua analyzer bersih, check_arch OK, REPO_MAP 375 berkas.
- Prompt 31 SELESAI; berikutnya docs/prompts/32-transaksi-b.md setelah tinjauan.
