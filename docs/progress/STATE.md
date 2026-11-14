# STATE Laurum
Diperbarui: 2026-11-14 | Cabang ui/pelanggan

## Sesi aktif
Persiapan modal Pilih tanggal030, dasar533d772 (redesign Laporan029 WIP).
Frame pilihan aktif4294968452 dibaca sekali; popup tengah342×470, bukan halaman.
Dokumen docs/design/new-design-laurum.figcraft; snapshot/paritas030 di spec18.

## Status irisan
- Proposal030 disiapkan untuk kalender rentang dan template modal yang belum di registry.
- Rencana: AppCalendarDay, AppRangeCalendar, ModalScaffold, ReportRangeSheet dan UI draft.
- Dari/Ke, panah bulan, Sen–Min, Reset/Terapkan; konten scroll saat font besar/layar sempit.
- Belum mengubah kode/registry/state/tes untuk modal; menunggu izin komponen baru.
- Alur lama masih showDateRangePicker halaman penuh; batas/range/Terapkan akan tetap.
- Pekerjaan029 sudah di533d772; verifikasi akhir masih tertunda, sumber tes API sudah diperbaiki.

## Keputusan pengguna terbaru
- Pilih tanggal diubah menjadi modal mengikuti frame FigCraft yang dipilih.
- Frame menunjukkan popup tengah dengan latar redup; Reset adalah aksi baru yang
  diusulkan hanya mengosongkan draft, tidak menghapus filter laporan aktif.
- Font HP berbeda tetap diuji; tidak memaksa dimensi470px atau font kecil Figma.
- Merge ke backend-newdesign HARUS melalui persetujuan eksplisit pengguna.
- Pertahankan data HP; jangan uninstall/hapus DB/outbox; Contacts Data safety wajib.

## Belum di-commit
Perubahan lokal yang sudah ada saat tugas mulai (agen tidak membuat/mengembalikan):
- lib/features/reports/widgets/report_header_section.dart: Ekspor Excel menjadi Excel.
- lib/shared/widgets/atoms/app_badge.dart: parameter warna opsional.
- lib/shared/widgets/organisms/report_summary.dart: Masuk/Keluar dan warna badge.
android/build/ tetap artefak tak terlacak; tidak dimasukkan Git.
Dokumen persiapan030 dicakup commit wip sesi ini, kode lokal di atas dikecualikan.

## Langkah berikutnya
1. Persetujuan030 untuk komponen/registry/template baru, draft dan Reset UI.
2. Setelah izin: atom→organism→template→Sheet/flow; provider aktual diubah hanya Terapkan.
3. Migrasikan finder tes Material ke modal baru, pertahankan assertion batas/locale/
   satu hari/range/batal/rute/ekspor; tambah reset/lintas bulan/font/scroll/golden modal.
4. Selesaikan verifikasi029 (getBoxesForSelection sudah sesuai SDK), lalu check_all akhir.
5. Tinjauan HP dan commit irisan; merge hanya dengan izin pengguna.

## Blocker
Aturan2/UI-13: kalender rentang dan template modal baru memerlukan persetujuan030.
Verifikasi029 belum tuntas setelah dua proses tes tambahan gagal API; sumber sudah diperbaiki.

## Bukti terakhir
- Branch ui/pelanggan; FigCraft aktif4294968452; coverage5berkas sumber lama bersih.
- Belum menjalankan tes modal karena sesi ini baru persiapan dokumen.
- Bukti029:45tes UI/alur sempat hijau; tambahan tes API sudah diperbaiki belum tes ulang.
- Fullcheck1244lulus/2skip adalah bukti detail pelanggan, bukan modal/laporan029.
- Visual belum diverifikasi manual pada HP; iOS belum diuji.
