# ROADMAP Backend Laurum (4 Nov 2026)
Dasar: PRD B (bagian 3.1-3.3, 14, 16) dan audit dev1rev. Prinsip: lokal dulu, server belakangan, satu fase satu hasil yang bisa diuji.

## Urutan dan ukuran
| Fase | Isi | Ukuran | Bergantung pada | Tindakanmu |
| --- | --- | --- | --- | --- |
| 100 | Audit akhir UI dummy, APK | Sedang | R10 | Pasang Android SDK, uji di HP (COD, bayar sebagian, akun, struk) |
| BP0 | Persiapan: IdGenerator, tes kontrak, antarmuka rentang, local_settings, aturan | Sedang | 100 | - |
| B0 | Supabase lokal: skema, RLS, RPC, tes RLS | Besar | BP0 | Pasang Docker Desktop dan Supabase CLI |
| B1a-f | Drift/SQLite menggantikan InMemory | Besar (6 prompt) | BP0 (B0 tidak wajib) | - |
| B2 | SyncEngine | Besar | B0, B1f | - |
| B3 | Auth nyata, pemulihan, hapus akun | Sedang | B2 | Buat proyek Supabase cloud (gratis), OAuth client Google + SHA-1, pilih penyedia SMTP |
| B5 | Printer nyata | Sedang | B1f | Printer 58 mm fisik |
| B6 | Persiapan Play Store | Sedang | B3, B5 | Akun Play Console |
| B7 | AI | Besar | B3 | Putuskan jalur WhatsApp |
| B8 | Pro | Kecil-sedang | B6 | - |

B0 dan B1 tidak saling bergantung. Urutan di INDEX: B1 dulu (hasilnya langsung terlihat: data bertahan setelah aplikasi ditutup), lalu B0 (butuh Docker). B2 butuh keduanya.

## Mengapa begini
- Wiring ke aplikasi baru dilakukan di B1f, setelah semua repository lolos tes kontrak. Mode campuran (order di memori, pelanggan di database) tidak konsisten.
- Outbox ditulis sejak B1 supaya B2 tidak perlu membongkar semua repository lagi.
- Laporan dari ledger masuk B1e: baseline fixture tidak punya padanan di database.
- Pengembangan memakai Supabase lokal (Docker): tanpa biaya dan tanpa risiko mengubah proyek cloud. Cloud baru dipakai di B3.

## Temuan teknis yang dibereskan lebih awal
1. ID fixture dan ID turunan bergaya teks (`ord-0137`, `<orderId>-pay-cash`, `-payment-N`) tidak cocok dengan kolom uuid dan bisa bentrok antar perangkat -> IdGenerator (BP0).
2. API repository mengembalikan semua baris -> metode rentang tanggal (BP0), query SQL (B1d/B1e).
3. Counter pending sinkron dummy per mutasi -> jumlah baris outbox (B1f).
4. `ownerId` fixture statis -> berasal dari sesi; database per akun (B1a).
5. Preferensi: tanpa shared_preferences (PRD B 3.2).

## Biaya (cek ulang sebelum memutuskan)
- Pengembangan: Rp0 (Supabase lokal, Drift, Docker Desktop gratis untuk penggunaan pribadi).
- Supabase cloud: paket gratis dengan batas yang tercatat di PRD B bagian 8 (diperiksa Juli-Agustus 2026); Pro sekitar US$25/bulan sebelum rilis luas.
- SMTP kustom untuk konfirmasi/reset email: pilih penyedia dengan paket gratis; cek batas kirim.
- Google Play Console: biaya pendaftaran sekali bayar (sekitar US$25, cek ulang). iOS hanya bila diputuskan (PRD B bagian 17).

## Risiko
- SQLite di `flutter test` pada Windows: agen harus memverifikasi cara menjalankan (NativeDatabase.memory). Jika perlu pustaka native, catat langkahnya di README.
- Fixture laporan tidak bisa direkonsiliasi dari order yang ada: JANGAN menciptakan baseline; laporkan dan minta izin mengubah angka DATA MASTER.
- Ganti akun di satu HP: terselesaikan oleh database per akun.
- Fitur AI/usulan/pengaturan AI tetap in-memory sampai B7: data hilang saat restart. Catat di UI/dokumen, jangan disembunyikan.
- Satu perangkat per akun (default); multi-perangkat butuh keputusan ulang soal nomor nota dan konflik.

## Prompt yang belum ditulis (sengaja)
B2, B3, B5-B8 ditulis setelah B1f selesai, memakai temuan nyata B1. Minta saya menyusunnya saat B1f SELESAI.
