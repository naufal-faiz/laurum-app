# 19 - Pengaturan dan Akun
Rute: /lainnya (tab Lainnya, indeks 3; Transaksi adalah aksi tengah)   Prompt: 70/R4/R10
Frame acuan: MCP FigCraft `LAURUM · Lainnya`, ID4294968100, pilihan pengguna12 Nov2026.
Template: RootScaffold dari RootShellPage; isi memakai SettingsMenuSection.

## Paritas redesign
| Butir | Data/aksi/keadaan/Key | Status |
|---|---|---|
| Profil | businessProfileProvider: alamat,useOrderStatus; nama usaha di shell | Selesai |
| Status setting | orderStatusSettingProvider saving/error; disabled loading/saving | Selesai |
| Akun | authSessionProvider busy/error; authServiceProvider.email; kosong Belum masuk | Selesai |
| WhatsApp | whatsappConnectionProvider Terhubung/Terputus | Selesai |
| Operasional | onNavigate layanan,pengeluaran,printer,AI; rute/argumen tetap | Selesai |
| Pengaturan | onNavigate info-usaha/sinkronisasi; setEnabled(enabled: enabled) | Selesai |
| Kelola akun | onNavigate /lainnya/akun; disabled saat busy | Selesai |
| Keluar | confirmSignOut(context, ref); dialog,batal/konfirmasi,pending/offline,signOut tetap | Selesai |
| Error | BannerMessage setting.error ?? session.error | Selesai |
| Shell | sync loading/sukses/offline/gagal,akun,empat tab,aksi transaksi tetap | Selesai |
| Responsif | gulir,320px teks2x; tanpa field/tes keyboard | Selesai |
| Key tes | antrean-golden dari host; Section tidak punya Key eksplisit | Selesai |

## Ringkasan frame redesign (dibaca sekali)
- Kanvas390×844; header nama usaha + Pengaturan toko · Laurum v1.0.0,
  status simpan dan akun; konten bg,padding horizontal24/vertikal10.
- Kelompok Operasional,Pengaturan,Akun: gap8; judul kecil ink3,gap kartu6.
- Kartu putih radius frame18 dipetakan token16; tanpa padding luar ganda.
- Baris44,ikon kotak primaryTint,label/caption,chevron,divider inset14.
- Operasional: layanan,pengeluaran,Laporan,printer,AI; catatan AI di bawah.
- Pengaturan: alamat aktual,status order,sinkronisasi; akun: Email,nilai,Kelola akun.
- Subtitle Kelola akun: Nama, nomor HP, kata sandi; Keluar outline merah di luar kartu.
- Pemetaan: AppIcon/MenuRow/ToggleRow/NoticeAi varian padat,AppCard,AppDivider,
  AppText caption/label,AppButton kecil,AppBarRoot/RootScaffold subtitle opsional.

## Selisih desain aktif
- Koreksi pengguna12 Nov2026/proposal025: SettingsHeaderSection kini pembungkus tipis
  AppPageHeader, judul Lainnya/subjudul Pengaturan toko · Laurum v1.0.0.
  Inisial usaha dan aksi akun/sync tetap; tinggi intrinsik dari satu komponen bersama.
  Tidak lagi memakai perhitungan88/112dp atau mengubah AppBarRoot semua halaman.
- Proposal024 disetujui 12 Nov 2026; varian komponen dan susunan Lainnya diterapkan.
- Laporan belum ada di menu lama; /laporan sudah tersedia.
  Penambahan onNavigate('/laporan') disetujui pengguna dan diterapkan, router tetap.
- Teks contoh alamat/nama/email tidak disalin; data/provider aplikasi tetap.
- Font8–10.5 dinaikkan sesuai keputusan global minimum11; area sentuh minimal44.
- Radius18/ikon30/gap1 memakai token terdekat; tanpa token khusus layar.
- AppBarRoot lama dan Beranda dipertahankan; header intrinsik025 hanya untuk tiga tab.
- Subjudul header membungkus sesuai ruang; teks dan versi tetap utuh.
- Catatan AI/toggle dan email dapat membungkus; Keluar tetap dapat dicapai dengan gulir.
- Status tersimpan memakai varian global biru; akun Lainnya memakai inisial usaha,
  bukan inisial R contoh frame. Judul/subjudul/gaya dikelola AppPageHeader.

## Verifikasi redesign
- Tes widget lama tetap mempertahankan assertion perilaku; versi pada tes halaman
  dipindah ke subtitle header, peta navigasi Section menambah /laporan.
- settings_redesign_test: golden normal, navigasi Laporan, akun kosong/busy,
  callback MenuRow padat serta seluruh area AppCard tetap interaktif.
