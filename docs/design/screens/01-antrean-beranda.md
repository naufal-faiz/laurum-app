# 01 — Antrean - Beranda
Rute: /antrean. Redesign: frame FigCraft 408 (10 Nov 2026), proposal 015.
Template: RootScaffold pada RootShellPage, empat cabang StatefulShellRoute.

## Paritas redesign (proposal 015, tes perilaku dan widget)

| Butir | Jenis | Status | Sumber/aksi yang dipertahankan |
|---|---|---|---|
| Order aktif, pelanggan, item/layanan, total, waktu | Data | ✅ | antreanDataProvider, Formatters |
| Status order, status pembayaran, sisa COD | Data | ✅ | pemetaan lama di AntreanOrdersSection |
| Usulan, teks lengkap, nama, waktu | Data | ✅ | antreanDataProvider.proposals |
| Filter 0..4 dan mode status nonaktif | Aksi/data | ✅ | antreanFilterProvider, AntreanFilterView |
| Buka order/usulan, Tolak, majukan status/pelunasan | Aksi | ✅ | callback dan argumen lama tetap |
| Pending/klik ganda, galat aksi | Keadaan | ✅ | antreanActionsProvider |
| Memuat, gagal+Coba lagi, kosong, filter kosong, review kosong | Keadaan | ✅ | AntreanStatusSection |
| Notice nota, offline, sync gagal, WhatsApp terputus+Hubungkan | Keadaan/aksi | ✅ | provider dan callback lama |
| Akun, status sinkronisasi | Aksi/data | ✅ | akun melalui Lainnya; sync di header bersama sesuai proposal025 |
| ord-*/ValueKey(order.id), antrean-golden | Key tes | ✅ | tidak diubah |
| Query nama/nota/layanan/teks usulan, kosong, tutup, keyboard | Baru diminta pengguna | ✅ | state layar saja, tanpa persistensi |
| Pindah tab, filter/scroll bertahan, reduced motion | Animasi | ✅ | navigator tetap di pohon |

## Selisih desain frame 408
- Koreksi pengguna12 Nov2026/proposal025: AntreanHeaderSection mendelegasikan
  LAURUM/judul/subjudul/aksi/status ke AppPageHeader yang sama dengan Pelanggan/Lainnya.
  Jumlah order/review dan sync pindah dari AntreanSummarySection ke header intrinsik;
  kelas summary lama dihapus. Cari/tutup,query,filter,Key,banner dan callback tetap.
- Pengguna meminta contoh akurasi: badge bertanda `contoh` hanya di main_dummy
  melalui fixture terpisah; build utama tidak menampilkan akurasi buatan.
- Dua tab seperti frame; filter status lama ada di ikon Filter status. Daftar utama
  menampilkan dua usulan, Lihat semua menampilkan seluruhnya. Pesan dua baris
  sebagai preview; teks lengkap di Periksa. Semua CTA pembayaran/status tetap ada.
- Jumlah order aktif/perlu dicek sejajar dengan sync di header bersama025. Nama usaha dan ikon
  akun dihapus sesuai permintaan terakhir pengguna; akun tetap melalui Lainnya.
- Header LAURUM/Antrean/ikon cari tetap di slot AppBar, bukan di ListView.
- Ukuran font global 16/13 dipertahankan; tinggi kartu mengikuti isi, bukan 74/124
  dp seperti teks contoh Figma. Teks dan nominal memakai data aplikasi.

## Komposisi
- AppBar tetap: LAURUM, Antrean, ikon Cari/Tutup. Posisi vertikal LAURUM sama
  dengan Beranda pada teks 1x/2x. Ringkasan jumlah dan SyncService berada di body;
  pada teks besar ringkasan dan sync tersusun vertikal agar terbaca.
- Pencarian dibuka dari ikon, fokus otomatis; query menyaring nama/nota/layanan
  dan teks usulan di data aktif. Tutup membersihkan query; tidak disimpan.
- ChipBar utama: Semua (atau status terpilih) dan Perlu dicek. Ikon filter membuka
  AntreanFilterSheet berisi Semua/Jemput/Proses/Siap/Perlu dicek dari data yang sama.
