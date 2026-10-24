# 17 - Impor Kontak HP
Rute: /pelanggan/impor   Prompt: 51
Frame .pen: "Pelanggan - Impor Kontak HP"; State "Izin kontak ditolak".

Template: FormScaffold (AppBarSub + isi bergulir + FooterBar ringkasan).

Komposisi:
- AppBarSub(title: 'Impor kontak HP', backLabel: 'Kembali').
- AppCard penjelasan: 'Aplikasi membaca kontak di HP Anda untuk mempercepat pencatatan
  pelanggan tanpa perlu mengetik ulang satu per satu.'
- AppSearchField(label 'Nama pelanggan', hint 'Cari nama atau nomor kontak...'),
  pencarian nama dan nomor ternormalisasi.
- AppButton aksi 'Pilih semua (n kontak)' / 'Batalkan pilihan'.
- AppCard ringkasan: 'Siap impor', 'n nomor sudah terdaftar di sistem dan akan otomatis
  dilewati', 'n kontak baru dipilih (n dilewati)', 'Total n kontak'.
- ToggleRow per kontak: nama, nomor; kontak terdaftar memakai nilai false, nonaktif,
  dan keterangan '<nomor> • Sudah ada (dilewati)'.
- FooterBar: AppButton 'Simpan n pelanggan' (nonaktif bila n = 0).

Data dan provider:
- ContactSource (core, implementasi palsu memakai contactFixtures).
- customerImportProvider = FutureProvider: kontak + pelanggan aktif/terdaftar,
  menghasilkan baris {kontak, sudahTerdaftar} memakai normalizePhone.
- customerImportSelectionProvider (autoDispose): query pencarian dan himpunan nomor terpilih.
- Simpan membuat Customer baru untuk setiap kontak terpilih yang belum terdaftar
  (id 'cust-new-<n>', ownerId pengguna aktif, createdAt jam usaha), lalu kembali ke daftar.

Interaksi:
- Ketuk ToggleRow menambah/menghapus pilihan; kontak terdaftar tidak dapat dipilih.
- Pilih semua memilih seluruh kontak baru pada hasil filter; tombol berubah menjadi
  'Batalkan pilihan'.
- Simpan memperbarui Daftar Pelanggan dan jumlah chip; nomor duplikat tetap dilewati.

State layar:
- Izin ditolak (State "Izin kontak ditolak"): EmptyState 'Izin kontak belum diberikan',
  deskripsi 'Izinkan akses kontak agar nomor bisa diimpor.', aksi 'Buka pengaturan'
  memanggil ExternalLauncher.launchUrl('app-settings:').
- Memuat: AppSkeleton; gagal lain: EmptyState 'Kontak tidak tersedia' + 'Coba lagi'.
- Kontak kosong: EmptyState 'Belum ada kontak'.
- Semua kontak sudah terdaftar: ringkasan 0 baru, tombol simpan nonaktif.

Risiko izin (PRD B bagian 10): READ_CONTACTS termasuk izin sensitif dan berisiko ditinjau
ketat di Play Store. Mitigasi yang disarankan: pemilih kontak sistem untuk satu pelanggan
(tanpa izin) dan impor massal tetap opsional dengan penjelasan izin. Implementasi palsu
memakai ContactSource di core sehingga penggantian ke pemilih sistem tidak mengubah layar.

Format: nomor lewat Formatters.telepon di daftar; pencarian memakai normalizePhone.

Selisih terhadap .pen:
- Fixture kontak baru berisi 4 nama DATA MASTER dan keempatnya sudah terdaftar sebagai
  pelanggan (cust-010..013), sehingga dummy menampilkan 0 kontak baru; alur simpan diuji
  dengan ContactSource override. Perlu keputusan pemilik produk bila ingin kontak baru.
- Tanpa header huruf A/B/D per grup; daftar diurutkan nama.
- Tanpa tombol 'Bantuan' pada app bar; tanpa avatar inisial (memakai ikon person).
- Ringkasan diletakkan di footer (bukan sticky bar terpisah).
