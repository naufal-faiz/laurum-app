# Fase 6 - Pelanggan (24 Oktober 2026)

## Prompt 50: Daftar Pelanggan
- Sesi dibatasi satu layar sesuai AGENTS.md; Detail/Edit belum dikerjakan.
- Tab /pelanggan memakai CustomerRow, AppSearchField, ChipBar, SectionHeader,
  FooterBar, EmptyState, dan AppSkeleton dari registry.
- Jumlah chip dan saldo/piutang reaktif terhadap repository; riwayat dummy memakai
  baseline + selisih snapshot order agar nota fixture tidak dihitung dua kali.
- Tambah cepat memakai sheet yang sama, banner konteks daftar, dan navigator utama.
  Temuan: membuka sheet dari navigator tab memotong tinggi 500 px (overflow 97 px
  pada viewport tes); memilih navigator utama di page menyelesaikannya tanpa mengubah
  AppBottomSheet. Integrasi keyboard/perangkat nyata masih perlu ditinjau.
- Selisih desain: urutan repository; chip Semua/Punya tabungan diberi jumlah sesuai
  prompt; DP memakai teks CustomerRow tanpa nomor nota; CTA tambah tetap di footer.
- Tes: angka DATA MASTER dan normalisasi/filter, pembatalan reaktif, pencarian/rute,
  tambah pelanggan, loading/kosong, error/retry, lebar 320 px dengan teks 2x.
- Atom/registry/token/lint/PRD tidak berubah; tidak ada dependensi baru.
- Detail pelanggan dan Impor kontak masih placeholder; telepon memakai launcher palsu.
- Hasil check_all akhir dicatat di STATE.md; tinjau Daftar sebelum melanjutkan prompt 50.

## Prompt 50: Detail Pelanggan dan sheet Edit profil
- /pelanggan/:id mengganti placeholder; statistik, tiga mutasi, tiga nota terbaru.
- customerSummariesProvider memuat aktif/nonaktif; daftar memfilter aktif sehingga
  detail/histori tetap tersedia setelah nonaktif. Saldo dihitung sebelum membatasi mutasi.
- Edit memakai Notifier dan konfirmasi nonaktif, mempertahankan identitas/metadata awal,
  menolak nomor duplikat aktif, serta tidak menghapus nota/piutang/tabungan.
- Rute statis impor didahulukan dari parameter id. Setor/riwayat mutasi masih placeholder.
- Selisih: statistik vertikal, tanpa rata-rata bulanan yang tidak tersedia di data master,
  tanpa klaim tabungan otomatis, NotaCard tanpa CTA Struk/Lihat semua; inisial helper.
- Spec 13/14 mencatat detail dan teks baru ConfirmModal. Tidak ada widget bersama baru.
- Sembilan tes baru: tiga data/edit/nonaktif, tiga alur UI, tiga state/layar sempit.
- Penutup: directive import dirapikan (dart fix directives_ordering) pada
  customer_detail_page.dart dan customer_detail_page_test.dart; check_all SEMUA HIJAU,
  285 tes, REPO_MAP 441 berkas. Berikutnya prompt 51 setelah tinjauan.
