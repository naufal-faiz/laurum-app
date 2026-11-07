# B2b — mesin sinkronisasi lokal di atas kontrak grup

DISETUJUI sebagai kelanjutan B2 dan SELESAI (7 Nov 2026). Bukti: docs/progress/b2b.md.
Prasyarat: B2a SELESAI; baca docs/progress/b2a.md, docs/plans/B2-kontrak-sinkronisasi.md,
PRD B7–9 dan STATE. Berhenti setelah B2b; B2c–B2e belum.

## Hasil yang diminta
1. Drift v5 menambah kolom outbox: `group_id`, `group_seq`, `requires_recovery`,
   `conflict_code`. Baris baru otomatis satu grup per transaksi bisnis (ID UUID v4 dari
   IdGenerator, urutan `group_seq` 1..n). Migrasi v4 tidak menebak grup: baris lama
   diberi `requires_recovery=1`, kolom grup null, dan TIDAK boleh terkirim sampai
   pemulihan eksplisit. Snapshot v1–v4 beku; snapshot v5 ditambahkan.
2. OutboxWriter memakai grup dari DriftTransactionRunner; penulisan bersarang dalam
   satu operasi bisnis memakai grup yang sama. Rollback menghapus data + outbox + grup.
3. `SyncOutboxStore` (antarmuka baru) dengan implementasi Drift dan InMemory:
   ambil grup tertua, hitung pending/konflik/legacy, ack hanya ID yang dikirim,
   catat percobaan gagal, tandai konflik, dan pulihkan baris legacy lewat pemetaan
   eksplisit (tanpa menebak dari waktu).
4. `SyncEngine` mengirim grup lewat `SyncTransport`:
   - hash kanonik SHA-256 sama dengan server; >50 perubahan dipecah fragmen;
   - receipt committed menghapus hanya change_id yang `ok`;
   - receipt rejected menandai seluruh grup konflik dan berhenti;
   - respons hilang setelah commit: percobaan ulang mengembalikan receipt lama,
     tidak menggandakan atau memundurkan data;
   - konflik/legacy memblokir pengiriman berikutnya sampai diselesaikan.
5. Transport palsu untuk tes: commit, staged/fragmen, reject terkonfigurasi,
   kehilangan respons setelah commit. Tidak ada Supabase/network/paket baru selain
   `crypto` yang disetujui untuk hash.
6. Tes: kontrak store dijalankan pada Drift dan InMemory; migrasi v1→v5 dan v4→v5;
   grouping/rollback; hash vektor tetap; fragmen; retry; ack selektif; konflik;
   legacy; isolasi dua akun pada store Drift. check_all hijau, STATE/INDEX dan commit.

## Batas
- Tidak ada UI, Auth, Supabase adapter, pull-apply tabel, upload foto, atau cloud.
  Pull-apply dan pemetaan seluruh tabel tetap B2c; indikator/retry tetap B2d.
- Jangan mengubah registry, tema, fixture, PRD, atau migrasi server B0/B2a.
- Jangan menambah dependensi lain; `crypto` sudah disetujui pengguna.

## Bukti penerimaan
- Operasi order+item/payment+tabungan menghasilkan satu group_id dan urutan stabil.
- Edit baru selama request berjalan tidak ikut ter-ack.
- Grup >50 dikirim sebagai fragmen dengan hash fragmen/grup yang benar.
- Reject satu anggota tidak menghapus anggota lain dan grup berhenti.
- Vektor hash cocok dengan implementasi kanonik server (dibuktikan silang di tes).
