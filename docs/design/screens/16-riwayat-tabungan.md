# 16 - Riwayat Tabungan
Rute: /pelanggan/:id/tabungan   Prompt: 51
Frame .pen: "Pelanggan - Riwayat Tabungan"; State "Tabungan kosong".

Template: SubScaffold (AppBarSub + isi bergulir). Tanpa BottomNavBar.

Komposisi:
- AppBarSub(title: 'Riwayat tabungan', backLabel: 'Kembali').
- AppCard profil: AppAvatar, AppText nama, AppText telepon, AppStatusText 'Pelanggan Aktif'
  (BannerMessage 'Pelanggan nonaktif. Riwayat tetap tersimpan.' bila nonaktif).
- StatTile(label: 'Saldo tabungan saat ini', value saldo) + AppText caption
  'Titipan saldo dapat langsung memotong tagihan nota berikutnya secara otomatis di kasir.'
- AppButton '+ Setor tabungan baru' (nonaktif bila pelanggan nonaktif).
- SectionHeader('Riwayat mutasi', subtitle 'Catatan mutasi tidak dapat diubah').
- ChipBar: 'Semua (n)', 'Setoran (n)', 'Terpakai (n)'; angka dari seluruh mutasi.
- SavingsRow per mutasi: label, waktu 'd MMM yyyy HH.mm WIB', nominal bertanda,
  saldo berjalan, metode, referensi nota (bila ada), catatan.
- AppText penutup 'Riwayat mutasi tidak dapat diubah atau dihapus.'

Data dan provider:
- customerSavingsProvider(:id) = ringkasan pelanggan + seluruh SavingsEntry pelanggan,
  dihitung kronologis untuk saldo berjalan lalu dibalik (terbaru dulu).
- customerSavingsFilterProvider(:id) menyimpan indeks chip (0 semua, 1 setoran, 2 terpakai).
- Sumber: SavingsRepository (fixture DATA MASTER: Pak Dedi Rp50.000, tiga mutasi).

Interaksi:
- Chip memfilter daftar; hitungan chip tidak ikut berubah oleh filter.
- '+ Setor tabungan baru' membuka /pelanggan/:id/setor; setelah simpan daftar dan saldo
  ikut bertambah tanpa memuat ulang manual.
- State kosong (State "Tabungan kosong"): EmptyState 'Belum ada mutasi tabungan',
  deskripsi 'Setoran dan pemakaian saldo akan tampil di sini.', aksi 'Setor tabungan'.
- Filter tanpa hasil memakai EmptyState 'Tidak ada mutasi pada filter ini'.

Format: uang int rupiah, waktu lewat Formatters.tanggal(ringkas) + Formatters.jam.
Tanpa tombol 'Pengembalian', 'Terverifikasi', atau unduh PDF.

Selisih terhadap .pen:
- Tanpa BottomNavBar (sesuai prompt).
- Status 'Pelanggan Aktif' memakai AppStatusText varian lunas, bukan badge hijau baru.
- Mutasi yang belum punya catatan tidak menampilkan baris Catatan kosong.
- Referensi memakai nomor nota dari OrderRepository, bukan teks bebas.
