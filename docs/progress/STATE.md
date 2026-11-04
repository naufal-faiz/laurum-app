# STATE Laurum
Diperbarui: 2026-11-04 | Cabang dev2backend

## Posisi
UI dummy 100/R0-R10 selesai; docs/progress/fase-ui.md.
BP0 8e51cda, B1a c22ec5b, B1b 8821b17, B1c f9bd41c SELESAI.
B1d SELESAI: repository order, alur atomik, migrasi v3 dan benchmark.
Baseline B1d 781 tes hijau (exit 0), %TEMP%/laurum-b1d-baseline.log.
check_all akhir: 848 tes, kedua analyzer tanpa isu, check_arch OK, REPO_MAP 840; exit 0.
Bukti %TEMP%/laurum-b1d-check.log; rencana/laporan dirujuk docs/progress/b1d.md.

## Selesai B1d
- DriftOrderRepository/reader/mapping memenuhi semua API; parent/owner dijaga.
- writeOrderStore dipakai dua backend; COD, status final, nominal dan retry ledger
  dijaga di repository. sameRecordContent membandingkan semua props kecuali metadata.
- Snapshot item hilang menjadi tombstone+outbox. Posisi rowid order/item mengikuti
  urutan InMemory; ID domain tetap UUID. Ledger append-only, retry tidak menambah ledger.
- Skema v3/16 tabel: indeks owner/status, owner/entered_at dan owner/paid_at;
  payments(order_id) lama tetap. Migrasi v1/v2->v3 dan snapshot v3 tersedia.
- entered_at/paid_at wajib sqlTimestamp: UTC ISO enam digit pecahan untuk range presisi.
  Penulis SQL/sync berikutnya wajib format sama. Domain range kembali ke waktu lokal.
  Snapshot v1/v2 tidak berubah; helper --data-classes --companions.
- DriftTransactionRunner mendukung checkpoint memory sementara (AI/auth/sync dummy);
  nested gagal menggagalkan transaksi luar. Semua penulisan tetap data+outbox atomik.
- Tes controller Drift: checkout/counter, edit, bayar+tabungan, selesai/COD,
  batal/refund, retry AI termasuk status approval memory hilang, cleanup akun.
- DriftLocalDataService menghapus baris/FK/outbox/settings dan callback memory atomik;
  owner asing ditolak. Tutup/hapus berkas setelah commit pada wiring/lifecycle B1f.
- Benchmark Windows memory: 5.000 order/8.000 pembayaran, range 7 hari/581 hasil,
  5 warmup/100 sampel; median 12,208 ms, p95 15,018 ms (non-gating, target <100 ms).
- Tidak ada widget/layar baru; Dart non-generated <=100 baris (maksimal 93 saat review).
- LANGKAH BERIKUTNYA: docs/prompts/B1e-drift-pengeluaran-laporan.md.
  Berhenti setelah commit B1d; jangan memulai B1e tanpa prompt berikutnya.

## Antrean dan lingkungan
1. Aplikasi tetap InMemory sampai B1f; B1e lalu B1f, kemudian B0 Supabase lokal.
   Database Android/iOS belum diuji; SQLite native Windows sudah diuji.
2. Sebelum SEMUA perintah Dart/Flutter pada setiap proses PowerShell baru:
   . ./tool/windows_native_sdk.ps1 (SDK asli E:/App Data/flutter/flutter berspasi).
   Junction Flutter + salinan Dart (~588 MB) di Temp; lingkungan hanya per proses.
3. Supabase cloud/key belum dibutuhkan pada B1d. Pengguna meminta pemberitahuan akhir
   fase ketika dibutuhkan; agen dilarang mengubah proyek cloud. Jangan push/merge.
4. AiPreferences, usulan AI, auth dan sync tetap dummy/memory sampai fasenya (B7/B3/B2).
   B2/B3/B5-B8 MENUNGGU. Printer asli ditunda; pilihan printer hanya local_settings.

## Keputusan dan batas
- Persistensi hanya data/core persistence/sync, tanpa shared_preferences. Preferensi
  perangkat local_settings, bisnis/struk sinkron, sesi secure storage (fase auth nyata).
- Namespace retry BP0 tetap; seed fixture UUID pada B1f. Counter nota ikut transaksi.
- B1c profil/struk satu baris per owner dijaga repository, belum UNIQUE(owner_id) SQL.
- Payload snake_case/UTC ISO tanpa sync_state/pay_status/key pencarian lokal.
- B1b API prefiks dan normalisasi 0/62/+62/8; UI pencarian belum disambung.
- PRD B 5 belum memuat order_events; tabel tersedia sesuai domain/B1d (laporan B1a).
- PayStatus turunan; COD bersisa ditahan; tabungan sebagian dengan bayar nol wajib COD.
  Kelebihan tunai bukan omzet. Catat bayar aktif melepas tahanan, Terima bayar siap selesai;
  mode sederhana otomatis selesai saat COD lunas; non-COD lama belum lunas didukung.
- Fixture 48 pelanggan/12 antrean, cust-010/A-0137, AI 142/8/3 agregat tetap.
- Registry 60/60, Section debt 14. Utang runtime 101-110/tool lama: fase-ui/bp0-id.
- Slot lintas fitur OrderEditBodySection izin R0; statusLabel R4. iOS belum diuji.
- check_all dapat hijau dengan info Riverpod: baca log dan hilangkan info lint baru.
