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

Interaksi:
- CTA memajukan satu status (nextStatus) + OrderEvent; Antrean ikut berubah.
- Menu titik tiga: Edit order -> /order/:id/edit; Ubah status -> AppBottomSheet satu
  langkah status; Batalkan order -> ConfirmModal 'Batalkan order A-0142?' memakai
  cancelOrder, order keluar dari laporan dan saldo tabungan kembali.
- Catat pembayaran -> AppBottomSheet Numpad (Tunai/QRIS/Transfer) menyimpan Payment +
  event; Terbayar/Sisa piutang, kartu Antrean, dan Laporan berubah.
- Cetak struk memakai receiptLines data tersimpan; gagal menampilkan BannerMessage.
- Buka WhatsApp memakai ExternalLauncher palsu.

State layar: loading skeleton, gagal memuat, nota tidak ditemukan, modal batalkan
(State - Batalkan order A-0142), menu sheet, sheet pembayaran, error aksi.

Format: rupiah/berat/tanggal/jam lewat Formatters; status memakai label Indonesia.

Selisih terhadap .pen: MenuRow tidak punya warna destruktif, jadi 'Batalkan order'
memakai AppButton destructiveOutline di dalam sheet; jejak aktivitas tidak menampilkan
'Oleh Pemilik' dan tidak mengulang jam di judul; tombol Cetak struk dan CTA sejajar
dalam satu baris footer.
