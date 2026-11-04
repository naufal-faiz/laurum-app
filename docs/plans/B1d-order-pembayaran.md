# B1d - Order dan pembayaran Drift

Scope: prompt B1d, tanpa UI baru/dependensi/wiring aplikasi B1f.

1. Baseline check_all pada f9bd41c; baca kontrak dan alur checkout/edit/bayar/batal/AI.
2. Tes kontrak order yang sama pada InMemory/Drift; tambah nominal/ledger retry,
   status final, item snapshot, range mikrodetik dan owner scope.
3. Pertahankan satu penjaga writeOrderStore; bandingkan seluruh isi bisnis tanpa
   metadata sinkron, validasi nominal di repository (termasuk koreksi pembatalan).
4. DriftOrderRepository/readers/mapping dan penulisan snapshot/outbox atomik.
   Item yang dihapus menjadi tombstone; ledger append-only dan retry tanpa duplikasi.
5. Skema v3: indeks owner/status dan owner/entered_at; payments(order_id) tetap.
   Normalisasi kolom range UTC dengan enam digit pecahan agar range berindeks presisi.
   Migrasi v1/v2, snapshot baru dan tes data lama; snapshot lama tetap dibekukan.
6. Uji alur controller yang sama lewat override Drift dan satu DriftTransactionRunner:
   checkout/counter, edit, bayar+tabungan, selesai/COD, batal/refund dan persetujuan AI.
7. Partisipan memory sementara (AI/auth dummy) wajib ikut checkpoint rollback bila
   dipakai bersama SQLite; hapus data lokal atomik, tanpa cloud/sesi produksi.
8. Injeksi gagal setiap tabel/outbox; retry AI tidak menggandakan order/counter.
   Nomor pulih dari angka terbesar per kode perangkat; gagal checkout tidak naik.
9. Benchmark non-gating 5.000 order/8.000 pembayaran, p95 getOrdersInRange 100 ms.
10. check_all hijau, self-review <=100 baris, laporan/STATE/INDEX, commit lalu berhenti.

ID lewat IdGenerator; metadata lokal diuji terpisah seperti B1b/B1c.
AI/auth/sinkron tetap dummy; belum memerlukan cloud/key. Berikutnya B1e.
