# B7b - Migrasi lokal skema AI WhatsApp

Ikuti _COMMON.md bagian A (kecuali A.3 dan A.4) dan F. Rencana: docs/plans/B7-ai-integrasi.md;
skema disetujui: docs/plans/B7a-skema.md. Aturan: AGENTS.md Mode Integrasi AI WhatsApp di atas
Mode Backend.
Pengecualian A.3: B3b BELUM dan tidak memblokir B7 (keputusan pengguna 18 Nov 2026). A.4 tidak
berlaku (tidak membaca Figma/.pen).
Prasyarat: branch ai-whatsapp, Docker Desktop aktif, `supabase start` dan `supabase test db`
hijau (219 tes). GATE B7a sudah dijawab: keputusan lewat sync_push, polling 2 dtk, retensi
source_text 30 hari, kolom tambahan diterima, satu koneksi per akun.
Fase ini MIGRASI LOKAL SAJA: tanpa kode Dart, tanpa Edge Function, tanpa cloud, tanpa kunci (AI-3).

## Hasil yang diminta
1. Satu migrasi baru aditif (timestamp setelah b2a): dua tabel `ai_proposals` dan
   `wa_connections` sesuai B7a-skema, indeks, trigger `stamp_record` + guard, RLS per operasi
   (ai_proposals: select+update milik sendiri tanpa INSERT; wa_connections: select saja), grant
   untuk authenticated/service_role/laurum_account_deleter.
2. Empat RPC: `ingest_ai_proposal`, `get_ai_context`, `set_wa_connection_status` (service_role),
   `set_ai_settings` (authenticated). Kode hasil dan idempotensi sesuai B7a-skema.
3. `sync_push` dan `sync_pull` diperluas: `ai_proposals` masuk push+pull, `wa_connections` pull.
   Reproduksi fungsi dengan `create or replace`; tanpa perubahan perilaku tabel lama.
4. `private.purge_my_rows` dan `public.delete_my_account` dibuat ulang termasuk dua tabel baru.
5. Berkas pgTAP baru `supabase/tests/b7b_test.sql`, minimal: isolasi dua akun (baca/ubah/tulis),
   ingest idempoten, instance tak dikenal, payload tidak valid, pesan diabaikan, transisi status
   hanya menunggu->disetujui/ditolak, kolom LLM tidak bisa diubah klien, tanpa INSERT klien,
   `set_ai_settings` hanya menyentuh akun sendiri, get_ai_context tanpa owner_id, purge akun.
6. Bukti: `supabase db reset` (migrasi dari nol) dan `supabase test db` hijau; laporkan angka
   sebelum/sesudah (219 -> ...). `check_all` tidak perlu diulang (tanpa kode Dart), tetapi
   jalankan `dart run tool/repo_map.dart` bila ada berkas baru di luar lib/test/tool.
7. Tulis docs/progress/b7b.md: ringkasan objek, hasil tes, langkah terapan cloud untuk pengguna
   (perintah, urutan, cara memeriksa, cara membatalkan), dan catatan untuk B7c (mis. kolom Drift
   `decided_at` tidak boleh ada di klien).
8. Perbarui STATE.md (UI-34) dan baris B7b di INDEX.md. Commit: "feat(b7b): migrasi lokal AI".
   BERHENTI di GATE: pengguna menerapkan migrasi ke cloud.

## Larangan khusus
- Tanpa DROP/TRUNCATE/perubahan tabel lama. Tanpa cloud, tanpa `supabase link`, `db push`,
  `--remote`, atau kunci cloud (AI-2, AI-3).
- Tanpa perilaku uang baru: persetujuan tetap di TransactionRunner (B7c), bukan di RPC.
- Tanpa mengubah docs/prd.
