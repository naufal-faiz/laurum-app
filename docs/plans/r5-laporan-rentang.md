# R5: rentang tanggal laporan

- Pengguna 31 Okt mengonfirmasi pengeluaran yang sudah tersimpan ikut dihitung.
- Pertahankan baseline tiga periode; custom memakai buildReport tanpa baseline,
  repository order/payment/expense/savings nyata; tidak mengubah kontrak repository.
- State custom tanggal inklusif -> ReportRange akhir eksklusif, batas 1 Jan 2026
  sampai businessClock; batal tidak mengubah periode. Label lewat Formatters.
- Gunakan showDateRangePicker Indonesia, flutter_localizations paket SDK dan tema token.
- Grafik custom <=7 hari memakai data aktual, >7 disembunyikan dengan pesan;
  top services dihitung dari items aktual dan allocateRevenue yang sudah ada.
- Header Ekspor Excel menggantikan footer; status tepat di bawah header; empty/busy disabled.
- Migrasikan ReportBodySection ke callback tanpa go_router; tes Section dan layar.
- CSV mengikuti rentang aktif; daftar nota menyusul R6 karena data view daftar belum ada.
- Tes dulu: satu hari, sebagian minggu, kosong, batas/label; tes picker/cancel/ekspor.
- Spec 18, fase-8 keputusan komposisi, STATE/INDEX; check_all dan commit tanpa push.
