# STATE Laurum
Diperbarui: 2026-10-31 | Cabang dev1rev

## Posisi
R0-R7 SELESAI otomatis. check_all terakhir hijau: 449 tes, REPO_MAP 553 berkas.
Pelanggan: aksi di atas; Akun: tombol Keluar destruktif terpisah dari kartu.
Transaksi: tombol tengah ber-ripple, rute alur memakai transisi fade + lift.

## Selesai
- Fase 1-8 sampai prompt 70; rincian fase-0..8.md. R0: 38 Section, 50 state.
- R1: keyboard/insets, diskon, berat fresh/minimum, nominal, audit input;
  koma/nol desimal tetap di layar. Rincian r1-input-keyboard.md.
- R2: empat tab, aksi Transaksi tengah, tanpa FAB Beranda, Antrean aktif,
  navigasi Piutang. PRD disinkronkan dan Android manual dikonfirmasi 30 Okt.
- R3: FAB Layanan baru di dua rute pemilih; sembunyi saat keyboard; katalog
  reaktif; Baru langsung tambah/pilih pelanggan. Section pelanggan Stateless.
  Sembilan skenario baru lulus; dua golden ditinjau, registry/tema/dependensi tetap.
- Validasi ulang 31 Okt: format draf dirapikan, empat lint diperbaiki tanpa ignore,
  seluruh 387 tes lulus. Rincian docs/progress/r3-transaksi.md.
- R4: useOrderStatus default true, toggle Lainnya/PENGATURAN, checkout/profil/repository
  mengikuti policy. Antrean sederhana dua chip, Detail Edit/Hapus/Selesaikan;
  cetak sukses/fallback/Hapus bertabungan/piutang tervalidasi. 428 tes hijau.
  AI masih placeholder 80; spec 01/09/19/PRD B sinkron. Rincian r4-status-order.md.
- R5: state range inklusif -> akhir domain eksklusif, kalender 1 Jan 2026..clock,
  label/batal/ekspor aktif; komposisi repository aktual tanpa baseline custom.
  Grafik <=7 hari dan top services aktual; empty tidak meminjam posisi global.
  Golden laporan/kalender ditinjau, 320 px/teks 2x/7 hari lulus. 15 tes baru; 443 hijau.
- R6: ReportOrdersSection (pencarian, 4 chip, grup tanggal, buka Detail) di semua
  periode; CSV nota; /transaksi, NotaHistoryPage, spec 11 dihapus. 445 hijau.
  Rincian docs/progress/r6-laporan-nota.md.
- R7: aksi Pelanggan baru + Impor kontak di atas (responsif 320 px/2x), tanpa
  FooterBar; Keluar jadi tombol destructiveOutline berikon logout di bawah kartu,
  ConfirmModal destruktif. 447 hijau. Rincian r7-pelanggan-akun.md.
- Animasi Transaksi: tombol tengah BottomNavBar memakai Material ink; rute
  /transaksi/baru, /layanan, /bayar memakai fade + lift 280 ms easeOutCubic
  (balik 200 ms) dari transaction_routes.dart. 449 hijau.
  Rincian animasi-transaksi.md.

## Sedang dikerjakan / langkah tepat berikutnya
1. SEMUA HIJAU: dua analyzer bersih, check_arch OK, 449 tes. Golden nav, root,
   antrean, r4_settings, dan r5_report diperbarui (selisih hanya tepi lingkaran).
   Rincian dan bukti di animasi-transaksi.md.
2. 71-lainnya-b.md berikutnya: Daftar dan Catat Pengeluaran.
3. Tinjauan Android/iOS/pembaca layar dan ekspor/printer nyata belum dilakukan.
4. Persetujuan AI baru prompt 80; wajib gunakan initialOrderStatus dari profil.

## Keputusan dan batas
- Keputusan pengguna 31 Okt: R5 menyertakan pengeluaran yang sudah tersimpan;
  menggantikan batas lama hanya nota/pembayaran. CRUD pengeluaran tetap prompt 71.
- R6: daftar nota hanya nota tersimpan dalam range; preset baseline historis tidak
  dijadikan nota. Custom: omzet ringkasan = jumlah daftar non-batal. OrderCard
  ringkas dipakai agar label status mengikuti mode R4; CSV memuat daftar nota.
- R7: Pelanggan baru/Impor kontak jadi aksi atas (bukan FooterBar); Keluar di luar
  kartu AKUN sebagai tombol destruktif, modal ikon logout. MenuRow Keluar dihapus.
- Animasi Transaksi hanya di tombol tengah dan tiga rute alur; rute lain tetap
  transisi bawaan. Ripple memakai warna bawaan tema (tanpa token warna baru).
- Utang Section 21; ReportBodySection sekarang aksi piutang callback tanpa router.
- R4 selesai tidak wajib lunas; toggle Lainnya/PENGATURAN default aktif.
- Izin 31 Okt: statusLabel opsional OrderCard, label mengikuti dua mode; proposal 001.
- Izin 31 Okt: order lama Menunggu jemput boleh langsung selesai setelah cetak
  sukses dalam mode sederhana; toggle sendiri tidak mengubah order lama.
- OrderEditBodySection slot details lintas fitur tetap keputusan R0.
- Prompt 70: tanpa Urutkan, switch langsung, receiptFooter, signOut placeholder90,
  top services preset Minggu ini, CSV BOM titik koma, piutang ledger, nonaktif tidak hapus data.
- Pembatalan order/tabungan belum rollback lintas repository.
- Sesudah R7: 71,80,90,100. Catat bayar/Ingatkan piutang masih placeholder.
- Repo C:/Users/Naufal/Downloads/laurum-app. Branch dev1rev melacak origin/dev1rev.
- SDK: E:/App Data/flutter/flutter; cache/lock di luar workspace perlu akses eskalasi.
- Graph lokal kini laurum-app (root C:/Users/Naufal/Downloads/laurum-app);
  indeks lama E-Latihan-Pemrograman-laurum-projects-laurum menunjuk checkout lama.
- R3/R4: Android/iOS perangkat, TalkBack/VoiceOver dan printer nyata belum diuji.

## Untuk agen penerus
Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status/log. Lanjut bagian di atas.
Berhenti mendekati sisa usage 10%; simpan perubahan dengan bukti validasi dan commit.
