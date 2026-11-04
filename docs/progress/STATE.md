# STATE Laurum
Diperbarui: 2026-11-04 | Cabang dev2backend

## Posisi
UI dummy prompt 100/R0-R10 selesai; docs/progress/fase-ui.md.
BP0 selesai 8e51cda; B1a selesai c22ec5b; B1b selesai 8821b17.
B1c SELESAI: usaha/layanan/struk Drift dan integrasi repository pengaturan printer.
check_all akhir: 781 tes lolos, kedua analyzer bersih, check_arch OK, exit 0;
REPO_MAP 804 berkas. Bukti %TEMP%/laurum-b1c-check.log.
Baseline bersih B1c: 759 tes, analyzer bersih, check_arch OK, exit 0.
Bukti %TEMP%/laurum-b1c-baseline-clean.log; tes terarah B1c 84 hijau.
Rencana docs/plans/B1c-usaha-layanan.md; laporan docs/progress/b1c.md.

## Selesai B1c
- DriftBusinessRepository/DriftServiceRepository/DriftReceiptSettingsRepository:
  owner scope, updatedAt lokal/pending, data dan outbox atomik; profil default status true.
- ReceiptSettingsRepository baru; adapter InMemory berbagi state bisnis lama untuk
  notifikasi/rollback/cleanup. BusinessRepository tetap menyediakan jembatan API struk.
- PrinterSettings dan receiptView memakai antarmuka struk. Simpan profil+struk lewat
  TransactionRunner; footer/note digabung dengan profil terbaru agar mode/nama tetap.
- Printer_id/printer_name tetap LocalSettingsRepository lokal, tanpa outbox sinkron.
- Katalog sortOrder lalu urutan insert stabil; filter aktif/soft delete pada dua backend.
- Profil/struk satu baris per owner dijaga transaksi repository; ID tersimpan tak boleh
  berubah. Belum ada UNIQUE(owner_id) SQL; sync/penulisan langsung nanti wajib menjaganya.
- Default kosong memakai UUID v4, tanpa menulis database/outbox, stabil per instance.
- Skema tetap v2/16 tabel; snapshot v1/v2 tidak diubah. Migrasi berikut wajib tes.
- Tes: kontrak dua backend, rollback trigger/gabungan + retry, metadata/owner/ID,
  database file ditutup/dibuka ulang, status mode setelah form dibuka dan golden printer.
- Tidak ada widget/layar baru. Spec 06 diperbarui untuk aliran data; golden lama cocok.
- AiPreferences TETAP in-memory sampai B7; catatan batasan wajib dipertahankan.
- LANGKAH BERIKUTNYA: B1d-drift-order-pembayaran.md. Berhenti setelah commit B1c.

## Antrean dan lingkungan
1. Sesudah B1c selesai: docs/prompts/B1d-drift-order-pembayaran.md, lalu B1e/B1f dan B0.
2. Aplikasi tetap InMemory sampai B1f. Database Android/iOS belum diuji;
   SQLite native Windows diuji. Printer asli ditunda; tampilan/fixture tetap.
3. Sebelum SEMUA perintah Dart/Flutter pada setiap proses PowerShell baru:
   . ./tool/windows_native_sdk.ps1 (SDK asli E:/App Data/flutter/flutter berspasi).
   Junction Flutter + salinan Dart (~588 MB) di Temp; lingkungan hanya per proses.
4. B0 hanya Supabase lokal (Docker/CLI); cloud/key belum dibutuhkan pada B1c.
   Pengguna meminta kebutuhan cloud disampaikan di akhir fase ketika diperlukan.
   Agen dilarang mengubah proyek cloud. B2/B3/B5-B8 MENUNGGU; jangan push/merge.

## Keputusan dan batas
- Persistensi hanya data/core persistence/sync; tanpa shared_preferences.
  Preferensi perangkat local_settings, bisnis/struk sinkron, sesi secure storage.
- UUID/namespace retry: docs/progress/bp0-id.md (28 titik, 21 v4/7 v5); seed UUID B1f.
- Lintas repository wajib TransactionRunner; nested gagal menggagalkan transaksi luar.
- Payload snake_case/UTC ISO tanpa sync_state/key pencarian lokal. B1b memakai prefiks
  nama/nomor dan normalisasi alias 0/62/+62/8; UI pencarian belum disambung.
- PRD B 5 belum memuat order_events; tabel tersedia sesuai domain/B1d (laporan B1a).
- PayStatus turunan; COD bersisa ditahan; tabungan sebagian dengan bayar nol wajib COD.
  Kelebihan tunai bukan omzet. Catat bayar aktif melepas tahanan, Terima bayar siap selesai;
  mode sederhana otomatis selesai saat COD lunas; non-COD lama belum lunas didukung.
- Semua auth/account/sync masih dummy; password bukan state UI/log/error.
- Fixture 48 pelanggan/12 antrean, cust-010/A-0137, AI 142/8/3 agregat tetap.
- Registry 60/60, Section debt 14. Utang runtime 101-110/tool lama: fase-ui/bp0-id.
- Slot lintas fitur OrderEditBodySection izin R0; statusLabel R4. iOS belum diuji.
- Graph E-Latihan-Pemrograman-laurum-projects-laurum auto-index checkout E: aktif.
