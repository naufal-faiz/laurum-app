# B7d - Addendum percakapan pelanggan
Status: USULAN TEKNIS; perilaku disepakati 20 Nov 2026, skema/RPC belum disetujui; kontrak/kode aktif tetap.

## Perilaku yang disepakati
- Satu usulan Menunggu per akun + nomor pengirim yang dinormalisasi dari webhook.
- AI merangkum konteks bertahap; belum jelas order = belum ada usulan di aplikasi.
- Satu pesan yang sudah jelas order langsung membuat usulan; lanjutan memperbarui usulan itu.
- Pembatalan pelanggan menutup usulan Menunggu menjadi ditutup_otomatis; terlihat di riwayat setelah sinkron.
- Setelah disetujui/ditolak/ditutup, permintaan order baru boleh membuat usulan baru; sapaan tidak membuat/menutup usulan.
- Order dari cache offline tetap bisa sinkron walau usulan ditarik; AI tidak membatalkan order/uang atau mengirim pesan.

## Perubahan database yang diusulkan (migrasi baru; hanya lokal oleh agen)
- ai_conversation_contexts: id/owner_id, phone, chat_id, generation_id, revision, draft_context JSON,
  proposal_id, last_received_at, created_at/updated_at; unik owner_id+phone.
- ai_message_receipts: id/owner_id, wa_message_id, conversation_id, received_at, result_code, proposal_id,
  created_at; unik owner_id+wa_message_id untuk peristiwa calon order/order/pembatalan.
- Konteks hanya customer_name/address/service_hint/uncertain_address/confidence; obrolan non-order diabaikan.
  Receipt hanya metadata tanpa isi pesan; pesan sumber order mengikuti batas source_text yang ada.
- Kedua tabel hanya diakses RPC worker setelah pemetaan instance; tanpa akses langsung klien/LLM.
  Pembersihan akun ikut mencakup keduanya. Tidak menambah tabel Drift atau dependensi aplikasi.
- Indeks unik parsial ai_proposals(owner_id,phone) untuk Menunggu, tidak terhapus, phone tidak kosong.
  Pra-migrasi memeriksa duplikat lama; jika ada, berhenti tanpa menghapus/menutup data otomatis.

## Kontrak worker yang diusulkan
- RPC baru get_ai_conversation_context(p_instance_id,p_phone): layanan/pengaturan, ringkasan, status/versi;
  owner_id tidak diberikan ke LLM; identitas/versi dipegang node biasa.
- ingest_ai_proposal tetap memakai signature lama; payload ditambah action, draft_context,
  conversation_generation dan context_revision yang divalidasi; action default order untuk pemanggil lama.
- Action LLM: collect | order | cancel | ignore; nomor/owner/id/versi bukan hasil LLM.
- Hasil RPC: created | updated | closed | collected | ignored | duplicate | stale | retry | unknown_instance | invalid.
- Semua jalur ingest mengikuti satu usulan aktif. Node memakai versi konteks, pengurutan per nomor,
  serta receipt agar duplikat/pembatalan lama tidak menarik usulan baru; retry tidak menimpa konteks baru.
- Guard mengizinkan worker memperbarui isi usulan hanya selama Menunggu dan menutupnya otomatis.
  Penerimaan eksplisit pemilik dapat mengesahkan usulan yang ditutup AI lewat grup order+usulan yang valid.

## Verifikasi dan batas
- Uji lokal: pesan lengkap, konteks bertahap, pembaruan satu usulan, pembatalan, order baru setelah final,
  duplikat/terlambat, isolasi akun, dan penerimaan offline setelah penarikan; semua tanpa pembatalan uang.
- Pertahankan alur pembatalan order lama untuk data lama; jangan menghapus logika atau tesnya.
- Setelah disetujui: perbarui bagian Kontrak di plan utama, implementasi lokal, lalu GATE B7d; B7e menunggu.
