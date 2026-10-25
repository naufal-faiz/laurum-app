# STATE Laurum
Diperbarui: 2026-10-25 | Cabang dev1

## Posisi
Prompt 60 SELESAI. check_all SEMUA HIJAU: 301 tes, REPO_MAP 473 berkas.
Laporan Ringkasan dan Daftar Piutang terimplementasi.

## Selesai
- Fase 1: 60/60 widget. Prompt 20-51: Antrean, transaksi, pembayaran/nota, printer
  palsu, Detail/Edit Order, Riwayat Nota, Daftar/Detail/Edit Pelanggan,
  Setor/Riwayat Tabungan, Impor Kontak palsu. Rincian fase sebelumnya di fase-5/6.md.
- Prompt 60 Ringkasan: PeriodTabs, ReportSummary, WeeklyBarChart, TopServices,
  kartu piutang, ekspor CSV palsu, loading/error/retry/kosong. Angka Minggu ini
  sesuai DATA MASTER. Checkout/pembayaran reaktif terhadap periode.
- Prompt 60 Daftar Piutang: /laporan/piutang dengan BottomNavBar Laporan aktif,
  header total piutang, ChipBar Semua/Belum bayar/DP, lima PiutangCard urut tertua,
  catatan immutable. outstandingListProvider menghitung dari OrderRepository +
  CustomerRepository + PaymentRepository; PiutangCard menampilkan tanggal dan umur.
  Catat bayar dan Ingatkan belum diimplementasi (TODO placeholder).

## Antrean
- Berkas prompt berikutnya: docs/prompts/70-lainnya-a.md (Pengaturan dan Akun,
  Layanan, Info Usaha).
- Catat bayar dan Ingatkan di Daftar Piutang perlu sheet Numpad dan ExternalLauncher
  WhatsApp; implementasi terpisah bila diminta.

## Keputusan dan batas
- ReportRepository hanya punya top services Minggu ini. Hari/Bulan menampilkan
  keterangan belum tersedia; tidak meminjam angka minggu (DATA MASTER bagian akhir).
- Grafik minggu = fixture harian + snapshot order kini - order fixture awal;
  hari mendatang null. Hari ini satu batang; grafik Bulan belum tersedia.
- Ringkasan uang int rupiah; rata-rata harian pembagian integer. Urutan layanan pendapatan.
- ExportService menerima CSV UTF-8 BOM, pemisah titik koma, angka rupiah mentah;
  bukan XLSX nyata. Ganti periode disabled saat ekspor; kegagalan dapat dicoba lagi.
- OutstandingListData menghitung total piutang, jumlah nota, jumlah pelanggan,
  dan chip filter dari ledger aktual; tidak menggunakan nilai pre-computed.
- PiutangCard menampilkan sisa tagihan, tanggal, dan umur (X hari lalu);
  tanpa jatuh tempo (sesuai prompt).
- Tanpa arus periode tampil EmptyState; posisi tabungan/piutang tetap terlihat jika ada.
- Tidak mengubah widget bersama/registry/tema/lint/PRD/dependensi. Test layar 320 px
  dan teks 2x lulus.
- Customer summaries termasuk nonaktif; daftar hanya aktif. Nonaktif tidak menghapus
  nota/piutang/tabungan. Riwayat dummy baseline + selisih snapshot, bukan nota fiktif.
- Setor chip aditif, maksimal 9 digit. Mutasi dihitung sebelum memfilter baris.
- Impor normalizePhone, kontak aktif/nonaktif dilewati. Semua fixture kontak sudah
  terdaftar: dummy 0 baru; tes memakai override ContactSource. Izin masih palsu.
- Pembatalan order lalu penyesuaian tabungan belum memiliki rollback lintas repository.

## Handoff untuk agen penerus
1. Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status/log sebelum melanjutkan.
2. Lanjut prompt 70-lainnya-a.md bila diminta; satu layar/kelompok widget per sesi,
   berhenti menunggu tinjauan. Tool AI Memory tidak tersedia; handoff disimpan di repo.
3. Pengguna meminta berhenti bila sisa usage mendekati 10%; cek usage berkala dan
   simpan STATE + commit sebelum berhenti.
4. Launcher sandbox kadang gagal karena drive G: terkunci. Read/exec di luar sandbox
   yang disetujui berhasil membaca repo E: dan menjalankan SDK. Bukan lokasi proyek G:.
5. Android/iOS perangkat, keyboard, TalkBack/VoiceOver, ekspor/telepon/printer nyata belum diuji.
Tidak push/merge.
