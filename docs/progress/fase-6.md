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
