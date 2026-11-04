# STATE Laurum
Diperbarui: 2026-11-04 | Cabang dev2backend

## Posisi
UI dummy 100/R0-R10 selesai; docs/progress/fase-ui.md.
BP0 8e51cda, B1a c22ec5b, B1b 8821b17, B1c f9bd41c, B1d 70041af SELESAI.
B1e SEDANG, MENUNGGU KEPUTUSAN WAJIB pada langkah rekonsiliasi (prompt langkah 3).
Audit: docs/progress/b1e-reconciliation.md + .json; rencana B1e-pengeluaran-laporan.md.
Baseline kode 70041af: check_all 848 tes, dua analyzer tanpa isu, check_arch OK,
REPO_MAP 840, exit 0; %TEMP%/laurum-b1e-baseline.log. Kode aplikasi tidak diubah.

## Audit B1e dan langkah berikutnya
- Seed lengkap: 16 order, 16 item, 14 pembayaran, 18 pengeluaran, 7 mutasi tabungan.
- Minggu: ledger Rp589.000/14 nota vs target Rp1.800.000/58; selisih Rp1.211.000/44 nota.
  Kas Rp500.000 vs Rp1.699.500; pengeluaran Rp850.000 cocok, laba ledger -Rp261.000.
- Hari: ledger Rp177.000/6 vs Rp375.000/12; bulan Rp864.000/16 vs Rp4.250.000/135.
  Piutang Rp400.500 dan saldo tabungan Rp430.000 cocok. Grafik/top services juga berbeda.
- Menghitung reportSnapshot dengan baseline nol, topServices dari snapshot, memeriksa
  identitas kas cohort + tabungan dipakai + piutang baru = omzet. Output audit exit 0.
- Belum ada detail 44 nota tambahan untuk target minggu. Prompt B1e melarang membuat
  baseline/data fiktif dan MEWAJIBKAN berhenti serta meminta keputusan pengguna.
- LANGKAH BERIKUTNYA: minta keputusan apakah angka/penjelasan laporan DATA MASTER,
  grafik/top services dan golden terkait mengikuti ledger aktual (usulan), atau
  pengguna melengkapi ledger historis di DATA MASTER dahulu. Tunggu jawabannya.
- DATA MASTER, fixture, golden dan kode BELUM diubah. DriftExpenseRepository,
  penghapusan baseline, kontrak laporan dan benchmark B1e belum dimulai.
- Setelah keputusan lanjutkan docs/prompts/B1e-drift-pengeluaran-laporan.md dan rencana;
  B1f HANYA sesudah B1e selesai. Jangan melompati keputusan rekonsiliasi.

## Fondasi B1d yang dipertahankan
- DriftOrderRepository dan writeOrderStore bersama: COD/status final/nominal/ledger
  retry; data+outbox+counter atomik. Report B1d di docs/progress/b1d.md.
- Skema v3/16 tabel; snapshot v1/v2/v3 dibekukan. entered_at/paid_at wajib
  sqlTimestamp UTC ISO enam digit pecahan, termasuk penulis SQL/sync berikutnya.
- DriftTransactionRunner mendukung checkpoint memory sementara AI/auth/sync;
  nested gagal menggagalkan transaksi luar. Cleanup FK/outbox/settings atomik;
  tutup/hapus berkas setelah commit pada wiring/lifecycle B1f.
- Benchmark B1d Windows memory: 5.000 order/8.000 bayar, p95 15,018 ms (non-gating).

## Lingkungan dan batas
- Aplikasi tetap InMemory sampai B1f, lalu B0 Supabase lokal. Database Android/iOS
  belum diuji; SQLite native Windows diuji. Jangan push/merge atau mengubah cloud.
- Sebelum SEMUA perintah Dart/Flutter di setiap proses PowerShell baru:
  . ./tool/windows_native_sdk.ps1. SDK asli E:/App Data/flutter/flutter berspasi;
  junction Flutter + salinan Dart (~588 MB) di Temp, lingkungan hanya per proses.
- Cloud/key belum dibutuhkan. Pengguna meminta pemberitahuan akhir fase ketika perlu.
- AI settings/usulan, auth dan sync tetap dummy/memory sampai B7/B3/B2; printer nyata
  ditunda. Preferensi printer local_settings; bisnis/struk sinkron, tanpa shared_preferences.
- B1c profil/struk satu baris per owner dijaga repository; belum UNIQUE(owner_id) SQL.
- Namespace retry BP0 tetap; seed UUID pada B1f. Payload snake_case/UTC ISO tanpa
  sync_state/pay_status/key pencarian lokal. B1b pencarian prefiks belum wiring UI.
- PRD B 5 belum memuat order_events; tersedia sesuai domain/B1d (laporan B1a).
- PayStatus turunan; COD bersisa ditahan; tabungan sebagian dengan bayar nol wajib COD.
  Kelebihan tunai bukan omzet. Mode sederhana selesai saat COD lunas; non-COD lama didukung.
- Fixture 48 pelanggan/12 antrean, cust-010/A-0137, AI 142/8/3 tetap.
- Registry 60/60, Section debt 14. Utang runtime 101-110/tool: fase-ui/bp0-id.
- Slot OrderEditBodySection izin R0; statusLabel R4. iOS belum diuji.
- check_all dapat hijau dengan info Riverpod: baca log dan hilangkan info lint baru.
