# 07 - Pembayaran
Rute: /transaksi/baru/bayar   Fase: 3   Frame .pen: "Transaksi - Pembayaran"
Template: FormScaffold (AppBarSub + body gulir + FooterBar sticky)

Komposisi:
- PaymentSummarySection: AppCard nama pelanggan, jumlah layanan, Total tagihan,
  AppChip status Lunas/DP/Belum bayar; BannerMessage error bila simpan gagal.
- PaymentSavingsSection: saldo tabungan, AppSwitch 'Pakai tabungan' (hanya bila saldo > 0),
  Tabungan dipakai, Sisa bayar, Sisa tabungan.
- PaymentMethodSection: AppChip Tunai/QRIS/Transfer; MenuRow 'Uang diterima' membuka
  CashInputSheet; Kembali Rp... untuk tunai; Sisa bayar.
- Footer: AppButton 'Simpan dan cetak' + 'Simpan saja'.

Data dan provider:
- transactionDraftProvider (isi nota), checkoutControllerProvider (metode, mode,
  received, useSavings, error), customerBalanceProvider.
- CashInputSheet memakai cashInputProvider + Numpad standar + NominalChips.
- saveCheckout membuat Order/OrderItem/Payment/OrderEvent lewat saveOrder, lalu
  SavingsEntry lewat SavingsRepository.

Interaksi:
- Status: Lunas membayar sisa setelah tabungan, DP memakai uang diterima, Belum bayar
  tanpa pembayaran. Tabungan memakai applySavings (maks saldo/total).
- Uang diterima tunai lewat sheet; kembalian = diterima - dibayar.
- Simpan memakai nomor nota berikutnya (A-0143), status order diproses, sumber kasir,
  estimasi estimateReady; draf dibersihkan; buka /transaksi/nota/:id.
- QRIS/Transfer dibayar tepat sebesar sisa (tanpa kembalian).

State: draf belum lengkap (EmptyState kembali), simpan gagal (Banner error), saldo 0.
Format: Formatters.rupiah; total memakai lineTotal, bukan double.

Selisih terhadap .pen: satu halaman, bukan sheet; tanpa opsi menyimpan kelebihan ke
tabungan (tidak ada di frame); kedua tombol footer menyimpan tanpa cetak otomatis
(cetak tersedia di Nota Tersimpan). Validasi saldo dilakukan sebelum simpan; SavingsEntry
ditulis setelah saveOrder karena antarmuka repository masih terpisah (rollback belum ada).
