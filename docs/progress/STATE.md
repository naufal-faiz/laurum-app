# STATE Laurum
Diperbarui: 2026-11-19 | Cabang ai-whatsapp (dari backend-newdesign). Mode Integrasi AI WhatsApp.

## Sesi aktif
B7c (GATE di HP): diagnosis "Gagal sinkron" dan build ulang APK. Dasar commit 6895672.
Tidak membaca Figma.

## Status irisan
- Diagnosis 19 Nov 2026: banner "Gagal sinkron" di HP berasal dari build lama
  sebelum `36afd11` (canonical JSON menolak `confidence` pecahan). Kode HEAD
  dibuktikan lewat tes integrasi baru `test/sync/ai_proposal_sync_local_test.dart`
  di Supabase lokal (pull 0.9 -> setujui -> push -> server `disetujui`, `0.9`).
- APK release dibangun ulang dari HEAD dan dipasang (`adb install -r`, data aman).
  Sisa GATE: pengguna menekan "Sinkron sekarang", usulan tampil, disetujui.
- Skema Drift v6: `ai_proposals` (tanpa decided_at) + `wa_connections` (pull-only), migrasi
  v5->v6 createTable/createIndex, tes migrasi v1/v3/v4/v5 -> 6 lulus.
- `DriftProposalRepository` + pemetaan wire (tanpa sync_state/decided_at, kolom worker utuh).
- Kontrak ProposalRepository untuk InMemory dan Drift; InMemory menolak status id asing.
- Sinkron: ai_proposals push+pull, wa_connections pull, urutan pull, normalizer received_at/
  connected_at, fixture wire dan applier diperbarui.
- Usulan demo hanya akun demo; akun nyata memakai Drift dan berubah lewat accountChangesProvider.
- Skrip simulasi worker: supabase/scripts/simulate-worker.ps1 (kunci dari environment).
- Perbaikan B7c: canonical JSON menolak double, sehingga push gagal sebelum jaringan
  ("Gagal sinkron", attempts=0) begitu ada usulan dengan confidence pecahan. Sekarang
  0.9 ditulis apa adanya, setara teks jsonb; NaN/tak hingga/eksponen tetap ditolak.

## Keputusan pengguna terbaru
- B7a disetujui; B7b diterapkan ke cloud laurumdb oleh agen atas perintah pengguna (19 Nov 2026).
- Satu fase per sesi, berhenti di GATE. AI hanya membaca (AI-5); isolasi di server (AI-4).
- Usulan demo tidak boleh tampil di akun nyata (AI-7); akurasi AI hanya di build dummy (BE-6).

## Belum di-commit
Tidak ada setelah commit feat(b7c).

## Langkah berikutnya
1. GATE B7c: dengan APK baru, tekan "Sinkron sekarang"; pastikan usulan tampil,
   setujui, dan order terbentuk. Laporkan bila masih gagal.
2. B7d GATE: jalankan `./scripts/smoke.ps1` di laurum-infra (kunci hanya di
   environment pengguna) dan laporkan tabel enam kasus.
3. B7e: penautan WhatsApp manual + webhook ke n8n.
4. B7f: Edge wa-connect/wa-disconnect, status koneksi nyata (ganti Fake), set_ai_settings,
   kode pasangan (AI-8, perlu keputusan UI).
5. B7g/B7h: penyetelan prompt dengan sampel tersamarkan, lalu uji end-to-end.

## Blocker
- Sisa GATE B7c ada di HP pengguna (tekan "Sinkron sekarang" dengan APK baru ->
  usulan tampil -> setujui -> order terbentuk).
- B7d worker selesai di laurum-infra; enam kasus smoke menunggu kunci service role
  di environment pengguna dan instance pemilik kedua.
- APK 19 Nov 2026 13:30 (release, 78,6 MB) sudah terpasang di SM-N975F.

## Bukti terakhir
- `check_all`: SEMUA HIJAU, 1230 tes lulus, 3 skip, REPO_MAP 1188.
- Tes integrasi AI (Supabase lokal): pull usulan `confidence 0.9`, setujui, push ->
  server `status=disetujui`, `confidence=0.9` LULUS.
- `supabase test db`: Files=3, Tests=306, PASS (B7b; tanpa migrasi baru di B7c).
- Cloud laurumdb: migrasi 20261118090000 terpasang, terverifikasi lewat dump skema.
- APK release baru: build/app/outputs/flutter-apk/app-release.apk (19 Nov 2026 13:30).
