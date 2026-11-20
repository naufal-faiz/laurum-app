# STATE Laurum
Diperbarui: 2026-11-20 | Cabang ai-whatsapp. Mode Integrasi AI WhatsApp.

## Sesi aktif
Tambahan berat eksplisit B7d selesai diimplementasikan dan diuji secara lokal.
Basis ee35403 (merge aplikasi ccfbc38). Worker basis 8444f13, kode lama 18e5105.

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
- Workflow utama cloud tidak diubah dan cloud belum dimigrasi. B7e belum dimulai.

## Keputusan pengguna terbaru
- Izin khusus ADD COLUMN ai_proposals, Drift dan perluasan kontrak diberikan.
- Tanpa berat eksplisit gunakan empty state, bukan tebakan. Order tetap disetujui pemilik.
- Merge newdesign dan debug lokal sudah diizinkan. AI hanya membaca.

## Belum di-commit
Implementasi berat, migrasi/snapshot, tes dan dokumen di kedua repo; commit setelah catatan ini.

## Langkah berikutnya
1. Terapkan kedua migrasi B7d ke cloud sesuai docs/progress/b7d.md, lalu terbitkan worker dari repo infra.
2. Kirim chat nyata dari HP kedua: order dengan `2 kg`, lalu pastikan Periksa Ani mengisi 2 kg setelah refresh.
3. Uji satu chat order tanpa berat untuk memastikan field tetap kosong.
4. Setelah GATE adopsi B7d dilaporkan pengguna, baru susun prompt B7e.

## Blocker
Tidak ada blocker kode. Verifikasi chat nyata/cloud dan keputusan GATE adalah langkah pemilik.

## Bukti terakhir
- check_all hijau: 1.407 lulus, 4 dilewati.
- Supabase SQL 405 lulus; 4 integrasi lokal lulus; Edge Function 6 lulus.
- Worker unit 41/41 lulus; n8n lokal sebelumnya 19 fixture dan 16 dengan kredensial LLM yang ada lulus,
  bukan pengukuran akurasi. Draf/kontrak/persetujuan terarah 26, migrasi 4, dan migrasi lama 8 lulus.
