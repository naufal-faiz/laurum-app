# 18 - Laporan - Ringkasan
## Modal rentang tanggal030 — persiapan14Nov2026
Frame aktif pilihan pengguna `LAURUM · Laporan · Pilih Tanggal`4294968452 dibaca sekali.
Proposal030 menunggu persetujuan karena kalender/template modal belum ada di registry.

### Snapshot modal
- Latar redup menutupi laporan; popup tengah x24/y190,342×470 pada kanvas390×844.
- Judul Pilih tanggal, subjudul Rentang laporan kustom, tombol X kanan atas.
- Kotak Dari dan Ke di atas kalender; nilai contoh November2026 bukan fixture/data baru.
- Navigasi bulan dengan panah; header Sen–Min; grid6baris dan rentang terpilih.
- Reset kiri dan Terapkan berikon kanan; ukuran teks/target mengikuti token global.

### Paritas modal030
| Butir | Sumber/perilaku yang dipertahankan | Verifikasi |
|---|---|---|
| Sumber waktu | businessClockProvider; tanggal lokal tanpa konversi UTC | [ ] |
| Batas | firstDate1Jan2026; lastDate/currentDate=today dari businessClock | [ ] |
| Draft awal | custom lama atau reportPeriodRange; start/end dibatasi kalender seperti flow lama | [ ] |
| Satu hari/rentang | start=end valid; selectedReportRange akhir eksklusif, UI inklusif | [ ] |
| Terapkan | customRange.select → period.select(3) → export.reset, argumen sama | [ ] |
| Batal | hasil null/Tutup/back/barrier tidak mengubah data atau periode lama | [ ] |
| Locale/input | bahasa Indonesia; bulan/tanggal lewat Formatters; kalender tanpa TextField | [ ] |
| Reaktivitas | laporan/ringkasan/CSV mengikuti rentang terpilih melalui sumber yang sama | [ ] |
| Reset baru | perlu persetujuan030: kosongkan draft, bukan range laporan aktif | [ ] |
| Font/akses | viewport280–600,font1–2×; konten scroll, aksi terjangkau | [ ] |

### Selisih dan batas030
- Popup kalender rentang baru diperlukan agar bentuk mengikuti FigCraft, bukan
  halaman kalender Material yang sekarang dibuka showDateRangePicker.
- Tanggal contoh Figma tidak disalin; kalender tetap memakai waktu bisnis/range aktif.
- Grid/font dan tinggi popup tidak dipaksa470px; font besar/layar kecil boleh scroll.
- Registry hanya ditambah setelah persetujuan; state draft baru hanya UI dan tidak
  menyentuh repository/skema/perhitungan uang. Pembatalan tetap lewat X/back/barrier.
- Perubahan lokal report_header_section/app_badge/report_summary saat mulai tugas
  dipertahankan dan tidak termasuk perubahan agen pada tahap persiapan030.

## Revisi chart14Nov2026 — arahan pengguna
- Revisi warna terbaru: primaryTint di atas ke primary di bawah, agar lebih cerah.
  AppChartStyles memakai warna/radius yang ada; tanpa token warna baru.
- Pengguna memilih bulanan satu batang per hari dengan geser horizontal.
- Bulanan mengambil dailyRevenue repository yang sama, satu label tanggal per hari;
  tanggal mendatang tetap null/penanda putus-putus, bukan omzet0 yang dibuat-buat.
- Chart panjang memakai lebar minimum batang yang mengikuti skala teks; hari ini dan
  minggu ini memakai lebar konten seperti sebelumnya. Semua berbagi WeeklyBarChart.
- Ekspor/periode/total/filter/notifikasi repository tetap; custom>7hari tetap memakai
  pesan batas lama. Perubahan perilaku hanya mengaktifkan tampilan harian bulanan.
- Tes report_page_test memperbarui satu assertion bulan: dari tanpa chart menjadi
  chart31tanggal. Semua assertion uang, ekspor, navigasi dan keyboard lama tetap.

### Paritas revisi chart
| Butir | Sumber/perilaku | Verifikasi terarah |
|---|---|---|
| Total omzet | ReportRepository.getReport; tidak mengubah ledger/perhitungan uang | [x] |
| Data batang | getDailyRevenue; jumlah nilai bulan sama dengan totals.revenue | [x] |
| Masa depan | null tetap penanda putus-putus; hari lampau tanpa data tetap0 | [x] |
| Periode | Hari ini1, Minggu ini7, Bulan ini28–31; provider/range lama | [x] |
| Label | Tanggal bulanan melalui Formatters; hari/minggu tetap | [x] |
| Font/scroll | Widget langsung320px/font1–2×,31batang bisa digeser sampai akhir | [x] |
| Aksi lama | ekspor, ubah periode, buka piutang, daftar/filter/keyboard tidak diubah | [x] |
- Tes terarah12lulus; analyzer berkas berubah bersih. check_all sebelumnya dihentikan
  saat pengguna mengganti warna; hasil penuh laporan belum dinyatakan hijau.

## Persiapan irisan laporan029
Frame aktif pilihan pengguna `LAURUM · Laporan`4294968337 (390×844) dibaca sekali.
Proposal029 disetujui melalui arahan pengguna untuk redesign seluruh halaman.

