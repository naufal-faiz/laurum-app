# Prompt 30 - Transaksi baru bagian 1

- Draf nota global (Notifier) di features/transactions/pages, bertahan antar layar alur.
- /transaksi/baru: FormScaffold + ringkasan total, pelanggan, layanan, estimasi, diskon,
  catatan; Bayar ke placeholder; keluar dengan ConfirmModal.
- /transaksi/baru/layanan: SubScaffold, pencarian, Sering dipakai, Kiloan/Satuan, hanya aktif.
- Sheet: CustomerPickerSheet, AddCustomerSheet (+ContactPickerSheet), TransactionLineSheet,
  WeightInputSheet, DiscountSheet.
- Validasi pelanggan, nomor dinormalkan, duplikat menawarkan Pakai pelanggan ini.
- Estimasi memakai estimateReady; total/diskon memakai fungsi domain.
- Router: dua rute transaksi menjadi layar nyata; rute pembayaran tetap placeholder.
- Tes draf, alur transaksi, layanan, pelanggan, router, 3 golden; check_all wajib hijau.
