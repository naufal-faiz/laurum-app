# B7a - Skema AI WhatsApp (usulan; dikunci setelah GATE)
Dasar: docs/plans/B7-ai-integrasi.md, PRD B 5/12. Pola tabel lama: id uuid pk, owner_id uuid default
auth.uid() references auth.users(id), created_at/updated_at/deleted_at, unique(owner_id,id), trigger
private.stamp_record, indeks pull. Wire schema tetap 5 sampai B7c.

## ai_proposals (kolom tambahan; kolom pola di atas tetap)
- status text not null default 'menunggu', check 4 nilai.
- source_text text not null, 1..2000.
- customer_name text not null default '', maks 120; phone text not null default '', kosong atau
  6..15 digit; address text not null default '', maks 300.
- service_id uuid null, fk (owner_id,service_id) -> services.
- cancel_requested, uncertain_address boolean not null default false.
- customer_id uuid null, tanpa fk (dicocokkan server/klien, bukan LLM).
- order_id uuid null, tanpa fk (sama seperti orders.proposal_id).
- wa_message_id text not null, 1..200 (kunci idempotensi); chat_id text not null, 1..100.
- confidence numeric(3,2) null, 0..1; bukan akurasi yang ditampilkan (BE-6).
- received_at timestamptz not null (dari webhook); decided_at timestamptz null (diisi server).
- Unik (owner_id,wa_message_id); indeks (owner_id,updated_at,id), (owner_id,status),
  partial (owner_id,decided_at) where source_text is not null (retensi).

## wa_connections
- instance_id text not null, unik global (kunci isolasi AI-4a).
- status text not null default 'belum', check belum/menunggu/terhubung/terputus.
- connected_at timestamptz null, diisi ulang tiap transisi ke 'terhubung'.
- read_messages, ignore_groups, detect_cancellation boolean not null default true.
- Unik (owner_id) = satu baris per akun (v1); indeks (owner_id,updated_at,id).

## RLS (default-deny; tanpa policy = ditolak)
- ai_proposals: select owner; insert tanpa policy (AI-4d); update owner tetapi dibatasi guard
  trigger (hanya keputusan + nilai edit, transisi menunggu->disetujui/ditolak); delete hanya
  laurum_account_deleter.
- wa_connections: select owner; insert/update/delete tanpa policy (tulis lewat RPC/Edge Function).
- Sync: ai_proposals di syncPushTables + syncPullTables; wa_connections hanya pull (entitlements).
- purge_my_rows dan pgTAP purge_tests ditambah kedua tabel.

## Padanan Proposal -> kolom dan status
id, owner_id, created_at, updated_at, deleted_at, status, source_text, customer_id, order_id,
customer_name, phone, address, service_id, cancel_requested, uncertain_address (snake_case);
syncState lokal saja. Status menunggu/disetujui/ditolak sama; ditutupOtomatis -> 'ditutup_otomatis'
hanya server (PRD tidak punya aturan penutupan otomatis, jadi tanpa timer di B7).

## RPC (security definer, set search_path = '')
- ingest_ai_proposal(p_instance_id, p_wa_message_id, p_chat_id, p_received_at, p_payload jsonb)
  -> {code}; hanya service_role; owner dari wa_connections.instance_id, bukan payload/LLM.
  code: created | duplicate (unik owner+message, ON CONFLICT DO NOTHING = idempoten) | ignored
  (received_at < connected_at atau read_messages=false) | unknown_instance | invalid.
- get_ai_context(p_instance_id) -> {code, connected_at, 3 saklar, services[{id,name,kind}]};
  service_role; tidak mengembalikan owner_id (AI-4b).
- set_wa_connection_status(p_instance_id, p_status) -> {code: updated|unknown_instance|invalid};
  service_role; 'terhubung' mengisi connected_at.
- set_ai_settings(p_read_messages, p_ignore_groups, p_detect_cancellation) ->
  {code: saved|no_connection}; authenticated, owner dari auth.uid(), hanya 3 kolom itu.
  Pengaturan AI = kolom wa_connections (dibaca worker), bukan local_settings (aturan 20).

## Keputusan pemilik tanpa INSERT klien
Setujui: TransactionRunner yang ada membuat order + item + usulan disetujui (order_id dan nilai
edit nama/telepon/alamat/layanan; decided_at diisi server) -> outbox -> sync_push update. Tolak:
status 'ditolak'. Batal (cancel_requested): cancelOrder yang ada. Edit hanya ikut dalam perubahan
keputusan; guard trigger menolak update tanpa status final, perubahan kolom LLM, dan transisi
keluar dari final. Retry idempoten: payload identik = no-op. Klien tidak pernah INSERT.
