# STATE Laurum
Diperbarui: 2026-11-04 | Cabang dev2backend

## Posisi
BP0 SELESAI pada 8e51cda: UUID, local_settings, rentang dan 8 suite kontrak.
UI dummy prompt 100/R0-R10 selesai; bukti docs/progress/fase-ui.md.
B1a SELESAI pada c22ec5b: database per akun, outbox, runner dan LocalSettings Drift.
B1b SELESAI: repository pelanggan/tabungan Drift dan migrasi skema v1->v2.
check_all SEMUA HIJAU (exit 0): 759 tes, kedua analyzer bersih, check_arch OK,
REPO_MAP 787. Bukti %TEMP%/laurum-b1b-check.log; ringkasan docs/progress/b1b.md.
Baseline B1b 740 tes hijau; log %TEMP%/laurum-b1b-baseline.log.

## Selesai B1b
- Prompt B1b-drift-pelanggan.md; rencana docs/plans/B1b-pelanggan-tabungan.md.
- DriftCustomerRepository/DriftSavingsRepository: owner scope, soft delete, ledger
  append-only, SQL SUM saldo, outbox + data atomik dan updatedAt lokal/pending.
- Skema v2 tetap 16 tabel: name_key/phone_key lokal, indeks unik nomor aktif,
  indeks prefiks nama/nomor dan owner/updated_at. Nomor asli tetap dipertahankan.
- Pencarian API prefiks (LIKE + UNION), alias 0/62/+62/8 sama; UI belum disambung.
- Kontrak InMemory/Drift memeriksa semua field bisnis; updatedAt/syncState diuji
  terpisah karena metadata penyimpanan. Retry ledger mengabaikan metadata itu saja.
- 55 tes terarah hijau: kontrak, SQL plan, rollback trigger, owner/parent, metadata,
  migrasi data lama dan collision alias (migrasi batal atomik, tanpa merge/hapus).
- Snapshot v1 tidak diubah; v2 dibekukan. Perubahan skema berikut wajib migrasi/tes.
  Helper snapshot dihasilkan dengan --data-classes --companions.
- Self-review: Dart baru non-generated <=100 baris; fixture/registry/tema/lint tetap.
- SDK Windows path berspasi gagal hook native. Sebelum SEMUA perintah Dart/Flutter
  pada setiap proses PowerShell baru: . ./tool/windows_native_sdk.ps1
  Helper memakai junction Flutter + salinan Dart di Temp (~588 MB), hanya per proses.
  Source SDK tetap E:/App Data/flutter/flutter. Instruksi lengkap di README.
- LANGKAH BERIKUTNYA: B1c-drift-usaha-layanan.md. Berhenti setelah commit B1b.

## Antrean
1. Prompt berikutnya: docs/prompts/B1c-drift-usaha-layanan.md; lanjut B1d-B1f, lalu B0.
2. Aplikasi tetap in-memory sampai wiring B1f. Database Android/iOS belum diuji;
   pengujian SQLite tahap ini di Windows. Tidak ada perubahan layar/.pen/fixture.
3. B0 hanya Supabase lokal (Docker/CLI). B2/B3/B5-B8 MENUNGGU. Jangan push/merge.
4. Pengguna meminta kebutuhan Supabase cloud disampaikan pada akhir fase ketika perlu.
   B1b belum memerlukan cloud/key; agen tetap dilarang mengubah proyek cloud.

## Keputusan dan batas
- AGENTS 19-22: persistensi hanya data/core persistence/sync; tanpa shared_preferences.
  Preferensi perangkat local_settings, bisnis/struk tersinkron, sesi secure storage.
- UUID dan namespace retry sesuai docs/progress/bp0-id.md (28 titik, 21 v4/7 v5).
  Fixture teks baru dipetakan saat seed B1f; nomor nota terpisah dari ID.
- Lintas repository wajib TransactionRunner; nested gagal menggagalkan transaksi luar.
- Payload outbox snake_case/UTC ISO tanpa sync_state atau key pencarian lokal.
- PRD B 5 belum memuat order_events; tabel tersedia sesuai domain/B1d (laporan B1a).
- PayStatus turunan; COD bersisa tidak boleh selesai. Tabungan sebagian dengan bayar nol
  wajib COD; tagihan tertutup tabungan boleh disimpan. Kelebihan tunai bukan omzet.
- Catat bayar mode aktif melepas tahanan; Terima bayar di siap sekaligus selesai.
  Mode sederhana otomatis selesai saat COD lunas; non-COD lama belum lunas didukung.
- Semua data/account/sync aplikasi masih dummy; password bukan state UI/log/error.
  CSV BOM/titik koma; Ingatkan piutang tersembunyi; omzet dari nota non-batal.
- Fixture 48 pelanggan/12 antrean, cust-010/A-0137, AI 142/8/3 agregat tetap.
- Registry 60/60, Section debt 14 tetap. Utang runtime 101-110/tool lama: fase-ui/bp0-id.
- Slot lintas fitur OrderEditBodySection izin R0; statusLabel R4. iOS belum diuji.
- Graph E-Latihan-Pemrograman-laurum-projects-laurum auto-index checkout E: aktif.
