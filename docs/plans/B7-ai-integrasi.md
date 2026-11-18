# B7 - Integrasi AI pembaca WhatsApp

Status: dirancang 18 Nov 2026, dikerjakan bertahap B7a sampai B7h, satu fase per sesi, berhenti di tiap GATE.
Dasar: PRD B 5, 12, 16.3; docs/backend/ROADMAP.md baris B7; AGENTS.md bagian Mode Integrasi AI WhatsApp (AI-1 sampai AI-12). Branch: ai-whatsapp.

## Keadaan saat ini (diperiksa 18 Nov 2026)
- UI AI dummy sudah lengkap (prompt 80): AiSettingsPage, WhatsappLinkPage (QR placeholder, kedaluwarsa 1 menit), ProposalDetail/History, setujui/tolak/batal idempoten. Spec 25-28.
- ProposalRepository hanya InMemory, juga di mode Drift (drift_repository_overrides.dart); usulan demo hanya untuk akun demo.
- whatsappConnectionProvider = FakeWhatsappConnection (default connected). AiSettings 3 saklar hanya di memori.
- Server: 13 tabel + sync_push grup atomik + pull kursor; ai_proposals dan wa_connections BELUM ada (PRD B 5 menunda).
- Migrasi cloud diterapkan pemilik (INDEX 9 Nov); supabase/README.md: agen hanya lokal.

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
