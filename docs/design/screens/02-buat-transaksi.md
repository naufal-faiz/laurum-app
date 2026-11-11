# 02 - Buat Transaksi
Rute: /transaksi/baru   Fase: 3   Frame .pen: "Transaksi - Buat Transaksi" (+ State Validasi nama/WhatsApp/nominal)
Template: FormScaffold (AppBarSub + body gulir + FooterBar sticky)

Komposisi:
- AppBarSub(title: 'Buat transaksi', backLabel: 'Kembali') dengan guard ConfirmModal.
- SectionHeader('Pelanggan'), lalu satu baris AppButton('Pilih pelanggan') melebar
  dan AppButton('Baru', ikon add, actionOutline). Saat terpilih, hanya MenuRow
  pelanggan (nama, telepon, saldo) yang membuka CustomerPickerSheet.
- SectionHeader('Layanan', subtitle: '<n> layanan di nota'), AppButton('Pilih layanan' /
  'Tambah layanan lain') menuju /transaksi/baru/layanan.
- MenuRow per layanan terpilih: nama, '<berat/jumlah> · <total>'; mengetuk membuka
  TransactionLineSheet (StepperField, ubah jumlah, hapus).
- AppCard: InfoRow('Estimasi selesai'), AppText('Mengikuti layanan terlama'),
  MenuRow('Atur diskon'), LabeledField + AppTextField('Catatan nota').
- FooterBar: ringkasan 'Total tagihan (<n> item)' + total figure; AppButton('Bayar').

Data dan provider:
- transactionDraftProvider (Notifier global, bertahan antar layar alur).
- customerCatalogProvider, customerBalanceProvider, serviceCatalogProvider.
- businessClockProvider untuk enteredAt/estimateReady; tanggal dummy 16 Okt 2026 12.00.

Interaksi:
- Pilih pelanggan lewat pencarian di CustomerPickerSheet; hasil kosong menawarkan
  Tambah CustomerSheet. Pelanggan terpilih langsung dipakai draf.
- Baru membuka AddCustomerSheet(forOrder: true); hasil simpan dipilih di draf.
  Menutup sheet tanpa simpan tidak mengubah draf. Tombol Baru hilang saat terpilih.
- Pilih layanan menambah DraftLine (kg 1 kg, pcs 1 pcs) lalu kembali.
- Stepper +/- memakai langkah 0,5 kg atau 1 pcs; minus nonaktif saat nilai sudah
  minimum. Nilai dapat diketuk untuk Input Berat (lihat spec 04).
- Diskon dibatasi 0..subtotal; field kosong berarti 0 (hint '0'), hanya digit tanpa
  nol di depan, dan nilai awal bukan nol diseleksi semua saat fokus. Total =
  subtotal - diskon; catatan tersimpan di draf.
- Field catatan nota dan tombol Bayar tetap terlihat saat keyboard muncul
  (FooterBar memakai padding viewInsets; field dapat digulir).
- Bayar menuju /transaksi/baru/bayar (placeholder sampai prompt 32); nonaktif tanpa item.
- Kembali dengan draf berisi memunculkan ConfirmModal 'Keluar tanpa menyimpan?'.
- Transisi masuk dari tombol Transaksi: fade + lift 4% selama 280 ms easeOutCubic,
  balik 200 ms easeInCubic. Ketiga rute alur (/transaksi/baru, /layanan, /bayar)
  memakai transisi yang sama dari transaction_routes.dart.

State: kosong (tanpa pelanggan/layanan), terisi, modal keluar, sheet pelanggan/layanan/
berat/diskon. Belum ada penyimpanan order (prompt 32).

Format: Formatters.rupiah/berat/jumlah/tanggal/jam/telepon; estimateReady memakai WIB.

Selisih terhadap .pen: pencarian pelanggan berada di sheet, bukan inline; detail estimasi
memakai InfoRow dua kolom (frame label di atas nilai); baris layanan memakai MenuRow,
bukan kartu dengan StepperField langsung; tidak ada ikon kasir pada app bar (AppBarSub).

R3 (30 Oktober 2026): kode dan tes disiapkan tanpa SDK; tervalidasi otomatis 31 Oktober 2026 (check_all: 387 tes).
TransactionCustomerSection menerima customer/balance dan onChoose/onCreate dari Page.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.

## Redesign Transaksi - frame 691 (2026-11-11)
Acuan dibaca sekali: frame 691, transaksi kosong. Varian isi 752 menunggu
konfirmasi pengguna. Pemetaan: AppBarSub.detail + AppBadge Draft; SectionHeader
primer; kartu pelanggan/layanan kosong lewat AppCard dan widget registry;
Ringkasan lewat AppCard/InfoRow/AppDivider; footer total + tombol Bayar sejajar.
Ukuran font/tap memakai token global, bukan ukuran contoh frame 8-11 px.

### Paritas redesign
| Butir | Sumber/aksi yang dipertahankan | Status |
|---|---|---|
| Pelanggan, saldo, katalog belum tersedia | customerCatalogProvider, customerBalanceProvider | Menunggu |
| Pilih pelanggan | CustomerPickerSheet.show(context, ref) | Menunggu |
| Pelanggan baru lalu pilih | AddCustomerSheet.show; invalidate catalog; selectCustomer(created.id) | Menunggu |
| Draf/item/qty/harga/total/diskon/catatan | transactionDraftProvider, DraftLine, Formatters | Menunggu |
| Pilih/tambah layanan | push /transaksi/baru/layanan | Menunggu |
| Edit berat/jumlah dan stepper | TransactionLineSheet.show, WeightInputSheet jalur lama | Menunggu |
| Hapus layanan (ikon diminta pengguna) | TransactionDraft.remove(serviceId), aksi lama | Menunggu |
| Estimasi dan jam bisnis | estimateReady, businessClockProvider dari Section lama | Menunggu |
| Atur diskon + validasi | DiscountSheet.show(context, ref), aksi lama | Menunggu |
| Catatan nota dan keyboard 300 dp | setNote, label/maxLines/urutan fokus tetap | Menunggu |
| Total/footer/Bayar nonaktif bila tanpa item | draft.total/itemCount/lines; push /transaksi/baru/bayar | Menunggu |
| Kembali dan konfirmasi draf kotor | leaveTransaction(context, ref) | Menunggu |
| Keadaan kosong/terisi, rute, key | cabang lama; tidak ada Key eksplisit pada Page/Section | Menunggu |

### Selisih desain
- Frame 691 menampilkan pilihan Lunas/Bayar nanti. Aplikasi menetapkan cara bayar
  pada langkah Pembayaran; PayStatus tetap turunan, tidak boleh dipilih.
- Estimasi dan catatan tetap tersedia meskipun tidak ditampilkan frame 691.
- TransactionDetailsSection adalah utang ConsumerWidget yang sudah ada; pembacaan
  provider dipertahankan sesuai UI-16, tanpa migrasi atau state baru.
- Usulan penempatan: estimasi/catatan sesudah Ringkasan; pembayaran tetap langkah
  lama. Menunggu konfirmasi bersama pasangan frame 752.