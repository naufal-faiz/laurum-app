# STATE Laurum
Diperbarui: 2026-11-10 | Cabang `newdesign`

## Posisi dan sesi aktif
- Dasar implementasi: `1a4d9e7` (Beranda/nav); audit sebelumnya `35d1b6e`.
- Redesign token, atoms, molecules, organisms, templates, dan auth lapisan 6
  selesai. Sesi ini: koreksi Beranda/nav sesuai arahan pengguna, proposal 013.
- Header manual pengguna (`LAURUM` / `Laundry Management`) dipertahankan dan
  ditempatkan tetap di AppBar bersama ikon notifikasi; tidak ada toolbar kosong.
- Padding Beranda 16 dp; nav margin 8, lima slot fleksibel, tanpa kotak aktif
  atau label ellipsis; konten tampil di sisi tombol Transaksi yang menonjol.
- Antrean aktif menampilkan maksimal tiga layanan berdasarkan jumlah nota aktif
  unik per layanan; label satu baris ellipsis, badge total rata kanan, empty state
  tanpa tile/progress palsu. Repository, fixture, dan penyimpanan tetap.
- Banner minimum 168 dp dan tumbuh mengikuti isi; judul 18, gap teks 4, gap
  tombol 16, padding 18. Tombol small berlabel 13 memakai cursor-back SVG ke kanan.
- Font global: body/input 16/24, label/caption 13/18, meta 12/16, CTA 16/22.
- Awal aplikasi, selesai login, dan selesai onboarding menuju `/beranda`.
- Zona beku yang disentuh atas permintaan pengguna: token, pemetaan Beranda,
  rute awal/auth, dan tes terkait. Tidak mengubah dependensi, lint, PRD, atau tool.

## Verifikasi dan bukti
- Build dummy Android berhasil dipasang/diperiksa pada SM-N975F (wireless).
  Awal Beranda, banner, header, badge, nav, dan perpindahan Antrean diperiksa;
  perangkat dikembalikan ke Beranda. iOS belum diuji.
- 320 dp/teks 2x: tes header tetap, perpindahan tab, dan jarak deskripsi/tombol.
- `check_all: SEMUA HIJAU` (exit 0): 1020 tes lulus, 1 skip; format, kedua analyzer,
  check_arch OK; REPO_MAP 1039. Bukti: TEMP/laurum-beranda-check-all-final.log.
- 115 golden lama berubah karena font global/nav; daftar lengkap dan alasan:
  `docs/design/proposals/013-golden-impact.md`. Menunggu tinjauan visual pengguna.
- Daftar tes yang diubah beserta alasan, paritas, dan bukti Android:
  `docs/design/proposals/013-koreksi-beranda-nav.md`, `docs/design/screens/01-beranda.md`.
- Screenshot lokal: TEMP/laurum-beranda-android.png dan TEMP/laurum-nav-check.png.

## Langkah berikutnya
1. Tinjauan pengguna atas koreksi Beranda/nav dan pergeseran golden.
2. Redesign Antrean frame 408 pada sesi terpisah (isi daftar belum diredesign).
3. Setelah Beranda DAN Antrean selesai/ditinjau, bahas proposal 014 loader.
   Referensi JSON dan `laurum_loader.dart.txt` ada di docs/design; Lottie belum
   dipasang dan varian animasi/dependensi menunggu keputusan pengguna.

## Backend dan batas
- UI100/R0-R10, BP0, B1a-f, B0, B2a-d, B3a, B3c selesai; B3b dan B2e+ menunggu.
- Berikutnya backend: uji cloud ujung-ke-ujung/workmanager Android, Google login,
  lalu B3b (akun uji/peti surat); rencana `docs/plans/B3-auth.md`.
- Drift v5, wire schema 5; migrasi cloud 5/5 sudah diterapkan pemilik.
  PayStatus turunan, COD bersisa ditahan, multi-repository lewat TransactionRunner.
- Keputusan global pengguna: primer #2675C9, hijau success, Inter, tombol 50/44/40;
  koreksi tipografi terbaru pada proposal 013. Utang token auth nol.

## Lingkungan dan Git
- Sebelum Dart/Flutter: `. ./tool/windows_native_sdk.ps1`.
- Alias Flutter TEMP sudah dipulihkan ke E:/flutter/flutter; alias lama dibackup
  sebagai laurum-flutter-sdk-before-beranda-20261110. SDK asli/tool tidak diubah.
- `docs/design/new-design-laurum.figcraft` sudah berubah sebelum sesi; dipertahankan
  dan tidak dimasukkan ke commit koreksi. Jangan push/merge tanpa izin.
- Riwayat rinci sebelum ringkasan ini: `docs/progress/state-history-2026-11-10.md`.
