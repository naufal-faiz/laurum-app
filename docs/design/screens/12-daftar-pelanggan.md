# 12 - Pelanggan - Daftar Pelanggan
Rute: /pelanggan   Prompt: 50 (bagian pertama)
Frame .pen: "Pelanggan - Daftar Pelanggan"; State Pelanggan kosong,
Pencarian pelanggan kosong, Memuat Daftar Pelanggan, Gagal memuat data.
Template: RootScaffold dari RootShellPage; tanpa FooterBar (R7).

## Paritas header bersama 025
| Butir | Paritas |
|---|---|
| Judul/jumlah | AppPageHeader melalui CustomerHeaderSection; jumlah dari customerDirectoryProvider yang sama |
| Status/sync | status shellSyncProvider tetap; avatar Pelanggan dihapus sesuai revisi final, akun melalui Lainnya |
| Daftar/filter/search | rows/filter/search dan semua callback CustomerDirectoryPage tetap |
| Impor/tambah/buka/telepon | rute,AddCustomerSheet,ExternalLauncher dan argumen tetap |
| Loading/error/kosong | skeleton,retry,kosong/tidak ditemukan tetap; jumlah kosong saat belum dimuat |
| Key/keyboard | antrean-golden dan Key lama tetap; field pencarian diuji keyboard300dp |

Komposisi (header bersama disetujui pengguna12 Nov2026):
- Judul/jumlah dipindah dari body ke CustomerHeaderSection → AppPageHeader.
- RootShell boleh membaca customerDirectoryProvider secara kondisional (izin025).
- Header intrinsik tetap di atas daftar saat digulir; judul Pelanggan/subjudul jumlah.
- CustomerDirectoryActionsSection: AppButton 'Impor kontak' (actionOutline) dan
  'Pelanggan baru' (action, ikon add) satu baris; tumpuk vertikal pada layar sempit
  atau teks 1,3x ke atas. Keduanya memakai tinggi tetap touchTarget (48 dp) agar
  ukuran visualnya sama persis.
- AppSearchField('Nama pelanggan', hint 'Cari nama atau nomor WhatsApp...').
- ChipBar: Semua (48), Ada piutang (5), Punya tabungan (5); jumlah dinamis.
- CustomerRow: nama/telepon, avatar, piutang/DP, saldo, jumlah order/total historis.
- EmptyState untuk kosong/tanpa hasil/error; AppSkeleton saat memuat.

Data dan provider:
- B1f main/Drift: jumlah order dan total historis berasal dari transaksi tersimpan,
  mengecualikan pembatalan/soft delete. Tidak menambahkan ringkasan fixture;
  customerHistoryOffsetsProvider kosong secara default. Selisih angka terhadap
  .pen/riwayat ringkasan di bawah disengaja agar cocok dengan ledger aktual.
- Entry memory saja menginjeksi offset historis DATA MASTER; tampilan demo lama tetap.
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
- Impor kontak (tombol atas) -> /pelanggan/impor.
- Pelanggan baru (tombol atas, action ikon add) -> AddCustomerSheet di navigator utama;
  simpan memperbarui daftar, mereset filter dan pencarian. Banner form menjelaskan
  konteks daftar, bukan nota. Tidak ada FooterBar di layar ini (R7).
- Ikon telepon -> ExternalLauncher palsu dengan tel:; disabled bila nomor kosong.
- Coba lagi mengulang provider. Perubahan repository memperbarui daftar dan jumlah.

Format: uang/telepon lewat CustomerRow dan Formatters; nominal seluruhnya int rupiah.
Selisih terhadap .pen:
- Chip Semua/Punya tabungan diberi jumlah sesuai prompt; urutan mengikuti repository.
- DP memakai teks CustomerRow ('DP ...', 'Sisa ...'), tanpa nomor nota A-0140.
- Tombol tambah pindah dari footer ke baris aksi atas bersama Impor kontak (R7);
  pada 320 px/teks 2x keduanya ditumpuk vertikal.
- Loading memakai empat skeleton kartu; header usaha mengikuti RootScaffold yang ada.

Verifikasi: tes fixture/filter/normalisasi, pembatalan, tambah pelanggan/navigasi,
loading/kosong/error/retry, serta lebar 320 px pada teks 2x.
Perangkat Android, keyboard nyata, dan TalkBack belum diuji; belum diuji di iOS.
Panggilan telepon masih palsu; integrasi platform belum diuji di iOS.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.

## Hasil uji header bersama 025 — 12 Nov 2026
- AppPageHeader satu sumber gaya; slot pageHeader RootScaffold mengikuti tinggi isi.
- Uji320/390px,skala1/2,judul/subjudul panjang,semua status sync,aksi akun/cari: lulus.
- Pencarian keyboard300dp,filter/scroll/tab,save profil→inisial→struk tetap lulus.
- dart run tool/check_all.dart: SEMUA HIJAU,1135 lulus,1skip,exit0.
- Format1040 berkas tanpa perubahan; analyzer/lint Riverpod bersih,check_arch OK.
- Tes lama hanya dimigrasikan pada finder/struktur header: count digabung menjadi subjudul;
  nama usaha kini diperiksa lewat data SettingsHeaderSection + inisial; data repo/struk tetap.
- Golden layar terkait diperbarui; Beranda/default template lama tetap lolos tanpa perubahan.
- Pengguna menerima hasil akhir dan mengizinkan commit; revisi avatar lulus5tes+1golden terarah.
