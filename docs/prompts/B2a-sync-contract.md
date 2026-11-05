# B2a — kontrak server untuk sinkronisasi nota

DRAF; JANGAN DIEKSEKUSI sebelum pengguna menyetujui docs/plans/B2-kontrak-sinkronisasi.md.
INDEX tetap MENUNGGU sampai persetujuan dicatat. Ikuti _COMMON.md A,D,E,F dan AGENTS19–22.
Prasyarat: B0/B1f selesai; baca STATE, progress/b0.md, progress/b1f.md dan PRD B5–9.

## Izin yang diminta (belum berlaku)
- Revisi terbatas PRD B5/7/8 sesuai usulan: item mutable sebelum final, atomisitas grup,
  metadata protokol dan pull yang aman. Jangan mengubah fitur laundry, UI atau registry.
- Tambah migrasi Postgres melalui CLI migration new, pgTAP, tes runtime dan README.
- B2a tidak memasang paket Flutter. Dependensi B2 baru dipasang pada kelompok terkait
  setelah persetujuan paket pada usulan induk; versi di-resolve flutter pub add.
- Tanpa cloud/link/db push, service_role di aplikasi, token/env di repo, push atau merge.

## Hasil B2a
1. Catat persetujuan nyata pengguna, baru sesuaikan PRD pada bagian yang diizinkan.
   Jangan menganggap isi draf ini sendiri sebagai persetujuan pengguna.
2. order_items: insert/update/soft-delete hanya ketika order milik sendiri belum final.
   id/owner/order_id tidak dapat diganti. Tidak ada DELETE klien. Lindungi status
   final dan nilai nota final dari jalur RPC maupun REST biasa; role cleanup tetap sempit.
   Pembayaran/tabungan/event tetap immutable, termasuk service role biasa.
3. Perluas sync_push lewat migrasi baru: owner dari JWT, whitelist, schema minimum baru,
   group_id/change_id UUID dan hash isi. Hasil tetap dapat dipetakan ke tiap outbox.
   Konflik menyebabkan rollback seluruh grup, bukan mengakui sebagian anggota berhasil.
   Grup lain tetap terisolasi; kode error generik tanpa data pelanggan/pesan SQL mentah.
4. Retry grup identik setelah respons hilang harus mengembalikan receipt commit yang
   sama; jangan menerapkan ulang snapshot lama di atas edit yang lebih baru.
   UUID sama/isi berbeda ditolak. Simpan receipt per pemilik sampai penghapusan akun.
5. Maks50 perubahan tiap request tetap. Untuk grup >50, stage fragmen milik akun
   secara idempoten dan commit atomik setelah lengkap. Fragmen parsial tidak masuk
   tabel bisnis/pull. Jangan menambah batas jumlah layanan di UI untuk mengakalinya.
   Cleanup akun mencakup staging/receipt; uji isolasi serta penghapusan dua pemilik.
6. Terapkan urutan FK dan pemeriksaan keadaan akhir: order COD final bersama payment
   dalam satu grup boleh tersimpan jika lunas; COD bersisa dan koreksi tidak konsisten
   tidak boleh commit. Jangan mengurangi pemeriksaan hanya agar seed berhasil.
7. Tetapkan kontrak pull (maks500, tuple updated_at+id UTC enam digit, owner/tombstone).
   Buktikan row tidak terlewat saat commit terlambat atau waktu sama. Bila diperlukan
   gunakan RPC snapshot/watermark/serialisasi per owner melalui migrasi yang teruji;
   jangan sekadar mengandalkan clock_timestamp sebelum transaksi commit.
8. Dokumentasikan bentuk request/response/receipt/cursor/error dan pemulihan antrean
   v4 yang belum punya group_id. Jangan menebak grup berdasarkan created_at; jangan
   menghapus antrean lama atau mengganti UUID ledger agar retry tampak berhasil.

## Bukti penerimaan
- Dua pemilik untuk seluruh jalur, update item milik B ditolak, pemindahan item ditolak,
  edit/soft-delete sebelum final berhasil, sesudah final ditolak, ledger tetap immutable.
- Nota+item dan pembayaran+tabungan rollback utuh saat salah satu anggota gagal.
- Retry/response hilang tidak menggandakan ledger atau memundurkan snapshot baru.
- Grup >50 dikirim beberapa request, putus di tengah lalu lanjut; belum terlihat
  sebelum commit, hasil akhir utuh. Owner/ukuran/hashes/urutan fragmen palsu ditolak.
- >500 row dengan timestamp sama terambil sekali; commit terlambat tidak hilang.
- Schema terlalu lama, akses anonim, akun lain dan cleanup staging/receipt diuji.
- supabase db reset dan test db hijau, runtime lokal relevan hijau, check_all hijau.
  Jika perubahan membuat tes B0 tidak berlaku, perbarui alasan dan tes penggantinya;
  jangan menurunkan pengujian isolasi/ledger. Catat bukti di docs/progress/b2a.md.

## Penutup
Update STATE/INDEX dan commit. Berhenti setelah B2a; B2b ditulis dari kontrak teruji.
Jangan menyambungkan SyncEngine UI atau Auth nyata dalam kelompok ini.
