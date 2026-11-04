# B1e - Pengeluaran dan laporan murni ledger (4 Nov 2026)

Status: SELESAI; check_all akhir hijau, exit 0, kedua analyzer tanpa isu.
Dasar: 2fb58eb. Pengguna menyetujui perbaikan semua selisih laporan setelah audit
docs/progress/b1e-reconciliation.md. Angka mengikuti ledger; tidak menambah transaksi.
Baseline sesudah persetujuan: 848 tes hijau, dua analyzer bersih, exit 0;
%TEMP%/laurum-b1e-approved-baseline.log.

## Hasil rekonsiliasi yang disetujui

| Periode | Pendapatan | Nota | Pengeluaran | Laba | Kas masuk |
| --- | ---: | ---: | ---: | ---: | ---: |
| Hari ini | 177.000 | 6 | 145.000 | 32.000 | 130.500 |
| Minggu ini | 589.000 | 14 | 850.000 | -261.000 | 500.000 |
| Bulan ini | 864.000 | 16 | 1.850.000 | -986.000 | 868.500 |

Posisi piutang 400.500/5 nota dan tabungan 430.000 tetap. Grafik minggu
0/0/248.000/164.000/177.000, lalu dua hari masa depan null; rerata 117.800, puncak Rabu.
Layanan minggu: Cuci setrika 301.500, Cuci kering lipat 108.000, Bed cover 100.000,
Cuci kiloan 59.500, Selimut tebal 20.000. Jumlah tepat 589.000, tanpa bucket fiktif.
DATA MASTER bagian laporan dan spec 18 diperbarui; fixture transaksi tetap persis.

## Perubahan

- ReportBaseline/getBaseline dan file report_fixtures/snapshot/adjustments/top_services/
  daily_fixtures lama dihapus. Tidak ada baseline atau delta fixture di jalur runtime.
- buildReport mengolah ledger; ReportPositions hanya posisi terkini yang dihitung
  dari data (SQL/domain), bukan tambahan pendapatan atau riwayat. Pengelompokan
  pembayaran/item berdasarkan owner+order menghindari pemindaian silang berulang.
- InMemory dan Drift menjalankan kontrak yang sama. Drift membaca cohort/arus kas/
  pengeluaran/setoran lewat SQL rentang; posisi utang dan tabungan lewat agregat SQL.
  Pembayaran cohort di luar tanggal laporan tetap diperhitungkan untuk rekonsiliasi,
  pembayaran nota lama di dalam periode hanya mengubah kas dan posisi utang.
- Hari/Minggu/Bulan/kustom memakai satu ReportRepository pada ReportView; CSV memakai
  view yang sama. Daily/top services tersedia untuk semua rentang. Widget grafik
  tetap dibatasi tujuh hari dan memakai pesan batas yang benar untuk bulan.
- Sampel Widgetbook/test diturunkan dari ledger DATA MASTER, bukan ditambah ke laporan.
- DriftExpenseRepository/reader: kategori, soft delete, owner/parent, metadata lokal,
  data+outbox atomik. Kategori terhapus disembunyikan oleh dua backend.
- ExpensePhotoStore menyalin foto terpilih ke app-support/expense_photos/<owner>/UUID.
  File asal tetap. Path milik aplikasi dipakai ulang ketika edit. Callback rollback
  DriftTransactionRunner membuang salinan baru bila outbox/outer transaction gagal.
  Penghapusan foto lama dan folder akun sesudah commit perlu disambung pada lifecycle
  B1f/B2; jangan menghapus file yang masih diperlukan outbox sebelum commit.

## Skema v4

- Tetap 16 tabel. expenses.spent_at menjadi UTC ISO enam digit pecahan; indeks
  expenses_owner_spent(owner_id,spent_at).
- savings_entries.created_key adalah key waktu lokal-turunan berformat sqlTimestamp,
  dengan indeks savings_owner_created(owner_id,created_key). created_at asli tetap
  dipertahankan (identitas UTC/lokal), dan key tidak dikirim pada payload outbox.
