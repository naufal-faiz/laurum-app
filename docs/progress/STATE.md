# STATE Laurum
Diperbarui: 2026-11-14 | Cabang ui/pelanggan

## Sesi aktif
Finalisasi modal030 dan verifikasi laporan029, dasar08dc364.
Frame4294968452 dibaca sekali; FigCraft masih aktif dengan frame sama.
Proposal030 disetujui; pengguna meminta perapihan dan verifikasi akhir.

## Status irisan
- Batas AppRangeCalendar110baris dan lint controller diperbaiki; check_arch lulus.
- Regresi laporan/modal40tes dan8tes kalender/back/barrier/golden lulus.
- Viewport280/320/390/600, font1/2; reset, satu hari/range, batal dan buka ulang lulus.
- check_all: format1133berkas bersih; flutter analyze dan dart analyze bersih;
  check_arch OK; tes1253lulus,36gagal,2skip. Repo map belum dijalankan.
- 34kegagalan golden cocok komponen bersama yang disetujui029/7580497.
- Batch pembaruan34golden lulus; satu tes alur non-golden keliru ikut batch.
- Dua tes non-golden tersisa: bulanan masih expect daily=null; label Pendapatan/Masuk.
- Golden report/modal4lain juga diperbarui; belum ada check_all hijau akhir.
- Visual golden ditinjau; visual belum diverifikasi manual pada HP/iOS.

## Keputusan pengguna terbaru
- Proposal030 komponen/modal/draft/Reset disetujui; lanjut perapihan diizinkan.
- Bulanan satu batang per hari; gradasi primaryTint ke primary.
- Merge ke backend-newdesign hanya melalui persetujuan eksplisit pengguna.
- Jangan uninstall atau menghapus DB/outbox perangkat.

## Belum di-commit
Agen: calendar/controller, tes lint/finder, dua tes baru,38golden dan spec18.
Lokal pengguna yang tetap dipertahankan/dikecualikan dari commit agen:
- lib/features/reports/widgets/report_header_section.dart: label Excel.
- lib/shared/widgets/atoms/app_badge.dart: parameter warna opsional.
- lib/shared/widgets/organisms/report_summary.dart: Masuk/Keluar dan warna badge.
android/build/ artefak tak terlacak, tidak masuk Git.

## Langkah berikutnya
1. Tunggu jawaban dua pertanyaan async: izin tes bulanan beku dan lanjut setelah UI-36.
2. Setelah izin: ganti expect month.daily=null dengan31hari/total864000/future null;
   ubah finder ui_final_flow_test agar nominal tetap tepat untuk label Pendapatan/Masuk.
3. Uji dua tes itu terarah; check_all ulang setelah temuan diketahui sudah diperbaiki.
4. Lengkapi paritas/spec/peta frame/STATE, commit final setelah hijau.
5. Tinjauan HP; tidak push/merge tanpa izin.

## Blocker
UI-6/UI-18: report_view_test non-widget beku; izin penyesuaian assertion diminta.
UI-36: finder ui_final_flow_test gagal kedua kali di batch golden yang keliru.
Sudah meminta izin lanjut; jangan mencoba tes ketiga sebelum jawaban pengguna.

## Bukti terakhir
- targeted40tes lulus; kalender/dismiss/visual8tes lulus.
- check_all kedua: analyze2tahap bersih, check_arch OK,1253lulus/36gagal/2skip.
- flutter test kasus gagal --update-goldens:34lulus/1gagal (finder label, bukan golden).
- 38golden:laporan,AI/WA,antrean,auth/sync,Beranda,pelanggan,nota/detail,printer,
  usulan,COD,transaksi dan galeri; artefak kegagalan sesi dibersihkan.
- Verifikasi memakai workspace termasuk3perubahan lokal pengguna yang tidak di-stage.

