# 11 - Riwayat Nota
Rute: /transaksi (tab Transaksi)   Fase: 5   Frame .pen: "Transaksi - Riwayat Nota";
state "State - Riwayat nota kosong"
Template: RootScaffold (dari RootShellPage) + FooterBar untuk CTA di atas BottomNavBar

Komposisi (urut dari atas, HANYA nama widget registry + argumen penting):
- AppBarRoot dari RootShellPage (nama usaha, SyncIndicator, akun)
- AppSearchField(label 'Nama pelanggan', hint 'Cari nomor nota atau nama pelanggan')
- ChipBar: Semua, Hari ini, Belum lunas, Selesai, Dibatalkan
- DateGroupHeader('Hari ini - Jumat, 16 Okt 2026') per tanggal masuk
- NotaCard(nomor, jam, pelanggan, total, ringkasan layanan, AppBadge status,
  AppStatusText pembayaran)
- FooterBar + AppButton 'Transaksi baru' di atas BottomNavBar
- BottomNavBar lima tab

Data dan fixture: seluruh Order dari repository (termasuk selesai/dibatalkan),
OrderItem (ringkasan), Payment (status bayar), Customer (nama), DATA MASTER.
Snapshot awal berisi 16 nota (12 antrean + 4 riwayat selesai), belum termasuk A-0143;
A-0143 dan A-0144 baru muncul setelah alur transaksi membuatnya.
Provider: notaHistoryProvider (order, item, payment, pelanggan),
notaFilterProvider (0..4), notaSearchProvider (teks), businessClockProvider.

Interaksi:
- Semua: semua nota; Hari ini: enteredAt sama dengan jam bisnis; Belum lunas:
  payStatus belumBayar/DP dan bukan dibatalkan; Selesai/Dibatalkan: status itu.
- Pencarian mencocokkan nomor nota atau nama pelanggan tanpa membedakan huruf besar.
- NotaCard membuka /order/:id (Detail order), menggantikan placeholder.
- 'Transaksi baru' membuka /transaksi/baru.
- Pembatalan/edit di Detail order langsung mengubah daftar, Antrean, dan Laporan.

State layar: kosong 'Belum ada nota' + 'Nota yang Anda buat akan tampil di sini.',
pencarian/filter tanpa hasil, loading skeleton, gagal memuat + Coba lagi.

Format: jam 'HH.mm WIB', tanggal panjang Indonesia lewat Formatters; total rupiah.

Selisih terhadap .pen: label kolom 'Nama pelanggan' dipakai sebagai label aksesibilitas
AppSearchField (bukan judul terpisah); tanggal pada NotaCard memakai jam masuk order;
ringkasan A-0140 tidak menambahkan 'Sisa Rp15.000' karena NotaCard tidak punya slot
detail (sisa terlihat di Detail order dan chip Belum lunas).
