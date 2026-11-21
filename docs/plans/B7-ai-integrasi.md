# B7 - Integrasi AI pembaca WhatsApp

Status: dirancang 18 Nov 2026, dikerjakan bertahap B7a sampai B7h, satu fase per sesi, berhenti di tiap GATE.
Dasar: PRD B 5, 12, 16.3; docs/backend/ROADMAP.md baris B7; AGENTS.md bagian Mode Integrasi AI WhatsApp (AI-1 sampai AI-12). Branch: ai-whatsapp.

## Dasar rancangan (diperiksa 18 Nov 2026; historis sebelum B7b/B7c)
- UI AI dummy sudah lengkap (prompt 80): AiSettingsPage, WhatsappLinkPage (QR placeholder, kedaluwarsa 1 menit), ProposalDetail/History, setujui/tolak/batal idempoten. Spec 25-28.
- ProposalRepository hanya InMemory, juga di mode Drift (drift_repository_overrides.dart); usulan demo hanya untuk akun demo.
- whatsappConnectionProvider = FakeWhatsappConnection (default connected). AiSettings 3 saklar hanya di memori.
- Server: 13 tabel + sync_push grup atomik + pull kursor; ai_proposals dan wa_connections BELUM ada (PRD B 5 menunda).
- Migrasi cloud diterapkan pemilik (INDEX 9 Nov); supabase/README.md: agen hanya lokal.

Perkembangan 20 Nov: B7b terpasang oleh pemilik; B7c repository Drift/sinkron sudah
diuji pengguna sampai usulan menjadi antrean. Addendum percakapan B7d diimplementasikan
dan diuji lokal (docs/progress/b7d.md), belum diterapkan ke cloud. Penautan dan
pengaturan/koneksi WhatsApp nyata dalam aplikasi menunggu fase berikutnya.

## Keputusan pengguna (14-18 Nov 2026)
- Jalur WhatsApp: Evolution API (Baileys, tidak resmi) HANYA untuk uji internal; rilis publik wajib dievaluasi ulang ke Cloud API resmi (PRD B 16.3).
- Satu flow n8n untuk semua pengguna; isolasi ditegakkan server (AI-4), bukan prompt.
- Uji: PC lokal (Docker Desktop), Supabase cloud yang ada, Quick Tunnel Cloudflare, nomor WhatsApp biasa cadangan, AI hanya membaca.
- Keamanan/privasi lanjutan ditunda; AI-3, AI-4, AI-5 tetap wajib. Cadangan rahasia (password manager) belakangan.

## Arsitektur
WhatsApp pelanggan -> Evolution API (laurum-infra) -> webhook -> n8n -> [node biasa: cari instance, saring, ambil nomor pengirim] -> LLM (hanya JSON) -> [node biasa: validasi] -> RPC ingest_ai_proposal (Supabase, service role) -> ai_proposals -> sinkron pull -> aplikasi (usulan Menunggu) -> pemilik setuju/tolak -> TransactionRunner membuat order (source whatsappAi) dan status usulan berubah.
Penautan: aplikasi -> Edge Function wa-connect (JWT pemilik) -> Evolution API (via tunnel) -> kode pasangan/QR -> pemilik memasukkannya di WhatsApp -> event connection.update -> n8n -> RPC set_wa_connection_status -> wa_connections.

## Kontrak (usulan awal; DIKUNCI setelah B7a disetujui, perubahan = AI-9)
Tabel (PRD B 5; kolom umum id, owner_id, created_at, updated_at, deleted_at):
- ai_proposals: status (menunggu/disetujui/ditolak/ditutup_otomatis, padanan ProposalStatus), source_text, customer_name, phone, address, service_id, cancel_requested, uncertain_address, customer_id, order_id; tambahan usulan: wa_message_id, chat_id, confidence. Unik (owner_id, wa_message_id).
- wa_connections: satu baris per akun (v1), instance_id unik, status (belum/menunggu/terhubung/terputus), connected_at, pengaturan worker (read_messages, ignore_groups, detect_cancellation).
RPC khusus service role (tidak dapat dipanggil klien):
- ingest_ai_proposal(p_instance_id text, p_wa_message_id text, p_chat_id text, p_received_at timestamptz, p_payload jsonb) -> {code}: created | duplicate | ignored | unknown_instance | invalid.
- get_ai_context(p_instance_id text) -> connected_at, tiga pengaturan, daftar layanan aktif (nama, jenis) untuk prompt.
- set_wa_connection_status(p_instance_id text, p_status text) -> {code}.
Payload p_payload (hasil LLM yang sudah divalidasi n8n): source_text (maks 2000), customer_name, address, service_hint, uncertain_address, cancel_requested, confidence 0..1. Nomor telepon dan wa_message_id diisi node biasa dari webhook, bukan LLM.
Edge Function (JWT pemilik): wa-connect, wa-disconnect. Pengaturan AI dari aplikasi disimpan ke wa_connections lewat jalur sinkron/RPC yang diputuskan di B7a.

