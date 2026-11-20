# 12 - Pelanggan - Daftar Pelanggan
## Redesign FigCraft — persiapan 13 Nov 2026
Frame pilihan: `LAURUM · Pelanggan` (`4294969460`, 390 × 844).
Proposal027 disetujui pengguna 13 Nov 2026 ("ya lakukan"). Struktur frame dibaca sekali.

### Paritas redesign
Implementasi proposal027 selesai; semua butir paritas diverifikasi.

| Butir | Data/aksi/keadaan yang dipertahankan | Verifikasi |
|---|---|---|
| Data | customerDirectoryProvider; nama/nomor/inisial/orderCount/historyTotal/debt/savings/paid | [x] |
| Header | jumlah pelanggan dan indikator sinkron dari sumber yang sama | [x] |
| Filter | customerDirectoryFilterProvider; Semua/Ada piutang/Punya tabungan; jumlah dari semua rows | [x] |
| Cari | customerDirectorySearchProvider; normalisasi nama/nomor; hapus pencarian | [x] |
| Lihat semua | awal10 hasil setelah filter/search; ekspansi semua hasil; reset saat query/filter berubah; izin eksplisit pengguna | [x] |
| Impor | context.push('/pelanggan/impor') | [x] |
| Tambah | AddCustomerSheet.show(forOrder: false); sukses mereset filter/search | [x] |
| Buka | context.push('/pelanggan/$id') | [x] |
| Kontak | launcher sama; phone pelanggan/message kosong; disabled jika nomor kosong | [x] |
| Uang | Belum bayar atau DP + Sisa; tabungan; Formatters tetap | [x] |
| Keadaan | 4 skeleton, gagal/retry, kosong, tidak ditemukan, terisi | [x] |
| Key/fokus | Page/list/actions/header/CustomerRow tanpa Key eksplisit; host antrean-golden tetap | [x] |
| Keyboard | pencarian inset300dp, viewport320, teks besar, semua aksi terjangkau | [x] |

### Selisih desain
- Header jumlah pemilik piutang belum tersedia pada API Section; jumlah pelanggan
  dipertahankan dahulu tanpa mengubah pembacaan provider shell.
- Angka/nama Figma hanya contoh; data tetap dari repository.
- Revisi pengguna: tampil awal maksimal10 hasil; Lihat semua membuka seluruh hasil
  di daftar yang sama, bukan rute baru. Batas diterapkan setelah filter/pencarian.
- Informasi DP dan Sisa dipertahankan meski tidak tampil pada contoh Figma.
- Margin24/gap10/12 memakai token; font minimum/area sentuh mengikuti keputusan global.
- Tinggi aksi48 sesuai revisi sebelumnya; chip tetap horizontal dan dapat digulir.
- Frame detail pelanggan4294969558 dipilih pengguna untuk irisan berikutnya.
- Status memakai AppStatusText/AppText yang tersedia, bukan chip baru; DP/Sisa tetap.
- Tombol WhatsApp memakai tileSuccess48, bukan tombol32 pada contoh frame.
- Kedua tombol memakai AppButtonSize.small (teks label), tinggi sentuh tetap48;
  impor memakai AppIcons.download. Pada layar acuan label tampil satu baris.

### Revisi batas10 dan Lihat semua — disetujui pengguna
- Pengguna secara eksplisit mengizinkan perubahan perilaku dan zona state terkait,
  termasuk melewati batasan AGENTS.md yang diperlukan untuk permintaan ini.
- CustomerDirectoryExpansion menyimpan status Lihat semua dalam Riverpod, dibaca Page;
  Section menerima showAll/onShowAll. Tidak ada perubahan repository/skema/rute.
- Perubahan filter atau pencarian mereset ekspansi. Jumlah chip tetap seluruh pelanggan.
- Footer menampilkan jumlah hasil/total cocok; Lihat semua hanya jika hasil lebih10.
- Hasil kosong tidak menampilkan footer; hasil10atau kurang tidak menampilkan link.
- Tidak perlu proposal komponen baru: footer adalah Section sefitur, tersusun dari
  AppText/InlineLink yang terdaftar; API shared, token dan dependensi tetap.
- Tes terarah15lulus; check_all SEMUA HIJAU1222lulus/2skip Supabase lokal, exit0.
- Tes lama tidak dilemahkan: actions_section_test menambah assertion ikon/ukuran;
  limit_test menguji ekspansi10ke48, reset filter/search dan pencarian pelanggan terakhir;
  footer_section_test menguji ringkasan dan callback pada lebar272.
- Golden customer_directory diperbarui dan diperiksa; keyboard300dp lulus suite penuh.

### Implementasi proposal027
- CustomerRow: padding12, status Wrap berjarak8 dengan runSpacing6, WhatsApp tileSuccess;
  ringkasan memakai AppCard muted/padding sync. API dan nilai uang tetap.
- Daftar: horizontal24/vertikal12, gap10; tombol sejajar jika konten minimal320 dan
  skala di bawah1,3; selain itu bertumpuk. Tinggi tetap48.
- Tes lama tidak diubah/dilemahkan; customer_row_test menambah kasus DP/Sisa sempit,
  customer_directory_actions_section_test menambah kasus aksi sejajar pada lebar342.
- Dua golden diperbarui: customer_row dan customer_directory; keduanya diperiksa.
- Tes terarah14lulus; analisis lima berkas bersih. check_all SEMUA HIJAU: 1218 lulus, 2 skip integrasi Supabase lokal; exit0.

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
| Impor/tambah/buka/WhatsApp | rute dan AddCustomerSheet tetap; ikon WhatsApp membuka chat nomor pelanggan melalui ExternalLauncher.launchWhatsApp |
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
- Ikon WhatsApp -> ExternalLauncher.launchWhatsApp dengan nomor pelanggan dan pesan
  kosong; disabled bila nomor kosong. Build perangkat memakai launcher WhatsApp nyata.
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
Integrasi WhatsApp platform belum diuji di iOS.


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
