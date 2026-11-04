# B1e - Drift: pengeluaran dan Laporan dari ledger
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: B1d SELESAI. Baca: AGENTS 19-22, expense_repository.dart, report_repository.dart, features/reports/data/{report_fixtures,report_snapshot,report_adjustments,in_memory_report_repository}.dart, core/domain/{report,report_totals,revenue_allocation}.dart, docs/design/data_master.md bagian laporan, spec 18.

Masalah yang diselesaikan: laporan masih memakai baseline/snapshot/penyesuaian fixture, tidak punya padanan di database.

## IZIN TERTULIS (4 Nov 2026)
- Menghapus getBaseline, ReportBaseline, report_fixtures/snapshot/adjustments dan kode yang bergantung padanya; mengubah antarmuka ReportRepository sesuai.
- Mengubah ANGKA di docs/design/data_master.md bagian laporan HANYA bila rekonsiliasi (langkah 3) terbukti mustahil dan setelah melapor kepada pengguna; selain itu, fixture tidak diubah.

## Isi
1. DriftExpenseRepository (+ kategori, foto: path lokal di folder aplikasi, antrean unggah menyusul di B2), outbox, kontrak lolos.
2. Laporan murni ledger: omzet, uang masuk, pengeluaran, piutang, tabungan, layanan terlaris, grafik harian dihitung dari order/pembayaran/pengeluaran lewat query SQL per rentang dan fungsi domain yang sama dengan sekarang (report_totals); Hari ini, Minggu ini, Bulan ini, dan rentang kustom memakai SATU jalur hitung. InMemory mengikuti jalur yang sama sehingga kontrak laporan identik.
3. Rekonsiliasi: dengan data seed DATA MASTER (order pengisi + pembayaran + pengeluaran) angka Laporan Minggu ini harus sama dengan DATA MASTER. Jika tidak bisa direkonsiliasi, JANGAN membuat baseline atau data fiktif: hentikan, laporkan selisih, minta keputusan pengguna.
4. Ekspor CSV memakai hasil yang sama; tes golden Laporan diperbarui hanya bila angka berubah sah.
5. Tes kontrak laporan lolos di InMemory dan Drift; benchmark rentang bulan di 5.000 order.

Prompt berikutnya: B1f-drift-penyambungan.md.