- Migrasi v1/v2 melewati migrasi B1b/B1d, v3 langsung ke v4, semuanya atomik.
  Snapshot v1/v2/v3 tidak berubah; v4 dibekukan. Helper --data-classes --companions.
- Penulis SQL/sync berikutnya wajib mengisi created_key dari created_at; spent_at,
  entered_at dan paid_at harus memakai sqlTimestamp agar batas mikrodetik tepat.

## Verifikasi dan visual

- Tes merah sebelum perbaikan: implementasi lama mengembalikan 1.800.000 saat ledger
  mengharuskan 589.000. Domain dan integrasi mengikuti angka ledger setelah perbaikan.
- 159 tes terarah hijau sebelum tambahan kasus mutasi laporan/kategori dan query plan.
  Kontrak mencakup empat periode, kas cohort vs arus kas, batas mikrodetik/UTC,
  posisi akun global, edit/hapus pengeluaran, pembatalan dan alokasi layanan.
- Injeksi gagal outbox mengembalikan kategori/pengeluaran/tombstone. Foto baru juga
  hilang setelah kegagalan outer transaction; sumber terpilih tetap ada.
- Tiga golden ditinjau PNG lalu diperbarui sesuai persetujuan: report_summary,
  top_services dan weekly_bar_chart. Tidak ada overflow pada ketiganya. Tujuh tes
  interaksi/view/export/body laporan lolos termasuk 320px/teks 2x.
- Tidak ada widget/layar baru. ReportBodySection tetap menerima data/callback dan
  perhitungan label dipindah ke ReportView agar file <=100 baris. Registry/tema/lint,
  dependensi dan fixture selain sampel laporan tidak diubah. Tanpa ignore lint manual.
- check_all akhir: 869 tes lolos, flutter analyze dan dart analyze tanpa isu,
  check_arch OK, REPO_MAP 860 berkas, exit 0; %TEMP%/laurum-b1e-check.log.

```text
No issues found!
check_arch: OK
06:51 +869: All tests passed!
REPO_MAP diperbarui: 860 berkas
check_all: SEMUA HIJAU
```

- Self-review: seluruh Dart non-generated baru/tersentuh <=100 baris (maksimal 99),
  git diff --check bersih; snapshot v1-v3 dan fixture transaksi tidak berubah.
- Acuan .pen masih menampilkan 1.800.000/58 nota, laba 950.000 dan grafik/layanan lama.
  Perbedaan angka ini disengaja sesuai persetujuan rekonsiliasi; spec 18/DATA MASTER
  ledger menang atas .pen. Teks frame Laporan dan daftar State telah dibaca lewat pen_frame.

## Benchmark non-gating

tool/benchmark_reports.dart + report_benchmark_seed.dart: Windows, SQLite memory,
5.000 order + 5.000 item, 8.000 pembayaran, 100 pengeluaran, 20 mutasi tabungan.
Range Oktober mengembalikan 2.490 transaksi/Rp2.490.000; 5 warmup + 30 sampel.

| API | Median ms | p95 ms |
| --- | ---: | ---: |
| Ringkasan | 162,412 | 183,348 |
| Harian | 58,821 | 67,782 |
| Layanan | 97,623 | 119,201 |

Mencakup baca+mapping+perhitungan, tidak mencakup seed/outbox/file I/O/perangkat.
Tidak ada ambang gating B1e; ini berbeda dari benchmark query tujuh hari B1d.
Bukti %TEMP%/laurum-b1e-benchmark.log.

Aplikasi tetap InMemory sampai B1f. Database/foto native Android dan iOS belum diuji;
unggah foto/sinkron baru B2, pemilih foto native belum disambung. Cloud/key belum perlu.
Prompt berikutnya: B1f-drift-penyambungan.md.
