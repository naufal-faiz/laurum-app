# 18 - Laporan - Ringkasan
Rute: /laporan (tab)   Prompt: 60, bagian pertama
Frame .pen: "Laporan - Ringkasan", State - Laporan kosong.
Template: RootScaffold dari RootShellPage; FooterBar di atas BottomNavBar.

Komposisi:
- SectionHeader Laporan; PeriodTabs Hari ini / Minggu ini / Bulan ini.
- ReportSummary dengan kartu piutang yang membuka /laporan/piutang.
- WeeklyBarChart, AppText puncak hari, TopServices (peringkat pendapatan).
- FooterBar dengan satu AppButton Ekspor ke Excel dan status BannerMessage.
- AppSkeleton; EmptyState kosong/error dengan Coba lagi.

Data/provider:
- reportPeriodProvider (awal Minggu ini), reportViewProvider, reportExportProvider.
- Periode dihitung dari businessClockProvider; minggu Senin sampai Minggu.
- ReportRepository menyediakan totals/top services; OrderRepository menghitung jumlah
  nota belum lunas (order dibatalkan/dihapus dikecualikan).
- Minggu: pendapatan Rp1.800.000, 58 transaksi, pengeluaran Rp850.000, laba Rp950.000,
  kas Rp1.699.500, tabungan Rp430.000, piutang Rp400.500/5 nota.
- Grafik: fixture 340/385/290/410/375 ribu, Sab/Min null, rata-rata Rp360.000,
  puncak Kamis. Nilai = baseline harian + order kini - order fixture awal.
- Top services dari repository, diurutkan pendapatan menurun. Rincian Hari/Bulan
  tidak tersedia menurut DATA MASTER bagian Penjelasan baseline; tampilkan keterangan.
- Hari ini memakai satu batang sesuai total hari ini. Grafik Bulan belum tersedia.
- Perubahan checkout/pembayaran/setoran mengikuti notifikasi repository.

Interaksi/state:
- Ganti periode memuat ulang data; tidak mempertahankan angka periode sebelumnya
  saat loading/error. Tidak bisa mengganti periode saat ekspor berjalan.
- Kartu piutang menuju placeholder Daftar Piutang (bagian kedua prompt 60).
- Ekspor: CSV UTF-8 BOM, pemisah titik koma, nominal angka rupiah tanpa desimal,
  ringkasan/periode/grafik/layanan yang tersedia; FakeExportService hanya mencatat
  permintaan dan path palsu. Tidak membuat XLSX/file nyata atau membuka Excel.
- Ekspor disabled saat loading/kosong/busy; error dapat dicoba lagi.
- Periode tanpa arus transaksi/pengeluaran/kas menampilkan EmptyState. Jika posisi
  piutang/tabungan tetap ada, ringkasannya tetap terlihat agar tidak tersembunyi.

Selisih .pen: tanpa Atur (prompt hanya tiga periode), label pengeluaran Operasional usaha,
puncak di bawah grafik agar teks besar tidak terpotong, batas rincian Hari/Bulan di atas.
Format tampilan memakai Formatters; seluruh nominal int rupiah. Widget bersama tidak diubah.
Verifikasi: angka master, checkout/pembayaran reaktif, ganti periode, navigasi, ekspor/retry,
loading/kosong/error, lebar 320 px dan teks 2x. Perangkat Android belum diuji;
belum diuji di iOS. Ekspor masih palsu pada kedua platform.
