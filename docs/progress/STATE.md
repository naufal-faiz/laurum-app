# STATE Laurum
Diperbarui: 2026-10-30 | Cabang dev1rev

## Posisi
R0/R1/R2 SELESAI. Bukti otomatis perangkat lama: 366 tes, REPO_MAP 507.
PRD R2 disinkronkan dengan izin eksplisit pengguna 30 Oktober 2026; pemeriksaan
manual R2 di ponsel Android dikonfirmasi pengguna.
R3 SEDANG: kode/tes tanpa SDK, BELUM TERVALIDASI. Rincian: r3-transaksi.md.
R4 DRAF PARSIAL: fondasi model/policy/preservasi profil; belum ada toggle atau alur cetak.

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
- R3 draf: FAB layanan, tombol Baru, migrasi CustomerSection; enam tes baru belum
  dijalankan, golden/REPO_MAP perlu ditinjau saat SDK tersedia. Lihat r3-transaksi.md.
- Permintaan pengguna melanjutkan bagian yang memungkinkan tanpa SDK: R4 fondasi
  profil useOrderStatus default true, aturan awal/label/transisi dan 12 tes kontrak.
- R4 belum aktif di UI. Guard repository order masih mode lama. Lihat catatan
  docs/progress/r4-status-order.md sebelum meneruskan policy ke repository/settings.
- Berikutnya: guard repository yang konsisten, toggle, checkout/AI, Antrean/Detail,
  alur selesai/cetak dan koreksi ledger sesuai R4; spec dan kolom sinkron PRD B.
- R3/R4 tetap BELUM TERVALIDASI. Di perangkat SDK: format/analyze/tes, golden,
  check_all dan regenerasi REPO_MAP. Jangan menandai selesai atau mulai R5 dulu.
- Tidak memasang SDK atau melakukan push/merge. Semua draf disimpan lewat commit wip.

## Antrean dan keputusan
- R3-R7 berurutan, lalu 71,80,90,100. Catat bayar/Ingatkan piutang placeholder.
- Utang Section 24: TransactionCustomerSection dimigrasikan pada R3; hanya menyusut.
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
- Pengguna 30 Okt 2026: JANGAN memasang SDK di laptop ini (keterbatasan sumber daya).
  Coding dan penulisan tes dapat diteruskan tanpa SDK; prasyarat PRD R2 selesai.
  Format/analyze/check_all ditunda sampai pengguna mengonfirmasi perangkat baru;
  perubahan kode berikutnya harus ditandai BELUM TERVALIDASI, bukan hijau.
- R2 diperiksa manual di Android oleh pengguna; iOS, cakupan keyboard nyata,
  TalkBack/VoiceOver dan printer nyata belum diverifikasi pada sesi ini.

## Untuk agen penerus
Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status dan git log -5.
Lanjut bagian Sedang dikerjakan. Pengguna meminta berhenti mendekati sisa 10%.
