# 18 - Laporan - Ringkasan
Rute: /laporan (tab)   Prompt: 60, bagian pertama
Frame .pen: "Laporan - Ringkasan", State - Laporan kosong.
Rekonsiliasi B1e (izin 4 Nov 2026): angka ledger pada spec/DATA MASTER menggantikan
angka historis lama di .pen. Golden diperbarui, struktur/tampilan widget tetap.
Template: RootScaffold dari RootShellPage; tanpa FooterBar ekspor (R5).

Komposisi:
- SectionHeader Laporan, aksi kanan 'Ekspor Excel'; BannerMessage hasil ekspor
  tepat di bawah header; PeriodTabs Hari ini / Minggu ini / Bulan ini / Pilih tanggal.
- ReportSummary dengan kartu piutang yang membuka /laporan/piutang.
- WeeklyBarChart, AppText puncak hari, TopServices (peringkat pendapatan).
- ReportOrdersSection di bawah ringkasan untuk semua periode: judul 'Nota (n)',
  AppSearchField nomor/nama, ChipBar Semua/Belum lunas/Selesai/Dibatalkan,
  DateGroupHeader per tanggal, OrderCard ringkas per nota; ketuk membuka /order/:id.
- Pemilih rentang bawaan showDateRangePicker dalam mode kalender saja, lokal id_ID,
  warna DatePickerThemeData dari token yang ada. Tidak menambahkan input keyboard.
- AppSkeleton; EmptyState kosong/error dengan Coba lagi.

Data/provider:
- reportPeriodProvider (awal Minggu ini, indeks 0..3), reportCustomRangeProvider,
  reportViewProvider, reportExportProvider, reportOrdersProvider,
  reportOrdersFilterProvider (0..3), reportOrdersSearchProvider.
- Daftar nota memakai orderRepository (item, payment, pelanggan) difilter range aktif.
  Seluruh periode memakai ledger yang sama. Omzet/jumlah transaksi berasal dari nota
  non-batal yang benar-benar tersimpan, sesuai daftar nota pada rentang tersebut.
- Mode status order nonaktif memakai label kebijakan 'Sedang dikerjakan' pada nota.
- Periode dihitung dari businessClockProvider; minggu Senin sampai Minggu.
- ReportRepository menyediakan totals, grafik harian, layanan terlaris dan jumlah
  nota belum lunas; posisi piutang/tabungan memakai seluruh ledger akun.
- Minggu: pendapatan Rp589.000, 14 transaksi, pengeluaran Rp850.000, laba -Rp261.000,
  kas Rp500.000, tabungan Rp430.000, piutang Rp400.500/5 nota.
- Grafik: ledger 0/0/248/164/177 ribu, Sab/Min null, rata-rata Rp117.800,
  puncak Rabu. Hari lampau tanpa nota bernilai nol, masa depan belum memiliki batang.
- Top services seluruh periode dari snapshot item dan alokasi diskon yang sama;
  urutan berdasarkan pendapatan. Minggu memuat lima layanan nyata, tanpa bucket fiktif.
- Hari ini memakai satu batang. Grafik tampilan dibatasi tujuh hari; data harian
  bulan tetap dihitung repository, tampilan bulan memakai pesan batas tujuh hari.
- Perubahan checkout/pembayaran/setoran mengikuti notifikasi repository.
- Semua preset dan rentang kustom melewati ReportRepository dan buildReport yang sama.
  InMemory menghitung ledger; Drift memakai query range dan posisi SQL lalu fungsi
  domain yang sama. Angka DATA MASTER/golden direkonsiliasi dengan izin 4 Nov 2026.
- Batas kalender 1 Jan 2026 sampai tanggal businessClockProvider. Mulai/akhir di UI
  inklusif (satu hari boleh), ReportRange akhir eksklusif. Label 12-18 Okt atau 16 Okt;
  lintas bulan/tahun menampilkan kedua ujung yang diperlukan melalui Formatters.
- Omzet/jumlah nota berdasarkan enteredAt, pengeluaran berdasarkan spentAt,
  kas berdasarkan paidAt/setoran createdAt di rentang. Piutang aktif dan saldo
  tabungan tetap posisi terkini usaha sesuai semantik domain buildReport.
- Pengguna 31 Okt mengizinkan pengeluaran yang sudah tersimpan ikut dihitung;
  keputusan ini menggantikan catatan lama STATE yang membatasi R5 pada nota/pembayaran.
- Custom <=7 hari memakai grafik aktual; >7 hari disembunyikan dengan BannerMessage
  'Grafik harian ditampilkan untuk rentang hingga 7 hari.'. TopServices mendukung
  daftar dinamis; bila snapshot item tidak lengkap, tampil keterangan tanpa angka palsu.

Interaksi/state:
- Ganti periode memuat ulang data; tidak mempertahankan angka periode sebelumnya
  saat loading/error. Tidak bisa mengganti periode saat ekspor berjalan.
- Pilih tanggal membuka kalender; Terapkan menyimpan range lalu mengaktifkan tab 3.
  Ketuk tab range untuk mengganti; tutup/batal tetap periode dan range sebelumnya.
  Identitas ListView mencakup range agar daftar baru mulai dari atas.
- Kartu piutang menuju placeholder Daftar Piutang (bagian kedua prompt 60).
- Ekspor: CSV UTF-8 BOM, pemisah titik koma, nominal angka rupiah tanpa desimal,
  ringkasan/periode/grafik/layanan yang tersedia; FakeExportService hanya mencatat
  permintaan dan path palsu. Tidak membuat XLSX/file nyata atau membuka Excel.
- Ekspor disabled saat loading/kosong/busy; error dapat dicoba lagi.
- CSV custom memakai label/rentang aktif dan nama laporan-YYYYMMDD-YYYYMMDD.csv;
  CSV semua periode memuat daftar nota (nomor, tanggal, pelanggan, total, status bayar).
- Seluruh /transaksi, NotaHistoryPage, dan spesifikasi Riwayat Nota dihapus (R6).
- Pencarian nota di Laporan wajib lulus tes keyboard (viewInsets 300 dp).
- Periode tanpa arus transaksi/pengeluaran/kas menampilkan EmptyState. Jika posisi
  piutang/tabungan tetap ada, ringkasannya tetap terlihat agar tidak tersembunyi.
- Khusus custom kosong: hanya EmptyState, tidak menampilkan ringkasan posisi global.
  Nota historis yang benar-benar ada (termasuk sebelum 12 Okt) tetap dihitung;
  periode tanpa data sama sekali, misalnya Januari, tidak meminjam baseline.

Selisih .pen R5: Atur diganti Pilih tanggal/rentang, Ekspor Excel pindah ke header;
kalender Material lokal Indonesia tidak ada pada frame lama. Label pengeluaran Operasional usaha,
puncak di bawah grafik agar teks besar tidak terpotong, batas rincian Hari/Bulan di atas.
Format tampilan memakai Formatters; seluruh nominal int rupiah. Widget bersama tidak diubah.
Verifikasi: angka master, checkout/pembayaran reaktif, ganti periode, navigasi, ekspor/retry,
loading/kosong/error, lebar 320 px dan teks 2x. Perangkat Android belum diuji;
belum diuji di iOS. Ekspor masih palsu pada kedua platform.
R5: golden r5_report_custom/r5_date_picker ditinjau, grafik 7 hari dan kalender pada
320 px/teks 2x lulus. ReportBodySection tanpa router, aksi piutang lewat callback Page.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
