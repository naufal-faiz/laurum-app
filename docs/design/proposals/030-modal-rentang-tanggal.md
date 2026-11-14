# 030 — Modal pilih rentang tanggal
Status: MENUNGGU PERSETUJUAN; branch ui/pelanggan, dasar533d772.
Acuan: LAURUM · Laporan · Pilih Tanggal4294968452, pilihan aktif pengguna14Nov2026.

## Komponen baru (aturan2/UI-13; persetujuan termasuk registry)
- Atom AppCalendarDay(day,selected,inRange,enabled,onPressed): sel tanggal dengan
  area sentuh minimum global, penanda awal/akhir/rentang dan tanggal disabled.
- Organism AppRangeCalendar(month,firstDate,lastDate,start,end,onDay,onMonth):
  bulan/tahun, panah, Sen–Min, grid kalender; Stateless, data/callback dari Sheet.
- Template ModalScaffold(title,subtitle,child,footer,onClose) dan show<T>:
  Dialog tengah berlatar redup, konten bisa digulir, footer tetap terlihat.
- AppCalendarStyles hanya memakai warna/radius/typography yang sudah ada;
  tanpa token angka/warna baru, dependensi, atau perubahan API komponen lama.

## Fitur/alur
- ReportRangeSheet melalui ModalScaffold.show di navigator utama; laporan tetap
  terlihat di belakang, navbar tertutup barrier modal, tidak menambah rute.
- Ringkasan Dari/Ke di atas kalender; tanggal memakai Formatters yang tersedia.
- Draft awal dari pilihan lama; state sementara Riverpod terpisah dari range laporan.
- Dua ketukan memilih awal/akhir, termasuk tanggal sama; tanggal akhir sebelum awal
  memulai pilihan awal baru, tidak membulatkan/memaksakan rentang diam-diam.
- Reset mengosongkan DRAFT saja; Terapkan disabled sampai dua tanggal valid dipilih.
- Tutup/X/back/luar modal atau Batal tidak mengubah periode/range/hasil laporan.
- Terapkan memakai selectedReportRange dan urutan update provider yang sama;
  minimum1Jan2026/maksimum businessClock, rentang inklusif UI/eksklusif domain tetap.

## Verifikasi
- Popup342×470 Figma adaptif: font minimum global, layar sempit/font besar dapat
  scroll kalender; header/Reset/Terapkan tetap terjangkau, tanpa input keyboard.
- Pertahankan assertion batas/locale/satu hari/range/batal/ekspor; tambah reset,
  lintas bulan/tahun,future disabled,font1–2× dan golden modal; check_all akhir.
