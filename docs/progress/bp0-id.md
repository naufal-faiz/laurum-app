# BP0 — Audit ID dan kontrak (4 Nov 2026)

Cabang: dev2backend. Dasar: BP0, PRD B 3.1–3.3/5/7 dan ROADMAP.
28 titik pembentukan ID baris diganti: 21 UUID v4 dan 7 UUID v5.
Hitungan adalah lokasi pembentukan ID, bukan jumlah baris fixture yang diubah.

## Tabel audit

| Lokasi | Baris baru | Keputusan |
| --- | --- | --- |
| transactions/state/checkout_save.dart | order | v4; nomor nota tetap terpisah |
| transactions/state/checkout_save.dart | pembayaran tabungan | v4 |
| transactions/state/checkout_save.dart | pemakaian tabungan | v4 |
| transactions/state/checkout_save.dart → checkout_item.dart | pembayaran kasir | v4; satu ID dipakai referensi setoran kelebihan |
| transactions/state/checkout_item.dart | item order | v4 |
| transactions/state/checkout_item.dart | event dibuat | v4 |
| transactions/state/add_customer_form.dart | pelanggan | v4 |
| customers/state/customer_import_controller.dart | pelanggan impor | v4, tanpa hitungan jumlah pelanggan |
| customers/state/customer_deposit_controller.dart | setoran | v4 |
| expenses/state/expense_form_controller.dart | pengeluaran | v4 |
| expenses/state/expense_category_controller.dart | kategori | v4 |
| services/state/service_edit_controller.dart | layanan | v4 |
| orders/state/order_payment_save.dart | pembayaran | v4, tanpa `-payment-N` |
| orders/state/order_payment_save.dart | event pembayaran | v4 |
| orders/state/order_payment_save.dart | event selesai | v4 |
| orders/state/antrean_controller.dart | event status | v4 |
| orders/state/order_detail_controller.dart | event status | v4 |
| orders/state/order_completion_save.dart | event selesai setelah cetak | v4 |
| orders/state/order_edit_item.dart | item layanan tambahan | v4; item lama mempertahankan ID |
| orders/state/order_edit_controller.dart | event edit | v4, tanpa hitungan event |
| core/services/fake_auth_accounts.dart | akun dummy baru | v4 melalui generator yang dapat diinjeksi |
| proposals/state/proposal_accept.dart | pelanggan dari usulan | v5 `(proposalId, customer)`; retry persetujuan |
| proposals/state/proposal_order.dart | order dari usulan | v5 `(proposalId, order)`; retry persetujuan |
| proposals/state/proposal_order.dart | item order usulan | v5 `(orderId, item)`; retry persetujuan |
| core/domain/payment_corrections.dart | koreksi tiap metode bayar | v5 `(correctionPrefix, payment-<method>)`; retry pembatalan |
| core/domain/cancellation.dart | pengembalian tabungan | v5 `(correctionPrefix, savings)`; retry pembatalan |
| core/domain/cancellation.dart | event batal | v5 `(correctionPrefix, event)`; retry pembatalan |
| core/domain/payment_excess.dart | setoran kelebihan | v5 `(paymentId, excess)`; satu setoran per pembayaran |

Path fitur pada tabel berada di `lib/features/`; path `core/` berada di `lib/`.
`derived` memakai namespace URL → UUID v5 parent → UUID v5 label. Tidak ada
penggabungan parent/label yang ambigu; parent fixture teks masih diterima sampai B1f.
Namespace/label merupakan identitas retry: jangan menggantinya ketika menambah Drift.

## Batas dan hasil

- Fixture teks, owner/session dummy, ID perangkat printer eksternal dan referensi demo
  tetap; pemetaan fixture menjadi UUID dilakukan saat seed B1f. Tidak ada migrasi data.
- Kode perangkat default A; counter per perangkat `order_counter_<kode>` berada di
  LocalSettingsRepository. Reservasi melanjutkan nilai terbesar counter/nota yang ada.
- Counter ikut TransactionRunner, rollback checkout dan persetujuan. Hapus akun dummy
  membersihkan pengaturan lokal; keluar tetap mempertahankannya. Printer berhasil
  dihubungkan menyimpan `printer_id`/`printer_name`, terpisah dari format struk bisnis.
- 7 suite kontrak repository: Customer, Service, Business, Order, Savings, Expense,
  LocalSettings; ditambah 1 suite TransactionRunner. Factory menerima FutureOr agar
  B1 dapat membuka/menutup database lewat setup/teardown tanpa menyalin kontrak.
- Kontrak mencakup upsert/filter/soft-delete, telepon unik, ledger immutable/idempoten,
  saldo, snapshot order atomik, COD kedua mode, rentang [start,end) dan rollback bersarang.
- Tes regresi lama tetap ada dan ekspektasinya dipertahankan. Setup beberapa tes
  memasang FakeIdGenerator untuk ID teks historis; tes `bp0_id_flow_test.dart` menguji
  jalur default dengan UUID asli dan nota A-0143. Fake hanya ada di test/.
- Checker aturan 19–21 menguji impor/ekspor persistensi, larangan shared_preferences
  dan pola ID teks/hitungan/timestamp. Ini pemeriksaan statis pola umum, bukan bukti
  semantik semua ekspresi Dart; audit literal dan review tetap diperlukan.
- Tidak ada perubahan tampilan, fixture, PRD, registry, tema, utang Section atau cloud.

## Verifikasi

Baseline: check_all 688 tes hijau. Tes baru gagal sebelum implementasi.
Fondasi: 26 tes; regresi terarah: 41 tes; alur UUID/checker/kontrak: 18 tes, hijau.
Regresi ID historis tambahan: 6 tes hijau. Pemeriksaan akhir:

```
Formatted 670 files (0 changed)
flutter analyze: No issues found!
dart analyze / Riverpod lint: No issues found!
check_arch: OK
+719: All tests passed!
REPO_MAP diperbarui: 738 berkas
check_all: SEMUA HIJAU
```

Exit 0, log `%TEMP%/laurum-bp0-check.log`. Seluruh 688 tes lama dan 31 tes baru lolos.
Self-review: tidak ada widget/layar baru atau selisih .pen; semua Dart baru <=100 baris.
Lima berkas runtime lama yang disentuh berada pada 101–110 baris (batas keras lolos);
checker lama 202 baris tetap utang tooling. Tidak ada perubahan batas checker/debt list.
Prompt berikutnya: B1a-drift-fondasi.md; belum memulai fase tersebut.
