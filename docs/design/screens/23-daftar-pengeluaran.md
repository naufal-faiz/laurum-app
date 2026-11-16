# 23 - Daftar Pengeluaran
Rute: /lainnya/pengeluaran | Prompt: 71
Frame .pen: Lainnya - Daftar Pengeluaran. Template: RootScaffold, Lainnya aktif.

Komposisi: ExpenseListSection menyusun SectionHeader bulan, AppCard total/jumlah
transaksi/rincian kategori, ChipBar, DateGroupHeader dan ExpenseRow. FooterBar
berisi Catat pengeluaran tetap di atas nav dan bebas tombol tengah. Tanpa Ekspor.
Provider: expenseDirectoryProvider, expenseFilterProvider, ExpenseRepository.
Bulan mengikuti businessClockProvider: [awal bulan, awal bulan berikutnya).
DATA MASTER Oktober: 18 transaksi Rp1.850.000; Bahan cuci Rp850.000,
Listrik & air Rp620.000, Kemasan Rp380.000. Filter tidak mengubah ringkasan bulan.

Interaksi: Catat membuka /lainnya/pengeluaran/baru dengan draf baru kosong.
ExpenseRow membuka ExpenseDetailSheet via AppBottomSheet.show, berisi kategori,
nominal, tanggal/jam, vendor, catatan, status lampiran. Hapus memerlukan
ConfirmModal destruktif 'Hapus pengeluaran ini?'. Batal menjaga data; konfirmasi
soft-delete memperbarui daftar, total, dan Laporan. Gagal hapus dapat diulang.
State: loading, kosong/filter kosong, error + Coba lagi. Nav empat tab tetap aktif.
Format uang/tanggal/jam/bulan melalui Formatters; uang int rupiah.
Selisih .pen: empat tab dan tombol tengah revisi terbaru; ringkasan AppCard responsif.
Tes: fixture/filter, simpan/hapus/batal, error/retry, golden, 320 px/teks 2x.
Perangkat Android/iOS untuk layar ini belum diuji.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.


## Redesign 16 Nov 2026 (tanpa frame FigCraft)

Tidak ada frame Pengeluaran di new-design-laurum.figcraft; tangkapan layar lama
(ditempel di FigCraft) hanya acuan data. Konsep visual mengikuti layar terbaru
(AppPageHeader + kartu ringkasan primary, seperti Pelanggan/Pembayaran).

### Paritas redesign

| Butir | Sumber lama | Ada di UI baru |
|---|---|---|
| Data expenseDirectoryProvider (bulan, kategori, daftar, total) | Page | ya |
| expenseFilterProvider + ChipBar | Page/List | ya |
| businessProfileProvider (judul bisnis) + shellSyncStatusProvider | Page | subtitle + SyncIndicator |
| Catat pengeluaran (invalidate draf + push) | Footer | ya |
| Tab nav 4 + tombol tengah /transaksi/baru | RootScaffold | ya |
| ExpenseRow membuka ExpenseDetailSheet | List | ya |
| Total Rp1.850.000, 18 transaksi, rincian 3 kategori | List | ya |
| Tanggal grup + total harian + filter kosong | List | ya |
| Memuat / gagal + Coba lagi | Page | ya |
| Key `antrean-golden` | tes | ya |

### Selisih desain

- Header memakai AppPageHeader (LAURUM + Pengeluaran), bukan AppBarRoot berisi nama
  usaha; tombol akun dihapus karena tujuan yang sama ada di tab Lainnya (UI-10).
- Ringkasan total memakai AppCard primary (gaya Pembayaran), bukan kartu putih.
- Bulan tetap teks sendiri di atas kartu agar tes Section tetap berlaku.