### Addendum percakapan B7d (disetujui pengguna 20 Nov 2026)
- Satu usulan Menunggu per owner + nomor webhook; pesan lanjutan memperbarui usulan yang sama.
  Setelah disetujui/ditolak/ditutup, permintaan baru boleh membuat usulan baru. Pembatalan
  menarik usulan Menunggu menjadi ditutup_otomatis; AI tidak membatalkan order/uang.
- Tabel server-only: ai_conversation_contexts (owner+phone unik, chat_id, generation_id,
  revision, draft_context, proposal_id, last_received_at, created_at/updated_at) dan
  ai_message_receipts (owner+wa_message_id unik, conversation_id, received_at, result_code,
  proposal_id, created_at). ID UUID v4. RLS tanpa akses klien; ikut pembersihan akun.
- get_ai_conversation_context(p_instance_id text,p_phone text) khusus service_role:
  code, pengaturan/layanan, draft_context, proposal_status, conversation_generation,
  context_revision. Identitas/versi ditangani node biasa, tidak diberikan ke LLM.
- ingest_ai_proposal mempertahankan signature; payload menambah action (default order),
  draft_context, conversation_generation, context_revision. Hasil: created | updated |
  closed | collected | ignored | duplicate | stale | retry | unknown_instance | invalid.
- Action LLM: collect | order | cancel | ignore. Konteks hanya customer_name, address,
  service_hint, uncertain_address, confidence; nomor/owner/id/versi berasal dari node/server.
  Pesan non-order tidak disimpan; receipt hanya metadata. source_text hanya untuk usulan order.
- Versi konteks, generasi dan receipt mencegah penimpaan/pembatalan lama atau duplikat.
  Penerimaan eksplisit pemilik dari cache offline tetap dapat disinkronkan melalui grup
  order+usulan yang valid, meski usulan sudah ditutup AI. Logika uang tetap.
- Rancangan dan batas: docs/plans/B7d-percakapan.md. Migrasi baru, tanpa mengubah riwayat.

### Addendum berat (disetujui 20 Nov 2026, docs/plans/B7d-berat-usulan.md):
- `ai_proposals.estimated_weight_grams` integer nullable, positif, maksimum 2147483647;
  null berarti belum diketahui. Data lama tetap null. Drift v7/domain membawa nilai sama.
- `draft_context.estimated_weight_grams` menerima integer gram atau null; key hilang
  mempertahankan ringkasan, null menghapus perkiraan. RPC/guard menjaga metadata AI
  saat keputusan pemilik memakai cache lama; isolasi dan idempotensi tetap.
- Node validasi mengambil angka+satuan yang eksplisit di chat (termasuk sebutan jelas
  seperti dua kilo); tebakan field dari LLM diabaikan. Pesan tanpa berat mempertahankan
  berat yang sudah disebut dalam percakapan itu; order baru tanpa berat tetap null.
- Rentang atau penyebutan ambigu tidak dipilih titik tengahnya. Draf layanan kiloan
  memakai perkiraan ini, dapat diedit pemilik; tanpa data memakai empty state yang ada.
  Persetujuan tetap eksplisit, memakai perhitungan/order/TransactionRunner yang sama.

### Addendum B7e/B7f (disetujui pengguna 21 Nov 2026)
- B7e: backend penautan. Edge Function `wa-connect` mengembalikan QR **dan** kode pasangan
  sekaligus (WhatsApp Web), `wa-status` memetakan connectionState ke wa_connections.
  Diuji `npm test` dan panggilan langsung ke Evolution lokal; tanpa perubahan UI.
