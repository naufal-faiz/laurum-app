# 50 - Pelanggan bagian 1
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: prompt 40 SELESAI. Baca: frame "Pelanggan - Daftar Pelanggan", "Detail Pelanggan & Tabungan", "Edit Pelanggan" dan varian State.

Layar: Daftar Pelanggan (tab Pelanggan), Detail Pelanggan, Edit Pelanggan (sheet).
- Daftar: AppSearchField, ChipBar ("Semua (48)", "Ada piutang (5)", "Punya tabungan (5)"), CustomerRow, tombol "Pelanggan baru" (sheet Tambah Pelanggan Cepat dari prompt 30) dan "Impor kontak" (placeholder sampai prompt 51). State: kosong, pencarian tanpa hasil.
- Detail: ringkasan (total belanja, frekuensi, piutang aktif Rp31.500, saldo tabungan), 3 mutasi terakhir, riwayat order terakhir, tombol "Setor tabungan" dan "Lihat riwayat mutasi" (placeholder sampai prompt 51), "Edit profil" membuka sheet.
- Edit Pelanggan: field sama dengan Tambah Cepat, "Simpan perubahan", dan "Nonaktifkan pelanggan" lewat ConfirmModal (teks baru, catat di spec).
- Data persis data_master.md (Pak Dedi: 0813-7788-1122, 16 order, Rp580.000).
