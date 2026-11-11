# 07 - Pembayaran
Rute: /transaksi/baru/bayar. Frame FigCraft: 1146, LAURUM · Pembayaran.
Template: FormScaffold detail, body gulir dan dua tombol footer sticky satu baris.

## Redesign frame 1146 (11 Nov 2026)
Frame dibaca sekali melalui MCP FigCraft; snapshot 0. Proposal 022 disetujui pengguna.
Urutan visual: header kembali/judul/pelanggan, kartu total biru, pilihan waktu bayar,
tabungan (fungsi lama), tiga baris metode, uang diterima dan kembalian, footer sticky.
Pemetaan: FormScaffold detail; AppCard.primary; SelectionTile;
AppText, AppSwitch, MenuRow, ChipBar, BannerMessage dan AppButton yang sudah ada.
Font minimum dan jarak memakai token global; radius total 18 dipetakan ke AppRadius.card 16.

### Paritas redesign
Centang setelah implementasi dan tes terarah; tabel ini tidak ditulis ulang saat koreksi.

| Butir | Sumber/aksi/keadaan yang dipertahankan | Terverifikasi |
|---|---|---|
| Draf | transactionDraftProvider: customerId, lines, itemCount, total | [x] |
| Pelanggan | customerCatalogProvider; nama pelanggan terpilih | [x] |
| Tabungan | customerBalanceProvider(customerId); saldo/pemakaian/sisa | [x] |
| Checkout | checkoutControllerProvider; payTerm, method, useSavings, saveExcess, saving, error | [x] |
| Perhitungan | quotePayment: due, received, valid, outstanding, change, deposit, savingsUsed | [x] |
| Waktu bayar | controller.setTerm; Bayar sekarang / Bayar nanti (COD) | [x] |
| Tabungan aksi | controller.setSavings(value: value) | [x] |
| Metode | controller.setMethod; Tunai/QRIS/Transfer | [x] |
| Nominal | CashInputSheet.show(context, ref, quote.due, quote.received) | [x] |
| Kelebihan | controller.setExcess(save: save); Kembalian / Simpan ke tabungan | [x] |
| Simpan struk | Konfirmasi pembayaran: finishCheckout(context, ref, receipt: true) | [x] |
| Simpan antrean | Kembali: finishCheckout(context, ref, receipt: false) | [x] |
| Kembali | context.pop(), termasuk aksi Nota belum lengkap | [x] |
| Tidak siap | pelanggan/layanan/saldo belum siap; footer nonaktif; EmptyState | [x] |
| COD | metode/input tersembunyi; pesan COD lama tetap | [x] |
| Validasi | nominal nol/berlebih non-tunai, piutang, checkout.error, saving; disabled tetap | [x] |
| Key/fokus | Page/Section tidak memiliki Key eksplisit; CashInputSheet dan urutan fokus tetap | [x] |
| Aksesibilitas | saldo/switch sejajar; teks besar 320 px; keyboard 300 dp | [x] |

### Selisih desain
- Tabungan tetap sebelum metode; dua aksi footer lama tetap tersedia.
- Koreksi pengguna: footer satu baris, Kembali di kiri dan Konfirmasi pembayaran di kanan.
- Kedua tombol tetap menyimpan; tombol kembali pada header tetap context.pop tanpa simpan.
- Nomor nota belum tersedia sebelum simpan; header memakai nama pelanggan tanpa nomor contoh.
- Nama bank contoh dan badge Belum bayar tidak ditambahkan; status tetap turunan pembayaran.
- Label Bayar nanti (COD), Transfer, pesan validasi dan aksi mengikuti spec perilaku.
- Input uang tetap membuka CashInputSheet, bukan mengubah alur menjadi input inline.
- Rincian total tetap jumlah layanan yang sudah dibaca; tidak menambah berat/diskon dari state.
- Kartu total memakai warna primer polos; dekorasi lingkaran tidak ditambahkan.
- Penempatan selisih disetujui bersama proposal 022 dan koreksi footer 11 Nov 2026.

### Tes yang disesuaikan
- payment_page_test.dart, r9_checkout_flow_test.dart, r9_validation_flow_test.dart:
  hanya finder label footer; assertion simpan/validasi/COD/tujuan rute dipertahankan.
- r4_finish_test_host.dart dan ui_final_flow_test.dart: finder konfirmasi saat membuat nota;
  tombol Cetak struk pada detail/struk tetap memakai label lama.
