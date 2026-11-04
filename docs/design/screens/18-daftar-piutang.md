# 18 - Daftar Piutang
Rute: /laporan/piutang. Frame .pen: Laporan - Daftar Piutang.

## R9 (2 Nov 2026)
- OutstandingListSection Stateless: data, filter, jam bisnis dan callback dari Page.
- SectionHeader total piutang, jumlah nota dan pelanggan; tetap menghitung semua sisa
  order non-batal, termasuk order selesai dengan pembayaran sebagian.
- ChipBar Semua | COD | Sebagian dengan jumlah masing-masing. COD berdasarkan
  Order.payTerm; Sebagian adalah non-COD dengan sisa (termasuk nota lama yang belum dibayar).
- PiutangCard urut tertua: nomor, nama, tanggal/usia netral, sisa, paymentLabel dari
  pemetaan state yang sama dengan Antrean/Detail/Struk/Laporan.
- Catat bayar membuka PaymentRecordSheet order tersebut melalui openOrderPayment.
  Uang diterima diterapkan maksimal sisa; kelebihan tunai dipilih kembalian/tabungan.
  Pembayaran, setoran kelebihan dan event selesai COD tersimpan atomik lewat runner R8.
- Ingatkan disembunyikan (onRemind null); bukan placeholder aktif.
- Catatan: 'Piutang tidak dapat dihapus; catat pembayaran untuk mengurangi sisa tagihan.'
- Kosong/error/loading tetap memakai EmptyState/AppSkeleton dari registry.

## Data dan verifikasi
outstandingListProvider membaca OrderRepository, CustomerRepository, pembayaran aktual.
Tidak ada paymentReceived/PayStatus yang disimpan. outstandingFilterProvider menyimpan
indeks pilihan. Fixture master tetap 5 nota, Rp400.500; semua payTerm sekarang sehingga
filter awal Semua 5 / COD 0 / Sebagian 5. Order COD tambahan hanya di tes.
Tes Catat bayar dari order selesai, filter, callback Section, tanpa Ingatkan, 320 px/2x.
Selisih .pen: dua filter bayar lama diganti COD/Sebagian; tombol Ingatkan dihapus.
Belum diuji manual di Android/iOS; tidak ada WhatsApp atau jaringan nyata.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
