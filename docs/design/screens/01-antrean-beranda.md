# 01 — Antrean - Beranda
Rute: /antrean. Fase: 2. Frame: zb8jN; state akEX1, zqBHI, MrWTS, P1axJ.
Template: RootScaffold pada RootShellPage, lima cabang StatefulShellRoute.

## Komposisi
- AppBarRoot: nama BusinessRepository, status SyncService, akun ke /lainnya.
- SectionHeader: Antrean hari ini, tanggal melalui Formatters dan total order aktif.
- ChipBar: Semua, Jemput, Proses, Siap, Perlu dicek; jumlah dari repository.
- SectionHeader Perlu dicek dan ProposalCard untuk usulan menunggu.
- SectionHeader Sedang berjalan dan OrderCard untuk order aktif, terbaru dahulu.
- FAB Transaksi baru ke /transaksi/baru; BottomNavBar lima tab.
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

## State dan batas
Loading: tiga AppCard berisi AppSkeleton. Error: EmptyState dengan Coba lagi.
Kosong: Belum ada order hari ini; filter kosong: Tidak ada order di status ini.
WhatsApp terputus: banner warning; order kasir tetap dapat digunakan.
Nama/nominal/teks pesan mengikuti DATA MASTER, bukan usulan Bu Rina tambahan di .pen.
Belum diuji di Android/iOS perangkat; tidak ada integrasi WhatsApp/jaringan nyata.

## Selisih terhadap .pen
Token/komponen Fase 1 dipertahankan: mono w400, nav dinamis, DP amber, glyph Ionicons.
Tanggal memakai format baku dengan tahun. Banner dan tombol Hubungkan terpisah karena API
BannerMessage tidak memiliki slot aksi. Detail/persetujuan AI menunggu prompt 80;
tidak membuat tombol Biarkan/Batalkan order atau data interpretasi yang belum ada di kontrak.
