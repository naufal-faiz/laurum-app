# STATE Laurum
Diperbarui: 2026-10-24 | Cabang dev1

## Posisi
FASE 1 SELESAI: registry 60/60 (17 atoms, 21 molecules, 17 organisms, 5 templates).
Prompt 14 selesai; check_all SEMUA HIJAU, 215 tes, REPO_MAP 327 berkas.
Berhenti untuk tinjauan seluruh Widgetbook sebelum prompt 20-antrean.md.

## Selesai
- Fondasi, domain prompt 10 (80ed571), audit data dummy prompt 11 (c17cd40).
- Prompt 12 organisms 1 (9 widget) dan prompt 13 organisms 2 + ReceiptFormatter.
- Perbaikan tinjauan prompt 13: nominal ExpenseRow rata kanan; status LockedRow
  sejajar switch (commit 1389203).
- Prompt 14: RootScaffold, SubScaffold, FormScaffold, SheetScaffold, AuthScaffold.
  Root memakai AppBarRoot + SyncIndicator + BottomNavBar + FAB pil; Sub/Form memakai
  AppBarSub; Form memakai FooterBar sticky; SheetScaffold adalah isi AppBottomSheet;
  Auth tanpa app bar.
- Setiap template punya use-case semua varian, tes kontrak, golden, dan uji 320 px +
  skala teks 2x. Penutup Fase 1 (ringkasan, selisih, temuan, proposal, cara Widgetbook)
  ada di docs/progress/fase-1.md.

## Sedang dikerjakan
- Tidak ada. Fase 1 ditutup setelah check_all hijau.

## Antrean
1. Tinjau seluruh Widgetbook (60 widget) dan daftar selisih kumulatif di fase-1.md.
2. Jika disetujui: docs/prompts/20-antrean.md (kerangka navigasi + Antrean - Beranda),
   lalu coba di HP/emulator Android.
3. APK, NDK 28.2.13676358, iOS, TalkBack/VoiceOver, dan SafeArea perangkat masih ditunda.

## Keputusan dan batas
- Templates hanya slot/komposisi; tanpa provider/navigasi. BottomNav hanya di RootScaffold;
  tidak di Sub/Form/Sheet/Auth sesuai PRD A bagian 5.
- RootScaffold memakai FAB pil `FloatingActionButton.extended` elevasi 0 (label + callback);
  AppBarRoot/AppBarSub dibungkus PreferredSize 64.
- FormScaffold: body dapat digulir (padding 16) + FooterBar sticky. SheetScaffold: body
  gulir + footer, dipakai sebagai child AppBottomSheet, bukan surface sendiri.
- AuthScaffold mulai 96 px dari atas layar, SafeArea bawah aktif, dapat digulir.
- Struk 32 kolom; status LUNAS/LUNAS (TABUNGAN)/DP/BELUM BAYAR; alamat DATA MASTER
  membungkus dua baris; tepi clipper 8 px.
- ReportSummary dipadatkan karena batas 110 baris; ConfirmModal varian biasa memakai
  tombol action; grafik mingguan tanpa paket chart.
- Organisms/templates hanya primitif/enum/domain model dan callback; tanpa provider.
- Formatters.nomorNota masih kunci A; transaksi Order/Savings atomik ditunda ke alur kasir.
- Selisih visual lama dipertahankan: Ionicons, mono w400, nav 61 px, DP amber, field 48.
- Atom/token/registry/lint/PRD tidak diubah. Tanpa dependensi baru.

## Pemeriksaan dan batas
- Android/iOS perangkat, TalkBack/VoiceOver, SafeArea nyata belum diuji; APK ditunda.
- Screenshot Pencil baru tidak dibuat; transport VS Code tidak tersedia. Perbandingan
  memakai referensi yang sudah dibaca dan 59 golden Flutter.
- android/gradle.properties berisi perubahan lama pengguna (kotlin.incremental,
  compiler.execution.strategy); tidak diubah atau di-commit.
- Tidak push/merge. Prompt berikutnya dijalankan hanya setelah pengguna meminta.
