# STATE Laurum
Diperbarui: 2026-11-04 | Cabang dev2backend

## Posisi
UI 100/R0-R10 selesai. BP0 8e51cda, B1a c22ec5b, B1b 8821b17, B1c f9bd41c,
B1d 70041af selesai; audit B1e 2fb58eb. B1e SELESAI: pengeluaran dan laporan ledger.
check_all 869 tes, dua analyzer tanpa isu, check_arch OK, REPO_MAP860, exit0; log Temp/laurum-b1e-check.log.
Baseline sesudah persetujuan 848 tes hijau, exit 0; laurum-b1e-approved-baseline.log di Temp.
Rencana docs/plans/B1e-pengeluaran-laporan.md; laporan docs/progress/b1e.md.

## Pekerjaan B1e
- Pengguna menyetujui seluruh angka mengikuti ledger aktual pada 4 Nov 2026.
  Audit awal docs/progress/b1e-reconciliation.md/.json adalah bukti historis, bukan target aktif.
- DATA MASTER/spec 18 diperbarui: hari 177.000/6, minggu 589.000/14, bulan 864.000/16;
  pengeluaran 145.000/850.000/1.850.000, laba 32.000/-261.000/-986.000.
  Kas 130.500/500.000/868.500; posisi piutang 400.500 dan tabungan 430.000 tetap.
- ReportBaseline/getBaseline dan penyesuaian fixture dihapus. Satu jalur ReportRepository
  untuk preset/kustom/CSV/grafik/layanan. buildReport/domain dipakai InMemory dan Drift;
  ReportPositions adalah posisi global aktual, bukan baseline pendapatan.
- Query SQL membatasi cohort/flow/biaya/setoran ke range, saldo/utang memakai agregat akun.
  Harian/layanan dihitung dari snapshot; grafik UI tetap max7hari, masa depan null.
- DriftExpenseRepository + kategori, owner/parent, metadata, outbox/soft delete atomik.
  Foto disalin ke app-support/expense_photos/<owner>/UUID, sumber tidak diubah;
  callback rollback runner membuang salinan baru termasuk bila outer transaction gagal.
- Skema v4/16 tabel: expense spent_at canonical + owner index; savings created_key
  terindeks sebagai turunan created_at (created_at asli/identitas UTC tetap).
  Snapshot v1/v2/v3 utuh; v4 dihasilkan dengan --data-classes --companions.
- SQL/sync berikutnya wajib created_key=sqlTimestamp(created_at); entered_at/paid_at/
  spent_at juga sqlTimestamp UTC enam digit. Migrasi v1-v3->v4 diuji.
- 159 tes terarah hijau; mutasi laporan/kategori/query plan juga lolos check_all akhir.
  Tiga golden angka baru ditinjau dan diperbarui; 7 tes UI/view/CSV/body lolos.
- Benchmark bulan 5.000 order/8.000 bayar: p95 totals183,348ms, harian67,782ms,
  layanan119,201ms (Windows memory; non-gating; rincian laporan).
- LANGKAH BERIKUTNYA: docs/prompts/B1f-drift-penyambungan.md.
  Berhenti setelah commit B1e; .pen masih angka lama, spec18/DATA MASTER ledger menang.

## Lingkungan dan batas
- Aplikasi tetap InMemory sampai B1f, sesudahnya B0 lokal. Android/iOS database/foto
  belum diuji. B1f lifecycle harus membersihkan foto/folder akun sesudah commit;
  file lama jangan dihapus saat masih diperlukan outbox. Upload foto baru B2.
- Sebelum SEMUA Dart/Flutter pada proses PowerShell baru: . ./tool/windows_native_sdk.ps1
  SDK asli E:/App Data/flutter/flutter berspasi; junction Flutter+salinan Dart di Temp
  (~588MB), lingkungan hanya per proses. Cloud/key belum dibutuhkan; beri tahu saat perlu.
- Jangan push/merge atau mengubah proyek cloud. B2/B3/B5-B8 MENUNGGU.
- AI settings/usulan, auth/sync tetap dummy/memory sampai B7/B3/B2; printer/picker native
  belum disambung. Preferensi perangkat local_settings; bisnis/struk sinkron; tanpa shared_preferences.
- DriftTransactionRunner checkpoint memory sementara; nested gagal menggagalkan outer.
  Cleanup FK/outbox/settings atomik, tutup/hapus file DB setelah commit.
- Namespace retry BP0 tetap; seed UUID pada B1f. Payload snake_case/UTC ISO tanpa
  sync_state/pay_status/key pencarian lokal. B1b pencarian prefiks belum wiring UI.
- B1c profil/struk satu baris per owner dijaga repository, belum UNIQUE(owner_id) SQL.
- PRD B5 belum memuat order_events; tabel tersedia sesuai domain/B1d (laporan B1a).
- PayStatus turunan; COD bersisa ditahan; tabungan sebagian+bayar nol wajib COD.
  Kelebihan tunai bukan omzet; mode sederhana selesai saat COD lunas; non-COD lama didukung.
- Fixture transaksi tetap 48 pelanggan/12 antrean; cust-010/A-0137 dan AI 142/8/3 tetap.
- Registry60/60, Section debt14; utang runtime101-110/tool: fase-ui/bp0-id.
- Slot OrderEditBodySection izin R0, statusLabel R4. check_all bisa hijau dengan info
  Riverpod: baca log dan bersihkan info baru. Tidak ada ignore lint manual/dependensi baru.
