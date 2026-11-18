# STATE Laurum
Diperbarui: 2026-11-18 | Cabang ai-whatsapp (dari backend-newdesign). Mode Integrasi AI WhatsApp.

## Sesi aktif
B7b selesai termasuk penerapan cloud (dasar commit 4f330f2). Berikutnya B7c. Tidak membaca Figma.

## Status irisan
- Selesai: supabase/migrations/20261118090000_b7b_ai_tables.sql (dua tabel, 4 indeks, RLS
  per operasi, 4 trigger guard/stamp, 4 RPC, sync_push/pull dan purge dibuat ulang).
- Selesai: supabase/tests/b7b_test.sql (87 tes: isolasi dua akun, ingest idempoten/invalid/ignored,
  transisi dan immutable, grant, retensi, auto-close, sync_push/pull, purge).
- Selesai: docs/progress/b7b.md (objek, hasil tes, penerapan cloud + cara membatalkan, catatan B7c).
- Terpasang di cloud laurumdb (iczxtytiomlrpngitdlf) 2026-11-18 atas izin pengguna; terverifikasi
  lewat dump skema (tabel, indeks, RLS, trigger, RPC, grant) dan migration list remote.
- Tanpa kode Dart, Edge Function, atau dependensi baru.

## Keputusan pengguna terbaru
- B7a disetujui seluruhnya: keputusan lewat sync_push, polling status 2 dtk/60 dtk, retensi
  source_text 30 hari, kolom wa_message_id/chat_id/confidence, satu koneksi per akun.
- B3b BELUM dan tidak memblokir B7. Satu flow n8n multi-user; isolasi di server (AI-4).
- AI hanya membaca (AI-5); tanpa perubahan perilaku uang di fase migrasi.

## Belum di-commit
Tidak ada setelah commit feat(b7b).

## Langkah berikutnya
1. B7c: Drift v6 dua tabel tanpa decided_at, DriftProposalRepository + kontrak, sinkron push/pull,
   lepas usulan demo di akun nyata, skrip simulasi worker.
2. B7d/B7e di repo laurum-infra; B7f Edge wa-connect/wa-disconnect + set_ai_settings + status
   nyata (ganti FakeWhatsappConnection) + kode pasangan (AI-8, perlu keputusan UI).
3. B3b menunggu akun uji/peti surat; B2e foto pengeluaran tertunda.

## Blocker
- APK terakhir 1.0.2 code 3 (build/app/outputs/flutter-apk), belum dibangun ulang.

## Bukti terakhir
- `supabase db reset --workdir .`: 6 migrasi dari nol, exit 0.
- `supabase test db --workdir .`: Files=3, Tests=306, Result PASS (baseline 219 -> 306).
- `supabase db push --linked` ke laurumdb: 1 migrasi; dump skema cloud memuat 2 tabel, 4 indeks,
  RLS, 4 trigger, 3 policy per tabel, 4 RPC; migration list remote = 20261118090000.
- Tanpa perubahan kode Dart: check_all baseline B7a tetap berlaku (1216 lulus, 2 skip).
