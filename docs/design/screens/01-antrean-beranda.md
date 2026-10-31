# 01 — Antrean - Beranda
Rute: /antrean. Fase: 2. Frame: zb8jN; state akEX1, zqBHI, MrWTS, P1axJ.
Template: RootScaffold pada RootShellPage, empat cabang StatefulShellRoute.

## Komposisi
- AppBarRoot: nama BusinessRepository, status SyncService, akun ke /lainnya.
- SectionHeader: Antrean aktif, jumlah order aktif tanpa tanggal atau 'hari ini'.
- ChipBar: Semua, Jemput, Proses, Siap, Perlu dicek; jumlah dari repository.
- SectionHeader Perlu dicek dan ProposalCard untuk usulan menunggu.
- SectionHeader Sedang berjalan dan OrderCard untuk order aktif, terbaru dahulu.
- Tanpa FAB. BottomNavBar lima slot: Antrean, Pelanggan, Transaksi, Laporan, Lainnya.
  Empat tab berindeks 0..3; Transaksi adalah aksi push /transaksi/baru dan tidak aktif.
  Tombol primary 56 dp menempel garis atas nav (tanpa cincin dan tanpa celah),
  ikon AppIcons.add; permukaan putih mengisi penuh sampai garis.
  label Transaksi, semantics 'Transaksi baru'. Akun menuju Lainnya (3).
  Ketuk memberi ripple Material; /transaksi/baru masuk dengan fade + lift singkat
  (280 ms, easeOutCubic; balik 200 ms) dari transaction_routes.dart.
- BannerMessage dan AppButton Hubungkan hanya saat koneksi WhatsApp palsu terputus.

## Data dan provider
Fixture DATA MASTER melalui antarmuka repository publik; tanpa membaca fixture di page.
antreanDataProvider menggabungkan order/items/payment/customer/proposal.
antreanFilterProvider menyimpan filter; antreanActionsProvider mengunci aksi dan error.
businessProfileProvider/shellSyncProvider untuk app bar; whatsappConnectionProvider palsu.
Jam bisnis dummy tetap 16 Oktober 2026 melalui override di entry point.

## Interaksi
- Semua: order aktif dan usulan; status: hanya order status itu; Perlu dicek: hanya usulan.
- OrderCard membuka /order/:id; aksi memajukan satu status dan menyimpan OrderEvent.
- Klik ganda pada aksi yang sedang berjalan diabaikan; status usang tidak dimajukan dua kali.
- ProposalCard Periksa membuka /antrean/usulan/:id (placeholder sampai prompt 80).
- Tolak mengubah status usulan menjadi ditolak; tidak membatalkan order terkait.
- Filter/tab bertahan saat pindah tab dan kembali. Rute lain PRD A 8 placeholder eksplisit.
- Hanya menungguJemput/diproses/siap, termasuk order hari sebelumnya. Selesai dan
  dibatalkan tidak muncul. Chip serta usulan Perlu dicek dipertahankan.
- Daftar Piutang: Laporan aktif (2), empat tab berfungsi, aksi push transaksi sama.
- Riwayat Nota dilihat lewat Laporan (R6); rute /transaksi dihapus, bukan cabang tab.

## R4: mode status order
- businessProfileProvider.useOrderStatus true mempertahankan seluruh chip dan CTA.
- Saat false, hanya chip Semua dan Perlu dicek; ID filter internal tetap 0 dan 4.
  Pilihan status lama 1..3 ditampilkan sebagai Semua tanpa menulis ulang pilihan
  atau order; bila mode aktif kembali, filter status lama kembali berlaku.
- AntreanOrdersSection Stateless menerima data/callback dari Page. OrderCard memakai
  showAction false; kartu tetap membuka Detail. Badge diproses menjadi 'Sedang
  dikerjakan' melalui statusLabel opsional (izin pengguna 31 Oktober 2026, proposal 001).
- Controller membaca profil terkini dan menolak callback maju status yang usang
  saat mode nonaktif; tidak menyimpan status atau event.
- Perlu dicek tetap menampilkan/menolak usulan. Saat kosong: 'Belum ada usulan yang
  perlu dicek'. Persetujuan AI masih placeholder, menunggu prompt 80.
- Penyelesaian dari Detail sesudah cetak mengeluarkan order dari Antrean; sisa
  pembayaran tetap piutang. Mengganti mode tidak mengubah data order lama.
- Golden r4_antrean_sederhana.png menampilkan kartu setelah daftar digulir;
  tujuh golden mode aktif tetap. Tes alur pada 390 px dan 320 px dengan teks 2x.
- Toggle global belum ditampilkan sampai integrasi checkout/AI lengkap.
- R4 Android/iOS perangkat dan pembaca layar belum diuji.

## State dan batas
Loading: tiga AppCard berisi AppSkeleton. Error: EmptyState dengan Coba lagi.
Kosong: Belum ada order aktif; tombol Transaksi baru tetap. Filter kosong: Tidak ada order di status ini.
WhatsApp terputus: banner warning; order kasir tetap dapat digunakan.
Nama/nominal/teks pesan mengikuti DATA MASTER, bukan usulan Bu Rina tambahan di .pen.
Pengguna mengonfirmasi pemeriksaan manual R2 di ponsel Android pada 30 Oktober 2026.
Belum diuji di iOS; tidak ada integrasi WhatsApp/jaringan nyata.

## Selisih terhadap .pen
Token/komponen Fase 1 dipertahankan: mono w400, nav dinamis, DP amber, glyph Ionicons.
R2/nav-referensi.png menggantikan nav dan FAB lama di .pen. Header tidak memakai tanggal.
Tes 320 px/teks 2x dan tombol tengah menempel garis atas lulus. Banner dan tombol
Hubungkan terpisah karena API
BannerMessage tidak memiliki slot aksi. Detail/persetujuan AI menunggu prompt 80;
tidak membuat tombol Biarkan/Batalkan order atau data interpretasi yang belum ada di kontrak.
R4 menyembunyikan chip dan CTA dalam mode sederhana; varian ini belum ada di .pen.
