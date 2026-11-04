# 19 - Pengaturan dan Akun
Rute: /lainnya (tab Lainnya, indeks 3; Transaksi adalah aksi tengah)   Prompt: 70/R4/R10
Frame .pen: "Lainnya - Pengaturan & Akun"; State "Keluar dari akun".
Template: RootScaffold dari RootShellPage; isi memakai SettingsMenuSection.

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
