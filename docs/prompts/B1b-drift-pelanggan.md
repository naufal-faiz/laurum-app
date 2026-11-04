# B1b - Drift: pelanggan dan tabungan
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: B1a SELESAI. Baca: AGENTS 19-22, core/domain/repositories/{customer,savings}_repository.dart, test/contracts, features/customers/data.

Tujuan: DriftCustomerRepository dan DriftSavingsRepository yang lolos tes kontrak yang SAMA dengan InMemory. Belum disambungkan ke aplikasi (B1f).

## Isi
1. Repository di features/customers/data (atau features/savings sesuai struktur yang ada) memakai AppDatabase; setiap penulisan menulis outbox dalam transaksi yang sama; updatedAt lokal dicatat, nilai server menyusul di B2.
2. Pelanggan: unik nomor telepon untuk baris aktif (pelanggaran = error domain yang sama dengan InMemory), soft delete, pencarian nama/telepon (SQL LIKE terindeks), is_active.
3. Tabungan: hanya tambah (tanpa update/delete); saldo = SUM(setor + penyesuaian - pakai) lewat SQL, hasil sama dengan fungsi domain savings_rules pada data yang sama (tes silang).
4. Kontrak lolos di InMemory DAN Drift; tambahkan kasus kontrak yang hanya muncul di database (urutan, null, unicode, nomor telepon dengan awalan 0/62).
5. Tes atomik: penulisan pelanggan + outbox gagal di tengah (injeksi kegagalan) membatalkan keduanya.
6. Indeks seperlunya `(owner_id, updated_at)` dan nama/telepon; jelaskan di docs/progress/b1b.md.

Prompt berikutnya: B1c-drift-usaha-layanan.md.
