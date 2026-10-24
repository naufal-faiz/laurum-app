# STATE Laurum
Diperbarui: 2026-10-24 | Cabang dev1

## Posisi
Prompt 13-organisms-2.md SELESAI: delapan organisms baru, tiga checkpoint.
check_all: SEMUA HIJAU; 200 tes; kedua analyzer bersih; check_arch OK.
REPO_MAP 310 berkas, 55/60 widget. Berhenti menunggu tinjauan; jangan mulai prompt 14.

## Selesai
- Fondasi, atoms 17, molecules 21, organisms 9 (prompt 12) sesuai catatan fase-1.md.
- Domain prompt 10 (80ed571), audit data dummy prompt 11 (c17cd40), organisms O1a-O1c.
- Prompt 13: ReceiptFormatter (32 kolom) + Formatters.tanggalStruk, ReceiptPreview
  dengan tepi bergerigi, ReceiptToggleList, Numpad standar/desimal.
- Prompt 13: AppBottomSheet, ConfirmModal (biasa/destruktif), ReportSummary, TopServices,
  WeeklyBarChart tanpa paket chart.
- Setiap widget punya use-case semua varian, tes kontrak/callback, golden 390 px, dan uji
  320 px + skala teks 2x. API dan selisih tercatat di component_catalog.md.
- Commit checkpoint 1 dan 2 tercatat di git log; checkpoint 3 = commit penutup prompt 13.
- Perbaikan tinjauan: nominal ExpenseRow rata kanan; status LockedRow sejajar switch.

## Sedang dikerjakan
- Tidak ada. Prompt 13 ditutup setelah check_all hijau.

## Antrean
1. Tinjau delapan organisms dan selisih visual di docs/progress/fase-1.md.
2. Berikutnya: docs/prompts/14-templates.md (5 templates, penutup Fase 1, 60/60 widget).
3. Setelah tinjauan: layar 20-antrean.md dan seterusnya sesuai INDEX.md.

## Keputusan dan batas
- Struk 32 kolom memakai Formatters; status LUNAS/LUNAS (TABUNGAN)/DP/BELUM BAYAR,
  SISA BAYAR selalu tampil, baris lain mengikuti ReceiptSettings dan receipt_template.md.
- Alamat lengkap DATA MASTER membungkus dua baris seimbang; frame memakai satu baris tanpa
  kota. Tepi struk memakai clipper 8 px, bukan path .pen.
- ReportSummary dipadatkan agar <=110 baris: metrik dua baris, kewajiban satu kartu,
  piutang tanpa lingkaran ikon. Perlu ditinjau terhadap frame.
- ConfirmModal varian biasa memakai tombol action; frame hanya menunjukkan destruktif.
  Isi modal digulir agar teks 2x tidak overflow. Close sheet berlatar putih (atom lama).
- Grafik mingguan tanpa paket chart; hari belum terjadi memakai garis putus-putus;
  tinggi grafik bertambah mengikuti skala teks.
- Organisms hanya primitif/enum/domain model dan callback; tanpa provider/navigasi.
- Data pelengkap DATA MASTER disetujui prompt 11; baseline laporan Hari/Minggu/Bulan.
- Formatters.nomorNota masih kunci A; transaksi Order/Savings atomik ditunda ke alur kasir.
- Selisih visual lama dipertahankan: Ionicons, mono w400, nav 61 px, DP amber.
- Atom/token/registry/lint/PRD tidak diubah. Tanpa dependensi baru.

## Pemeriksaan dan batas
- Android/iOS perangkat, TalkBack/VoiceOver, SafeArea nyata belum diuji; APK ditunda.
- Screenshot Pencil baru tidak dibuat pada prompt ini; perbandingan memakai referensi
  yang sudah dibaca dan golden Flutter. Transport VS Code masih tidak tersedia.
- package-lock.json untracked tidak terkait; tidak diubah atau di-commit.
- Tidak push/merge. Prompt berikutnya dijalankan hanya setelah pengguna meminta.
