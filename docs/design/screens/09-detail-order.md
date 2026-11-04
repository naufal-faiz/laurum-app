# 09 - Detail Order
Rute: /order/:id   Fase: 5   Frame .pen: "Transaksi - Detail Order"; state "State - Batalkan order A-0142"
Template: FormScaffold (AppBarSub + FooterBar, tanpa nav)

Komposisi (urut dari atas, HANYA nama widget registry + argumen penting):
- AppBarSub(title: 'Detail order', trailing: AppIconButton(AppIcons.more) -> AppBottomSheet)
- AppCard: AppText 'No. nota' + nomor, AppBadge status, AppStatusText pembayaran,
  InfoRow 'Masuk', InfoRow 'Estimasi siap'
- AppCard pelanggan: AppAvatar inisial, AppText nama, AppText telepon, AppText alamat,
  AppButton 'Buka WhatsApp' (actionOutline, AppIcons.chat)
- SectionHeader 'Rincian cucian' + AppCard: baris MenuRow layanan (nama, '4,5 kg × Rp7.000',
  total), AppDivider, InfoRow 'Subtotal', InfoRow 'Total tagihan'
- AppCard catatan cucian (hanya bila Order.note tidak kosong)
- SectionHeader 'Riwayat pembayaran' + AppCard: AppStatusText, InfoRow 'Terbayar',
  InfoRow 'Sisa piutang', AppButton 'Catat pembayaran' (actionOutline)
- SectionHeader 'Jejak aktivitas' + AppCard: titik waktu (Container) + AppText judul +
  AppText jam, dari OrderEvent
- BannerMessage error/notice aksi dan hasil cetak
- FooterBar: AppButton 'Cetak struk' (secondary, AppIcons.printer) + AppButton CTA
  ('Tandai dijemput' / 'Tandai siap' / 'Serahkan' sesuai status)

Data dan fixture: Order A-0142 Pak Dedi (DATA MASTER), OrderItem Cuci kiloan 4,5 kg,
Payment kosong, OrderEvent diproses 10.30; pelanggan cust-001.
Provider: orderDetailProvider(:id) (order, item, payment, event, pelanggan),
orderActionsProvider (pending/error), receiptPrintProvider (cetak dari data tersimpan).

## R4: mode sederhana (useOrderStatus false)
- Menu titik tiga disembunyikan. Footer aktif hanya Edit, Hapus, Selesaikan.
- Badge diproses menjadi 'Sedang dikerjakan'; status lama tidak diubah saat toggle.
- Edit memakai rute yang sama; Hapus memakai ConfirmModal 'Hapus nota ini?' dan
  alur pembatalan/koreksi ledger, bukan menghapus riwayat.
- Selesaikan membuka konfirmasi, lalu Cetak struk menuju /transaksi/nota/:id?complete=1.
  Halaman struk belum mencetak otomatis. Ikon cetak menjalankan guard/PrintService;
  sukses cetak baru menyimpan status selesai + OrderEvent dan keluar dari Antrean.
- Gagal/exception/batal cetak: tetap aktif; gagal menampilkan BannerMessage dan retry
  di halaman struk. Jalur Selesaikan tanpa cetak dihapus sesuai koreksi 4 Nov 2026.
- Order lama Menunggu jemput atau Siap boleh langsung selesai (izin 31 Okt 2026).
- Order final hanya Cetak struk. Lunas tidak wajib; sisa piutang tetap tercatat.
- Ketukan ganda diblokir; order dan pengaturan diperiksa ulang sesudah mencetak.
- ContentSection Stateless, data/callback dari Page. Provider tambahan:
  businessProfileProvider dan orderCompletionProvider(:id).
- Golden r4_order_detail.png: 390 x 844. Android/iOS dan printer nyata belum diuji.
- Selisih .pen: footer dua baris Edit/Hapus lalu Selesaikan. Konfirmasi membuka
  struk dan tidak menyediakan aksi tanpa cetak, sesuai koreksi pengguna 4 Nov 2026.

