# 12 - Pelanggan - Daftar Pelanggan
Rute: /pelanggan   Prompt: 50 (bagian pertama)
Frame .pen: "Pelanggan - Daftar Pelanggan"; State Pelanggan kosong,
Pencarian pelanggan kosong, Memuat Daftar Pelanggan, Gagal memuat data.
Template: RootScaffold dari RootShellPage; FooterBar di atas navigasi bawah.

Komposisi:
- SectionHeader('Pelanggan', jumlah pelanggan, aksi 'Impor kontak').
- AppSearchField('Nama pelanggan', hint 'Cari nama atau nomor WhatsApp...').
- ChipBar: Semua (48), Ada piutang (5), Punya tabungan (5); jumlah dinamis.
- CustomerRow: nama/telepon, avatar, piutang/DP, saldo, jumlah order/total historis.
- FooterBar + AppButton('Pelanggan baru').
- EmptyState untuk kosong/tanpa hasil/error; AppSkeleton saat memuat.

Data dan provider:
- customerDirectoryProvider membaca CustomerRepository, OrderRepository,
  SavingsRepository. Hanya pelanggan aktif yang ditampilkan.
- Fixture awal: 48 pelanggan, lima pemilik piutang, lima pemilik tabungan.
- Pak Dedi: 0813-7788-1122, 16 order, Rp580.000, piutang Rp31.500, tabungan Rp50.000.
- Riwayat dummy = customerHistoryFixtures + snapshot order kini - orderFixtures awal;
  order dibatalkan/dihapus dikecualikan. Pelanggan tanpa baseline memakai order kini.
- customerDirectoryFilterProvider dan customerDirectorySearchProvider menyimpan filter/query.

Interaksi:
- Cari nama tanpa membedakan kapital; nomor dinormalisasi (spasi/tanda, +62/62/8).
- Filter digabung pencarian; jumlah chip selalu dari seluruh pelanggan aktif.
- Ketuk baris -> /pelanggan/:id (Detail Pelanggan, spec 13).
- Impor kontak -> /pelanggan/impor (placeholder prompt 51).
- Pelanggan baru -> AddCustomerSheet di navigator utama; simpan memperbarui daftar,
  mereset filter dan pencarian. Banner form menjelaskan konteks daftar, bukan nota.
- Ikon telepon -> ExternalLauncher palsu dengan tel:; disabled bila nomor kosong.
- Coba lagi mengulang provider. Perubahan repository memperbarui daftar dan jumlah.

Format: uang/telepon lewat CustomerRow dan Formatters; nominal seluruhnya int rupiah.
Selisih terhadap .pen:
- Chip Semua/Punya tabungan diberi jumlah sesuai prompt; urutan mengikuti repository.
- DP memakai teks CustomerRow ('DP ...', 'Sisa ...'), tanpa nomor nota A-0140.
- Tombol tambah tetap di footer pada state tanpa hasil (label 'Pelanggan baru').
- Loading memakai empat skeleton kartu; header usaha mengikuti RootScaffold yang ada.

Verifikasi: tes fixture/filter/normalisasi, pembatalan, tambah pelanggan/navigasi,
loading/kosong/error/retry, serta lebar 320 px pada teks 2x.
Perangkat Android, keyboard nyata, dan TalkBack belum diuji; belum diuji di iOS.
Panggilan telepon masih palsu; integrasi platform belum diuji di iOS.
