# 18 - Daftar Piutang
Rute: /laporan/piutang   Prompt: 60
Frame .pen: "Laporan - Daftar Piutang"; State "Piutang kosong".
Template: RootScaffold dari RootShellPage; BottomNavBar dengan Laporan aktif.

Komposisi:
- SectionHeader(title: 'Piutang', subtitle: 'Total piutang usaha Rp400.500 / 5 nota belum lunas - 5 pelanggan').
- ChipBar: Semua (5), Belum bayar (2), DP (3); jumlah dari filter aktif.
- PiutangCard per nota urut tertua: nomor, nama pelanggan, tanggal, total piutang sisa,
  status (Belum bayar/DP), CTA "Catat bayar" dan "Ingatkan".
- AppText catatan "Piutang tidak dapat dihapus; catat bayar atau tandai lunas di kasir.".

Data dan provider:
- outstandingOrdersProvider: filter order dengan piutang > 0 (paymentReceived < total),
  urutkan createdAt ascending (tertua dulu), berikut customer dan payment info.
- outstandingFilterProvider: indeks chip (0 semua, 1 belum bayar, 2 DP).
- Sumber: OrderRepository + CustomerRepository + PaymentRepository.
- DATA MASTER: 5 nota piutang, total Rp400.500, Belum bayar 2, DP 3.

Interaksi:
- Chip memfilter daftar tanpa mengubah hitungan.
- "Catat bayar" membuka sheet Numpad (maks piutang sisa), update Payment dan Order
  (paymentReceived += nominal), kembali ke daftar dengan saldo baru.
- "Ingatkan" memanggil ExternalLauncher.launchWhatsApp dengan teks siap kirim (template
  di fixture, tidak mengirim otomatis).
- State kosong (State "Piutang kosong"): EmptyState 'Tidak ada piutang', deskripsi
  'Semua nota sudah lunas.', aksi tidak ada.

Format: uang int rupiah; tanggal lewat Formatters. Tanpa jatuh tempo.

Selisih terhadap .pen:
- Tanpa Atur; header ringkasan disatukan SectionHeader.
- ChipBar menempatkan Semua di depan urutan filter.
- Catatan ditambah akhir (bukan status bar sticky).
