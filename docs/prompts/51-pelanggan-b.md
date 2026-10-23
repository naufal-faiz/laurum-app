# 51 - Pelanggan bagian 2
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: prompt 50 SELESAI. Baca: frame "Setor Tabungan", "Riwayat Tabungan", "Impor Kontak HP" dan varian State.

- Setor Tabungan (/pelanggan/:id/setor): Numpad, NominalChips (+Rp20.000, +Rp50.000, +Rp100.000), metode, saldo sekarang dan saldo akhir. Simpan menambah SavingsEntry setor; Detail dan Riwayat ikut berubah. Pak Dedi Rp50.000 + Rp50.000 = Rp100.000.
- Riwayat Tabungan (/pelanggan/:id/tabungan): ChipBar (Semua, Setoran, Terpakai) dengan hitungan, SavingsRow, catatan "Riwayat mutasi tidak dapat diubah atau dihapus." TANPA BottomNavBar, tanpa "Pengembalian", "Terverifikasi", atau unduh PDF.
- Impor Kontak HP (/pelanggan/impor): ContactSource palsu, pilih semua, kontak yang sudah ada dilewati, ringkasan jumlah. State izin ditolak (EmptyState "Izin kontak belum diberikan" + "Buka pengaturan"). Catat risiko izin READ_CONTACTS dan opsi pemilih kontak sistem (PRD B bagian 10).