- B7f: layar Hubungkan WhatsApp memakai fungsi itu (QR | nomor telepon) dan deploy cloud
  oleh pemilik. Langkah deploy ada di docs/progress/b7e.md.

## Fase
| Fase | Hasil | Selesai bila | GATE (tindakanmu) |
| --- | --- | --- | --- |
| B7a | Audit + rancangan skema (dokumen saja): docs/plans/B7a-skema.md, maks 60 baris | Keputusan terbuka terjawab (lihat prompt B7a) | Setujui skema dan kontrak |
| B7b | Migrasi lokal: dua tabel, RLS, tiga RPC, tes pgTAP lintas akun, idempotensi, instance tak dikenal | supabase test db hijau | Terapkan migrasi ke cloud sesuai docs/progress/b7b.md |
| B7c | Aplikasi: tabel Drift + DriftProposalRepository + kontrak + pull sinkron; hapus usulan demo dari akun nyata; skrip simulasi worker (curl/SQL ke RPC) | check_all hijau | Jalankan skrip: usulan muncul di HP setelah sinkron, setujui, order terbentuk |
| B7d | Repo laurum-infra: compose Evolution+Postgres+Redis+n8n (versi dikunci), flow n8n tunggal multi-user, prompt + JSON schema; diuji dengan payload webhook tiruan | Payload tiruan jadi usulan di akun benar, akun lain kosong | Isi kunci LLM dan kunci Supabase di Credentials n8n (UI), impor flow |
| B7e | Penautan WhatsApp manual lewat Evolution API + webhook ke n8n | Chat dari HP kedua tiba di n8n | Masukkan kode pasangan di HP (nomor cadangan), kirim chat uji |
| B7f | Edge Function wa-connect/wa-disconnect + status koneksi nyata di aplikasi (ganti Fake) + pengaturan AI tersimpan; kode pasangan (AI-8) | Layar Hubungkan WhatsApp berjalan nyata | Pasang cloudflared, jalankan Quick Tunnel, set secret fungsi, deploy fungsi |
| B7g | Penyetelan prompt dengan sampel chat asli + skrip evaluasi di laurum-infra | Laporan akurasi apa adanya | Sediakan 15-20 chat tersamarkan beserta label |
| B7h | Uji end-to-end dan isolasi (disusun bersama pengguna setelah B7f) | Skenario lulus | Jalankan uji |
Prompt tiap fase ditulis setelah fase sebelumnya SELESAI. Hanya B7a yang sudah ditulis.

## Rahasia (AI-3)
| Nama | Dipakai oleh | Disimpan di | Yang mengisi |
| --- | --- | --- | --- |
| URL + publishable key Supabase | aplikasi | .env.local (--dart-define-from-file) | sudah ada |
| Secret key Supabase cloud | n8n | Credentials n8n (UI) | pengguna |
| API key LLM | n8n | Credentials n8n (UI) | pengguna |
| AUTHENTICATION_API_KEY, N8N_ENCRYPTION_KEY, WEBHOOK_SECRET | laurum-infra | laurum-infra/.env (gitignore) | dibuat otomatis lokal, tanpa dicetak |
| EVOLUTION_URL (tunnel), EVOLUTION_API_KEY | Edge Function | secrets Supabase cloud | pengguna, tanpa lewat chat |
EVOLUTION_URL berubah tiap Quick Tunnel dimulai ulang: B7f menyiapkan langkah pembaruan tanpa mengubah kode.

## Risiko dan catatan
- Jalur tidak resmi: nomor bisa diblokir; pakai nomor cadangan, jangan mengirim pesan (AI-5).
- PC harus menyala; sesi WhatsApp putus bila gateway mati lama. Status Terputus + Hubungkan ulang wajib ada.
- Status koneksi lewat pull sinkron mungkin terlalu lambat untuk layar penautan: B7a memilih antara polling singkat dan Realtime.
- Mode campuran dilarang: usulan nyata dan demo tidak tampil bersamaan (AI-7).
- Di luar lingkup B7: membalas pelanggan, multi-nomor per akun, voice note/gambar, Cloud API resmi, Pro/entitlement.
