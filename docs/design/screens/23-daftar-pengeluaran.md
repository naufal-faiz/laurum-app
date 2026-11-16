# 23 - Daftar Pengeluaran
Rute: /lainnya/pengeluaran | Prompt: 71
Frame .pen: Lainnya - Daftar Pengeluaran. Frame desain baru: LAURUM · Pengeluaran.
Template: SubScaffold header detail (tombol kembali) dengan FAB; tanpa nav bawah.

Komposisi: ExpenseListSection menyusun ExpenseSummarySection (bulan, AppCard primary
total + jumlah transaksi, tiga sub-card kategori terbesar), ChipBar, DateGroupHeader
dan ExpenseRow. FAB Catat pengeluaran di pojok kanan bawah. Tanpa Ekspor.
Provider: expenseDirectoryProvider, expenseFilterProvider, ExpenseRepository.
Bulan mengikuti businessClockProvider: [awal bulan, awal bulan berikutnya).
DATA MASTER Oktober: 18 transaksi Rp1.850.000; Bahan cuci Rp850.000,
Listrik & air Rp620.000, Kemasan Rp380.000. Filter tidak mengubah ringkasan bulan.

Interaksi: Kembali menutup layar ke /lainnya (pop, atau go bila dibuka langsung).
Catat membuka /lainnya/pengeluaran/baru dengan draf baru kosong.
ExpenseRow membuka ExpenseDetailSheet via AppBottomSheet.show, berisi kategori,
nominal, tanggal/jam, vendor, catatan, status lampiran. Hapus memerlukan
ConfirmModal destruktif 'Hapus pengeluaran ini?'. Batal menjaga data; konfirmasi
soft-delete memperbarui daftar, total, dan Laporan. Gagal hapus dapat diulang.
State: loading, kosong/filter kosong, error + Coba lagi. FAB tetap tampil.
Format uang/tanggal/jam/bulan melalui Formatters; uang int rupiah.
Selisih .pen: header detail + FAB menggantikan nav empat tab; ringkasan AppCard responsif.
Tes: fixture/filter, simpan/hapus/batal, error/retry, golden, 320 px/teks 2x.
Perangkat Android/iOS untuk layar ini belum diuji.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.


## Redesign 16 Nov 2026 (frame LAURUM · Pengeluaran)

Acuan tampilan: frame FigCraft `LAURUM · Pengeluaran` (ID 4294969797). Tangkapan
layar lama hanya acuan data. Tidak ada frame asli di .pen.

### Paritas redesign

| Butir | Sumber lama | Ada di UI baru |
|---|---|---|
| Data expenseDirectoryProvider (bulan, kategori, daftar, total) | Page | ya |
| expenseFilterProvider + ChipBar | Page/List | ya |
| Header detail: judul + jumlah transaksi | AppPageHeader | AppBarSub detail |
| Status sinkron di header | SyncIndicator | ya (trailing) |
| Kembali ke /lainnya | nav bawah | tombol kembali header |
| Catat pengeluaran (invalidate draf + push) | FooterBar | FAB kanan bawah |
| ExpenseRow membuka ExpenseDetailSheet | List | ya |
| Total Rp1.850.000 + 18 transaksi | List | ya |
| Top 3 kategori sebagai sub-card berjejer | List (rincian di kartu) | ya |
| Tanggal grup + total harian + filter kosong | List | ya |
| Memuat / gagal + Coba lagi | Page | ya |
| Key `antrean-golden` | tes | ya |

### Selisih desain

- Nav bawah dan tombol tengah transaksi dihapus dari layar ini; rute tetap
  /lainnya/pengeluaran dan tombol tengah tetap ada di tab utama.
- SyncIndicator tetap dipasang di trailing header detail agar perilaku status sinkron
  diuji (sync_page_test) tetap berjalan; frame tidak menampilkannya. Tombol akun
  lama tidak dipakai karena tujuannya ada di tab Lainnya (UI-10).
- Sub-card hanya menampilkan 3 kategori terbesar; kategori lain lewat chip filter.
- FAB memakai SubScaffold (FloatingActionButton.extended, AppRadius.chip, margin
  bawaan 16) sedangkan frame 24 px.
- DateGroupHeader bawaan membungkus tanggal panjang menjadi dua baris pada 390 px;
  widget bersama tidak diubah.
- Bulan tetap teks sendiri di atas kartu agar tes Section tetap berlaku.
