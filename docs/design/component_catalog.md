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

## AppButton
- Berkas: lib/shared/widgets/atoms/app_button.dart (54 baris).
- Parameter: label wajib; variant = cta; icon opsional (AppIcons); onPressed opsional; key.
- Varian: cta, secondary, action, actionOutline, destructiveOutline, destructiveFilled.
- onPressed null menonaktifkan aksi. Label dapat membungkus; tinggi minimum 56 untuk CTA,
  48 untuk lainnya. Lebar mengikuti konten; parent boleh memberi lebar penuh.
- Contoh: AppButton(label, variant: AppButtonVariant.action, icon: AppIcons.check, onPressed: onTap).
- Widgetbook: semua enam varian dengan ikon + CTA disabled; tes render, tinggi dan callback.
- Referensi: B4bt3y, Ax5fO, h8n1Hk, azFlV, xpKx9, e32I1Q.
- Selisih: CTA/secondary memakai token cta 16/22 w700; desain w600. Aksi memakai bodyStrong 14/20 w600.

## AppIconButton
- Berkas: lib/shared/widgets/atoms/app_icon_button.dart (40 baris).
- Parameter: icon dan label wajib; onPressed opsional; color = primary; key.
- label menjadi tooltip/nama aksesibel. Ukuran sentuh 48, ikon 20, radius action 8.
- Contoh: AppIconButton(AppIcons.person, label: label, onPressed: onTap).
- Widgetbook: enabled/disabled. Tes tooltip, AppIcon, ukuran, callback dan disabled.
- Referensi jo0oP; glyph Ionicons menggantikan Lucide sesuai PRD.

## AppChip
- Berkas: lib/shared/widgets/atoms/app_chip.dart (40 baris).
- Parameter: label wajib; selected = false; onPressed opsional; key.
- Varian: selected/idle, masing-masing enabled/disabled. Tinggi minimum 48, radius pil.
- Contoh: AppChip(label, selected: selected, onPressed: onSelect).
- Pilihan dan aksi digabung dalam satu node semantik; state tetap milik pemanggil.
- Widgetbook: empat kombinasi. Tes status semantik, callback, tinggi dan disabled.
- Referensi VFXLp/EciH5; primary/onPrimary saat selected, chipIdle/ink2 saat idle.

## AppBadge
- Berkas: lib/shared/widgets/atoms/app_badge.dart (31 baris).
- Parameter: label dan variant wajib; key. Tidak memiliki aksi.
- Varian: diproses, siap, menungguJemput, selesai, dibatalkan.
- Contoh: AppBadge(label, variant: AppBadgeVariant.diproses).
- Widgetbook: lima varian. Tes teks, warna, tipografi label dan tinggi 20 pada skala normal.
- Referensi s9ip1/p4CSbM/C68jco/enHH5; padding vertikal 2, horizontal 10, radius pil.
- Teks bisnis diberikan pemanggil, tidak dipetakan otomatis dari enum di atom.

## AppStatusText
- Berkas: lib/shared/widgets/atoms/app_status_text.dart (22 baris).
- Parameter: label dan variant wajib; key. Varian: lunas, belumBayar, dp.
- Contoh: AppStatusText(label, variant: AppStatusTextVariant.belumBayar).
- Widgetbook: tiga varian. Tes warna dan render tanpa dekorasi pil.
- Referensi G8xEZi: teks 12/16 w600. Titik dekoratif di frame tidak disertakan;
  mengikuti PRD/token yang menetapkan status bayar berupa teks.

## AppAvatar
- Berkas: lib/shared/widgets/atoms/app_avatar.dart (36 baris).
- Parameter: initials opsional; semanticLabel opsional; key. Isi inisial disiapkan pemanggil.
- Varian: inisial, fallback AppIcons.avatar jika initials null/kosong.
- Contoh: AppAvatar(initials: initials, semanticLabel: name).
- Ukuran 40, primaryTint, inisial primary menggunakan section 16/22 w600.
- Widgetbook: dua varian. Tes inisial, ukuran, dan fallback AppIcon.
- Referensi SlEQS; fallback Ionicons mengikuti Kit Agen. Tidak memuat foto/network.

## AppSwitch
- Berkas: lib/shared/widgets/atoms/app_switch.dart (50 baris).
- Parameter: value dan label wajib; onChanged opsional; key.
- Contoh: AppSwitch(value: enabled, label: label, onChanged: onChange).
- Varian: on/off dan disabled on/off. Tanpa state internal; callback memberikan !value.
- Semantik toggled/enabled dan label; TextButton menangani fokus/aktivasi keyboard.
- Widgetbook: empat kombinasi. Tes state semantik, callback, kontrol eksternal, ukuran dan disabled.
- Referensi ZOUFH (on) dan qcTo3 (off): area 48, track 48x28, thumb 24, inset 2.
- Track primary/on, borderStrong/off; thumb putih. Tidak memakai ukuran Switch Material bawaan.

## Verifikasi visual kelompok kontrol
- Screenshot MCP Pencil dan golden Flutter dibandingkan; referensi PNG tersimpan di
  docs/progress/fase-1-controls-visuals/, galeri pada test/goldens/app_*.png.
- Galeri memakai label varian teknis untuk isolasi komponen, bukan fixture pelanggan/transaksi.
- Semua tujuh galeri diperiksa: tidak ada overflow; seluruh varian terlihat.
- Selisih: glyph Ionicons, CTA/secondary w700 vs w600, status bayar tanpa titik dekoratif.
- State disabled belum memiliki referensi khusus yang terverifikasi; menggunakan token ink3,
  chipIdle/border serta opacity 0.5 untuk switch. Perlu tinjauan visual pengguna.
- Contoh Widgetbook bersifat galeri statis; callback contoh tidak menyimpan state.
  Tes memeriksa callback, sedangkan state layar nanti ditangani Riverpod pada Pages.
