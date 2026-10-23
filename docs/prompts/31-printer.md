# 31 - Printer dan Struk
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: prompt 30 SELESAI. Baca: frame "Lainnya - Printer dan Struk" dan varian State (printer tidak terhubung, Bluetooth mati), receipt_template.md.

TUGAS
1. Perluas PrintService (antarmuka) dengan discover, connect, print(ReceiptData), status; FakePrintService bisa disetel sukses, gagal, atau tidak terhubung untuk tes.
2. Layar /lainnya/printer: pilih dan hubungkan printer (daftar palsu), ukuran kertas 58/80 mm, ukuran huruf, ReceiptToggleList, kolom teks penutup dan catatan, ReceiptPreview memakai ReceiptFormatter, tombol "Cetak tes".
3. State: printer belum terhubung (BannerMessage warning "Printer belum terhubung." + aksi "Cari printer"), Bluetooth mati (AppBottomSheet "Aktifkan Bluetooth"), gagal cetak.
4. Pengaturan struk tersimpan lewat repository ReceiptSettings dan memengaruhi preview seketika.
5. Catatan: printer asli belum ada. Tandai "belum diuji di iOS" dan catat risiko Bluetooth Classic vs BLE (PRD B bagian 17).
