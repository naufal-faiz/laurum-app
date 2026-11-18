# STATE Laurum
Diperbarui: 2026-11-18 | Cabang ai-whatsapp (dari backend-newdesign). Mode Integrasi AI WhatsApp.

## Sesi aktif
B7a (audit + rancangan skema AI, dokumen saja), dasar commit 72b3685. Tidak membaca Figma.

## Status irisan
- Selesai: docs/plans/B7a-skema.md (60 baris: kolom/tipe/constraint/indeks dua tabel, RLS per
  operasi, padanan Proposal dan ProposalStatus, 4 RPC, alur keputusan tanpa INSERT klien,
  lokasi pengaturan AI).
- Selesai: docs/progress/b7a.md (audit berkas per fase B7b-B7f, 8 temuan, risiko migrasi cloud,
  rekomendasi + 5 pertanyaan GATE, catatan PRD).
- Tanpa kode Dart, migrasi, Edge Function, dependensi, atau sentuhan Supabase cloud (AI-2/AI-3).
- B7b belum ditulis dan tidak boleh dimulai sebelum GATE disetujui.

## Keputusan pengguna terbaru
- B7 dikerjakan satu fase per sesi, berhenti di tiap GATE (docs/plans/B7-ai-integrasi.md).
- B3b BELUM dan tidak memblokir B7 (18 Nov 2026). Jalur Evolution API hanya untuk uji internal.
- Satu flow n8n multi-user; isolasi ditegakkan server (AI-4). AI hanya membaca (AI-5).
- Skema ai_proposals/wa_connections: MENUNGGU persetujuan di GATE B7a.

## Belum di-commit
Tidak ada; commit docs(b7a) mencakup B7a-skema.md, b7a.md, INDEX.md, dan STATE.md.

## Langkah berikutnya
1. GATE B7a: setujui docs/plans/B7a-skema.md dan jawab pertanyaan a-e di docs/progress/b7a.md.
2. Setelah disetujui: tulis prompt B7b (migrasi lokal + RLS + RPC + pgTAP lintas akun), lalu
   docs/progress/b7b.md berisi langkah terapan cloud untuk pengguna.
3. B7c: Drift v6 dua tabel, DriftProposalRepository + suite kontrak, sinkron pull, lepas usulan
   demo di akun nyata, skrip simulasi worker.
4. B7d/B7e di repo laurum-infra; B7f Edge wa-connect/wa-disconnect + set_ai_settings + status
   koneksi nyata (ganti FakeWhatsappConnection) + kode pasangan (AI-8, perlu keputusan UI).
5. B3b menunggu akun uji/peti surat; B2e foto pengeluaran tertunda.

## Blocker
- Supabase lokal (Docker Desktop) belum tersedia saat pemeriksaan; B7b butuh `supabase test db`.
- APK terakhir 1.0.2 code 3 (build/app/outputs/flutter-apk), belum dibangun ulang.

## Bukti terakhir
- check_all SEMUA HIJAU (baseline B7a): 1216 tes lulus, 2 skip (Supabase lokal), REPO_MAP 1179.
- Hanya berkas docs yang ditambah setelah baseline; repo_map dijalankan ulang setelah commit.