### Implementasi029 (WIP, verifikasi akhir tertahan UI-36)
- Header laporan tunggal memakai AppBarSub detail dan ekspor berikon; saat sempit
  atau font>1,2×, ekspor turun ke baris berikutnya. Semua4periode dan pesan ekspor tetap.
- Appbar usaha RootShell disembunyikan khusus /laporan; SafeArea diaktifkan untuk
  laporan termasuk banner offline/error. Provider, rute dan navbar tetap.
- Laba memakai AppCard primary+bubble, badge transaksi/pendapatan/pengeluaran;
  angka laba memakai FittedBox scaleDown agar nilai utuh tidak pecah antarbaris.
- Kas/piutang memakai StatTile compact, tinggi intrinsik sejajar pada layar lebar,
  bertumpuk pada layar sempit/font besar. Rincian kas/setoran/tabungan titipan tetap.
- StatTile.onTap diteruskan ke AppCard; warna label primaryInk lokal dipertahankan.
- TopServices lebih rapat, badge peringkat, IconTile layanan, nilai/persen/kuantitas
  dan progress tetap; kolom fleksibel membungkus, tanpa tinggi konten tetap.
- Margin horizontal24/gap14, daftar nota penuh, pencarian/filter/range/ekspor tetap.
- Test report_page_test memisahkan finder label dan nilai piutang; assertion Rp400.500
  dan callback buka piutang tetap. Tidak menghapus/melemahkan tes perilaku lama.
- Terakhir45tes UI/alur lulus, termasuk16kombinasi lebar280/320/390/600 × font0,85/1/1,3/2.
- Setelah tambahan pengecekan angka laba satu baris, dua proses tes gagal kompilasi
  akibat RenderParagraph.getLineBoundary yang tidak tersedia. Sumber tes sudah diganti
  ke getBoxesForSelection yang diverifikasi pada SDK, tetapi belum dijalankan ulang.
- UI-36: berhenti sebelum percobaan ketiga. check_all akhir belum dijalankan.
- Golden laporan normal/font2× dan report_summary/top_services diperbarui; golden
  radius dari batch7580497 dan warna StatTile pada layar lain belum diverifikasi penuh.
- Visual belum diverifikasi manual pada HP; screenshot emulator tidak diambil.

### Snapshot pemetaan desain
- Header kembali/judul/subjudul periode/ekspor berikon → ReportHeaderSection,
  AppBarSub/SectionHeader/AppButton yang terdaftar; periode tetap PeriodTabs.
- Laba biru+bubble → AppCard primary dengan teks nilai dan rincian ledger.
- Kas/piutang2kolom → StatTile compact responsif; aksi piutang tetap callback lama.
- Chart → WeeklyBarChart dengan revisi warna cerah dan bulanan yang sudah disetujui.
- Peringkat layanan → TopServices, komposisi registry untuk peringkat/ikon/progress.
- Nota terbaru Figma → daftar nota lengkap aplikasi tetap dipertahankan.

### Paritas redesign029
| Butir | Data/aksi/keadaan yang dipertahankan | Verifikasi |
|---|---|---|
| Sumber | reportViewProvider/reportOrdersProvider/export/customRange/businessProfile.useOrderStatus | [ ] |
| Ringkasan | revenue/expenses/profit/transactionCount/cashIn/savingsBalance/activeOutstanding/unpaidCount | [ ] |
| Chart | daily/dayLabels/dailyAverage/peakDayName; aturan null/zero dan bulan harian tetap | [ ] |
| Layanan | nama/unit/qtyMilli/revenue/persentase; urutan/data lama | [ ] |
| Periode | reportPeriodProvider; selectReportPeriod; custom range/batal/label tanggal | [ ] |
| Ekspor | reportExportProvider.notifier.export(data,orders:orders); loading/kosong/busy disabled | [ ] |
| Kembali/piutang | canPop?pop:go('/lainnya'); push('/laporan/piutang') | [ ] |
| Nota | search/filter/notifikasi/range/group tanggal/push('/order/:id'); useOrderStatus tetap | [ ] |
| Keadaan | loading4skeleton, gagal/retry, kosong, posisi saldo/piutang, export success/error | [ ] |
| Key/fokus | ValueKey((data.period,data.range)); antrean-golden; fokus field pencarian tetap | [ ] |
| Aksesibilitas | lebar280–600/font0,85–2× dan keyboard300dp; navbar tetap terjangkau | [ ] |

### Selisih desain029
- Font7–10px dan area sentuh30/34px Figma mengikuti minimum global aplikasi.
- Teks "dihitung dari nota lunas" tidak cocok semantik omzet ledger; tidak disalin.
- Tidak menyalin angka contoh atau klaim Semua nota lunas bila data tidak mendukung.
- Semua nota/pencarian/filter tetap, bukan satu contoh dengan aksi Lihat semua baru.
- Navbar aplikasi tetap meskipun tidak tampak pada frame; rute/struktur navigasi tetap.
- Pendapatan/pengeluaran negatif dan saldo titipan tidak disamarkan oleh kartu biru.

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
- Hari ini memakai satu batang; minggu tujuh batang; bulan satu batang per hari
  dengan geser horizontal sesuai keputusan pengguna14Nov2026.
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
