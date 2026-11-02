# R8 - Transaksi atomik lintas repository

1. Verifikasi baseline dan simpan perubahan instruksi/revisi pengguna.
2. Tes runner: commit, rollback, error asli, nested, dan antrean transaksi independen.
3. Tambah TransactionRunner dan checkpoint internal data in-memory, termasuk sync.
4. Bungkus checkout, pembatalan, persetujuan AI, dan pembersihan akun.
5. Uji kegagalan setelah penulisan pertama pada setiap alur dan retry AI.
6. Catat pemetaan transaksi database lokal di PRD B sesuai izin R8.
7. Jalankan check_all, self-review, perbarui STATE/INDEX, commit; berhenti sebelum R9.

Checkpoint mengembalikan state immutable; kategori pengeluaran ikut dicadangkan.
Transaksi bersarang bergabung ke induk; kegagalan inner menandai rollback induk.
Transaksi independen diantrikan agar rollback tidak menghapus commit transaksi lain.
Rollback memulihkan sync terakhir setelah notifikasi restore repository.
