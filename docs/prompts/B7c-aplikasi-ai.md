# B7c - Aplikasi AI WhatsApp (Drift + repository + sinkron)

Ikuti _COMMON.md bagian A (kecuali A.3 dan A.4) dan F. Rencana: docs/plans/B7-ai-integrasi.md;
skema terpasang: docs/progress/b7b.md. Aturan: AGENTS.md Mode Integrasi AI WhatsApp + Mode Backend.
Prasyarat: branch ai-whatsapp; B7b SELESAI dan migrasi sudah di cloud; check_all hijau.

## Hasil yang diminta
1. Drift v6: tabel `ai_proposals` (tanpa `decided_at`) dan `wa_connections` (pull-only), migrasi
   dari v5 + tes migrasi, nama tabel/kolom sama dengan server agar applier generik bekerja.
2. `DriftProposalRepository` + suite kontrak ProposalRepository untuk InMemory dan Drift.
3. `syncPushTables` + ai_proposals, `syncPullTables` + wa_connections, urutan pull, normalizer
   timestamp (`received_at`, `connected_at`), payload tanpa `sync_state`/`decided_at`.
4. Usulan demo hanya untuk akun demo; akun nyata memakai Drift (tanpa fixture).
5. Skrip simulasi worker (PowerShell, service role dari environment) untuk GATE.
6. `check_all` hijau + bukti angka; docs/progress/b7c.md; STATE.md; INDEX.md; satu commit.

## Larangan khusus
- Tanpa perubahan tampilan, tanpa RPC/migrasi Supabase baru, tanpa kunci di repo (AI-3, BE-1).
- Perilaku uang tetap di TransactionRunner; tidak ada jalur tulis usulan selain keputusan pemilik.
- Jangan menambah kolom `decided_at` di klien: retry sync harus identik dengan baris server.
