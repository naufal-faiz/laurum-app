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