- r4_settings_page_test: saving/error/retry dan lebar320 teks2x tetap diuji.
- Golden terkait: lainnya.png baru dan r4_settings.png diperbarui.
- dart run tool/check_all.dart: SEMUA HIJAU, 1109 lulus, 1 skip, exit0 (12 Nov2026).
- Analyzer/lint Riverpod bersih, check_arch OK; visual belum diverifikasi manual di perangkat.

## Komposisi dan perilaku sebelum redesign

Komposisi:
- SectionHeader 'OPERASIONAL'; AppCard berisi MenuRow:
  Layanan dan tarif, Pengeluaran, Printer dan struk, Otomatisasi AI.
- NoticeAi di bawah kelompok AI.
- SectionHeader 'PENGATURAN'; AppCard berisi MenuRow Info usaha & alamat,
  ToggleRow 'Pakai status order', dan MenuRow Sinkronisasi.
- Toggle default aktif. Deskripsi: "Matikan bila usaha tidak melacak tahap cucian.
  Order baru langsung 'Sedang dikerjakan'." Tidak ada tombol Simpan terpisah.
- SectionHeader 'AKUN'; AppCard berisi email sesi dan MenuRow Kelola akun.
  Di bawah kartu: AppButton destructiveOutline 'Keluar' dengan ikon logout.
  AppText 'Laurum v1.0.0'. Tidak ada MenuRow Keluar di dalam kartu (R7).

Data dan provider:
- businessProfileProvider untuk subtitle alamat dan useOrderStatus.
- orderStatusSettingProvider: saving/error, baca profil terkini dan simpan langsung;
  sakelar disabled selama memuat/menyimpan. Gagal mempertahankan nilai tersimpan dan
  BannerMessage 'Gagal menyimpan pengaturan. Coba ubah sakelar lagi.'.
- SettingsMenuSection dan SettingsOperationalSection Stateless, navigasi lewat
  callback dari SettingsPage. Tidak membaca provider/router di Section.
- whatsappConnectionProvider untuk status Terhubung/Terputus pada Otomatisasi AI.
- authSessionProvider menangani masuk/keluar/hapus melalui AuthService palsu.
- Keluar memperingatkan jumlah pending dan menjaga data HP. Hapus akun hanya
  tersedia di Kelola akun (spec 33), tetap melalui dua ConfirmModal.

Interaksi:
- Layanan dan tarif -> /lainnya/layanan; Pengeluaran -> /lainnya/pengeluaran;
  Printer dan struk -> /lainnya/printer; Otomatisasi AI -> /lainnya/ai;
  Info usaha -> /lainnya/info-usaha; Sinkronisasi -> /lainnya/sinkronisasi;
  Kelola akun -> /lainnya/akun.
- Keluar membuka ConfirmModal 'Keluar dari akun?' dengan pesan
  'Data tetap tersimpan online. Anda bisa masuk lagi kapan saja.', ikon logout,
  dan tombol konfirmasi destruktif.
  Konfirmasi memanggil signOut lalu menuju /masuk (email/password atau Google dummy).
- Mengubah toggle memperbarui Antrean/Detail lewat invalidasi profil; data order
  lama tidak diubah. Default true mempertahankan tahap/CTA, false memakai alur R4.
- Checkout membaca profil terkini saat menyimpan; kasir langsung diproses, event
  created mengikuti status aktual dan repository menerima policy yang sama.
- Persetujuan AI (prompt 80) memakai initialOrderStatus sesuai mode aktif.

State layar: modal konfirmasi keluar; tab 320 px dan teks 2x diuji.
R4: simpan gagal/retry, ketukan ganda, golden r4_settings.png, toggle -> checkout ->
cetak sukses/gagal -> fallback dan Hapus bertabungan diuji. Android/iOS perangkat
dan printer nyata belum diuji.

Selisih terhadap .pen:
- Baris Sinkronisasi dan kelompok AKUN ditambahkan sesuai PRD A bagian 11;
  kini berfungsi pada prompt 90. Subtitle memakai teks ringkas, bukan
  kalimat panjang .pen. Riwayat usulan AI berada di Pengaturan AI (prompt 80).
- Judul AppBarRoot memakai nama usaha dari Info Usaha, sesuai keputusan global.
- Pengeluaran belum menampilkan total bulan ini (prompt 71).
- Toggle R4 ditambahkan sesuai revisi; tidak ada pada frame .pen lama.
- R10 mengganti Hapus akun dengan Kelola akun; Keluar tetap di luar kartu (R7).
  Email sesi bisa berasal dari email/password atau Google. Belum diuji di iOS.


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
- Pengguna menerima hasil akhir dan mengizinkan commit; agen belum menguji perangkat langsung.
