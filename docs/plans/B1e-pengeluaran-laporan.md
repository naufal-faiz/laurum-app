# B1e - Pengeluaran dan laporan ledger

Scope: prompt B1e; prasyarat B1d selesai pada 70041af.
Keputusan pengguna 4 Nov 2026: angka harus sesuai, perbaiki seluruh selisih.
Disetujui memakai ledger aktual; perbarui angka/penjelasan laporan, grafik dan golden.

1. Baseline check_all; audit seed DATA MASTER dan laporan yang memakai baseline.
2. Hitung laporan tanpa tambahan baseline, harian, layanan dan identitas rekonsiliasi
   dari order/payment/expense/savings fixture yang diizinkan. Simpan hasil audit.
3. Audit selisih selesai pada 2fb58eb; keputusan sudah diberikan. Gunakan angka ledger
   (minggu 589.000/14 nota) tanpa membuat nota/pembayaran baru.
4. Setelah keputusan: DriftExpenseRepository + kategori/outbox/path foto lokal,
   kontrak InMemory/Drift dan tes rollback; migrasi skema bila diperlukan.
5. Hapus API/kelas/penyesuaian baseline yang diizinkan B1e. Satu jalur ledger untuk
   Hari/Minggu/Bulan/kustom, SQL per range dan fungsi domain bersama di dua backend.
6. CSV dan grafik/top services memakai hasil yang sama. Angka DATA MASTER/golden
   berubah hanya setelah keputusan yang diwajibkan; fixture lainnya tetap.
7. Kontrak laporan dua backend; benchmark bulan pada 5.000 order; check_all hijau.
8. Self-review, STATE/INDEX/laporan, commit lalu berhenti sebelum B1f.

Cloud Supabase/key belum diperlukan; storage upload baru B2. Aplikasi tetap memory
sampai B1f. Tidak mengubah tema, registry, dependensi, atau PRD.
