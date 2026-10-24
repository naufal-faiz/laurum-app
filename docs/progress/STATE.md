# STATE Laurum
Diperbarui: 2026-10-25 | Cabang dev1

## Posisi
Prompt 51 selesai di 1e94f8f. Prompt 60 SEDANG: Laporan Ringkasan diimplementasikan;
Daftar Piutang belum dikerjakan. Sesi dibatasi satu layar, menunggu tinjauan.
Verifikasi final: check_all SEMUA HIJAU; 299 tes; kedua analyzer bersih; check_arch OK;
format 401 berkas (0 berubah); REPO_MAP 468 berkas. Tujuh tes laporan baru lulus.

## Selesai
- Fase 1: 60/60 widget. Prompt 20-51: Antrean, transaksi, pembayaran/nota, printer
  palsu, Detail/Edit Order, Riwayat Nota, Daftar/Detail/Edit Pelanggan,
  Setor/Riwayat Tabungan, Impor Kontak palsu. Rincian fase sebelumnya di fase-5/6.md.
- /laporan: PeriodTabs, ReportSummary, WeeklyBarChart, TopServices, kartu piutang,
  satu tombol Ekspor ke Excel, loading/error/retry/kosong.
- Periode awal Minggu ini; totals sesuai DATA MASTER. Checkout/pembayaran memperbarui
  ringkasan dan grafik. Ekspor CSV memakai FakeExportService, tidak membuat file nyata.

## Sedang dikerjakan
- Tidak ada. Laporan Ringkasan selesai; tunggu tinjauan sebelum Daftar Piutang.

## Antrean
1. Tinjau /laporan: ganti periode, angka minggu, grafik/layanan, ekspor palsu.
2. Lanjut docs/prompts/60-laporan.md bagian Daftar Piutang: /laporan/piutang masih
   placeholder; perlu BottomNavBar Laporan aktif, filter, catat bayar, ingatkan.
3. Setelah prompt 60 selesai: docs/prompts/70-lainnya-a.md.

## Keputusan dan batas
- ReportRepository hanya punya top services Minggu ini. Hari/Bulan menampilkan
  keterangan belum tersedia; tidak meminjam angka minggu (DATA MASTER bagian akhir).
- Grafik minggu = fixture harian + snapshot order kini - order fixture awal;
  hari mendatang null. Hari ini satu batang; grafik Bulan belum tersedia.
- Ringkasan uang int rupiah; rata-rata harian pembagian integer. Urutan layanan pendapatan.
- ExportService menerima CSV UTF-8 BOM, pemisah titik koma, angka rupiah mentah;
  bukan XLSX nyata. Ganti periode disabled saat ekspor; kegagalan dapat dicoba lagi.
- Tanpa arus periode tampil EmptyState; posisi tabungan/piutang tetap terlihat jika ada.
- Selisih .pen: tanpa Atur, puncak di bawah grafik, label Operasional usaha;
  rincian ada di spec 18-laporan-ringkasan.md. Tidak mengubah widget bersama/registry/
  tema/lint/PRD/dependensi. Test layar 320 px dan teks 2x lulus.
- Customer summaries termasuk nonaktif; daftar hanya aktif. Nonaktif tidak menghapus
  nota/piutang/tabungan. Riwayat dummy baseline + selisih snapshot, bukan nota fiktif.
- Setor chip aditif, maksimal 9 digit. Mutasi dihitung sebelum memfilter baris.
- Impor normalizePhone, kontak aktif/nonaktif dilewati. Semua fixture kontak sudah
  terdaftar: dummy 0 baru; tes memakai override ContactSource. Izin masih palsu.
- Pembatalan order lalu penyesuaian tabungan belum memiliki rollback lintas repository.

## Handoff untuk agen penerus
1. Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status/log sebelum melanjutkan.
2. Lanjut bagian Daftar Piutang dari prompt 60 setelah pengguna meninjau Ringkasan.
3. Pengguna meminta berhenti bila sisa usage mendekati 10%; cek usage berkala dan
   simpan STATE + commit sebelum berhenti. Tool AI Memory tidak tersedia.
4. Launcher sandbox kadang gagal karena drive G: terkunci. Read/exec di luar sandbox
   yang disetujui berhasil membaca repo E: dan menjalankan SDK. Bukan lokasi proyek G:.
5. Android/iOS perangkat, keyboard, TalkBack/VoiceOver, ekspor/telepon/printer nyata belum diuji.
Tidak push/merge.
