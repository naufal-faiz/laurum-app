# Prompt 14 — templates dan penutup Fase 1

- Lingkup: RootScaffold, SubScaffold, FormScaffold, SheetScaffold, AuthScaffold.
- RootScaffold: AppBarRoot (title/akun/SyncIndicator), body, BottomNavBar, FAB pil opsional
  (label + callback, hanya tampil bila keduanya diberikan). Tanpa navigasi/provider.
- SubScaffold: AppBarSub (title/back/trailing), body; tanpa nav bawah.
- FormScaffold: AppBarSub + body dapat digulir + FooterBar sticky (summary + aksi).
- SheetScaffold: layout isi sheet (body dapat digulir + footer opsional) untuk dipakai
  sebagai child AppBottomSheet; tanpa surface/header sendiri.
- AuthScaffold: latar bg, SafeArea, konten dapat digulir dengan padding atas sesuai frame
  Auth - Masuk; tanpa app bar.
- Semua template hanya slot/komposisi atom-molekul-organism; tanpa provider/navigasi.
- Setiap template: satu use-case semua varian, tes kontrak, golden; katalog dan progress.
- Penutup: verifikasi 60/60 registry, ringkasan Fase 1 + selisih .pen + temuan + proposal,
  cara membuka Widgetbook, check_all hijau, STATE/INDEX, commit.
