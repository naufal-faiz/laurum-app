# STATE Laurum
Diperbarui: 2026-11-20 | Cabang ai-whatsapp. Mode Integrasi AI WhatsApp.

## Sesi aktif
Tambahan berat eksplisit B7d selesai diimplementasikan dan diuji secara lokal.
Basis ee35403 (merge aplikasi ccfbc38). Worker basis f57bf4e, sudah diterbitkan
ke n8n lokal 20 Nov 2026.

## Status irisan
- User: isi berat hanya bila tertulis eksplisit dalam chat; tanpa atau ambigu memakai empty state lama.
- Migrasi lokal 20261120100000 menambah `estimated_weight_grams` nullable positif tanpa backfill.
  Fungsi context, ingest, guard, domain, Drift v7, pemetaan dan draf telah tersambung.
- Berat AI mengikuti refresh bila pemilik belum mengeditnya. Koreksi pemilik dipertahankan; layanan pcs
  tetap tidak memakai kg dan batas minimum berat lama tetap berlaku.
- Worker hanya membaca angka+satuan eksplisit. Nilai tebakan dari model diabaikan; konteks dapat membawa
  berat yang telah disebut, sedangkan order baru tanpa berat tetap kosong.
- Snapshot v6 dilengkapi hanya untuk migrasi v6 ke v7; snapshot Dart v1-v6 dan migrasi lama tidak diubah.
- Build Android lokal telah diperbarui: `com.cashier.laurum.b7dlocal` 1.0.3+4, skema v7, data uji utuh,
  reverse `tcp:54321` aktif. Usulan Ani yang ada masih berasal dari workflow manual sebelum perubahan berat.
- Kedua migrasi B7d telah diterapkan ke cloud `laurumdb`: riwayat remote cocok dengan lokal.
  Worker n8n sudah published dari infra f57bf4e (8 node, berat eksplisit), credential
  Supabase dan LLM dipertahankan, satu flow aktif untuk /wa-ingest. B7e belum dimulai.
- `com.cashier.laurum` (bukan varian b7dlocal) sudah dibangun ulang dari HEAD: debug 1.0.3,
  skema v7, sesi cloud lama utuh; dipakai untuk verifikasi UI berat 20 Nov 2026.
- Backlog pembatalan tanpa order sudah ditutup di dbb1ad1 (`UnlinkedCancellation`): usulan
  tetap menunggu dan pemilik melihat pesan; tes proposal_unlinked_cancellation_test 4/4 lulus
  (diverifikasi ulang 20 Nov 2026, tanpa perubahan kode).

## Keputusan pengguna terbaru
- Izin khusus ADD COLUMN ai_proposals, Drift dan perluasan kontrak diberikan.
- Tanpa berat eksplisit gunakan empty state, bukan tebakan. Order tetap disetujui pemilik.
- Merge newdesign dan debug lokal sudah diizinkan. AI hanya membaca.

## Belum di-commit
Tidak ada perubahan kode aplikasi.

## Langkah berikutnya
1. Smoke infra enam kasus menunggu SUPABASE_SERVICE_ROLE_KEY di terminal pemilik.
2. Setelah GATE adopsi B7d ditutup, baru susun prompt B7e.

## Blocker
Tidak ada. Verifikasi UI 20 Nov 2026 (build debug 1.0.3, skema v7): usulan "2 kg"
menampilkan BERAT 2 kg dan total Rp10.000; usulan tanpa berat menampilkan
"Belum diketahui" dengan total belum dihitung. Dua usulan uji 081300000101 dan
081300000102 masih Menunggu dan perlu diputuskan pemilik.

## Bukti terakhir
- check_all hijau: 1.407 lulus, 4 dilewati.
- Supabase SQL 405 lulus; 4 integrasi lokal lulus; Edge Function 6 lulus.
- Worker unit 41/41 lulus; n8n lokal sebelumnya 19 fixture dan 16 dengan kredensial LLM yang ada lulus,
  bukan pengukuran akurasi. Draf/kontrak/persetujuan terarah 26, migrasi 4, dan migrasi lama 8 lulus.
- Cloud: dry-run hanya menemukan dua migrasi B7d, lalu keduanya berhasil diterapkan dan terdaftar remote.
ya berhasil diterapkan dan terdaftar remote.
