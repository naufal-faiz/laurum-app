# R9 - Pembayaran: Bayar sekarang / COD, kembalian-tabungan, tombol alur, Catat pembayaran (revisi 1, 2, 6, 7, 8)
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: R8 SELESAI. Baca: AGENTS.md aturan 16-17, docs/revisi/REVISI-02.md, spec 07-pembayaran, 08-nota-tersimpan, 09-detail-order, 18-daftar-piutang, 01-antrean-beranda; kode: transactions/state/{checkout_state,checkout_save,payment_quote}.dart, transactions/pages/payment_page.dart, widgets/payment_*_section.dart, receipt_status_section.dart, orders/state/{order_payment_controller,order_completion_*,order_detail_controller,payment_draft}.dart, orders/pages/payment_record_sheet.dart, orders/widgets/{order_payment_section,order_detail_footer_section}.dart, reports/widgets/outstanding_list_section.dart, core/domain/{order,money,order_rules,savings_rules}.dart.

## Keputusan pengguna (2 Nov 2026)
1. DP/Belum bayar/Lunas BUKAN pilihan pengguna lagi. PayStatus tetap ada di domain sebagai nilai TURUNAN (total vs pembayaran masuk) untuk Piutang, Laporan, ekspor, fixture; jangan dihapus dan jangan disimpan terpisah.
2. Pilihan pembayaran di kasir hanya dua: "Bayar sekarang" (isi uang diterima; kurang dari total = sisa jadi piutang, ini pengganti DP) dan "Bayar nanti (COD)".
3. Bayar sekarang wajib jumlah > 0. Jumlah 0 harus memilih COD (tidak ada lagi "belum bayar" tanpa COD).
4. COD dengan sisa tagihan > 0: status selesai TERTAHAN. Cetak struk tidak mengubah status. Sisa COD tetap muncul di Antrean dan di Daftar Piutang.
5. Non-COD dengan sisa (bayar sebagian) boleh selesai seperti perilaku R4; sisa tetap piutang.
6. Kelebihan uang tunai: toggle Kembalian (default) atau Simpan ke tabungan pelanggan.

## IZIN TERTULIS (2 Nov 2026)
- Domain: enum PayTerm { sekarang, cod } di domain_enums.dart; Order.payTerm (default sekarang; masuk props, withStatus, serialisasi/salinan). Fixture DATA MASTER tidak berubah (semua sekarang). Tambah fungsi murni isCompletionHeld(order, paid) di order_rules.dart (true bila COD dan paid < total) dengan tes tabel. Catat kolom pay_term di docs/prd/prd-b-backend.md.
- Organisms: OrderCard dan NotaCard dan PiutangCard boleh menerima paymentLabel opsional (String?) agar label "DP/Belum bayar" diganti tanpa mengubah enum; PiutangCard: onRemind opsional, tombol Ingatkan DISEMBUNYIKAN bila onRemind null. Perbarui katalog dan tes. Tanpa perubahan tema, registry, dependensi.
- docs/prd/prd-a-ui.md: perbarui bagian pembayaran dan piutang (satu paragraf).
- Boleh menambah 1-2 order COD ke DATA MASTER hanya bila pengguna menyetujui ulang; default: JANGAN ubah fixture, buat order COD di tes.

