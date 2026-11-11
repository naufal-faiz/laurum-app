# 02 - Buat Transaksi
Rute: /transaksi/baru   Fase: 3   Frame .pen: "Transaksi - Buat Transaksi" (+ State Validasi nama/WhatsApp/nominal)
Template: FormScaffold (AppBarSub + body gulir + FooterBar sticky)

Komposisi:
- AppBarSub(title: 'Buat transaksi', backLabel: 'Kembali') dengan guard ConfirmModal.
- SectionHeader('Pelanggan'), lalu satu baris AppButton('Impor kontak') melebar
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
Acuan dibaca sekali: frame 691 kosong dan frame 752 terisi, sesuai
persetujuan pengguna. Pemetaan: AppBarSub.detail + AppBadge Draft; SectionHeader
primer; kartu pelanggan/layanan kosong lewat AppCard dan widget registry;
Ringkasan lewat AppCard/InfoRow/AppDivider; footer total + tombol Bayar sejajar.
Ukuran font/tap memakai token global, bukan ukuran contoh frame 8-11 px.

### Paritas redesign
| Butir | Sumber/aksi yang dipertahankan | Status |
|---|---|---|
| Pelanggan, saldo, katalog belum tersedia | customerCatalogProvider, customerBalanceProvider | Selesai |
| Pilih pelanggan lewat kartu kosong / Ganti | CustomerPickerSheet.show(context, ref) | Selesai |
| Impor kontak lalu tinjau dan simpan | ContactPickerSheet, AddCustomerSheet, aksi simpan/pilih lama | Selesai |
| Pelanggan baru lalu pilih | AddCustomerSheet.show; invalidate catalog; selectCustomer(created.id) | Selesai |
| Draf/item/qty/harga/total/diskon/catatan | transactionDraftProvider, DraftLine, Formatters | Selesai |
| Pilih/tambah layanan | push /transaksi/baru/layanan | Selesai |
| Edit berat/jumlah dan stepper | TransactionLineSheet.show, WeightInputSheet jalur lama | Selesai |
| Hapus layanan (ikon diminta pengguna) | TransactionDraft.remove(serviceId), aksi lama | Selesai |
| Estimasi dan jam bisnis | estimateReady, businessClockProvider dari Section lama | Selesai |
| Atur diskon + validasi | DiscountSheet.show(context, ref), aksi lama | Selesai |
| Catatan nota dan keyboard 300 dp | setNote, label/maxLines/urutan fokus tetap | Selesai |
| Total/footer/Bayar nonaktif bila tanpa item | draft.total/itemCount/lines; push /transaksi/baru/bayar | Selesai |
| Kembali dan konfirmasi draf kotor | leaveTransaction(context, ref) | Selesai |
| Keadaan kosong/terisi, rute, key | cabang lama; tidak ada Key eksplisit pada Page/Section | Selesai |

### Selisih desain
- Frame 691 menampilkan pilihan Lunas/Bayar nanti. Aplikasi menetapkan cara bayar
  pada langkah Pembayaran; PayStatus tetap turunan, tidak boleh dipilih.
- Estimasi dan catatan tetap tersedia meskipun tidak ditampilkan frame 691.
- TransactionDetailsSection adalah utang ConsumerWidget yang sudah ada; pembacaan
  provider dipertahankan sesuai UI-16, tanpa migrasi atau state baru.
- Usulan penempatan: estimasi/catatan sesudah Ringkasan; pembayaran tetap langkah
  lama. Penempatan disetujui bersama pasangan frame 752.
### Penerapan pasangan 691 + 752 (disetujui pengguna)
Frame 752 dibaca sekali: header/draft, pelanggan avatar/nama/telepon + Ganti,
Layanan dengan Tambah, kartu beraksen primer berisi nama/perhitungan/total/sampah,
Ringkasan subtotal-diskon-total, footer total/Bayar. Widget: AppBarSub.detail,
CustomerContactCard, TransactionServicesSection/ItemSection, AppCard,
InfoRow/AppDivider/InlineLink, TransactionSummarySection dan FooterSection.
Tombol sampah langsung memanggil remove(serviceId); Ubah berat/jumlah tetap
membuka TransactionLineSheet (stepper dan Input Berat lama tetap tersedia).
Pelanggan baru memakai teks penuh tanpa ikon agar muat satu baris dengan font global.
Estimasi/catatan sesudah Ringkasan dan pilihan cara bayar tetap di langkah
Pembayaran, sesuai persetujuan pengguna. Label Bayar dipertahankan karena tombol
ini menuju langkah pembayaran, belum menyimpan order. Nomor nota belum dibuat
pada draf, sehingga subtitle tetap nota otomatis, bukan nomor contoh frame.
Saldo pelanggan tetap tampil; badge WhatsApp contoh frame tidak menambah aksi baru.
Ikon sampah memakai AppIconButton error bertarget sentuh 48 dp dari registry;
kotak merah 34 dp pada frame tidak dibuat sebagai dekorasi khusus.
TransactionDetailsSection tetap ConsumerWidget utang lama (UI-16); provider tetap.

Izin state spesifik: pengguna menyetujui pembatasan diskon ke subtotal yang tersisa
saat menghapus layanan. remove mempertahankan pelanggan/catatan/baris lain, dan
mengosongkan diskon saat semua item dihapus. DraftLine dipisah ke transaction_line
untuk batas 110 baris; API diekspor ulang, tanpa perubahan data atau perhitungan.
Tes regresi non-widget baru dibuat sesuai izin; tes perilaku lama tidak dilemahkan.
Finder tes hanya mengikuti label Pelanggan baru/Buat Transaksi, Ganti, dan
Ubah berat sebagai pengganti ketukan subtitle layanan. Nilai qty/total tetap diuji.
Golden: transaction_page diperbarui, transaction_empty baru, add_customer_sheet
diperbarui hanya backdrop Transaksi. Tanpa screenshot emulator; iOS belum diuji.
Koreksi pengguna: tombol utama pelanggan kosong menjadi Impor kontak; seluruh
kartu Belum ada pelanggan membuka daftar pemilihan lewat MenuRow. Impor membuka
ContactPickerSheet lalu formulir AddCustomerSheet untuk ditinjau; belum menulis
pelanggan sampai Simpan pelanggan. Pembatalan tidak mengubah draf atau repository.
Padding atas body 8 dp (sebelumnya 24); sisi tetap 24 dp. Finder pemilihan pada
add_customer, keyboard_audit, transaction_page/golden mengikuti kartu kosong,
assertion perilaku tetap. Tes impor mencakup tinjau/simpan/pilih dan pembatalan.
