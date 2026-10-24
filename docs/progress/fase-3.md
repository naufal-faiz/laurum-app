# Fase 3 - Transaksi baru bagian 1 (24 Oktober 2026)

- Baseline commit 6107aae: check_all SEMUA HIJAU, 232 tes, 60/60 widget.
- Prompt 30: rute /transaksi/baru dan /transaksi/baru/layanan menjadi layar nyata;
  /transaksi/baru/bayar tetap placeholder sampai prompt 32.
- Draf nota di transactionDraftProvider (global, bertahan antar layar), membersihkan diri
  setelah keluar; total memakai lineTotal domain, diskon dibatasi 0..subtotal.
- Buat Transaksi: pemilihan pelanggan lewat sheet pencarian, baris layanan, estimasi
  estimateReady ('Mengikuti layanan terlama'), diskon, catatan, footer Bayar.
- Pilih Layanan: hanya layanan aktif, Sering dipakai, kelompok Kiloan/Satuan, pencarian.
- Input Berat/Jumlah: sheet dengan Numpad desimal/standar, chip +0,5/+1/+5 kg,
  ringkasan harga, StepperField 0,5 kg atau 1 pcs.
- Tambah Pelanggan Cepat: validasi nama/nomor, normalisasi 62/8 ke 0, duplikat menampilkan
  nama pemilik + 'Pakai pelanggan ini', ambil dari kontak palsu, simpan ke repository.
- Keluar dengan draf berisi memunculkan ConfirmModal; draf kosong langsung keluar.
- 10 tes baru (draf 2, transaksi 3, layanan 2, pelanggan 2, router 1) dan 3 golden:
  transaction_page, service_picker, add_customer_sheet.
- Selisih: pelanggan dipilih lewat sheet (bukan pencarian inline), baris layanan MenuRow,
  estimasi InfoRow dua kolom, Pilih Layanan berupa halaman (frame sheet S25), chip berat
  memakai AppChip, sheet pelanggan dibatasi 500 px agar dapat digulir.
- Atom/token/registry/lint tidak diubah; SheetScaffold footer dibuat full-width.
- Android/iOS perangkat, TalkBack/VoiceOver, keyboard nyata belum diuji.
- check_all SEMUA HIJAU: 245 tes, kedua analyzer bersih, check_arch OK, REPO_MAP 363 berkas.
- Prompt 30 SELESAI; berikutnya docs/prompts/31-printer.md setelah tinjauan.

## Prompt 32 - Pembayaran dan Nota Tersimpan (24 Oktober 2026)
- /transaksi/baru/bayar: status Lunas/DP/Belum bayar, tabungan via applySavings, metode
  Tunai/QRIS/Transfer, uang diterima lewat CashInputSheet (Numpad + NominalChips),
  kembalian, footer Simpan dan cetak/Simpan saja.
- checkoutControllerProvider menghitung sisa, tabungan terpakai, dan uang diterima;
  saveCheckout membuat Order/OrderItem/Payment/OrderEvent via saveOrder lalu SavingsEntry.
- Nomor nota berikutnya A-0143, status diproses, sumber kasir, estimasi estimateReady,
  draf dibersihkan, lalu /transaksi/nota/:id.
- Nota Tersimpan: status pembayaran, printer, ReceiptPreview data tersimpan, Cetak struk
  (PrintService), Kirim lewat WhatsApp (ExternalLauncher palsu), Transaksi baru, Lihat order.
- Gagal cetak menampilkan banner persis + Coba lagi + Pengaturan printer.
- Skenario A-0143 diuji end-to-end: total Rp56.500, tabungan Rp50.000, tunai Rp6.500,
  kembali Rp3.500, saldo tabungan jadi Rp0, order muncul di Antrean, laporan +Rp56.500,
  dan struk dari data tersimpan identik receipt_template.md.
- 5 tes baru (checkout, pembayaran, nota, golden payment_page, golden receipt_page).
- Jam bisnis dummy diubah 10.45 agar A-0143 sama dengan DATA MASTER/template.
- Temuan: Order/Item/Payment/Event atomik dalam saveOrder; SavingsEntry ditulis setelahnya
  karena antarmuka repository terpisah (validasi saldo dilakukan lebih dulu, rollback belum).
- Selisih: pembayaran berupa halaman (frame sheet), tanpa opsi simpan kelebihan ke tabungan,
  kedua tombol footer tidak mencetak otomatis; struk dicetak manual di Nota.
- check_all SEMUA HIJAU: 258 tes, kedua analyzer bersih, check_arch OK, REPO_MAP 391 berkas.
- Prompt 32 SELESAI; berikutnya docs/prompts/40-order.md setelah tinjauan.
