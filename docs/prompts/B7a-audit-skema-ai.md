# B7a - Audit dan rancangan skema AI WhatsApp

Ikuti _COMMON.md bagian A (kecuali A.3 dan A.4) dan F. Rencana: docs/plans/B7-ai-integrasi.md. Aturan: AGENTS.md Mode Integrasi AI WhatsApp (AI-1 sampai AI-12) di atas Mode Backend.
Pengecualian A.3: B3b berstatus BELUM dan TIDAK memblokir B7 (keputusan pengguna 18 Nov 2026). A.4 tidak berlaku (tidak membaca Figma/.pen).
Prasyarat: branch ai-whatsapp sudah dibuat pengguna dari backend-newdesign dan check_all hijau; selain itu berhenti dan lapor.
Fase ini DOKUMEN SAJA: tanpa kode Dart, tanpa migrasi, tanpa Edge Function, tanpa dependensi, tanpa menyentuh Supabase cloud.

## Hasil yang diminta
1. Audit singkat (baca terarah lewat REPO_MAP.md, tanpa membaca PRD utuh): Proposal, ProposalRepository, InMemoryProposalRepository, drift_repository_overrides.dart, proposal_*.dart di state, ai_settings.dart, whatsapp_link.dart, shell_state.dart (FakeWhatsappConnection), supabase/migrations 0001-0004 + b2a (pola owner_id, RLS, stamp_record, sync_push, daftar tabel yang boleh disinkron), pola supabase/functions/delete-account, cara tabel baru didaftarkan di core/sync dan core/persistence (wire schema, Drift schema_migration, kontrak repository). Laporkan sebagai tabel: file yang akan berubah per fase B7b-B7f. Maksimal 40 baris.
2. Tulis docs/plans/B7a-skema.md (maks 60 baris): kolom, tipe, constraint, dan indeks ai_proposals dan wa_connections; RLS per operasi; padanan setiap field Proposal ke kolom; padanan ProposalStatus ke nilai database; rancangan tiga RPC service-role (tanda tangan, kode galat, idempotensi); cara keputusan pemilik (setujui, tolak, batal, edit nama/telepon/alamat/layanan) sampai ke server tanpa memberi klien INSERT; pengaturan AI (3 saklar) disimpan di mana.
3. Jawab dengan rekomendasi dan alasan (satu baris tiap butir), lalu TANYA pengguna maksimal 5 pertanyaan sekaligus:
   a. Keputusan pemilik dikirim lewat sync_push (tabel baru masuk daftar) atau RPC khusus?
   b. Status koneksi di layar penautan: polling singkat atau Realtime?
   c. Retensi source_text usulan yang sudah disetujui/ditolak (hapus otomatis setelah berapa hari, atau disimpan)?
   d. Kolom tambahan wa_message_id, chat_id, confidence: diterima atau diubah?
   e. Satu koneksi per akun (v1) cukup, atau sediakan kunci unik yang memungkinkan lebih dari satu nanti?
4. Daftar temuan yang membuat rencana B7 perlu diubah (bila ada) dan risiko migrasi pada database cloud yang sudah berisi data.
5. Perbarui STATE.md (format UI-34) dan baris B7a di INDEX.md. Commit docs: "docs(b7a): rancangan skema AI". BERHENTI di GATE: tunggu pengguna menyetujui skema. Jangan menulis prompt B7b.

## Larangan khusus
- Tidak menulis SQL migrasi sungguhan; contoh SQL di dokumen hanya sketsa kolom.
- Tidak menyentuh docs/prd (usulan perubahan PRD ditulis sebagai catatan di B7a-skema.md, pengguna yang memutuskan).
- Tidak meminta, membaca, atau menulis kunci apa pun (AI-3).
