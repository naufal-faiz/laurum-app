# STATE Laurum
Diperbarui: 2026-10-30 | Cabang dev1rev

## Posisi
R0/R1 SELESAI. R2 implementasi SELESAI; bukti perangkat lama: 366 tes, REPO_MAP 507.
Sisa R2: sinkronisasi PRD menunggu izin eksplisit pengguna (r2-prd-proposal.md).
Jangan mulai R3 sebelum PRD diputuskan.

## Selesai
- Fase 1-8 sampai prompt 70; rincian fase-0..8.md. R0: 38 Section, 50 state.
- R1: keyboard/insets, selectAllOnFocus, diskon, berat fresh/minimum, nominal,
  14 audit keyboard; koreksi teks '0,'/'0,50' tersimpan 500 gram. Rincian r1-input-keyboard.md.
- R2: BottomNavBar lima slot dengan empat tab indeks 0..3. Tengah aksi Transaksi,
  bukan tab; onCreate, createLabel, semantics Transaksi baru, tidak aktif.
- Dua token: navCreateSize 56, navCreateLift 56/3; primary datar, cincin surface.
  RootScaffold tanpa FAB; RootShellPage akun goBranch(3), create push transaksi.
- Empat cabang /antrean,/pelanggan,/laporan,/lainnya. /transaksi sementara rute
  langsung NotaHistoryPage dengan SubScaffold; tidak dihapus, pemindahan tetap R6.
- OutstandingPage: Laporan aktif (2), onSelected context.go ke empat path tab,
  onCreate push /transaksi/baru. Kembali transaksi mempertahankan tab asal.
- Antrean aktif: jumlah order aktif, tanpa tanggal/hari ini. Kosong: Belum ada
  order aktif. Chip dan Perlu dicek tetap. Selesai/dibatalkan dikecualikan.
- Tes baru: sembilan navigasi R2, satu antrean lintas hari/status, satu 320 px/2x
  dan semantics/ketuk area terangkat. Tes terarah 26 lulus.
- Sembilan golden diperbarui (7 Antrean, BottomNavBar, RootScaffold); nav dan
  antrean_normal sudah ditinjau. Spec 01, katalog, Widgetbook diperbarui.

## Sedang dikerjakan / langkah tepat berikutnya
1. Validasi perangkat lama SELESAI: check_all hijau (366 tes, 507 berkas).
   Tiga tes lama disesuaikan dengan perilaku R2: teks kosong 'Belum ada order aktif'
   (antrean_states_test) dan RootScaffold tanpa FAB, aksi Transaksi tengah (widget_test).
2. PRD BELUM diubah: auto-review menolak karena izin eksplisit tidak ditemukan
   pada prompt R2. Usulan konkret: docs/progress/r2-prd-proposal.md.
   Minta izin pengguna untuk tiga perubahan PRD itu; jangan bypass penolakan.
3. Setelah izin, sinkronkan PRD A deskripsi RootScaffold dan bagian 8; tandai
   R2 selesai di INDEX/REVISI, perbarui STATE dan commit. Jangan push/merge.
4. Berikutnya R3-transaksi.md; tinjau navigasi di Android dan teks besar.

## Antrean dan keputusan
- R3-R7 berurutan, lalu 71,80,90,100. Catat bayar/Ingatkan piutang placeholder.
- Utang Section tetap 25, hanya menyusut; migrasikan saat disentuh.
- OrderEditBodySection slot details lintas fitur tetap keputusan R0.
- R5 hanya nota + pembayaran; pengeluaran ke 71. Prompt 70: tanpa Urutkan,
  switch langsung, receiptFooter, signOut placeholder90, top services Minggu ini,
  CSV BOM titik koma, piutang ledger, nonaktif tidak menghapus data.
- Pembatalan order/tabungan belum rollback lintas repository.
- R2 hanya dua token ukuran baru; registry/lint/dependensi tetap.
- Formatters beratInput mempertahankan teks draf; perhitungan tetap int gram.
- Perangkat baru: repo C:/Users/Naufal/Downloads/laurum-app (clone GitHub).
- Detached HEAD dipulihkan menjadi dev1rev, upstream origin/dev1rev.
  Fetch dan git push --dry-run berhasil; belum melakukan push aktual.
- Flutter/Dart belum ditemukan di PATH maupun lokasi SDK umum; check_all belum
  dijalankan ulang di perangkat ini. Siapkan SDK sebelum melanjutkan kode R3.
- Android/iOS, keyboard nyata, TalkBack/VoiceOver dan printer nyata belum diuji.

## Untuk agen penerus
Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status dan git log -5.
Lanjut bagian Sedang dikerjakan. Pengguna meminta berhenti mendekati sisa 10%.
