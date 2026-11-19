# STATE Laurum
Diperbarui: 2026-11-19 | Cabang ai-whatsapp (dari backend-newdesign). Mode Integrasi AI WhatsApp.

## Sesi aktif
B7c (aplikasi: Drift v6, repository usulan, sinkron). Dasar commit 0dc8a65. Tidak membaca Figma.

## Status irisan
- Skema Drift v6: `ai_proposals` (tanpa decided_at) + `wa_connections` (pull-only), migrasi
  v5->v6 createTable/createIndex, tes migrasi v1/v3/v4/v5 -> 6 lulus.
- `DriftProposalRepository` + pemetaan wire (tanpa sync_state/decided_at, kolom worker utuh).
- Kontrak ProposalRepository untuk InMemory dan Drift; InMemory menolak status id asing.
- Sinkron: ai_proposals push+pull, wa_connections pull, urutan pull, normalizer received_at/
  connected_at, fixture wire dan applier diperbarui.
- Usulan demo hanya akun demo; akun nyata memakai Drift dan berubah lewat accountChangesProvider.
- Skrip simulasi worker: supabase/scripts/simulate-worker.ps1 (kunci dari environment).

## Keputusan pengguna terbaru
- B7a disetujui; B7b diterapkan ke cloud laurumdb oleh agen atas perintah pengguna (19 Nov 2026).
- Satu fase per sesi, berhenti di GATE. AI hanya membaca (AI-5); isolasi di server (AI-4).
- Usulan demo tidak boleh tampil di akun nyata (AI-7); akurasi AI hanya di build dummy (BE-6).

## Belum di-commit
Tidak ada setelah commit feat(b7c).

## Langkah berikutnya
1. GATE B7c: jalankan skrip simulasi (docs/progress/b7c.md), cek usulan di HP, setujui, order jadi.
2. B7d: laurum-infra (compose Evolution+Postgres+Redis+n8n, flow n8n tunggal, prompt JSON).
3. B7e: penautan WhatsApp manual + webhook ke n8n.
4. B7f: Edge wa-connect/wa-disconnect, status koneksi nyata (ganti Fake), set_ai_settings,
   kode pasangan (AI-8, perlu keputusan UI).
5. B7g/B7h: penyetelan prompt dengan sampel tersamarkan, lalu uji end-to-end.

## Blocker
- GATE B7c butuh service role key di mesin pengguna (tidak lewat agen, AI-3).
- APK terakhir 1.0.2 code 3 (build/app/outputs/flutter-apk), belum dibangun ulang.

## Bukti terakhir
- `check_all`: SEMUA HIJAU, 1230 tes lulus, 2 skip, REPO_MAP 1187 (B7c).
- `supabase test db`: Files=3, Tests=306, PASS (B7b; tanpa migrasi baru di B7c).
- Cloud laurumdb: migrasi 20261118090000 terpasang, terverifikasi lewat dump skema.