## Perilaku
### A. Halaman Pembayaran (revisi 1, 6)
- Ganti chip Lunas/DP/Belum bayar dengan dua pilihan: Bayar sekarang | Bayar nanti (COD). Default Bayar sekarang, jumlah = total terutang.
- Bayar sekarang: metode (Tunai/QRIS/Transfer/Tabungan seperti sekarang), uang diterima (Numpad/CashInput; aturan angka AGENTS 16). Kurang dari terutang: caption "Sisa Rp X masuk piutang". 0: tombol aksi nonaktif dengan pesan "Isi jumlah atau pilih Bayar nanti (COD)".
- COD: sembunyikan metode dan jumlah; tampilkan BannerMessage "Pelanggan membayar saat struk/barang diterima. Order tetap di antrean sampai pembayaran dicatat." Tabungan boleh dipakai sebagian pada COD (mengurangi sisa); bila ada, tampil di ringkasan.
- Kelebihan (A2): bila metode tunai dan uang diterima > terutang, tampil pilihan Kembalian | Simpan ke tabungan (ChipBar atau ToggleRow yang ada; nilai kelebihan ditampilkan). Default Kembalian. Simpan ke tabungan membuat SavingsEntry setor sebesar kelebihan, terkait pembayaran (pakai kolom referensi yang sudah ada, lihat applySavings). Kelebihan bukan omzet.
- Dua tombol footer (revisi 6; sekarang keduanya memanggil _save yang sama = bug): "Cetak struk" (simpan nota lalu buka /transaksi/nota/:id) dan "Ke antrean" (simpan nota lalu go('/antrean') dan tampilkan pemberitahuan sekali-tampil "Nota {nomor} tersimpan"; bila tidak ada molecule toast, pakai pola notice provider yang sudah ada, bukan widget baru). Kedua tombol nonaktif saat menyimpan; tombol kembali app bar tidak menyimpan. Penyimpanan di dalam TransactionRunner (R8).
### B. Catat pembayaran (revisi 7, 2)
- Tombol "Catat pembayaran" tampil selama sisa > 0 dan order tidak dibatalkan, TERMASUK order selesai (sekarang disembunyikan bila isFinal). Tempat: Detail Order (OrderPaymentSection), halaman Struk (ReceiptPage), dan "Catat bayar" di Daftar Piutang (hapus TODO; buka PaymentRecordSheet dengan data order tersebut).
- PaymentRecordSheet: input = uang diterima. Pembayaran yang diterapkan = min(diterima, sisa); kelebihan memakai toggle Kembalian | Simpan ke tabungan (tunai). Nominal melebihi tidak lagi error, melainkan kelebihan. Penyimpanan di TransactionRunner.
- Setelah pembayaran melunasi order COD: mode status NONAKTIF -> status otomatis selesai (event status dicatat, keluar dari antrean); mode AKTIF -> hanya melepas tahanan (status tidak berubah); bila status siap, lihat C.
### C. Penahanan selesai (revisi 1, 8)
- Mode NONAKTIF, order COD dengan sisa > 0: footer Detail Order = baris Edit | Hapus, tombol "Cetak struk" (outline), dan aksi utama "Terima pembayaran" menggantikan "Selesaikan" (membuka PaymentRecordSheet). Ini pengecualian atas aturan "tepat tiga aksi" R4, hanya untuk COD tertahan. Setelah lunas: otomatis selesai (B).
- Mode AKTIF: langkah siap -> selesai ("Serahkan") untuk COD dengan sisa > 0 berubah menjadi "Terima pembayaran"; sukses = pembayaran + status selesai dalam satu TransactionRunner. Langkah sebelumnya normal; "Catat pembayaran" tetap tersedia kapan saja. OrderActions.advance dan OrderCompletion.complete harus menolak (StateError) bila isCompletionHeld, sehingga tombol tertahan tidak bisa ditembus lewat jalur lain (menu Ubah status, usulan AI, dll).
- Hapus (batal) tetap tersedia agar COD yang tidak pernah dibayar tidak macet; penyesuaian tabungan seperti alur batal.
### D. Antrean dan label (revisi 8)
- Query Antrean tidak berubah (selesai tertahan = otomatis tetap aktif). Kartu COD menampilkan penanda "COD - belum dibayar" dan sisa lewat paymentLabel. Label bayar di seluruh UI: lunas -> "Lunas"; sisa > 0 dan COD -> "COD - sisa Rp X"; sisa > 0 non-COD -> "Sisa Rp X" (menggantikan "DP" dan "Belum bayar"). Satu fungsi pemetaan label di state/ dipakai semua layar (Antrean, Detail, Struk, Nota di Laporan, Piutang).
- Daftar Piutang: chip filter menjadi Semua | COD | Sebagian (berdasarkan payTerm dan sisa); hapus teks "tandai lunas di kasir"; Ingatkan tidak ada (onRemind null).
- Ekspor/Laporan: kolom status bayar tetap dari PayStatus turunan (tanpa perubahan angka). Omzet nota tetap seperti keputusan sebelumnya (nota non-batal); uang masuk mengikuti pembayaran.

## Langkah (tes lebih dulu)
1. Domain: isCompletionHeld, payTerm default, tabel label bayar.
2. State: checkout (dua pilihan, validasi 0, kelebihan), saveCheckout (payTerm, setoran tabungan), order_payment (kelebihan, auto-selesai), penolakan advance/complete untuk COD tertahan.
3. UI: PaymentPage, PaymentRecordSheet, OrderPaymentSection/Footer, ReceiptPage, Piutang, kartu; potongan layar baru sebagai Section (AGENTS 14).
4. Tes alur nyata: (a) COD -> Cetak struk -> status tidak berubah -> order tetap di Antrean -> Terima pembayaran tunai pas -> selesai (mode NONAKTIF); (b) idem mode AKTIF di langkah siap; (c) Bayar sekarang kurang dari total -> selesai boleh -> Catat pembayaran tetap tampil di order selesai -> lunas; (d) kelebihan tunai: kembalian tidak membuat entri tabungan, Simpan ke tabungan membuat setoran dan saldo bertambah; (e) kegagalan di tengah (repository gagal) tidak meninggalkan data setengah jadi; (f) tombol "Cetak struk" dan "Ke antrean" menuju rute yang benar.
5. Tes keyboard (AGENTS 16e) untuk PaymentPage dan PaymentRecordSheet. Perbarui spec 01, 07, 08, 09, 18 dan STATE.

Prompt berikutnya: R10-akun.md.
