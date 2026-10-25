# 71 - Lainnya bagian 2
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: prompt 70 SELESAI. Baca: frame "Daftar Pengeluaran", "Catat Pengeluaran" dan varian State.

- Daftar Pengeluaran (/lainnya/pengeluaran, BottomNavBar dengan Lainnya aktif): total bulan (Rp1.850.000, 18 transaksi), ChipBar kategori (Semua, Bahan cuci, Listrik & air, Kemasan, Transport, Lain-lain), DateGroupHeader, ExpenseRow, tombol CTA "Catat pengeluaran" di atas nav. TANPA tombol Ekspor. State kosong.
- Catat Pengeluaran (/lainnya/pengeluaran/baru): AppBarSub tanpa avatar, ChipBar kategori + "Kategori baru", Numpad (tanpa Reset (C)), tanggal, vendor, catatan, foto struk opsional memakai PhotoPicker palsu, "Simpan pengeluaran". Validasi "Nominal harus lebih dari Rp0".
- Ketuk entri membuka detail ringkas dengan "Hapus" lewat ConfirmModal "Hapus pengeluaran ini?".
- Pengeluaran baru memperbarui total bulan dan Laporan.


Aturan baru (25 Okt 2026): ikuti AGENTS.md aturan 14-16. Catat Pengeluaran: field nominal kosong dengan hint "0" (tanpa teks 0), Numpad pertama mengganti nilai awal, tes keyboard pada tanggal/vendor/catatan. Potongan layar sebagai Section; BottomNavBar memakai API empat tab (R2).