- SectionHeader Rekomendasi AI dan ProposalCard.compact untuk semua usulan menunggu.
- SectionHeader Antrean berjalan dan OrderCard untuk order aktif,
  terbaru dahulu. Tombol status biru mempertahankan semua aturan pending/COD.
- Fade tab 220 ms easeOutCubic, reduced motion langsung; navigator/scroll/filter
  tetap terpasang. Animasi push transaksi 280 ms yang lama tetap.
- Tanpa FAB. BottomNavBar empat tab: Beranda, Antrean, Pelanggan, Lainnya
  (sejak redesign 10 Nov 2026; Laporan tidak lagi punya slot).
  Empat tab berindeks 0..3; Transaksi adalah aksi push /transaksi/baru dan tidak aktif.
  Tombol primary 52 dp di dalam cincin 58 dp, menonjol di atas pil nav mengambang;
  ikon AppIcons.add; label Transaksi di bawah lingkaran.
  semantics 'Transaksi baru'. Akun menuju Lainnya (3).
  Ketuk memberi ripple Material; /transaksi/baru masuk dengan fade + lift singkat
  (280 ms, easeOutCubic; balik 200 ms) dari transaction_routes.dart.
- BannerMessage dan AppButton Hubungkan hanya saat koneksi WhatsApp palsu terputus.

## Data dan provider
Mulai B1f, main memakai Drift per akun (mode memory tetap tersedia secara eksplisit).
Sebelum rute dibangun, root menampilkan Membuka data lokal atau error penyimpanan
dengan Coba lagi; teks pengecualian tidak ditampilkan. Empty state antrean tetap.
Order/item/pembayaran dibatasi status aktif lewat getActiveOrders/getActiveItems/
getActivePayments; tidak membaca seluruh riwayat atau satu query untuk setiap nota.
Data bisnis bertahan saat restart; AI/usulan/WhatsApp tetap in-memory sampai B7.
Database/foto native belum diuji di iOS. Rincian dan hasil perangkat: docs/progress/b1f.md.

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

## R9 - COD
Kartu memakai paymentLabel dari pemetaan state bersama dan penanda COD - belum dibayar
selama ada sisa. COD belum lunas tetap aktif karena penyelesaian ditolak state/repository.
Dalam mode aktif, kartu siap menampilkan Terima pembayaran, membuka sheet pembayaran
yang menyimpan pelunasan dan selesai atomik. Langkah sebelum siap tetap normal.
Banner Nota {nomor} tersimpan dari tombol Ke antrean tampil sekali selama empat detik.
Filter/query Antrean dan fixture master tidak diubah. Tes COD 320 px/teks 2x ditambahkan.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.

## Koreksi 016 (10 Nov 2026)
- Paritas tabel di atas tetap lengkap. Header mempertahankan LAURUM label hasil suntingan pengguna; tinggi slot 64, ringkasan tanpa padding vertikal. Padding daftar menjadi satu jarak sebelum chip.
- Rekomendasi AI dan Antrean berjalan memakai warna primary atas permintaan pengguna (frame memakai primaryInk).
- Modal filter pada navigator utama, menutupi nav bawah dan tombol Transaksi; opsi/data/callback tetap sama.
- Keadaan loading memakai AppLoader dari aset refined pengguna; kosong/error/retry tidak berubah.
- Tes lama antrean_states hanya mengganti finder AppSkeleton menjadi AppLoader. Golden loading memakai reduced motion agar deterministik; assertion perilaku tetap.

## Koreksi loader 017 (11 Nov 2026)
AppLoader dipusatkan pada gate Membuka data lokal bersama judul/deskripsi. Gate
menunggu pembacaan awal antrean/pelanggan/laporan tanpa mengganti sumber datanya.
Loading halaman kembali memakai skeleton, sehingga startup lokal tidak melewati
loader tambahan di daftar. Error dan retry tetap. Padding kecil AntreanPage yang
ditambahkan pengguna sebelum sesi dipertahankan.

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
