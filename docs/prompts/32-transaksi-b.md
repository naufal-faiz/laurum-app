# 32 - Transaksi baru bagian 2
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: prompt 31 SELESAI. Baca: frame "Transaksi - Pembayaran", "Nota Tersimpan" dan varian State terkait.

Layar: Pembayaran (/transaksi/baru/bayar), Nota Tersimpan (/transaksi/nota/:id).

Aturan:
- Pembayaran: metode Tunai, QRIS, Transfer; pemakaian tabungan (hanya bila saldo ada) lewat applySavings; status Lunas, DP, Belum bayar (tanpa jatuh tempo); uang diterima lewat sheet Numpad dengan NominalChips; kembalian dihitung; opsi menyimpan kelebihan ke tabungan hanya bila ada di .pen.
- Simpan membuat Order, OrderItem, Payment, dan SavingsEntry dalam satu operasi repository, memakai nomor nota berikutnya (A-0143), lalu membuka Nota Tersimpan. Draf dibersihkan.
- Nota Tersimpan: ReceiptPreview (data nota tersimpan), tombol "Cetak struk" memakai PrintService (gagal memunculkan Banner error "Struk gagal dicetak. Pastikan printer menyala dan Bluetooth aktif." dengan "Coba lagi" dan "Pengaturan printer"), "Kirim lewat WhatsApp" memakai ExternalLauncher palsu, "Lihat order" ke Detail Order (placeholder sampai prompt 40).
- Alur akhir yang HARUS berjalan: pelanggan baru dari sheet, dua layanan, berat, bayar tabungan + tunai, nota tersimpan, order muncul di Antrean, Laporan dan saldo tabungan berubah.
- Tes: skenario A-0143 persis seperti data_master.md (total Rp56.500, tabungan Rp50.000, tunai Rp6.500, kembali Rp3.500) dan struk identik dengan receipt_template.md.
