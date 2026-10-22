# Katalog komponen Laurum

Kelompok pertama Fase 1: enam atom di registry. Semua stateless, tanpa provider,
model bisnis, navigasi, atau dependensi baru. Formatter Dart: `dart format`.
Parameter warna/ukuran pada pemakaian harus berasal dari `core/theme`.

## AppText

- Berkas: `lib/shared/widgets/atoms/app_text.dart`.
- Parameter: `data` wajib; `variant = body`, `color = AppColors.ink`,
  `textAlign`, `maxLines`, `overflow`, `semanticsLabel`, `key`.
- Varian `AppTextVariant`: titleRoot, titleSub, section, figure, body,
  bodyStrong, input, label, caption, cta, monoLabel, monoReceipt.
- Semua varian memakai AppTextStyles; Plus Jakarta Sans untuk UI, IBM Plex Mono
  hanya nomor nota, jam, label grafik, dan struk. Skala teks sistem tetap dihormati.
- Contoh: `AppText(title, variant: AppTextVariant.titleRoot)`.
- Widgetbook: AppText / Semua varian; tes memeriksa semua gaya dan opsi teks.
- Acuan desain: judul/body Antrean - Beranda, Transaksi - Detail Order,
  struk pada Lainnya - Printer dan Struk. Judul VHueK (24/32 w700, ls -0.6), body D6n7xs (14/20), dan section XjlWD
  (16/22 w600) sesuai token. Selisih: nomor nota NAfLI di .pen berbobot 600,
  sedangkan monoLabel mengikuti token proyek yang sudah ada (400).

## AppIcon

- Berkas: `lib/shared/widgets/atoms/app_icon.dart`.
- Parameter: `icon: AppIcons` wajib; `size = AppDimensions.icon`,
  `color = AppColors.ink2`, `semanticLabel`, `key`.
- Varian glyph mengikuti seluruh AppIcons, termasuk pasangan outline/aktif:
  receipt, customers, reports, menu, queue. Ukuran token: 16, 20, dan 24; masing-masing terverifikasi pada D4sARD, sW6dC, qN76G.
- Contoh: `AppIcon(AppIcons.receiptActive, color: AppColors.primary)`.
- Ikon dekoratif tanpa semanticLabel; isi label untuk ikon yang membawa makna.
  Atom ini tidak interaktif; ukuran glyph bukan ukuran area sentuh.
- Widgetbook: semua enum, masing-masing ukuran 24, 20, dan 16; tes memeriksa mapping.
- Selisih disengaja terhadap .pen: Lucide/Material menjadi Ionicons sesuai PRD.
  `Icon()` hanya berada di implementasi atom ini, sesuai pengecualian check_arch.

## AppGap

- Berkas: `lib/shared/widgets/atoms/app_gap.dart`.
- Parameter: `size = AppSpacing.cardGap`, `axis = Axis.vertical`, `key`.
- Varian: vertikal dan horizontal; ukuran tidak negatif, sumbu lain berukuran nol.
- Contoh: `AppGap(axis: Axis.horizontal, size: AppSpacing.screenPadding)`.
- Widgetbook: kedua arah dan contoh jarak 12/16; tes memeriksa ukuran layout.
- Acuan: gap antarkartu dan padding layar pada tokens.md. Tidak memiliki warna
  atau bentuk visual sendiri. Gap 12 cocok dengan gxvLY/gKNjY pada Antrean - Beranda.

## AppDivider

- Berkas: `lib/shared/widgets/atoms/app_divider.dart`.
- Parameter: `axis = Axis.horizontal`, `key`.
- Varian horizontal dan vertikal, tebal AppDimensions.line (1), warna AppColors.border.
  Tidak menambahkan margin; gunakan AppGap di pemanggil.
