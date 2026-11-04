# STATE Laurum
Diperbarui: 2026-11-04 | Cabang dev2backend

## Posisi
BP0 SELESAI pada 8e51cda: UUID, local_settings, rentang dan 8 suite kontrak.
UI dummy prompt 100/R0-R10 selesai; bukti docs/progress/fase-ui.md.
B1a SELESAI: skema v1, database per akun, outbox, runner dan LocalSettings Drift.
check_all SEMUA HIJAU: 740 tes, kedua analyzer bersih, check_arch OK, REPO_MAP 769.
Bukti: %TEMP%/laurum-b1a-check.log; ringkasan docs/progress/b1a-drift-fondasi.md.
Baseline B1a 719 tes hijau; log %TEMP%/laurum-b1a-baseline.log.

## Selesai B1a
- Prompt B1a-drift-fondasi.md; rencana docs/plans/B1a-drift-fondasi.md.
- lib/core/persistence: AppDatabase schemaVersion 1, 16 tabel, factory per akun,
  runner/savepoint, OutboxWriter dan DriftLocalSettingsRepository. Belum wiring aplikasi.
- 20 tes fondasi hijau; snapshot + factory 4 tes hijau; snapshot dengan data lama
  juga lolos setelah helper dihasilkan dengan --data-classes --companions.
- Snapshot test/persistence/schema/drift_schema_v1.json dan helper generated dibekukan.
  Jangan mengubah v1 tanpa menaikkan versi/migrasi. Timestamp ISO-8601 menjaga subdetik.
- Temuan: PRD B 5 belum memuat order_events, tetapi domain/B1d memakainya; disediakan
  pada skema, dicatat di docs/progress/b1a-drift-fondasi.md, PRD tidak diubah.
- SDK Windows path berspasi gagal pada hook native. Sebelum SEMUA perintah Dart/Flutter
  pada setiap proses PowerShell baru: . ./tool/windows_native_sdk.ps1
  Helper memakai junction Flutter + salinan Dart di Temp (~588 MB), lingkungan per proses.
  Source SDK tetap E:/App Data/flutter/flutter. README memuat instruksi lengkap.
- Self-review: semua Dart baru non-generated <=100 baris; aplikasi/fixture/registry/tema
  dan lint tidak diubah. Helper snapshot dihasilkan dengan tipe generik lengkap.
- LANGKAH BERIKUTNYA: B1b-drift-pelanggan.md. Berhenti setelah commit B1a.

## Antrean
1. Prompt berikutnya: docs/prompts/B1b-drift-pelanggan.md; lanjut B1c-B1f, kemudian B0.
2. Aplikasi tetap in-memory sampai wiring B1f. Android/iOS untuk database belum diuji;
   pengujian SQLite tahap ini di Windows. Tidak ada perubahan layar/.pen/fixture.
3. B0 hanya Supabase lokal (Docker/CLI). B2/B3/B5-B8 MENUNGGU. Jangan push/merge.
4. Pengguna meminta kebutuhan Supabase cloud disampaikan pada akhir fase ketika perlu.
   B1a/B1b belum memerlukan cloud/key; agen tetap dilarang mengubah proyek cloud.

## Keputusan dan batas
- AGENTS 19-22: persistensi hanya data/core persistence/sync; tanpa shared_preferences.
  Preferensi perangkat local_settings, bisnis/struk tersinkron, sesi secure storage.
- UUID dan namespace retry tetap sesuai docs/progress/bp0-id.md (28 titik, 21 v4/7 v5).
  Fixture teks baru dipetakan saat seed B1f; nomor nota terpisah dari ID.
- Lintas repository wajib TransactionRunner; nanti transaksi SQLite + outbox. Error
  nested yang ditangkap tetap menggagalkan transaksi luar sesuai kontrak BP0.
- Payload outbox snake_case/ISO dipetakan repository B1b-e, bukan JSON default data-class.
- PayStatus turunan; COD bersisa tidak boleh selesai. Tabungan sebagian dengan bayar nol
  wajib COD; tagihan tertutup tabungan boleh disimpan. Kelebihan tunai bukan omzet.
- Catat bayar mode aktif melepas tahanan; Terima bayar di siap sekaligus selesai.
  Mode sederhana otomatis selesai saat COD lunas; non-COD lama belum lunas didukung.
- Semua data/account/sync aplikasi masih dummy; password bukan state UI/log/error.
  CSV BOM/titik koma; Ingatkan piutang tersembunyi; omzet dari nota non-batal.
- Fixture 48 pelanggan/12 antrean, cust-010/A-0137, AI 142/8/3 agregat tetap.
- Registry 60/60, Section debt 14 tetap. Utang runtime 101-110/tool lama: fase-ui/bp0-id.
- Slot lintas fitur OrderEditBodySection tetap izin R0; statusLabel R4. iOS belum diuji.
- Graph E-Latihan-Pemrograman-laurum-projects-laurum auto-index checkout E: aktif.
