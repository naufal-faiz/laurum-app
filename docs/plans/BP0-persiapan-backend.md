# BP0 — Persiapan backend

Lingkup: prompt BP0; tanpa Drift, Supabase, atau perubahan tampilan.

1. Verifikasi baseline dan simpan ROADMAP pengguna.
2. Tes lalu implementasikan IdGenerator UUID v4/v5 dan provider fake untuk tes.
3. Audit semua pembentukan ID baru; gunakan v5 hanya untuk retry idempoten.
4. Tambahkan LocalSettingsRepository dan InMemory dengan checkpoint transaksi.
5. Sambungkan kode perangkat/counter nota ke pengaturan lokal, lanjutkan fixture.
6. Tambahkan metode rentang setengah terbuka pada Order/Expense.
7. Ekstrak kontrak Customer, Service, Business, Order, Savings, Expense,
   LocalSettings dan TransactionRunner; jalankan pada InMemory kosong.
8. Tambahkan pemeriksaan arsitektur aturan 19–21 beserta tes negatif/positif.
9. Jalankan tes terarah, self-review batas baris/ID/rollback, lalu check_all.
10. Catat audit ID, hasil verifikasi, STATE/INDEX dan commit; berhenti sebelum B1a.

Validasi perilaku: COD tertahan, saldo/pembayaran atomik, retry usulan tanpa
duplikasi, counter nota pulih setelah rollback, rentang [start, end), dan fixture
serta ekspektasi perilaku tes lama tetap sama.
