# B7b - Migrasi lokal skema AI WhatsApp
Status: SELESAI lokal (2026-11-18). Berhenti di GATE: pengguna menerapkan ke cloud.
Migrasi: supabase/migrations/20261118090000_b7b_ai_tables.sql (606 baris).
Tes: supabase/tests/b7b_test.sql (87 tes baru). Skema: docs/plans/B7a-skema.md.

## Objek yang dibuat (aditif, tanpa DROP/ALTER tabel lama)
- Tabel public.ai_proposals: 20 kolom, unique(owner_id,id), unique(owner_id,wa_message_id),
  FK (owner_id,service_id) -> services, constraint source_text is not null or decided_at is not null.
- Tabel public.wa_connections: 11 kolom, unique(owner_id,id), unique(owner_id), instance_id unik.
- Indeks: ai_proposals_pull, ai_proposals_status, ai_proposals_retention (partial, baris ber-teks),
  wa_connections_pull. Wire schema tetap 5 (klien lama tidak pernah meminta tabel baru).
- RLS: ai_proposals select+update milik sendiri (tanpa INSERT/DELETE), wa_connections select saja.
  Grant: authenticated (select/update proposal, select koneksi), service_role penuh,
  laurum_account_deleter select+delete keduanya.
- Trigger guard_ai_proposal: klien hanya menunggu -> disetujui/ditolak, decided_at diisi server,
  kolom LLM dan identitas (id, owner_id, wa_message_id, chat_id, confidence, received_at,
  cancel_requested, uncertain_address, customer_id) immutable, teks pesan immutable, tanpa delete.
  service_role hanya boleh menutup yang masih menunggu (ditutup_otomatis, menstempel decided_at)
  atau menghapus source_text setelah decided_at terisi; nama/telepon/alamat/layanan/order_id
  tidak bisa diubah worker.
- Trigger guard_wa_connection: id, owner_id, instance_id tidak berubah setelah penautan.
- RPC: ingest_ai_proposal, get_ai_context, set_wa_connection_status (service_role),
  set_ai_settings (authenticated). Kode hasil: created/duplicate/ignored/invalid/unknown_instance,
  ok/updated/saved/no_connection. Ingest menormalkan telepon (62->0, 6..15 digit), memetakan
  service_hint ke layanan aktif milik owner (case-insensitive), menolak kunci payload asing
  (termasuk owner_id) dan order_id milik akun lain.
- create or replace: sync_push (ai_proposals masuk whitelist upsert), sync_pull
  (+ai_proposals, wa_connections), private.purge_my_rows dan public.delete_my_account (+2 tabel).

## Hasil tes
- `supabase db reset --workdir .`: enam migrasi dari nol, tanpa galat.
- `supabase test db --workdir .`: Files=3, Tests=306, Result PASS (baseline 219 -> 306, +87).
  Isi: isolasi dua akun (baca/ubah/tulis/delete), ingest idempoten dan penolakan payload,
  pesan lebih tua dari connected_at diabaikan, transisi status, immutable, grant RPC,
  retensi teks, auto-close, sync_push/pull, purge akun (A terhapus, B utuh).
- Bug yang ditemukan tes dan diperbaiki: service_role bisa mengubah kolom owner (immutable_content),
  auto-close bisa menutup usulan yang sudah diputuskan (sekarang hanya dari menunggu).

## Langkah terapan cloud (PENGGUNA; agen dilarang, AI-2)
1. Pastikan branch sudah di-merge/di-commit dan `supabase/migrations/20261118090000_b7b_ai_tables.sql`
   ada. Cadangkan dulu: `supabase db dump --linked -f backup-b7b.sql` (opsional, hanya data skema public).
2. `supabase link --project-ref <ref-laurumdb>` (sekali; jangan bagikan kunci ke agen).
3. `supabase db push` -> hanya migrasi baru yang dijalankan; tidak ada DROP/TRUNCATE.
4. Periksa: `select count(*) from public.ai_proposals;` (0 baris), `select count(*) from
   public.wa_connections;` (0 baris), `select proname from pg_proc where proname in
   ('ingest_ai_proposal','get_ai_context','set_wa_connection_status','set_ai_settings');` (4 baris),
   `select relrowsecurity from pg_class where relname in ('ai_proposals','wa_connections');` (true,true).
5. Jalankan `supabase test db --linked` bila ingin bukti pgTAP di cloud (opsional; butuh koneksi).
6. Cara membatalkan (hanya bila benar-benar perlu, tabel masih kosong):
   drop trigger guard_ai_proposal/guard_wa_connection/stamp_record, drop 4 RPC, drop table
   wa_connections lalu ai_proposals, lalu pulihkan sync_push/sync_pull/purge/delete_my_account
   dari migrasi b2a. Jangan lakukan setelah tabel berisi data.

## Catatan untuk B7c (aplikasi Flutter)
- Drift lokal TIDAK boleh punya kolom decided_at: payload sync harus identik dengan baris server
  agar retry menjadi no-op dan guard tidak menolak perubahan yang sama.
- ai_proposals masuk syncPushTables + syncPullTables; wa_connections pull saja (tanpa push).
- Tanpa INSERT klien: usulan demo (proposalSeedProvider) wajib dilepas di akun nyata sebelum
  sinkron aktif; build dummy tetap memakai fixture.
- Keputusan pemilik = satu update baris (status disetujui/ditolak + nama/telepon/alamat/layanan/
  order_id); after-copy ke pelanggan/order tetap di TransactionRunner, bukan di RPC.
- Gap tercatat untuk B7d/B7c: cancel_requested=true tanpa order_id akan gagal di acceptProposal
  (p.orderId!); perlu keputusan apakah auto-close atau wajib order_id.
- Retensi source_text butuh pg_cron di cloud (fallback SQL manual didokumentasikan di B7f).
