# Fase 8 - Lainnya bagian 1 (25 Oktober 2026)

- Prompt 70 dikerjakan dari baseline bersih commit 6f4954e (301 tes).
- Tab /lainnya mengganti placeholder dengan Pengaturan dan Akun: kelompok
  OPERASIONAL/PENGATURAN/AKUN, NoticeAi, versi, dan Keluar lewat ConfirmModal.
- Daftar Layanan: enam fixture DATA MASTER, pencarian, header total, switch
  aktif, dan tombol tambah. Switch langsung mengubah katalog Pilih Layanan.
- Tambah/Edit Layanan memakai satu form: tipe, nama, harga digit, ChipBar
  estimasi 1-5 hari, ToggleRow aktif, validasi, dan catatan harga khusus Edit.
- Info Usaha menyunting profil dan ikut memperbarui AppBarRoot serta struk.
- Sinkronisasi dan bagian Akun masih placeholder; keduanya dilengkapi prompt 90.
- Pengeluaran, AI, dan /masuk tetap placeholder sesuai urutan prompt.
- Selisih visual dicatat di spec 19-22. Tidak ada widget, tema, registry,
  dependensi, atau PRD yang diubah.
- Tes baru: settings (3), direktori/form layanan (4), info usaha (2),
  router diperluas. Termasuk layar 320 px dan teks 2x.
- check_all hijau: 310 tes, REPO_MAP 493 berkas, check_arch OK.

## Temuan
- ServiceItem tidak punya copyWith; ditambahkan helper copyService di lapisan
  pages (bukan domain) agar tidak mengubah model.
- ID layanan baru memakai microsecond waktu nyata; jam usaha dummy tetap
  sehingga dua layanan baru tidak bertabrakan.
- receiptFooter dan receiptNote adalah field terpisah; Info Usaha hanya
  menyunting footer, note tetap di Printer dan struk.

## R5 - Keputusan komposisi laporan (31 Oktober 2026)
- Custom dihitung di state/report_custom_data.dart melalui repository publik dan
  buildReport baseline nol; kontrak ReportRepository tidak diperluas. Ini menjaga
  tiga baseline preset dan menghindari meminjam omzet/top services historis.
- Pengguna mengonfirmasi pengeluaran tersimpan ikut custom (menggantikan batas
  lama STATE). Posisi piutang/tabungan tetap aktual usaha sesuai domain; flows
  mengikuti tanggalnya. Empty custom menyembunyikan ringkasan posisi global.
- Fixture memiliki nota/pengeluaran sebelum minggu 12-18 Okt, berbeda dengan
  asumsi singkat REVISI-01. Data aktual itu tetap dihitung bila masuk rentang;
  tidak menambah/mengubah DATA MASTER atau membatasi tanggal secara semu.
- Grafik maksimal tujuh hari memakai organism lama; lebih panjang diberi pesan.
  Top services aktual mendukung rentang, memakai alokasi diskon domain yang ada.
- Daftar nota CSV menunggu view R6. SDK flutter_localizations saja ditambahkan;
  tema hanya DatePickerThemeData/token yang sudah diizinkan R5.
