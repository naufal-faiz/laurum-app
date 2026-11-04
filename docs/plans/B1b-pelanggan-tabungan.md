# B1b — Repository pelanggan dan tabungan

1. Baseline check_all, baca antarmuka/kontrak dan implementasi InMemory.
2. Tambah tes bersama untuk Unicode, 0/62, pencarian prefiks literal, urutan/null,
   retry ledger dan saldo silang; jalankan pada InMemory dan Drift.
3. Nyatakan metadata updatedAt/syncState terpisah dari isi bisnis pada kontrak;
   uji metadata Drift dan outbox secara khusus, tanpa mengurangi pemeriksaan isi.
4. Tambah query opsional getCustomers(query:), normalisasi key telepon/nama bersama.
5. Skema v2: key turunan lokal, indeks prefiks/owner-updated, migrasi atomik v1->v2;
   jangan ubah snapshot v1, uji pelestarian data dan penolakan tabrakan nomor lama.
6. Implementasi DriftCustomerRepository: owner scope, CRUD/soft delete, outbox atomik.
7. Implementasi DriftSavingsRepository: append/idempoten, SUM SQL dan penjaga saldo.
8. Uji injeksi kegagalan data/outbox, owner scope, SQL query plan dan payload ISO.
9. check_all, catat docs/progress/b1b.md, STATE/INDEX, commit lalu berhenti sebelum B1c.

Aplikasi tidak di-wire sampai B1f; tanpa layar, paket baru atau Supabase cloud.
