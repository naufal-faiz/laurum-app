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
