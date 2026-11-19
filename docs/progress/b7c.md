# B7c - Aplikasi AI WhatsApp
Status: SELESAI (2026-11-18). Berhenti di GATE: usulan muncul di HP setelah sinkron.
Migrasi server acuan: docs/progress/b7b.md. Prompt: docs/prompts/B7c-aplikasi-ai.md.

## Yang berubah
- Skema Drift v6: `superbase` -> `ai_proposals` (19 kolom, TANPA decided_at) dan
  `wa_connections` (pull-only). Indeks owner+updated_at dan owner+status. Migrasi v5->v6 hanya
  createTable/createIndex; data lama tidak disentuh. Tes migrasi v1/v3/v4/v5 -> 6 lulus.
- `DriftProposalRepository` (features/proposals/data) + `proposal_storage_mapping`: row <-> Proposal,
  payload wire tanpa `sync_state`/`decided_at`, kolom worker (wa_message_id, chat_id, confidence,
  received_at) dipertahankan dari baris lama dan tidak pernah dikarang aplikasi.
- Kontrak `test/contracts/proposal_contract.dart` dijalankan untuk InMemory dan Drift
  (baca, simpan, filter status, keputusan membawa edit pemilik, id asing ditolak, soft delete).
- Sinkron: `syncPushTables` + ai_proposals (keputusan pemilik), `syncPullTables` + wa_connections,
  urutan pull di akhir, normalizer `received_at`/`connected_at`, fixture wire + tes applier.
- Usulan demo hanya untuk akun demo (`demoSeedEnabled && owner == demoOwnerId && demoProposals`);
  akun nyata memakai repository Drift dan berubah lewat `accountChangesProvider`.

## Bukti
- `check_all`: SEMUA HIJAU. 1230 tes lulus, 2 skip (tes integrasi Supabase lokal), REPO_MAP 1187.
  Sebelum B7c: 1216 lulus (delta +14: kontrak proposal 6x2, simpan keputusan, migrasi v6, wire).
- `supabase test db` tidak berubah (tanpa migrasi baru); hasil terakhir 306 PASS (B7b).

## GATE B7c (dijalankan pengguna; agen tanpa kunci)
1. Set env di PowerShell: `SUPABASE_URL` (dari .env.local) dan `SUPABASE_SERVICE_ROLE_KEY`
   (dashboard API). Jangan tempel nilainya di chat atau repo.
2. Jalankan: `./supabase/scripts/simulate-worker.ps1 -OwnerEmail 'akun-anda@contoh.com'`
   Skrip mencari owner dari email, membuat/menyegarkan baris wa_connections (instance
   `laurum-sim-...`), lalu memanggil `ingest_ai_proposal`. Harapan: `code=created`.
3. Buka aplikasi (akun itu) dan tarik sinkron / buka layar Antrean: usulan AI masuk sebagai
   Menunggu dengan teks, nama, telepon, alamat dari payload simulasi.
4. Setujui usulan: order terbentuk, status menjadi Disetujui, dan usulan hilang dari Antrean.
5. Laporkan: `code=created`, usulan tampil, order terbentuk (atau galat apa adanya).

Hasil 19 Nov 2026 (sisi server, sudah dijalankan): owner 8ceb3d1b (naufalfaiz6381@gmail.com),
instance laurum-sim-8ceb3d1b, `code=created` proposal 0edc99b7, baris server `menunggu`,
decided_at null, phone 081234567890, confidence 0.90. Sisa GATE: sinkron dan setujui di HP.
Catatan: Supabase menolak secret key bila User-Agent mirip browser; skrip memakai
`-UserAgent 'laurum-worker/1.0'` (tanpa itu: "Forbidden use of secret API key in browser").

## Catatan untuk fase berikutnya
- B7d/B7e (laurum-infra) memakai kontrak yang sama; skrip simulasi ini adalah pengganti sementara.
- B7f: `wa_connections` sudah tersinkron ke klien tetapi belum dipakai UI; FakeWhatsappConnection
  dan pengaturan AI di memori belum diganti, `set_ai_settings` belum dipanggil aplikasi.
- Gap tercatat: `cancel_requested=true` tanpa `order_id` masih gagal di `acceptProposal`
  (`p.orderId!`); perlu keputusan B7d/B7f, bukan B7c.
- Retensi `source_text` server (30 hari) berarti teks bisa menjadi null pada usulan yang sudah
  diputuskan; UI membaca '' sehingga riwayat aman.
