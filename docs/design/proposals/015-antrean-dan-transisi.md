# 015 — Antrean frame 408 dan transisi tab

Diminta pengguna 10 Nov 2026: lanjutkan Antrean, AppBar LAURUM/Antrean/cari,
transisi nav halus. Pengguna menegaskan kemiripan FigCraft dan meminta akurasi
contoh terlebih dahulu, sambil mempertahankan data/aksi. Frame 408 dibaca via MCP.
Tidak membuat widget bersama baru; komponen registry + Section/Sheet fitur.

## Urutan lapisan dan API
1. Token global AppMotion: 220 ms easeOutCubic, disableAnimations = langsung.
2. Atom: AppSearchField.autofocus default false; AppCard rail info/success dan
   style muted. AppButton.small tetap visual 40, hit target 48 agar aksesibel.
   Ikon optionsOutline/sparklesOutline dari Ionicons menjadi AppIcons.filter/sparkles.
3. Molekul: SectionHeader.icon opsional null; AppBarRoot tidak diubah.
4. Organisme: OrderCard mengikuti susunan frame untuk Antrean dan Laporan:
   pelanggan+badge, ringkasan, metadata+nominal, baris tambahan CTA status/detail.
   API lama dipertahankan, compact/showAction tetap mengendalikan CTA. ProposalCard
   mendapat compact=false/accuracyLabel=null; pesan dalam muted card, dua baris
   preview, teks lengkap melalui Periksa. Semua callback dan data tetap.
5. Template: RootScaffold.headerHeight default 64 (Antrean 72, mengikuti skala teks).
   Judul Antrean 24 mengikuti hierarki frame. Fade overlay
   IgnorePointer tanpa melepas navigator; state/filter/scroll dan hit target tetap.
6. Page/Section: AppBar tetap LAURUM/Antrean/cari; cari fokus otomatis. Dua tab
   Semua/Perlu dicek + ikon filter seperti frame. Status lama 0..4 ada di
   AntreanFilterSheet lewat AppBottomSheet; pilihan memanggil notifier lama.
   Label tab utama mengikuti status yang aktif. Mode sederhana tetap hanya 0/4.

## Data, aksi, dan penyesuaian kebutuhan aplikasi
- Pencarian lokal nama/nota/layanan dan teks usulan; state query tidak disimpan.
- Daftar utama menampilkan dua rekomendasi seperti frame. Lihat semua memakai
  select(4) yang lama dan menampilkan seluruh usulan; pencarian tidak dibatasi dua.
- Pesan AI preview dua baris; teks utuh dan semua aksi tetap tersedia lewat Periksa.
- Koreksi terakhir pengguna: nama usaha dan ikon akun di Antrean dihapus.
  Jumlah order aktif/perlu dicek sejajar dengan sync di body; pada teks besar
  baris disusun vertikal. Akun tetap dapat dibuka lewat tab Lainnya.
  Posisi vertikal LAURUM sama dengan Beranda, diuji pada teks 1x dan 2x.
- Aksi status/pelunasan tetap biru, pending menonaktifkan aksi, COD bersisa tertahan.
  Tambahan CTA dan font global membuat kartu lebih tinggi dari 74 dp di Figma.
- Contoh akurasi diberi label `AI 92% · contoh`, hanya melalui fixture tambahan
  override main_dummy. Scope data nyata tidak memasok skor palsu. Ini pengecualian
  DATA MASTER yang diminta pengguna; fixture lama/domain/repository tidak diubah.
- Rute, transaksi, serta semua provider/notifier bisnis lama tidak diubah.

## Dampak dan pemeriksaan
- Perubahan OrderCard juga menggeser galeri/Laporan; listed di 015-golden-impact.md.
- Target sentuh small 48 dp sedikit menggeser tombol banner Beranda; visual tetap 40.
- Tes perilaku lama tetap utuh; finder filter dipindahkan ke sheet dan indeks chip
  disesuaikan ke dua tab. Tes status/COD/mode sederhana tetap menguji nilai yang sama.
- Finder yang berubah: antrean_page_test (header/filter), antrean_states_test
  (pilihan Semua di sheet), r4_antrean_page_test (indeks tab), drift_app_test
  (tipe header). app_card_test menambah varian; app_button_test memeriksa target
  48 dp sekaligus visual 40 dp. Tidak ada assertion perilaku yang dihapus.
- r2_navigation_test membuka akun dari Pelanggan setelah ikon Antrean dihapus
  atas permintaan pengguna; tujuan Lainnya tetap diuji. r4_settings_page_test
  memeriksa lima pilihan status di sheet sesudah mode status diaktifkan lagi.
- Baru: pencarian, keyboard 300 dp (320/1x/2x), Section header/toolbar/usulan,
  preview dua/lihat semua, reduced motion, ketukan saat fade dan scroll/filter bertahan.
- Gerbang akhir: check_all, diff zona beku, golden + visual Android, commit.
- Android SM-N975F: header/ringkasan body, kartu, pencarian dengan keyboard
  terbuka dan sheet filter diperiksa pada build dummy terbaru. iOS belum diuji.
- Bukti akhir 10 Nov 2026: check_all exit 0, 974 berkas format (0 berubah),
  analyzer/Riverpod bersih, check_arch OK, 1036 tes lulus dan 1 skip,
  REPO_MAP 1052 berkas. Log lokal: TEMP/laurum-antrean-check-all-green.log.
- Diff terhadap e34fc26: domain/repository, persistensi/sync, supabase, tool,
  rute, dependensi dan PRD tidak berubah. Berkas state/data baru terbatas pada
  query layar dan akurasi contoh yang diminta pengguna; main_dummy memasok fixture.
