# STATE Laurum
Diperbarui: 2026-11-10 | Cabang `newdesign`

## Posisi dan sesi aktif
- Dasar sesi `e34fc26`: koreksi Beranda/nav selesai (1020 tes, 1 skip, Android diperiksa).
- Sesi ini: Antrean frame 408 + pencarian dan transisi tab, proposal 015.
- Pengguna menegaskan desain harus cukup akurat terhadap FigCraft dengan adaptasi
  kebutuhan aplikasi; semua data dan aksi lama dipertahankan.
- AppBar LAURUM / Antrean (judul 24) / cari, tinggi 72 mengikuti skala teks.
  LAURUM sejajar vertikal dengan Beranda. Nama usaha dan ikon akun dihapus.
- Jumlah order aktif/perlu dicek sejajar sync di body; teks besar disusun vertikal.
  Akses akun tetap melalui tab Lainnya sesuai koreksi terakhir pengguna.
- Dua tab Semua/Perlu dicek seperti frame; status lama 0..4 ada di ikon filter
  melalui AntreanFilterSheet dan AppBottomSheet. Mode sederhana tetap 0/4.
- Dua rekomendasi preview; Lihat semua memakai select(4) lama dan menampilkan
  seluruh usulan. Pesan dalam bubble lembut, preview dua baris, lengkap di Periksa.
- OrderCard mengikuti posisi frame: pelanggan/badge, layanan, metadata/nominal,
  tambahan CTA status biru dan detail. API/aturan pending, status, COD tetap.
- Pencarian lokal nama/nota/layanan/teks usulan; query layar saja, tanpa persistensi.
- Fade tab 220 ms easeOutCubic tanpa melepas navigator; reduced motion langsung.
- Pengguna meminta akurasi contoh: fixture terpisah hanya pada scope main_dummy,
  badge bertanda contoh. Provider scope data nyata kosong; fixture lama tidak diubah.
- Tombol small visual 40 dp, hit target 48 dp agar aksesibilitas >=44 tetap lulus.

## Verifikasi dan bukti
- Tes terarah aksi/filter/usulan/pencarian/keyboard/motion lulus. Mode sederhana
  dan COD tetap diuji pada 320dp/teks 2x; tes aksesibilitas lama tetap utuh.
- Golden 14 berkas bergeser; daftar + alasan: proposals/015-golden-impact.md.
  Ini termasuk galeri komponen dan tombol banner Beranda (hit target small).
- check_all HIJAU: format 974 (0 berubah), analyze + Riverpod bersih, check_arch OK,
  1036 tes lulus / 1 skip, REPO_MAP 1052 berkas; exit 0 (10 Nov 2026).
  Log lokal: TEMP/laurum-antrean-check-all-green.log.
- Visual Android SM-N975F diverifikasi: header/ringkasan, kartu, sheet filter,
  pencarian dengan keyboard terbuka. Teks LAURUM sejajar Beranda juga diuji 1x/2x.
- Detail izin, selisih, API dan tes: docs/design/proposals/015-antrean-dan-transisi.md.

## Langkah berikutnya
1. Tinjauan pengguna atas Antrean dan 14 golden terdampak.
2. Setelah Beranda DAN Antrean selesai/ditinjau, bahas proposal 014 loader.
   Lottie belum dipasang; referensi JSON dan laurum_loader.dart.txt tetap di docs/design.

## Batas dan backend
- Token sampai template + auth lapisan 6 selesai. Beranda tetap sesuai e34fc26,
  kecuali perubahan hit target small. Jangan menimpa header manual pengguna.
- UI100/R0-R10, BP0, B1a-f, B0, B2a-d, B3a, B3c selesai; B3b dan B2e+ menunggu.
- Berikutnya backend: uji cloud/workmanager Android, Google login, lalu B3b;
  lihat docs/plans/B3-auth.md. Drift v5, wire 5, migrasi cloud 5/5 oleh pemilik.
- PayStatus turunan, COD bersisa ditahan, multi-repo lewat TransactionRunner.
- Zona beku yang diizinkan sesi ini: query UI, contoh akurasi dummy, main_dummy,
  ikon/motion/button style terkait. Domain/repository/transaksi/rute/lint/PRD utuh.

## Lingkungan dan Git
- Sebelum Dart/Flutter: `. ./tool/windows_native_sdk.ps1`.
- Alias Flutter TEMP mengarah E:/flutter/flutter; SDK asli/tool tidak diubah.
- Perubahan docs/design/new-design-laurum.figcraft sudah ada sebelum sesi dan
  dipertahankan di luar commit koreksi. Jangan push/merge tanpa izin.
- Riwayat lama: docs/progress/state-history-2026-11-10.md; spec layar dan proposal
  menyimpan rincian visual/perilaku. iOS belum diuji.
