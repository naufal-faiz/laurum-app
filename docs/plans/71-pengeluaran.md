# Prompt 71 - Pengeluaran
- Acuan: prompt 71, frame Lainnya - Daftar/Catat Pengeluaran, DATA MASTER.
- Baseline check_all sebelum implementasi; tanpa perubahan tema/registry/dependensi.
- Tambah state daftar bulan berjalan, filter, draf nominal/tanggal/vendor/catatan/foto.
- Tambah penyimpanan kategori melalui ExpenseRepository; validasi nama duplikat.
- Susun Pages/Sheets dan Section Stateless dari widget registry.
- Daftar memakai RootScaffold Lainnya aktif, CTA tetap di atas nav; tanpa Ekspor.
- Detail ringkas dan ConfirmModal hapus; form memakai FormScaffold dan Numpad.
- Tes logika simpan/hapus/kategori, pembaruan laporan, interaksi, keyboard 300 dp,
  lebar 320 px/teks 2x, golden dua layar, serta satu tes per Section.
- Tulis spec 23/24, bukti validasi, INDEX/STATE; check_all hijau, commit, berhenti.
