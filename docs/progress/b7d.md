# B7d - Percakapan dan penarikan usulan

Implementasi lokal, 20 Nov 2026. Addendum disetujui pengguna; kontrak tunggal:
`docs/plans/B7-ai-integrasi.md`, bagian Kontrak. B7e belum dimulai; tanpa APK baru.

## Hasil
- Satu usulan Menunggu per pemilik+nomor webhook. Konteks terstruktur dikumpulkan
  sebelum order jelas; pesan lanjutan memperbarui usulan yang sama.
- Pembatalan menarik usulan ke riwayat; setelah keputusan final, order baru boleh
  menghasilkan usulan baru. AI tidak membatalkan order, pembayaran atau tabungan.
- Penerimaan pemilik dari cache offline tetap bisa disinkronkan walau AI menarik
  usulan. Metadata AI terbaru dipertahankan server. Pengaman pembatalan lama tetap.
- Receipt metadata mencegah pemrosesan ulang; versi konteks memicu pembacaan ulang
  jika ada perubahan bersamaan. Maksimal tiga percobaan lalu galat terkontrol.
- Dua tabel baru hanya di server, tanpa arsip chat mentah; hapus akun ikut membersihkan.
  Aplikasi memakai repository/Drift/sinkron B7c yang sudah ada, tanpa migrasi Drift.

## Batas hasil lokal
Workflow utama n8n yang mengarah ke cloud tetap versi sebelumnya. Pengujian baru
memakai workflow sementara, dua akun fixture Supabase lokal, serta credential LLM
yang sudah tersedia melalui referensinya. Fixture sintetis bukan ukuran akurasi.
Workflow/data/akun pengujian dibersihkan; credential dan workflow utama dipertahankan.
Compose membatasi eksekusi produksi n8n menjadi satu untuk tahap uji ini. Ini
membatasi throughput; revisi dan receipt server tetap melindungi perubahan bersamaan.

## Bukti pengujian lokal
- `supabase test db --workdir .`: 4 berkas, 375 tes PASS (69 addendum B7d).
- `npm test --prefix supabase`: 6/6; unit worker 26/26; logika smoke 9/9.
- Harness n8n: 14 skenario fixture deterministik lulus, termasuk konflik/retry;
  11 skenario dengan credential LLM nyata yang sudah ada lulus, tetap ke DB lokal.
- `flutter test test/sync/b7d_offline_accept_local_test.dart`: 1/1 lulus;
  membuktikan order+usulan dari Drift diterima setelah penarikan AI, outbox kosong,
  lalu metadata confidence terbaru kembali ke Drift melalui pull.
- Sembilan body fungsi runtime cocok persis dengan migrasi akhir. Empat layanan
  worker healthy; workflow sementara tersisa nol, workflow utama published satu.
- `dart run tool/check_all.dart`: SEMUA HIJAU; 1234 lulus, 4 skip;
  format/analyze/Riverpod/check_arch lulus, REPO_MAP 1190 berkas.
- Keempat tes integrasi yang skip dijalankan terpisah dengan Supabase lokal:
  confidence, isolasi akun, sinkron dua perangkat dan penerimaan offline; 4/4 lulus.

## Penerapan cloud - dilakukan pemilik, bukan agen
1. Cadangkan database dan ekspor versi published workflow n8n melalui UI; simpan
   ekspor berkredensial secara privat. Unpublish worker sampai migrasi selesai.
2. Di SQL Editor proyek tujuan, periksa duplikat tanpa menampilkan isi chat:
   `select owner_id, phone, count(*) from public.ai_proposals where status='menunggu'
   and deleted_at is null and phone<>'' group by owner_id,phone having count(*)>1;`
   Jika ada, putuskan sendiri usulan yang dipertahankan lewat aplikasi; jangan
   hapus/menutup otomatis. Migrasi berhenti bila duplikat belum diselesaikan.
3. Dari repo aplikasi, dengan login CLI milik Anda dan project ref yang sudah Anda
   periksa, jalankan (placeholder diganti sendiri, jangan kirim kunci ke agen):
   `supabase db push --remote=<project-ref> --dry-run --skip-vault --workdir .`
   Pastikan hanya `20261120090000_b7d_conversations.sql` yang tertinggal. Jika migrasi
   lain muncul, berhenti dan cocokkan riwayat dahulu. Kemudian jalankan perintah
   yang sama tanpa `--dry-run`. Jangan memakai `--include-all` atau seed.
4. Periksa kedua tabel sudah ada, RLS aktif, authenticated tidak punya SELECT/
   INSERT/UPDATE, service_role hanya SELECT tabel. RPC baru harus ada dan EXECUTE
   hanya service_role. Contoh pemeriksaan tanpa rahasia:
   `select relname,relrowsecurity from pg_class where relname in
   ('ai_conversation_contexts','ai_message_receipts');`
   `select has_table_privilege('authenticated','public.ai_conversation_contexts','SELECT'),
   has_table_privilege('service_role','public.ai_conversation_contexts','INSERT');`
   Hasil: dua RLS true; kedua pemeriksaan hak false. Ulangi hak untuk receipts.
5. Di repo laurum-infra: `docker compose up -d n8n` menerapkan concurrency=1.
   Buka workflow utama yang sudah ada di UI, Import from File dari
   `workflows/wa-ai-ingest.json` ke canvas itu, pasang kembali credential Supabase dan LLM
   melalui UI pada tiga HTTP node, periksa tujuan proyek, lalu Publish workflow
   utama. Impor menimpa referensi credential; jangan memakai JSON bersih tanpa
   memasang credential. Pastikan hanya satu workflow published untuk `/wa-ingest`.
   `docker compose restart n8n`, lalu `docker compose ps`.
6. Jalankan enam kasus `scripts/smoke.ps1` sesuai `docs/B7d-setup.md` di infra;
   tambahkan rangkaian percakapan: belum jelas -> order -> ubah alamat -> batal ->
   order baru. Di aplikasi, sinkron dan pastikan hanya satu Menunggu per nomor,
   penarikan pindah ke riwayat, dan order yang diterima muncul di antrean.
   Masukkan rahasia di perangkat sendiri; laporkan hanya hasil kasus, bukan nilai.

## Membatalkan penerapan
Unpublish worker dahulu jika ada kegagalan; aplikasi dan order yang sudah ada
tetap dipertahankan. Jangan DROP tabel, menghapus receipt, atau memutar ulang
pesan lama. Pertahankan skema baru dan gunakan migrasi perbaikan maju. Versi lama
worker tidak memahami konteks; jangan mengaktifkannya sebagai rollback otomatis.

GATE: pengujian lokal dicatat di STATE; adopsi cloud dan pemeriksaan aplikasi oleh
pemilik masih diperlukan. WhatsApp asli/penautan menunggu fase B7e.