Interaksi:
- CTA memajukan satu status (nextStatus) + OrderEvent; Antrean ikut berubah.
- Menu titik tiga: Edit order -> /order/:id/edit; Ubah status -> AppBottomSheet satu
  langkah status; Batalkan order -> ConfirmModal 'Batalkan order A-0142?' memakai
  cancelOrder, order keluar dari laporan dan saldo tabungan kembali.
- Catat pembayaran -> AppBottomSheet Numpad (Tunai/QRIS/Transfer) menyimpan Payment +
  event; Terbayar/Sisa piutang, kartu Antrean, dan Laporan berubah.
- Cetak struk selalu membuka /transaksi/nota/:id, termasuk COD tertahan/order final.
  Tidak memanggil PrintService di Detail. Pencetakan/retry dan akses Pengaturan printer
  berada di receipt agar printer belum terdeteksi ditangani di satu tempat.
- Buka WhatsApp memakai ExternalLauncher palsu.

State layar: loading skeleton, gagal memuat, nota tidak ditemukan, modal batalkan
(State - Batalkan order A-0142), menu sheet, sheet pembayaran, error aksi.

Format: rupiah/berat/tanggal/jam lewat Formatters; status memakai label Indonesia.

Selisih terhadap .pen: MenuRow tidak punya warna destruktif, jadi 'Batalkan order'
memakai AppButton destructiveOutline di dalam sheet; jejak aktivitas tidak menampilkan
'Oleh Pemilik' dan tidak mengulang jam di judul; tombol Cetak struk dan CTA sejajar
dalam satu baris footer.
Koreksi lanjutan 4 Nov: kedua tombol sama lebar dan tinggi, font bodyStrong 14 sp
(actionOutline/action). Tinggi baris mengikuti tombol tertinggi saat teks membungkus;
ukuran normal minimum 48 dp. Berlaku juga CTA status berikutnya/Terima pembayaran.

## R9 - COD dan pembayaran pada order selesai (menggantikan batas R4 terkait pembayaran)
- Catat pembayaran tersedia selama sisa > 0 dan tidak batal, termasuk order selesai.
- Label pembayaran sama dengan Antrean/Struk/Piutang: Lunas / Sisa Rp X / COD - sisa Rp X.
- COD dengan sisa tertahan: mode sederhana menampilkan Edit/Hapus, Cetak struk outline,
  dan Terima pembayaran. Tidak ada aksi Selesaikan tanpa cetak untuk melewati tahanan.
- Mode aktif: langkah siap mengganti Serahkan menjadi Terima pembayaran; aksi yang sama
  di kartu Antrean dan menu Ubah status membuka PaymentRecordSheet untuk pelunasan.
- Mode sederhana otomatis selesai setelah COD lunas. Mode aktif melalui Catat pembayaran
  biasa hanya melepas tahanan; aksi Terima pembayaran di langkah siap menyimpan pembayaran
  dan event selesai bersama. Pembayaran sebagian tetap disimpan tanpa menyelesaikan COD.
- State dan repository menolak penyelesaian COD yang belum lunas, termasuk callback usang.
- Kelebihan tunai dapat dikembalikan atau disetor ke tabungan; payment.amount maksimal sisa.
  Pembayaran, setoran dan status/event tersimpan dalam satu TransactionRunner.
- Non-COD bayar sebagian tetap boleh selesai; pembayaran lanjutan tidak mengubah status.
- Fixture tidak berubah; tes COD kedua mode, rollback, keyboard 300 dp, 320 px/2x.
Selisih .pen: pengecualian empat aksi untuk COD tertahan dan sheet pilihan kelebihan.
Header nomor nota/status membungkus agar nomor tidak terjepit vertikal pada teks 2x.
Belum diuji manual di Android/iOS; pencetakan masih layanan palsu.
