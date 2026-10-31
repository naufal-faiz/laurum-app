# R6 - Daftar nota di Laporan (SELESAI otomatis)
Diperbarui: 31 Oktober 2026. check_all hijau: 445 tes.

## Perilaku
- ReportOrdersSection di bawah ringkasan Laporan untuk semua periode: judul
  'Nota (n)', pencarian nomor/nama, ChipBar Semua/Belum lunas/Selesai/Dibatalkan
  (chip Hari ini dihapus), DateGroupHeader, OrderCard ringkas; ketuk ke /order/:id.
- Daftar hanya memuat nota tersimpan yang masuk range aktif. Preset tetap memakai
  baseline DATA MASTER pada ringkasan; baseline historis tidak dibuat menjadi nota
  fiktif, sehingga jumlah daftar bisa lebih kecil dari angka baseline preset.
- Rentang kustom: jumlah dan omzet ringkasan sama dengan daftar nota non-batal
  (16 Okt: 6 nota, Rp177.000). Pencarian/filter tidak mengubah ringkasan.
- Mode status order nonaktif memakai label kebijakan 'Sedang dikerjakan'. OrderCard
  dipakai karena NotaCard tidak punya slot label status; bentuk ringkas tanpa aksi.
- Riwayat Nota dihapus total: rute /transaksi, NotaHistoryPage, FooterBar CTA,
  spec 11, tes lama dipindah ke test/report_orders_test.dart. Tidak ada tautan mati.
- Logika data/filter pindah ke reports/state/report_orders_data.dart (git mv);
  controller menjadi report_orders_controller.dart (filter 0..3). Detail pelanggan
  memakai reportOrdersProvider.
- CSV semua periode memuat nomor, tanggal, pelanggan, total, status bayar nota.
- Tes keyboard pencarian nota di /laporan (viewInsets 300 dp) lulus.

## Bukti terarah
- Unit: range minggu 14 nota Rp589.000 urut terbaru; pencarian 'rina' -> A-0141;
  filter Selesai -> A-0138/A-0136; 16 Okt 6 nota Rp177.000.
- Widget: daftar/filter/pencarian/buka Detail/batal memperbarui daftar.
- Ekspor: baris 'A-0142 16 Okt Pak Dedi Budiarto 31500 Belum bayar'.

## Selisih .pen / tindak lanjut
- Frame 'Transaksi - Riwayat Nota' tidak dipakai lagi; daftar mengikuti gaya
  Laporan tanpa frame baru. OrderCard ringkas menggantikan NotaCard karena label
  status mengikuti pengaturan R4.
- Android/iOS perangkat dan pembaca layar belum diuji; ekspor masih palsu.
- Ringkasan preset baseline vs daftar nota aktual sengaja berbeda; jelaskan ke
  pengguna bila angka daftar dianggap harus sama dengan baseline historis.

## Bukti validasi penuh
Perintah: dart run tool/check_all.dart, 31 Oktober 2026.
```text
Formatted 483 files (0 changed)
flutter analyze: No issues found!
dart analyze: No issues found!
check_arch: OK
+445: All tests passed!
REPO_MAP diperbarui: 551 berkas
check_all: SEMUA HIJAU
```
