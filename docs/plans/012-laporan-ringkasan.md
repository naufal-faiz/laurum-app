# Laporan Ringkasan (prompt 60, bagian pertama)
1. Verifikasi prompt 51 lewat Git dan check_all.
2. Tes periode/angka DATA MASTER, perubahan checkout/pembayaran, dan ekspor.
3. Provider laporan memakai repository reaktif; grafik minggu memakai baseline harian
   DATA MASTER + perubahan order, tanpa menghitung fixture awal dua kali.
4. Susun tab dengan PeriodTabs, ReportSummary, WeeklyBarChart, TopServices, dan footer.
5. Uji loading/error/kosong dan navigasi; check_all; spec/STATE/INDEX; commit.

Satu layar per sesi. Daftar Piutang tetap placeholder untuk bagian kedua prompt 60.
Top services Hari/Bulan dan grafik Bulan tidak punya baseline; tampilkan keterangan,
bukan angka minggu. Ekspor CSV untuk Excel melalui FakeExportService (tidak membuat file nyata).