- r9_payment_keyboard_test.dart: finder Kembali; tambah cek kedua tombol sejajar,
  urutan kiri/kanan dan konfirmasi tetap terlihat di atas keyboard 300 dp.
- r9_payment_sections_test.dart: tambah verifikasi callback QRIS pada baris pilihan.
- app_card_test.dart: uji primary; muted memakai loop kasus yang mempertahankan assertion lama.
- selection_tile_test.dart: aksi seluruh baris, semantics pilihan dan golden;
  SemanticsHandle dilepas dalam finally sebelum callback tes berakhir.
- Golden 4: payment_page, r9_cod_payment, selection_tile (baru), serta app_icon
  (galeri bergeser karena tambahan ikon radio yang disetujui).
- Ikon radio dipetakan ke Ionicons radioButtonOnOutline/radioButtonOffOutline
  melalui AppIcons.radioSelected/radioUnselected, tanpa aset atau paket baru.
- Snapshot 0; visual belum diverifikasi manual. iOS belum diuji.

## R9 (2 Nov 2026)
- PaymentSummarySection: pelanggan, jumlah layanan, total dan hanya dua pilihan:
  Bayar sekarang (default) / Bayar nanti (COD). Tidak ada pilihan PayStatus.
- PaymentSavingsSection: saldo, Pakai tabungan, pemakaian, sisa bayar/saldo.
  Tabungan boleh dipakai sebagian atau seluruhnya pada kedua pilihan.
  Saldo dan switch sejajar spaceBetween (saldo kiri fleksibel, switch kanan),
  sesuai koreksi 4 Nov 2026; label aksesibilitas switch tetap Pakai tabungan.
- PaymentMethodSection: Tunai/QRIS/Transfer dan Uang diterima lewat CashInputSheet.
  Nilai awal = sisa setelah tabungan; nilai nol yang sengaja dimasukkan tetap nol.
  Bayar sekarang tanpa pembayaran positif tidak dapat disimpan; pesan
  'Isi jumlah atau pilih Bayar nanti (COD)'. Tagihan tertutup tabungan boleh disimpan.
- Kurang dari tagihan: 'Sisa Rp X masuk piutang'. Metode non-tunai tidak menerima
  jumlah melebihi tagihan; tunai menampilkan Kembalian (default) / Simpan ke tabungan.
  Kelebihan bukan omzet; simpan membuat SavingsEntry setor terkait order/ID pembayaran.
- COD menyembunyikan metode dan input jumlah, menampilkan BannerMessage:
  'Pelanggan membayar saat struk/barang diterima. Order tetap di antrean sampai pembayaran dicatat.'
- Footer Konfirmasi pembayaran (sebelumnya Cetak struk): simpan lalu /transaksi/nota/:id;
  tidak otomatis mencetak/menyelesaikan.
- Footer Kembali (sebelumnya Ke antrean): simpan lalu /antrean; banner 'Nota {nomor} tersimpan' hilang
  sesudah empat detik dan tidak diputar ulang. Kembali tidak menyimpan.
- Kedua tombol nonaktif saat menyimpan, saat draf belum lengkap atau nominal tidak valid.

## Data dan state
transactionDraftProvider, checkoutControllerProvider, customerCatalogProvider,
customerBalanceProvider. received null berarti gunakan terutang sebagai nilai awal;
received 0 adalah input eksplisit, bukan fallback ke total. PayTerm disimpan di Order,
PayStatus tetap dihitung dari pembayaran. saveCheckout memakai TransactionRunner R8
untuk nota/item/payment/event dan pemakaian/setoran tabungan.
Section Stateless menerima data/callback dari Page. CashInputSheet tetap AppBottomSheet;
Numpad: angka pertama mengganti nilai awal, backspace awal mengosongkan, tanpa nol depan.

## Verifikasi dan selisih .pen
R9 mengganti tiga chip status serta dua tombol lama; menambah pilihan kelebihan tunai.
Ringkasan pelanggan/total vertikal; saldo membungkus di kiri switch agar teks besar terbaca.
Spec R9 menang atas frame lama. Fixture DATA MASTER tidak diubah.
Tes domain/state, alur dua tujuan tombol, COD, kelebihan dan rollback; tampilan 320 px
teks 2x dan inset keyboard 300 dp untuk halaman serta CashInputSheet.
Belum diuji manual di Android/iOS; printer tetap dummy.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
