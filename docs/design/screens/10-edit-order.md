# 10 - Edit Order
Rute: /order/:id/edit   Fase: 5   Frame .pen: "Transaksi - Edit Order"; state "State - Keluar tanpa menyimpan"
Template: FormScaffold (AppBarSub + FooterBar, tanpa nav)

Komposisi (urut dari atas, HANYA nama widget registry + argumen penting):
- AppBarSub(title: 'Edit order A-0142')
- BannerMessage info 'Order dari WhatsApp: isi berat setelah cucian ditimbang.'
  (hanya bila Order.source == whatsappAi)
- BannerMessage error simpan
- SectionHeader 'Pelanggan' + LockedRow (nama, telepon + 'Saldo tabungan: Rp50.000',
  lockLabel 'Terkunci')
- SectionHeader 'Layanan' subtitle '1 layanan di nota' + AppButton 'Pilih layanan' /
  'Tambah layanan lain' (actionOutline) + MenuRow per DraftLine
- TransactionDetailsPage: InfoRow 'Estimasi selesai', caption 'Mengikuti layanan
  terlama', MenuRow 'Atur diskon', LabeledField 'Catatan nota' (AppTextField)
- FooterBar ringkasan 'Total tagihan (1 item)' + AppButton 'Simpan perubahan'

Data dan fixture: Order A-0142 dan itemnya; pelanggan cust-001 (saldo Rp50.000,
DATA MASTER); layanan dari ServiceRepository.
Provider: orderEditProvider(:id) mengisi transactionDraftProvider dari order tersimpan;
serviceCatalogProvider/customerBalanceProvider lewat halaman; orderActionsProvider tidak
dipakai di sini.

Interaksi:
- Draf dimuat dari order; pelanggan terkunci; tambah/ubah/hapus layanan, diskon, dan
  catatan memakai widget Buat Transaksi yang sama (MenuRow, TransactionLineSheet,
  WeightInputSheet, DiscountSheet).
- Kembali dengan draf berubah memakai ConfirmModal 'Keluar tanpa menyimpan?' dan
  membuang draf; setelah simpan kembali ke Detail order tanpa dialog.
- Simpan menulis item (ID lama dipertahankan), subtotal/total, estimasi dari
  enteredAt + durasi terlama, dan OrderEvent 'edited'; Antrean, Laporan, dan struk
  ikut berubah.
- Simpan ditolak bila total baru lebih kecil dari pembayaran yang sudah tercatat.
- Tombol 'Pilih layanan' membuka /transaksi/baru/layanan lewat rute edit.

State layar: loading skeleton, gagal memuat, nota final tidak dapat diedit,
keluar tanpa menyimpan (State - Keluar tanpa menyimpan), error simpan.

Format: sama dengan Buat Transaksi; berat gram, uang rupiah int.

Selisih terhadap .pen: baris layanan tetap MenuRow + sheet (bukan stepper inline di
kartu), jumlah layanan di subtitle, dan simpan tidak mencetak struk otomatis.
