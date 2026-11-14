# 029 — Irisan laporan
Status: MENUNGGU PERSETUJUAN; branch ui/pelanggan, dasar7580497.
Acuan: LAURUM · Laporan4294968337, pilihan aktif pengguna, dibaca14Nov2026.

## Komponen bersama (UI-13; satu persetujuan)
- ReportSummary: kartu laba biru+bubble, nilai/total transaksi dan rincian pendapatan/
  pengeluaran; kas/tabungan dan piutang berdampingan, bertumpuk untuk layar/font besar.
- StatTile: tambah onTap=null ke AppCard untuk kartu piutang; data tetap melalui
  ReportSummary.onOutstandingTap. Pertahankan warna label primaryInk yang sudah ada
  sebagai perubahan lokal workspace, lalu verifikasi golden yang terdampak.
- TopServices: padding lebih rapat, peringkat dan ikon layanan memakai komponen
  registry, nama/kuantitas/pendapatan/persentase/progress tetap lengkap dan membungkus.
- API/nilai default yang ada dipertahankan; token dan dependensi tidak ditambah.

## Page/Section
- ReportHeaderSection: judul+subjudul periode, kembali dan Ekspor Excel dengan ikon;
  ekspor pindah ke baris berikutnya saat sempit/teks besar. PeriodTabs tetap semua4opsi.
- RootShellPage: sembunyikan hanya appbar usaha lama pada /laporan agar header tidak
  ganda; provider, navbar, tujuan dan rute tidak berubah.
- Margin24 dan jarak14 memakai token yang ada; loading/error/kosong/pesan ekspor tetap.
- Nota lengkap, pencarian, filter, pengelompokan tanggal dan buka order tetap di bawah
  ringkasan; tidak dipotong menjadi satu nota contoh dan tidak menambah aksi mati.
- Tidak menyalin teks Figma "dihitung dari nota lunas"; semantik ledger/uang tetap.
- Chart yang sudah disetujui tetap primaryTint→primary, bulan harian geser horizontal;
  custom>7hari dan seluruh aksi uang/ekspor tetap sesuai sumber lama.

## Verifikasi
- Tes aksi/data/keyboard tetap; uji langsung280–600dp,font0,85–2×,nominal/nama panjang.
- Golden laporan dan komponen terdampak; perbarui golden radius batch7580497 bila perlu.
- check_all akhir, satu commit feat(ui), tinjauan pengguna; tanpa merge/push.
