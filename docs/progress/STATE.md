# STATE Laurum
Diperbarui: 2026-10-25 | Cabang dev1

## Posisi
Prompt 70 SELESAI. check_all SEMUA HIJAU: 310 tes, REPO_MAP 493 berkas.
Pengaturan dan Akun, Daftar/Tambah/Edit Layanan, dan Info Usaha terimplementasi.

## Selesai
- Fase 1: 60/60 widget. Prompt 20-51: Antrean, transaksi, pembayaran/nota, printer
  palsu, Detail/Edit Order, Riwayat Nota, Daftar/Detail/Edit Pelanggan,
  Setor/Riwayat Tabungan, Impor Kontak palsu. Rincian fase sebelumnya di fase-5/6.md.
- Prompt 60 Ringkasan: PeriodTabs, ReportSummary, WeeklyBarChart, TopServices,
  kartu piutang, ekspor CSV palsu, loading/error/retry/kosong. Angka Minggu ini
  sesuai DATA MASTER. Checkout/pembayaran reaktif terhadap periode.
- Prompt 60 Daftar Piutang: /laporan/piutang dengan BottomNavBar Laporan aktif,
  header total piutang, ChipBar Semua/Belum bayar/DP, lima PiutangCard urut tertua,
  catatan immutable. Catat bayar dan Ingatkan masih placeholder.
- Prompt 70 Pengaturan dan Akun: /lainnya memakai SettingsPage, kelompok
  OPERASIONAL/PENGATURAN/AKUN, NoticeAi, versi, LockedRow akun, dan Keluar lewat
  ConfirmModal. Sinkronisasi dan isi Akun menunggu prompt 90.
- Prompt 70 Daftar Layanan: enam fixture DATA MASTER, header total/aktif,
  pencarian, ServiceRow, switch aktif langsung tersimpan, tombol tambah, serta
  loading/error/kosong. Perubahan langsung terlihat di katalog Pilih Layanan.
- Prompt 70 Tambah/Edit Layanan: satu form, Kiloan/Satuan, nama, harga, ChipBar
  estimasi 1-5 hari, ToggleRow aktif, validasi, busy, dan catatan harga khusus Edit.
- Prompt 70 Info Usaha: nama, alamat, telepon, catatan kaki struk; simpan
  memperbarui AppBarRoot dan struk. Spec layar 19-22 dan rincian di fase-8.md.

## Antrean
- Revisi hasil uji HP (25 Okt 2026): kerjakan seri R dulu, dari docs/prompts/R0-struktur-section.md
  sampai R7; daftar di docs/revisi/REVISI-01.md. Prompt 71 ditunda sampai R7 SELESAI.
- Setelah seri R: docs/prompts/71-lainnya-b.md (Daftar dan Catat Pengeluaran).
- Setelah itu 80-ai.md (layar AI dummy) dan 90-auth-sinkron.md (Masuk Google,
  Sinkronisasi, Akun).
- Catat bayar dan Ingatkan di Daftar Piutang masih perlu sheet Numpad dan
  ExternalLauncher WhatsApp; implementasi terpisah bila diminta.

## Keputusan dan batas
- Prompt 70: direktori layanan memakai pencarian tanpa kontrol Urutkan; urutan
  tetap sortOrder. Switch aktif menyimpan segera lewat ServiceRepository.
- ID layanan baru memakai microsecond waktu nyata agar tidak bertabrakan dengan
  jam usaha dummy. ServiceItem belum punya copyWith; helper copyService diletakkan
  di features/services/pages, bukan domain.
- Info Usaha hanya menyunting receiptFooter. receiptNote ('Pakaian bersih, wangi &
  rapi') tetap di Printer karena keduanya field terpisah.
- Keluar memanggil AuthService.signOut lalu menuju /masuk (placeholder prompt 90).
  Rute Lainnya dipisah ke lainnya_routes.dart agar app_router.dart tetap 99 baris.
- ReportRepository hanya punya top services Minggu ini. Hari/Bulan menampilkan
  keterangan belum tersedia; tidak meminjam angka minggu (DATA MASTER bagian akhir).
- Grafik minggu = fixture harian + snapshot order kini - order fixture awal;
  hari mendatang null. Ringkasan uang int rupiah; rata-rata harian pembagian integer.
- ExportService menerima CSV UTF-8 BOM, pemisah titik koma, angka rupiah mentah;
  bukan XLSX nyata. Ganti periode disabled saat ekspor; kegagalan dapat dicoba lagi.
- OutstandingListData menghitung total piutang, jumlah nota, jumlah pelanggan,
  dan chip filter dari ledger aktual. PiutangCard tanpa jatuh tempo.
- Customer summaries termasuk nonaktif; daftar hanya aktif. Nonaktif tidak menghapus
  nota/piutang/tabungan. Riwayat dummy baseline + selisih snapshot, bukan nota fiktif.
- Setor chip aditif, maksimal 9 digit. Mutasi dihitung sebelum memfilter baris.
- Impor normalizePhone, kontak aktif/nonaktif dilewati. Semua fixture kontak sudah
  terdaftar: dummy 0 baru; tes memakai override ContactSource. Izin masih palsu.
- Pembatalan order lalu penyesuaian tabungan belum memiliki rollback lintas repository.
- Tidak mengubah widget bersama/registry/tema/lint/PRD/dependensi. Test layar 320 px
  dan teks 2x lulus.

## Handoff untuk agen penerus
1. Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status/log sebelum melanjutkan.
2. Lanjut prompt 71-lainnya-b.md bila diminta; satu layar/kelompok widget per sesi,
   berhenti menunggu tinjauan.
3. Pengguna meminta berhenti bila sisa usage mendekati 10%; cek usage berkala dan
   simpan STATE + commit sebelum berhenti.
4. Launcher sandbox kadang gagal karena drive G: terkunci. Read/exec di luar sandbox
   yang disetujui berhasil membaca repo E: dan menjalankan SDK. Bukan lokasi proyek G:.
5. Android/iOS perangkat, keyboard, TalkBack/VoiceOver, ekspor/telepon/printer nyata belum diuji.
Tidak push/merge.
