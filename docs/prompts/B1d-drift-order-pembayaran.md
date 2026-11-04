# B1d - Drift: order, item, pembayaran, event, nomor nota
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: B1c SELESAI. Baca: AGENTS 17, 19-22, order_repository.dart, order_store_write.dart (penjaga COD), checkout_save.dart, order_payment_save.dart, order_completion_save.dart, cancel di order_detail_controller.dart, OrderNumberGenerator, docs/progress/bp0-id.md.

Tujuan: seluruh alur nota (checkout, edit, bayar, selesai, batal, usulan AI) berjalan di atas DriftOrderRepository dengan perilaku IDENTIK dengan InMemory.

## Isi
1. DriftOrderRepository: orders (pay_term, status, source, proposal_id), order_items (snapshot nama layanan, qty_milli, unit_price), payments dan order_events (hanya tambah), savings terkait lewat repository tabungan. Semua metode antarmuka termasuk getOrdersInRange dan getPaymentsInRange dengan indeks `orders(owner_id, status)`, `orders(owner_id, entered_at)`, `payments(order_id)`.
2. Penjaga domain tetap di satu tempat: COD tertahan (isCompletionHeld), status final tidak mundur, nominal pembayaran valid; ditegakkan di repository dan diuji di kontrak, bukan hanya di UI.
3. Nomor nota: `<kode perangkat>-<urut 4 digit>` dari LocalSettingsRepository (default `A`); counter naik dalam transaksi yang sama dengan penyimpanan order; setelah pemulihan data counter dilanjutkan dari nomor tertinggi perangkat itu. Tes: dua checkout berurutan, checkout gagal tidak menaikkan counter.
4. Semua alur lintas repository (checkout, batal, bayar+tabungan, persetujuan usulan, hapus akun) berjalan di DriftTransactionRunner; tes injeksi kegagalan di tiap penulisan memastikan tidak ada data setengah jadi dan tidak ada baris outbox yatim.
5. ID: baris baru dari IdGenerator (aturan 21); tidak ada ID bergaya teks.
6. Kontrak order lolos di InMemory dan Drift; tambah tes "retry persetujuan usulan tidak membuat order ganda" di Drift.
7. Benchmark non-gating: seed 5.000 order dan 8.000 pembayaran, ukur getOrdersInRange (target p95 < 100 ms); laporkan angkanya.

Prompt berikutnya: B1e-drift-pengeluaran-laporan.md.