- Contoh: `AppDivider()`; untuk vertikal, berikan tinggi terikat dari parent.
- Memerlukan lebar terikat untuk horizontal / tinggi terikat untuk vertikal.
- Widgetbook: kedua arah; tes memeriksa ukuran dan warna.
- Acuan: pemisah rincian transaksi. Ketebalan 1 merupakan token dasar tambahan
  yang diizinkan dan cocok dengan strokeWidth plTzD. Selisih: plTzD memakai chipIdle,
  sedangkan divider generik mengikuti border sesuai tokens.md. Divider vertikal adalah
  orientasi API tambahan; tidak diklaim identik dengan separator horizontal tersebut.

## AppCard

- Berkas: `lib/shared/widgets/atoms/app_card.dart`.
- Parameter: `child` wajib; `rail = AppCardRail.none`,
  `padding = EdgeInsets.all(AppSpacing.cardPadding)`, `key`.
- Varian: none, warning (amber), error (merah).
- Warna surface, border AppColors.border selebar AppDimensions.line,
  radius AppRadius.card (16), padding 16, rail kiri 4, tanpa bayangan.
  Isi dan rail dipotong mengikuti radius kartu; rail berada di kiri fisik.
- Contoh: `AppCard(rail: AppCardRail.warning, child: content)`.
- Widgetbook: semua rail; tes memeriksa padding, border, radius, warna, lebar rail.
- Acuan: kartu Antrean - Beranda dan usulan AI. Galeri Flutter dibandingkan dengan i1jkP (amber), Xa0qs (merah), dan JrA3v
  (normal): warna, radius/padding 16, border 1, rail 4, tanpa bayangan cocok.
  Tinggi kartu mengikuti child, bukan tinggi tetap frame order; konten bisnis milik organism.

## AppSvg

- Berkas: `lib/shared/widgets/atoms/app_svg.dart`;
  konstanta aset: `lib/core/icons/app_svgs.dart`.
- Parameter: `assetName` wajib; `size = AppDimensions.icon`,
  `color = AppColors.ink2`, `semanticLabel`, `key`.
- Memuat SVG lokal lewat SvgPicture.asset, currentColor melalui SvgTheme.
  Tanpa label berarti dekoratif. Aset harus memakai currentColor, bukan warna tetap.
- Pola contoh setelah aset pertama tersedia:
  `AppSvg(AppSvgs.<namaAset>, semanticLabel: label)`.
- AppSvgs.paths masih kosong; tidak ada aset SVG produksi baru.
  Saat aset pertama hadir, tambahkan konstanta bernama, daftarkan aset di pubspec,
  lalu tambahkan use-case. **Use-case dan perbandingan visual SVG ditunda.**
- Tes memuat `test/fixtures/test_icon.svg` lewat bundle khusus tes,
  memeriksa currentColor dan label. Fixture ini bukan ikon produksi.

## Verifikasi visual kelompok ini

Galeri 390×900 dengan font lokal sudah dirender dan diperiksa di
`test/goldens/app_{text,icon,gap,divider,card}.png`. Tidak ditemukan overflow.
Golden dibuat pada Windows; rasterisasi lintas OS belum diverifikasi.

Referensi .pen dibaca lewat MCP Pencil VS Code tanpa mengubah desain. Screenshot
kartu dibandingkan secara visual dengan galeri Flutter; ukuran/style diperiksa
melalui properti node. Cakupan perbandingan adalah atom, bukan seluruh layar bisnis.
Cuplikan desain tersimpan di `docs/progress/fase-1-visuals/`.

| Area | Referensi | Hasil / selisih |
| --- | --- | --- |
| Teks | VHueK, D6n7xs, XjlWD | judul/body/section cocok dengan token |
| Mono | NAfLI | .pen w600; token monoLabel proyek w400, tidak diubah |
| Ikon | D4sARD, sW6dC, qN76G | ukuran 16/20/24 cocok; bentuk Ionicons berbeda sesuai PRD |
| Gap | gxvLY, gKNjY | jarak kartu 12 cocok |
| Divider | plTzD | tebal 1 cocok; warna border menggantikan chipIdle berdasarkan tokens.md |
| Kartu | i1jkP, Xa0qs, JrA3v | radius/padding 16, border 1, rail 4 cocok; tinggi mengikuti konten |
| SVG | belum ada aset produksi | use-case dan perbandingan ditunda sesuai instruksi |
