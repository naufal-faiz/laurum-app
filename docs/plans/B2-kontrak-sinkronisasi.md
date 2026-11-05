# Usulan B2 — sinkronisasi yang mempertahankan nota dan ledger
Status: DRAF UNTUK PERSETUJUAN; belum mengizinkan perubahan PRD atau implementasi B2.
Dasar: PRD B7–9, hasil B0/B1f, OrderEdit dan OutboxWriter yang sudah diverifikasi.
Tujuan: perubahan offline sampai ke server/perangkat lain tanpa nota setengah berubah,
tanpa pembayaran ganda, tanpa menimpa perubahan lokal yang masih menunggu kirim.

## Keputusan yang diminta
1. Item nota boleh diubah/soft-delete selama nota belum selesai/dibatalkan, sesuai
   editor yang sudah ada. Setelah final, item dan nilai transaksi dikunci server.
   Payments, savings_entries dan order_events tetap append-only; tidak ada hard delete item.
2. Satu operasi bisnis (nota+item, pembayaran+tabungan, pembatalan+koreksi) disinkronkan
   atomik. Konflik satu anggota menggagalkan seluruh operasi, dengan hasil per outbox.
3. Izinkan revisi PRD B5/7/8 yang terbatas pada dua aturan di atas, metadata kelompok,
   cursor pasangan waktu+ID serta jaminan pull tidak melewatkan commit terlambat.
4. Izinkan dependensi B2 yang sudah disebut PRD: supabase_flutter, connectivity_plus,
   workmanager. Instal pada kelompok yang memakainya lewat flutter pub add; jangan tebak versi.

## Pelaksanaan berurutan (usulan agen)
- B2a: kontrak server, migrasi baru (jangan ubah empat migrasi B0), penjaga item/final,
  RPC grup idempoten, paginasi/pengurutan aman dan pgTAP; prompt draf B2a tersedia.
- B2b: Drift v5 untuk metadata grup outbox, migrasi+tes, penyimpanan ack/konflik,
  SyncEngine dengan transport palsu; suite kontrak InMemory dan Drift bila ada antarmuka baru.
- B2c: adapter Supabase, push/pull nyata dua akun lokal dan pemetaan seluruh tabel B1.
- B2d: indikator/aksi sinkron yang sudah ada, debounce/retry/foreground/koneksi/periodik;
  nonaktif saat sesi Auth masih stub atau identitas tidak cocok, sampai B3.
- B2e: antrean foto JPEG<=200KB, upload privat/penggantian path dan retry. Jika perlu
  paket kompresi baru, ajukan tersendiri; tidak ada izin paket tambahan selain butir4.

## Jaminan yang wajib diuji
Grup mempunyai UUID dan hash isi tetap; retry setelah respons hilang mengembalikan
hasil lama tanpa menjalankan ulang edit. Maks50 perubahan per request; grup lebih besar
distaging per pemilik dan belum terlihat di tabel bisnis sebelum seluruh grup valid/commit.
COD selesai dan pembayaran dalam satu grup divalidasi pada keadaan akhir transaksi.
Ack hanya menghapus ID outbox yang dikirim; edit baru saat request berjalan tetap pending.
Pull maks500 memakai (updated_at,id) dengan presisi UTC enam digit, mencakup tombstone,
dan tidak kehilangan commit terlambat. Pending/konflik lokal tidak ditimpa.
Migrasi antrean lama tidak boleh membuang data atau menebak grup dari waktu yang sama;
protokol pemulihan eksplisit dan teruji diperlukan sebelum antrean lama dikirim.
Setiap kelompok: check_all hijau, bukti integrasi yang relevan, STATE/INDEX dan commit,
lalu berhenti untuk tinjauan. Cloud/OAuth/SMTP belum diperlukan; itu tahap B3.
