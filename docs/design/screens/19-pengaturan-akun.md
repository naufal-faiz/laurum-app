# 19 - Pengaturan dan Akun
Rute: /lainnya (tab Lainnya, indeks 3; Transaksi adalah aksi tengah)   Prompt: 70/R4
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
- SectionHeader 'AKUN'; AppCard berisi LockedRow 'Email Google & hapus akun'
  (Segera) dan MenuRow Keluar. AppText 'Laurum v1.0.0'.

Data dan provider:
- businessProfileProvider untuk subtitle alamat dan useOrderStatus.
- orderStatusSettingProvider: saving/error, baca profil terkini dan simpan langsung;
  sakelar disabled selama memuat/menyimpan. Gagal mempertahankan nilai tersimpan dan
  BannerMessage 'Gagal menyimpan pengaturan. Coba ubah sakelar lagi.'.
- SettingsMenuSection dan SettingsOperationalSection Stateless, navigasi lewat
  callback dari SettingsPage. Tidak membaca provider/router di Section.
- whatsappConnectionProvider untuk status Terhubung/Terputus pada Otomatisasi AI.
- authServiceProvider.signOut saat Keluar dikonfirmasi.

Interaksi:
- Layanan dan tarif -> /lainnya/layanan; Pengeluaran -> /lainnya/pengeluaran;
  Printer dan struk -> /lainnya/printer; Otomatisasi AI -> /lainnya/ai;
  Info usaha -> /lainnya/info-usaha; Sinkronisasi -> /lainnya/sinkronisasi.
- Keluar membuka ConfirmModal 'Keluar dari akun?' dengan pesan
  'Data tetap tersimpan online. Anda bisa masuk lagi kapan saja.'.
  Konfirmasi memanggil signOut lalu menuju /masuk (placeholder prompt 90).
- Mengubah toggle memperbarui Antrean/Detail lewat invalidasi profil; data order
  lama tidak diubah. Default true mempertahankan tahap/CTA, false memakai alur R4.
- Checkout membaca profil terkini saat menyimpan; kasir langsung diproses, event
  created mengikuti status aktual dan repository menerima policy yang sama.
- Persetujuan AI belum tersedia (placeholder prompt 80). initialOrderStatus sudah
  diuji untuk source whatsappAi kedua mode; caller persetujuan kelak wajib memakainya.

State layar: modal konfirmasi keluar; tab 320 px dan teks 2x diuji.
R4: simpan gagal/retry, ketukan ganda, golden r4_settings.png, toggle -> checkout ->
cetak sukses/gagal -> fallback dan Hapus bertabungan diuji. Android/iOS perangkat
dan printer nyata belum diuji.

Selisih terhadap .pen:
- Baris Sinkronisasi dan kelompok AKUN ditambahkan sesuai PRD A bagian 11;
  isinya placeholder sampai prompt 90. Subtitle memakai teks ringkas, bukan
  kalimat panjang .pen. Baris Riwayat usulan AI belum ada (prompt 80).
- Judul AppBarRoot memakai nama usaha dari Info Usaha, sesuai keputusan global.
- Pengeluaran belum menampilkan total bulan ini (prompt 71).
- Toggle R4 ditambahkan sesuai revisi; tidak ada pada frame .pen lama.
