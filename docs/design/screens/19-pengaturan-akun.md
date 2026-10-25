# 19 - Pengaturan dan Akun
Rute: /lainnya (tab kelima)   Prompt: 70
Frame .pen: "Lainnya - Pengaturan & Akun"; State "Keluar dari akun".
Template: RootScaffold dari RootShellPage; isi memakai SettingsMenuSection.

Komposisi:
- SectionHeader 'OPERASIONAL'; AppCard berisi MenuRow:
  Layanan dan tarif, Pengeluaran, Printer dan struk, Otomatisasi AI.
- NoticeAi di bawah kelompok AI.
- SectionHeader 'PENGATURAN'; AppCard berisi MenuRow Info usaha & alamat
  (subtitle alamat profil) dan Sinkronisasi.
- SectionHeader 'AKUN'; AppCard berisi LockedRow 'Email Google & hapus akun'
  (Segera) dan MenuRow Keluar. AppText 'Laurum v1.0.0'.

Data dan provider:
- businessProfileProvider untuk subtitle alamat.
- whatsappConnectionProvider untuk status Terhubung/Terputus pada Otomatisasi AI.
- authServiceProvider.signOut saat Keluar dikonfirmasi.

Interaksi:
- Layanan dan tarif -> /lainnya/layanan; Pengeluaran -> /lainnya/pengeluaran;
  Printer dan struk -> /lainnya/printer; Otomatisasi AI -> /lainnya/ai;
  Info usaha -> /lainnya/info-usaha; Sinkronisasi -> /lainnya/sinkronisasi.
- Keluar membuka ConfirmModal 'Keluar dari akun?' dengan pesan
  'Data tetap tersimpan online. Anda bisa masuk lagi kapan saja.'.
  Konfirmasi memanggil signOut lalu menuju /masuk (placeholder prompt 90).

State layar: modal konfirmasi keluar; tab 320 px dan teks 2x diuji.

Selisih terhadap .pen:
- Baris Sinkronisasi dan kelompok AKUN ditambahkan sesuai PRD A bagian 11;
  isinya placeholder sampai prompt 90. Subtitle memakai teks ringkas, bukan
  kalimat panjang .pen. Baris Riwayat usulan AI belum ada (prompt 80).
- Judul AppBarRoot memakai nama usaha dari Info Usaha, sesuai keputusan global.
- Pengeluaran belum menampilkan total bulan ini (prompt 71).
