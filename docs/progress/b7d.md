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

## Uji Android lokal dengan UI terbaru (20 Nov 2026)
Pengguna meminta dan menyetujui merge `newdesign` 7dd054f ke `ai-whatsapp` agar
tarik-refresh ikut diuji. Kode tanpa konflik; konflik STATE/REPO_MAP diselesaikan
dengan mempertahankan konteks AI dan membuat ulang indeks. Versi gabungan:
check_all 1394 lulus/4 skip, keempat integrasi Supabase lokal 4/4 lulus.

Salinan debug `com.cashier.laurum.b7dlocal`, label **Laurum B7d Uji**, diperbarui
ke 1.0.3+4 tanpa menghapus data/login. Aplikasi asli tetap terpisah. Build berhasil
1m3s; pemasangan Success, versi terpasang diperiksa lewat dumpsys.
Android memakai Supabase lokal melalui `adb reverse tcp:54321 tcp:54321`.
Jika debug nirkabel putus, sambungkan ulang lalu pulihkan reverse. Akun cloud
tidak bisa dipakai login di lingkungan ini; fixture lokal sudah dimasukkan.

Worker dengan model yang sudah ada: pesan belum jelas menghasilkan nol usulan,
pesan order menghasilkan satu Menunggu untuk Ani, alamat Jalan Uji B7D nomor 1.
Setelah pembaruan aplikasi, inspeksi UI Antrean menampilkan 1 perlu dicek dan
kartu Ani dengan pesan sumber; status server tetap Menunggu, belum menjadi order.
Pengguna mengonfirmasi Ani muncul dan meminta melanjutkan pengujian.
Worker kemudian mengubah alamat dari Jalan Uji B7D nomor 1 menjadi nomor 2.
Usulan tetap ID yang sama, berstatus Menunggu, jumlah satu, tanpa order baru.
Pengguna mengonfirmasi alamat nomor 2 terlihat setelah refresh dan jumlah tetap satu.
Pesan order awal kemudian dikirim ulang dengan ID pesan yang sama: RPC benar-benar
mengembalikan `duplicate`, ID usulan tetap sama, alamat nomor 2 tidak tertimpa,
jumlah Menunggu tetap satu. Setelah bukti duplikat lulus, pembatalan dikirim via worker:
usulan yang sama menjadi `ditutup_otomatis`, Menunggu nol dan order_id tetap null.
Pengguna mengonfirmasi refresh menjadi nol dan Ani keluar dari Menunggu.
Order baru dari nomor sama membuat usulan `cf8f67c1-8116-4894-a67f-8b06dd4058fc`,
alamat Jalan Uji B7D nomor 3, status Menunggu satu; usulan lama tetap ditutup.
Pembatalan lama diulang: RPC `duplicate` merujuk usulan lama dan tidak menarik usulan baru.
Pengguna mengonfirmasi usulan baru/alamat nomor 3 terlihat di Android.

Temuan lanjutan: chat sumber menyebut 2 kg tetapi kolom berat kosong. Ini belum
diimplementasikan pada kontrak worker, model Proposal, tabel server/Drift dan inisialisasi
draf, bukan kegagalan penarikan atau duplikat. Tambahan disetujui pengguna dengan
syarat berat ditulis di chat; selain itu memakai empty state yang sudah ada.

## Tambahan perkiraan berat (lokal)
- Migrasi 20261120100000 menambah satu kolom nullable gram dan memperluas fungsi
  ringkasan/ingest/guard; data lama tetap null. Metadata server dipertahankan saat
  pemilik menyetujui cache lama. Tidak membuat order atau pembayaran dari worker.
- Drift v7 mempertahankan data v6 dan mengisi draf layanan kiloan dari perkiraan.
  Draf mengikuti pembaruan AI selama belum diedit; koreksi pemilik dipertahankan.
  State dipisah ke berkas data/controller untuk batas 100 baris, API lama tetap diekspor.
- Node biasa membaca angka+satuan yang eksplisit; field berat tebakan LLM diabaikan.
  2 kg/dua kilo -> 2000 gram, 2,5 kg -> 2500 gram; rentang ambigu tetap kosong.
  Pesan lanjutan mempertahankan berat yang sudah disebut, order baru tanpa berat null.
- Snapshot Dart v1-v6 tetap; JSON v6 yang sebelumnya tidak tersimpan dilengkapi dari
  v7 dengan menghapus hanya kolom baru. Migrasi diverifikasi memakai snapshot Dart v6
  yang sudah ada, sehingga data/kolom lama diuji independen dari snapshot baru.
- pgTAP 405 PASS; unit worker 41/41; n8n lokal 19 fixture/16 model nyata lulus
  (bukan benchmark akurasi). Tes draf, kontrak, migrasi dan persetujuan terarah lulus.
- Tes B7d lama kini membatasi query ke pemilik fixture agar data Android aktif tidak
  dihitung sebagai hasil tes. Tidak menghapus data pengujian Android yang sedang direview.
Fixture dan workflow sementara dipertahankan sampai rangkaian manual selesai;
lihat STATE.md untuk sesi harness dan cara membersihkannya.

## Penerapan cloud

Status 20 Nov 2026: `20261120090000_b7d_conversations.sql` dan
`20261120100000_b7d_estimated_weight.sql` sudah diterapkan ke `laurumdb` dan riwayat
migrasi remote cocok dengan lokal. Workflow published belum diperbarui; lakukan langkah 5
sebelum mengirim chat nyata.

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
   Pastikan hanya `20261120090000_b7d_conversations.sql`, lalu
   `20261120100000_b7d_estimated_weight.sql` yang tertinggal. Jika migrasi
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
