# B7a - Audit skema AI WhatsApp
Status: dokumen saja. Usulan skema: docs/plans/B7a-skema.md. Berhenti di GATE.

## Audit: berkas yang akan berubah per fase
| berkas (kondisi sekarang) | fase |
| --- | --- |
| core/domain/proposal.dart + repositories/proposal_repository.dart (lengkap, tanpa kolom AI) | B7c, pemetaan saja |
| features/proposals/data/in_memory_proposal_repository.dart (fixture + proposalSeedProvider) | B7c, demo dilepas di akun nyata |
| core/persistence/drift_repository_overrides.dart (ProposalRepository = InMemory) | B7c |
| features/proposals/state/proposal_actions, proposal_accept, proposal_order (TransactionRunner, UUID v5) | B7c, tetap; repository berganti |
| features/proposals/state/{ai_settings,whatsapp_link}.dart + shell_state.dart FakeWhatsappConnection | B7f |
| core/persistence/app_database.dart (schemaVersion 5, 16 tabel) + schema_migration.dart | B7c, 2 tabel + migrasi v6 |
| core/sync/sync_table_names.dart (12 push/13 pull) + sync_change.dart (schema_version 5); drift_sync_remote_applier generik, nama tabel Drift harus sama dengan server | B7c |
| supabase/migrations 0001-0004 + b2a (pola owner_id, RLS, stamp_record, sync_push/pull, purge) | B7b, migrasi baru aditif |
| supabase/tests/backend_test.sql + b2a_test.sql (helper owner_tests, purge_tests) | B7b, berkas tes baru |
| supabase/functions/delete-account (handler murni + tes, verifikasi /auth/v1/user) | B7f, wa-connect/wa-disconnect |
| supabase/config.toml (entri fungsi) | B7f |
| test/contracts/*.dart + contracts_in_memory_test.dart + test/persistence (pola kontrak) | B7c, kontrak proposal |
| laurum-infra (repo terpisah): Evolution, n8n, prompt | B7d, B7e |

## Temuan yang mengubah rencana B7
1. Perlu RPC keempat set_ai_settings: wa_connections tidak boleh ditulis klien karena instance_id
   adalah kunci isolasi (AI-4a).
2. wa_connections hanya pull; ai_proposals push + pull. Rencana belum menyebut arah per tabel.
3. ai_proposals tanpa policy INSERT, jadi insert lewat sync_push ditolak; usulan demo wajib
   dilepas di akun nyata (AI-7) sebelum migrasi dipakai.
4. Edit nama/telepon/alamat/layanan hanya ikut dalam perubahan keputusan; tidak ada edit tanpa
   keputusan (PRD tidak mengaturnya).
5. connected_at diisi ulang pada tiap transisi ke terhubung (filter AI-5), bukan hanya pertama.
6. app_config.min_schema_version tetap 5 selama B7: klien lama tidak pernah meminta tabel baru.
7. private.purge_my_rows dan pgTAP purge_tests wajib menambah dua tabel.
8. order_id tanpa FK, mengikuti orders.proposal_id yang juga tanpa FK.

## Risiko migrasi cloud (sudah berisi data)
- Aditif: CREATE TABLE + indeks di tabel kosong + trigger baru; tanpa DROP/ALTER tabel lama,
  tanpa tulis ulang data, tanpa lock baris lama.
- Objek lama yang dibuat ulang hanya private.purge_my_rows dan public.delete_my_account
  (lock fungsi, sesaat).
- RLS default-deny: lupa policy select = aplikasi kosong tanpa galat. Tes lintas akun B7b wajib.
- Lokal dulu (supabase test db), cloud oleh pengguna lewat docs/progress/b7b.md (AI-2).

## Pertanyaan GATE (rekomendasi + alasan)
a. Keputusan pemilik lewat sync_push (rekomendasi). Alasan: offline-first, retry/grup/idempoten
   sudah ada; RPC khusus menambah jalur tulis kedua.
b. Status koneksi: polling 2 dtk selama 60 dtk (rekomendasi). Alasan: umur layar 1 menit, tanpa
   langganan atau pembersihan channel.
c. source_text: hapus (set null) 30 hari setelah decided_at (rekomendasi). Alasan: privasi dan
   tabel tumbuh; butuh pg_cron, fallback SQL manual didokumentasikan di b7f.
d. wa_message_id + chat_id + confidence diterima; confidence numeric(3,2) null (rekomendasi).
   Alasan: LLM bisa tidak yakin, dan nilainya tidak ditampilkan sebagai akurasi (BE-6).
e. Satu koneksi per akun: unik(owner_id) sekarang (rekomendasi). Alasan: cakupan v1; multi-nomor
   nanti cukup DROP unique(owner_id) + kolom label.

## Catatan PRD (pengguna yang memutuskan)
- PRD B 12 menyebut status 'approved'; enum dan database memakai 'disetujui'. Tanpa perubahan
  perilaku, hanya istilah dokumen.
- PRD B 5 masih menunda kedua tabel; B7a mengisi rinciannya tanpa mengubah docs/prd.
