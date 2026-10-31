# R5 - Rentang tanggal dan ekspor atas (SELESAI otomatis)
Diperbarui: 31 Oktober 2026. check_all hijau: 443 tes.

## Perilaku
- Empat tab Hari ini/Minggu ini/Bulan ini/Pilih tanggal. Kalender bawaan Flutter
  Indonesia, mode kalender saja, 1 Jan 2026..businessClock; satu hari boleh.
- Terapkan mengaktifkan indeks 3, label inklusif dari Formatters. Batal tetap
  periode/range sebelumnya. Model akhir eksklusif; daftar direset saat range berubah.
- Pengguna mengonfirmasi pengeluaran tersimpan ikut perhitungan pada 31 Okt,
  menggantikan batas lama STATE. Tidak membangun layar CRUD pengeluaran prompt 71.
- Komposisi repository publik di report_custom_data.dart, buildReport baseline nol;
  kontrak ReportRepository dan fixture tetap. Preset lama tetap angka DATA MASTER.
- Omzet/nota enteredAt, pengeluaran spentAt, kas paidAt/setoran createdAt di range.
  Piutang/tabungan adalah posisi terkini sesuai domain, bukan penjumlahan arus.
  Custom kosong hanya EmptyState; tidak menampilkan posisi global atau baseline.
- Snapshot historis sebelum 12 Okt ternyata tersedia; dihitung bila masuk range,
  berbeda dari asumsi ringkas REVISI-01. Januari tanpa data tetap kosong.
- Grafik custom <=7 hari dari nota nyata; >7 diberi BannerMessage. Top services
  dihitung dari snapshot item dan allocateRevenue; bila snapshot tak lengkap,
  tampil keterangan, tanpa meminjam rincian Minggu ini.
- Ekspor Excel pindah ke SectionHeader; pesan tepat di bawah, footer dihapus.
  Disabled loading/kosong/busy. CSV aktif mengikuti range, BOM/titik koma tetap;
  filename custom laporan-YYYYMMDD-YYYYMMDD.csv. Daftar nota menyusul R6.
- ReportBodySection tanpa router/provider, callback piutang dari Page, utang 22 -> 21.
- SDK flutter_localizations menjadi dependensi langsung lewat flutter pub add;
  sebelumnya transitive. App locale id_ID dan delegates, tema hanya DatePickerThemeData
  memakai token lama. Registry/organisms/dependensi pihak ketiga/PRD tidak diubah.

## Bukti terarah dan visual
- TDD rentang/state: tes gagal sebelum API tersedia. Satu hari 16 Okt: 6 nota,
  omzet 177.000, pengeluaran 145.000, kas 130.500, laba 32.000 (bukan baseline375.000).
- 14-15 Okt: 8 nota, omzet 412.000, pengeluaran 85.000, kas 258.000.
  Batal nota/hapus pengeluaran memperbarui omzet/grafik/top services secara reaktif.
- Batas/UTC/urutan hari, lintas bulan/tahun, empty/long range, picker/cancel/preset,
  export busy/CSV/header, callback Section dan scroll rentang tercakup.
- Dua golden r5_report_custom.png/r5_date_picker.png dirender dan ditinjau. Font
  MaterialIcons dimuat pada tes kalender agar ikon native tidak menjadi kotak.
- Grafik tujuh hari dan kalender lulus di 320 px/teks 2x; tampilan 390 px ditinjau.
- Total 15 tes baru. Seluruh 443 tes lulus, termasuk regresi baseline dan golden lama.

## Bukti validasi penuh
Perintah: dart run tool/check_all.dart, 31 Oktober 2026.
```text
Formatted 484 files (0 changed)
flutter analyze: No issues found!
dart analyze: No issues found!
check_arch: OK
+443: All tests passed!
REPO_MAP diperbarui: 552 berkas
check_all: SEMUA HIJAU
```
Log: TEMP/laurum-r5-all.log. ReportPage 100 baris, ReportBodySection 69,
report_range_flow 32, customReportData 55. Tidak ada ignore lint atau perubahan aturan.

## Selisih .pen / tindak lanjut
- Ekspor di header dan tab Pilih tanggal/rentang menggantikan Atur sesuai R5.
  Native Material range picker tidak ada pada frame lama; token lama dipertahankan.
- Android/iOS perangkat, pembaca layar, dan ekspor nyata belum diuji. ExportService
  masih palsu sesuai fase saat ini. Tidak membuat XLSX atau paket pihak ketiga.
- R5 ditutup di INDEX/STATE. Berikutnya R6 untuk
  daftar nota aktif dan CSV daftar nota; tidak memulai R6 pada sesi ini.
