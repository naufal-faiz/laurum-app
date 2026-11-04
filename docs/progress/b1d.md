# B1d - Order, pembayaran, nomor nota dan transaksi atomik (4 Nov 2026)

Status: SELESAI; check_all akhir hijau, exit 0, kedua analyzer tanpa isu.
Dasar: f9bd41c; baseline 781 tes hijau (exit 0), %TEMP%/laurum-b1d-baseline.log.
Rencana: docs/plans/B1d-order-pembayaran.md. Tidak ada layar/widget baru.

## Repository dan aturan bersama

- DriftOrderRepository beserta reader/mapping memenuhi seluruh OrderRepository:
  order, snapshot item, pembayaran/event append-only, filter status dan rentang.
- writeOrderStore tetap satu penjaga untuk InMemory dan Drift. Nominal nol/negatif
  biasa, uang diterima kurang, kelebihan non-tunai, net negatif dan pembayaran di atas
  tagihan ditolak. Koreksi negatif hanya pada pembatalan dengan saldo tiap metode nol.
- COD bersisa tidak dapat selesai lewat save/update maupun alur controller; status
  final tidak mundur. Semua field bisnis ledger immutable; metadata updatedAt/syncState
  diabaikan hanya saat membandingkan retry, diuji khusus pada penyimpanan.
- Snapshot hanya membaca order terkait dan ID anak yang mungkin bertabrakan, bukan
  memuat seluruh database. Owner/parent pelanggan/layanan dijaga, termasuk ID lintas order.
- Item yang dihapus menghasilkan tombstone + outbox; histori pembayaran tidak dihapus.
  Posisi internal rowid order/item mengikuti semantik urutan InMemory (order disimpan
  bergerak ke akhir, urutan item mengikuti snapshot). ID domain tetap UUID.
- Setiap mutasi data/outbox atomik, metadata lokal pending dan updatedAt lokal.
  Payload snake_case/UTC ISO, tanpa pay_status atau sync_state.

## Skema v3 dan waktu

- Tetap 16 tabel. Tambah orders_owner_status(owner_id,status),
  orders_owner_entered(owner_id,entered_at), payments_owner_paid(owner_id,paid_at).
  payments_order(order_id) dan indeks lama tetap ada.
- entered_at/paid_at disimpan sebagai UTC ISO dengan enam digit pecahan lewat
  sqlTimestamp; pembacaan domain kembali ke waktu lokal sesuai ReportRange.
  Format tetap ini menjaga perbandingan teks berindeks tepat sampai mikrodetik,
  tanpa julianday yang dapat kehilangan presisi. Metadata waktu lain mempertahankan
  identitas UTC/lokal input seperti B1a.
- Migrasi v1->v3 menjalankan backfill B1b dahulu; v2->v3 menormalkan dua kolom rentang
  dan menambah indeks. Semua migrasi dibungkus transaksi; collision nomor lama tetap
  membatalkan seluruh migrasi. Tes mempertahankan data lama dan offset +07:00.
- Snapshot v1/v2 tidak diubah; v3 dibekukan. Helper dihasilkan dengan
  --data-classes --companions. Penulis SQL/sync berikutnya wajib memakai sqlTimestamp
  untuk entered_at/paid_at; jangan menulis format ISO dengan presisi campuran.

## Alur atomik dan batas integrasi

- Alur checkout, edit, bayar, selesai, batal dan approve menggunakan controller yang
  sama melalui override repository Drift dalam tes; wiring aplikasi tetap B1f.
- Counter nota ikut transaksi SQLite melalui DriftLocalSettingsRepository.
  Checkout gagal tidak menaikkan counter; dua checkout berurutan A-0001/A-0002.
  Pemulihan B-0042 dengan counter B=2 melanjutkan B-0043 tanpa mengubah counter A.
- DriftTransactionRunner menerima checkpoint partisipan memory sementara, memakai
  runner memory yang sudah ada. Rollback SQL/commit gagal juga memulihkan status
  usulan AI/auth/sync dummy; nested gagal tetap menggagalkan transaksi luar.
- Approval memakai UUID v5 BP0 dan proposal_id tersimpan. Retry, termasuk hilangnya
  status persetujuan dummy, tidak membuat order/outbox/counter baru.
- DriftLocalDataService menghapus baris dalam urutan FK, seluruh outbox/settings,
  dan callback memory atomik. Database yang memuat owner asing ditolak sebelum hapus.
  Menutup/menghapus berkas database dilakukan setelah commit pada wiring/lifecycle;
  tidak menghapus berkas terbuka di dalam transaksi.
- Auth/usulan AI/sinkron masih dummy; ini bukan transaksi lintas jaringan atau
  implementasi hapus akun server. AiPreferences tetap memory sampai B7.

## Verifikasi

- Kontrak yang sama pada dua backend. Tes merah sebelum implementasi membuktikan
  nominal lama belum dijaga; regresi urutan item Drift juga dibuktikan gagal dahulu.
- 141 tes terarah hijau sebelum penambahan tes terakhir metadata/owner/query plan.
  Injeksi kegagalan di local_settings/orders/order_items/payments/order_events/
  savings_entries/outbox, edit, pembatalan/refund, penyelesaian, approval memory dan
  pembersihan akun memastikan tidak ada data/outbox/counter setengah jadi.
- check_all akhir: 848 tes lolos, flutter analyze dan dart analyze tanpa isu,
  check_arch OK, REPO_MAP 840 berkas, exit 0. Bukti %TEMP%/laurum-b1d-check.log:

```text
No issues found!
check_arch: OK
04:30 +848: All tests passed!
REPO_MAP diperbarui: 840 berkas
check_all: SEMUA HIJAU
```

- Log: %TEMP%/laurum-b1d-{red,item-red,targeted,check}.log.
- Self-review: Dart non-generated baru/tersentuh <=100 baris; tanpa dependensi,
  ignore lint manual, perubahan tema/registry/fixture/PRD. Tidak ada perubahan tampilan/.pen.
- Acuan teks Detail Order, Pembayaran dan State dibaca lewat pen_frame; tidak ada
  selisih visual baru. Catatan tool: info Riverpod tidak menggagalkan check_all;
  log analyzer wajib dibaca. Info properti publik pada helper tes dibersihkan,
  kemudian check_all diulang; tidak mengubah lint atau menambahkan ignore.

## Benchmark non-gating

tool/benchmark_orders.dart, SQLite native in-memory Windows, 5.000 order dan 8.000
pembayaran; range tujuh hari mengembalikan 581 order. Lima warmup dan 100 sampel:
median 12,208 ms, p95 15,018 ms (target p95 <100 ms). Ini ukuran read+mapping setelah
seed bulk SQL; tidak mengukur write/outbox, file I/O, Android atau iOS.
Log: %TEMP%/laurum-b1d-benchmark.log. Tidak dipakai sebagai syarat lulus tes.

Supabase cloud/key belum dibutuhkan. Android/iOS database belum diuji.
Prompt berikutnya: B1e-drift-pengeluaran-laporan.md.
