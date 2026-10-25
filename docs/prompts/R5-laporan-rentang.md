# R5 - Laporan: rentang tanggal dan Ekspor di atas (revisi 8 bagian ringkasan, 13, 14)
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: R4 SELESAI. Baca: docs/revisi/REVISI-01.md (item 8, 13, 14), spec 18-laporan-ringkasan, DATA MASTER bagian laporan dan baseline; core/domain/report_range.dart, report_totals.dart, revenue_allocation.dart; report_repository.dart.

## Perilaku
- PeriodTabs: Hari ini | Minggu ini | Bulan ini | Pilih tanggal. Ketuk "Pilih tanggal" membuka pemilih rentang (satu hari boleh: mulai = akhir). Batas pilih: 1 Jan 2026 sampai hari ini (businessClockProvider). Setelah dipilih, label tab keempat menjadi rentang ("12-18 Okt") dan tab itu aktif; ketuk lagi untuk mengganti. Batal memilih = tetap di periode sebelumnya.
- Ringkasan (ReportSummary) untuk rentang kustom dihitung dari nota, pembayaran, dan pengeluaran yang ada di rentang itu (ReportRange tanggal akhir eksklusif di domain, label inklusif di layar). Angka harus bisa direkonsiliasi dengan daftar nota di R6. Bila rentang di luar data yang ada: EmptyState "Belum ada data periode ini". Jangan meminjam angka Minggu ini; jangan menciptakan data. Grafik dan Layanan terlaris untuk rentang kustom: tampilkan bila organism mendukung jumlah hari yang dipilih, bila tidak sembunyikan dengan BannerMessage; catat sebagai temuan, jangan ubah organism.
- Ekspor Excel pindah ke atas: SectionHeader "Laporan" dengan aksi "Ekspor Excel" di kanan (nonaktif saat kosong/sedang ekspor). Hapus FooterBar ekspor di bawah. Pesan hasil ekspor tampil sebagai BannerMessage tepat di bawah header. Ekspor mengikuti periode/rentang aktif.

## IZIN TERTULIS (25 Okt 2026)
- pubspec: tambah flutter_localizations (SDK Flutter) dan atur locale id_ID serta localizationsDelegates di lib/app.dart agar pemilih tanggal berbahasa Indonesia. Tidak ada paket pihak ketiga.
- core/theme/app_theme.dart: tambah DatePickerThemeData memakai token yang ada (primary, surface, ink). Tanpa warna baru.
- ReportRepository: tambah method rentang bebas atau komposisi dari OrderRepository/ExpenseRepository di state/ (pilih yang paling sedikit mengubah kontrak; jelaskan di fase-8/9.md). Fixture DATA MASTER tidak berubah.
- Tombol ke-4 PeriodTabs cukup lewat label daftar; jangan ubah PeriodTabs.

## Langkah
1. Tes domain/state lebih dulu: hitungan rentang kustom (satu hari, dalam minggu fixture, di luar data), label rentang, batas tanggal.
2. reportCustomRangeProvider, reportPeriodProvider mendukung indeks 3, fungsi pemilih di pages/report_range_flow.dart (showDateRangePicker; fungsi biasa, bukan widget).
3. ReportPage: header dengan ekspor, PeriodTabs, ringkasan; pindahkan bagian tubuh ke Section di reports/widgets/ bila perlu (bukan akhiran Page).
4. ExportService: tambah bagian daftar nota (nomor, tanggal, pelanggan, total, status bayar) pada CSV rentang aktif bila datanya sudah tersedia dari R6; bila belum, catat sebagai tindak lanjut R6.
5. Tes layar: ganti periode, pilih rentang, ekspor di atas, keyboard tidak relevan. Perbarui spec 18-laporan-ringkasan.

Prompt berikutnya: R6-laporan-nota.md.
