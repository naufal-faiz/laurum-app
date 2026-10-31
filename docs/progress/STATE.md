# STATE Laurum
Diperbarui: 2026-10-31 | Cabang dev1rev

## Posisi
Fase 1-8 sampai prompt 71 dan R0-R7 selesai otomatis.
check_all: SEMUA HIJAU, 473 tes, kedua analyzer bersih, REPO_MAP 575 berkas.
Baseline sebelum tugas: 454 tes hijau pada commit 1b229a0.

## Selesai
- R0: struktur Section/state; utang Riverpod Section tinggal 21 (tidak bertambah).
- R1: input/keyboard, nominal/berat fresh/minimum; r1-input-keyboard.md.
- R2: empat tab, Transaksi tengah, Antrean aktif; Android dikonfirmasi 30 Okt.
- R3: katalog/FAB Layanan baru, tambah pelanggan; r3-transaksi.md.
- R4: useOrderStatus default aktif, mode sederhana/detail/cetak/selesai;
  r4-status-order.md. Selesai tidak wajib lunas; toggle tidak mengubah order lama.
- R5: laporan range aktual, kalender, grafik/top services/CSV; pengeluaran tersimpan
  termasuk custom range (izin pengguna). Baseline historis tidak dijadikan nota.
- R6: daftar nota/filter/pencarian/CSV di Laporan; Riwayat Nota dihapus.
- R7: aksi pelanggan di atas, Keluar destruktif terpisah dari kartu Akun.
- Nav: tombol tengah menonjol 28 dp, cincin putih 4 dp; area sampingnya milik
  halaman dan menerima tap/scroll. Ripple dan fade/lift tiga rute transaksi tetap.
- Padding akhir scroll Pelanggan/Laporan/Lainnya +28 dp; aksi pelanggan 48 dp;
  AppIconButton transparan. Bukti/golden: animasi-transaksi.md.
- Prompt 71: dua rute pengeluaran, daftar bulan aktual, kategori/filter/grup tanggal,
  detail/hapus terkonfirmasi, form nominal/numpad/tanggal/vendor/catatan/foto palsu,
  kategori baru persisten. Spec 23/24, docs/progress/71-pengeluaran.md.

## Sedang dikerjakan / langkah tepat berikutnya
1. Prompt 71 selesai; bukti check_all di docs/progress/71-pengeluaran.md.
2. Tinjau pengeluaran/nav/keyboard di Android. iOS, pembaca layar, printer/ekspor
   dan foto nyata belum diuji. Jangan mengklaim verifikasi perangkat sudah selesai.
3. Prompt berikutnya setelah 71: docs/prompts/80-ai.md, lalu 90 dan 100.
   AI wajib memakai initialOrderStatus profil. Berhenti setelah satu kelompok.

## Keputusan dan batas
- Terminal/Git/Flutter/test rutin langsung dijalankan tanpa pertanyaan pengguna;
  tanyakan hanya keputusan penting yang melewati aturan/desain. Batas sistem berlaku.
- Pengeluaran hanya dummy in-memory; PhotoPicker palsu, belum integrasi kamera.
- ExpenseRepository mendapat saveCategory untuk Kategori baru prompt 71; tanpa
  perubahan registry, tema/token, dependensi, lint, PRD, atau fixture.
- Catat bayar/Ingatkan piutang, AI, signOut masih placeholder prompt selanjutnya.
- Pembatalan order/tabungan belum rollback lintas repository.
- OrderEditBodySection slot details lintas fitur tetap keputusan R0.
- OrderCard statusLabel opsional (proposal 001) mengikuti dua mode R4.
- Custom omzet ringkasan = jumlah daftar nota non-batal; CSV BOM titik koma.
- Repo aktif: E:/Latihan Pemrograman/laurum-projects/laurum; dev1rev digabung
  fast-forward dari detached e09a81d pada sesi sebelumnya. Jangan push/merge tanpa izin.
- SDK E:/App Data/flutter/flutter; cache SDK/.git memerlukan izin sistem jika dibatasi.
- Graph lokal laurum-app menunjuk C:/Users/Naufal/Downloads/laurum-app;
  indeks E-Latihan-Pemrograman-laurum-projects-laurum lama. REPO_MAP acuan lokal.

## Untuk agen penerus
Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status/log lalu lanjut bagian
Sedang dikerjakan. Riwayat lengkap fase-0..8.md dan catatan R/71 terkait.
