# STATE Laurum
Diperbarui: 2026-11-20 | Cabang ai-whatsapp. Mode Integrasi AI WhatsApp.

## Sesi aktif
Addendum percakapan B7d selesai diimplementasikan dan diuji lokal; GATE adopsi.
Dasar aplikasi 6831cfa; worker laurum-infra 7839bc5. Tidak memulai B7e.

## Status irisan
- B7a/B7b selesai; B7c GATE lulus menurut pengujian sinkron/antrean oleh pengguna.
- B7d: konteks terstruktur sebelum order jelas; satu Menunggu per pemilik+nomor;
  pesan lanjutan memperbarui usulan, pembatalan menarik ke ditutup_otomatis.
- Setelah final boleh order baru; receipt/generasi/revisi melindungi duplikat,
  pesan lama dan konflik. Worker retry membaca ulang konteks/model maksimal 3 kali.
- Penerimaan dari cache offline tetap tersinkron dengan order valid; AI tidak
  membatalkan order/uang. Pengaman pembatalan legacy tetap dipertahankan.
- Migrasi baru 20261120090000: dua tabel server-only, RPC/guard/cleanup dan indeks;
  tidak mengubah migrasi lama, skema Drift, tampilan, dependensi atau logika uang.
- Harness n8n terisolasi ke DB lokal; seluruh fixture/workflow sementara dibersihkan.
- Workflow utama yang menuju cloud tetap versi sebelumnya; sumber addendum belum
  dipublikasikan. Compose concurrency=1 menunggu adopsi, bukan throughput produksi.

## Keputusan pengguna terbaru
- Satu usulan Menunggu per nomor; rangkum pesan, buat hanya bila niat order jelas.
- Batal menarik usulan; setelah disetujui/ditolak/ditutup boleh usulan order baru.
- Order dari persetujuan offline tetap milik keputusan pemilik, tanpa pembatalan AI.
- Addendum skema/kontrak disetujui; agen hanya mengimplementasikan Supabase lokal.
- Tidak membuat APK setiap coding. AI hanya membaca; urut GATE, B7e menunggu.

## Belum di-commit
Tidak ada setelah commit tugas ini; implementasi dan bukti disimpan di kedua repo.

## Langkah berikutnya
1. Pemilik menerapkan migrasi cloud dan publish worker sesuai docs/progress/b7d.md.
2. Pemilik memeriksa usulan/penarikan di aplikasi; B7e setelah GATE B7d lulus.
3. Penautan WhatsApp nyata dan pengaturan/koneksi aplikasi menunggu B7e/B7f.

## Blocker
Adopsi cloud harus dilakukan pemilik; tidak mengakses cloud atau membangun APK.
Chat WhatsApp asli belum diuji; hasil fixture bukan angka akurasi.

## Bukti terakhir
- supabase test db: Files=4, Tests=375 PASS (69 tes B7d); npm test: 6/6.
- Worker unit 26/26; smoke logic 9/9; n8n lokal 14/14 fixture, 11/11 LLM nyata
  dengan credential yang sudah ada, tetap ke DB lokal (bukan benchmark akurasi).
- Drift->sync_push->pull offline setelah penarikan AI: 1/1 lulus, outbox kosong.
- 9 body fungsi runtime cocok dengan migrasi akhir; 4 layanan worker healthy;
  workflow uji tersisa=0, workflow utama published=1.
- check_all: SEMUA HIJAU, 1234 lulus/4 skip; REPO_MAP 1190 berkas.
- Keempat skip dijalankan terpisah ke Supabase lokal: 4/4 lulus (confidence,
  isolasi akun, dua perangkat, persetujuan offline setelah penarikan AI).
- Tidak ada APK baru. Rincian dan panduan adopsi: docs/progress/b7d.md.
