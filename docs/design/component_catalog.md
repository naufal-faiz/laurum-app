# Katalog komponen Laurum


## ChipBar
- Berkas: lib/shared/widgets/molecules/chip_bar.dart.
- API dan contoh: labels wajib; selectedIndex opsional; onSelected(int) opsional. ChipBar(labels: labels, selectedIndex: index, onSelected: select). Scroll horizontal; tanpa state internal.
- Varian: selected/unselected/disabled/scroll.
- Galeri: widgetbook/molecules/chip_bar_use_case.dart; tes: test/chip_bar_test.dart.
- Acuan Pencil: XNjrV; selisih visual di docs/progress/fase-1.md.

## PeriodTabs
- Berkas: lib/shared/widgets/molecules/period_tabs.dart.
- API dan contoh: labels dan selectedIndex wajib; onSelected(int) opsional. PeriodTabs(labels: labels, selectedIndex: index, onSelected: select). Pilihan periode ditentukan pemanggil.
- Varian: setiap pilihan aktif dan disabled; tanpa ikon sesuai keputusan pengguna.
- Galeri: widgetbook/molecules/period_tabs_use_case.dart; tes: test/period_tabs_test.dart.
- Acuan Pencil: XNjrV; selisih visual di docs/progress/fase-1.md.

## NominalChips
- Berkas: lib/shared/widgets/molecules/nominal_chips.dart.
- API dan contoh: amounts List<int> rupiah wajib; onSelected(int rupiah), selectedAmount opsional; increment default true. NominalChips(amounts: amounts, onSelected: addAmount). Tidak menghitung saldo.
- Varian: increment/nominal, selected/disabled.
- Galeri: widgetbook/molecules/nominal_chips_use_case.dart; tes: test/nominal_chips_test.dart.
- Acuan Pencil: rtceE; selisih visual di docs/progress/fase-1.md.

## StepperField
- Berkas: lib/shared/widgets/molecules/stepper_field.dart.
- API dan contoh: value (sudah diformat), decreaseLabel, increaseLabel, editLabel wajib; onDecrease/onIncrease/onEdit opsional. StepperField(value: Formatters.berat(grams), decreaseLabel: minus, increaseLabel: plus, editLabel: edit, onIncrease: increment).
- Varian: aktif, disabled, hanya tambah.
- Galeri: widgetbook/molecules/stepper_field_use_case.dart; tes: test/stepper_field_test.dart.
- Acuan Pencil: K8zXI; selisih visual di docs/progress/fase-1.md.

## AppBarSub
- Berkas: lib/shared/widgets/molecules/app_bar_sub.dart.
- API dan contoh: title/backLabel wajib; onBack dan trailing slot opsional. AppBarSub(title: title, backLabel: backLabel, onBack: callback). Tanpa navigasi.
- Varian: utama/dengan trailing.
- Galeri: widgetbook/molecules/app_bar_sub_use_case.dart; tes: test/app_bar_sub_test.dart.
- Acuan Pencil: WiQtw; selisih visual di docs/progress/fase-1.md.

## AppBarRoot
- Berkas: lib/shared/widgets/molecules/app_bar_root.dart.
- API dan contoh: title, accountLabel, syncIndicator Widget wajib; onAccount opsional. AppBarRoot(title: title, accountLabel: account, syncIndicator: SyncIndicator(state: state), onAccount: openAccount). Slot menjaga larangan impor antarmolecules.
- Varian: empat status SyncIndicator.
- Galeri: widgetbook/molecules/app_bar_root_use_case.dart; tes: test/app_bar_root_test.dart.
- Acuan Pencil: C1rcX; selisih visual di docs/progress/fase-1.md.

## FooterBar
- Berkas: lib/shared/widgets/molecules/footer_bar.dart.
- API dan contoh: child wajib; summary Widget opsional. FooterBar(summary: AppText(total), child: AppButton(label, onPressed: submit)). Pemanggil menempatkan sticky; SafeArea bawah disediakan.
- Varian: aksi tunggal, summary, dua aksi.
- Galeri: widgetbook/molecules/footer_bar_use_case.dart; tes: test/footer_bar_test.dart.
- Acuan Pencil: uqTPF; selisih visual di docs/progress/fase-1.md.



## LabeledField
- Berkas: lib/shared/widgets/molecules/labeled_field.dart.
- API dan contoh: label dan child wajib; helperText/errorText opsional. LabeledField(label: label, child: AppTextField(label: label)). Error menggantikan helper.
- Varian: utama/helper/error/disabled child.
- Galeri: widgetbook/molecules/labeled_field_use_case.dart; tes: test/labeled_field_test.dart.
- Acuan Pencil: jbLdH. Lihat catatan visual di docs/progress/fase-1.md.

## BannerMessage
- Berkas: lib/shared/widgets/molecules/banner_message.dart.
- API dan contoh: message wajib; variant info (default), warning, error. BannerMessage(message: message, variant: BannerMessageVariant.warning).
- Varian: info/warning/error.
- Galeri: widgetbook/molecules/banner_message_use_case.dart; tes: test/banner_message_test.dart.
- Acuan Pencil: XFgML. Lihat catatan visual di docs/progress/fase-1.md.

## NoticeAi
- Berkas: lib/shared/widgets/molecules/notice_ai.dart.
- API dan contoh: Hanya key. NoticeAi() menampilkan kalimat tetap tanpa parameter pengganti.
- Varian: kalimat tetap.
- Galeri: widgetbook/molecules/notice_ai_use_case.dart; tes: test/notice_ai_test.dart.
- Acuan Pencil: K1Xa3y. Lihat catatan visual di docs/progress/fase-1.md.

## CalloutAi
- Berkas: lib/shared/widgets/molecules/callout_ai.dart.
- API dan contoh: message wajib; label default Periksa bagian ini; icon default location. CalloutAi(message: value). Hanya menampilkan, tidak mengubah data.
- Varian: label dan ikon default/kustom.
- Galeri: widgetbook/molecules/callout_ai_use_case.dart; tes: test/callout_ai_test.dart.
- Acuan Pencil: s45lh. Lihat catatan visual di docs/progress/fase-1.md.

## EmptyState
- Berkas: lib/shared/widgets/molecules/empty_state.dart.
- API dan contoh: title dan icon wajib; description/actionLabel/onAction opsional. EmptyState(title: title, icon: AppIcons.queue). Aksi membutuhkan actionLabel.
- Varian: utama/deskripsi/aksi.
- Galeri: widgetbook/molecules/empty_state_use_case.dart; tes: test/empty_state_test.dart.
- Acuan Pencil: nKUPl. Lihat catatan visual di docs/progress/fase-1.md.

## SyncIndicator
- Berkas: lib/shared/widgets/molecules/sync_indicator.dart.
- API dan contoh: state wajib: tersimpan, menyimpan, offline, gagal. SyncIndicator(state: SyncState.tersimpan). Status liveRegion, tanpa jaringan atau timer.
- Varian: tersimpan/menyimpan/offline/gagal.
- Galeri: widgetbook/molecules/sync_indicator_use_case.dart; tes: test/sync_indicator_test.dart.
- Acuan Pencil: I3YmrS/ARosk. Lihat catatan visual di docs/progress/fase-1.md.

LabeledField tidak mengubah dekorasi child: letakkan error pada wrapper ATAU AppTextField agar tidak ditampilkan dua kali. Label semantik child tetap diisi pemanggil.


## SectionHeader
- Berkas: lib/shared/widgets/molecules/section_header.dart.
- API dan contoh: title wajib; subtitle/actionLabel/onAction opsional. SectionHeader(title: title, actionLabel: label, onAction: onTap).
- Varian: utama dan opsi tambahan pada API.
- Galeri: widgetbook/molecules/section_header_use_case.dart; tes: test/section_header_test.dart.
- Acuan Pencil: ogqS8; selisih dicatat di docs/progress/fase-1.md.

## InfoRow
- Berkas: lib/shared/widgets/molecules/info_row.dart.
- API dan contoh: label/value wajib; icon opsional. InfoRow(label: label, value: formattedValue). Nilai sudah diformat oleh pemanggil.
- Varian: utama dan opsi tambahan pada API.
- Galeri: widgetbook/molecules/info_row_use_case.dart; tes: test/info_row_test.dart.
- Acuan Pencil: pA7A7; selisih dicatat di docs/progress/fase-1.md.

## StatTile
- Berkas: lib/shared/widgets/molecules/stat_tile.dart.
- API dan contoh: label/value wajib; description/icon opsional. StatTile(label: label, value: formattedValue).
- Varian: utama dan opsi tambahan pada API.
- Galeri: widgetbook/molecules/stat_tile_use_case.dart; tes: test/stat_tile_test.dart.
- Acuan Pencil: C2MvH3; selisih dicatat di docs/progress/fase-1.md.

## DateGroupHeader
- Berkas: lib/shared/widgets/molecules/date_group_header.dart.
- API dan contoh: label wajib; summary/summaryColor opsional. DateGroupHeader(label: Formatters.tanggal(date), summary: total).
- Varian: utama dan opsi tambahan pada API.
- Galeri: widgetbook/molecules/date_group_header_use_case.dart; tes: test/date_group_header_test.dart.
- Acuan Pencil: DaGCC; selisih dicatat di docs/progress/fase-1.md.

## ProgressRow
- Berkas: lib/shared/widgets/molecules/progress_row.dart.
- API dan contoh: label/progress (0..1) wajib; value opsional sudah diformat. ProgressRow(label: label, progress: fraction).
- Varian: kosong, sebagian, penuh.
- Galeri: widgetbook/molecules/progress_row_use_case.dart; tes: test/progress_row_test.dart.
- Acuan Pencil: ZFy5T; selisih dicatat di docs/progress/fase-1.md.

## MenuRow
- Berkas: lib/shared/widgets/molecules/menu_row.dart.
- API dan contoh: label/icon wajib; subtitle/onTap opsional. MenuRow(label: label, icon: AppIcons.service, onTap: action). Tidak menavigasi.
- Varian: label, subtitle, disabled.
- Galeri: widgetbook/molecules/menu_row_use_case.dart; tes: test/menu_row_test.dart.
- Acuan Pencil: MkVX5; selisih dicatat di docs/progress/fase-1.md.

## ToggleRow
- Berkas: lib/shared/widgets/molecules/toggle_row.dart.
- API dan contoh: label/value wajib; description/onChanged opsional. ToggleRow(label: label, value: enabled, onChanged: onToggle). icon opsional untuk ikon pendamping.
- Varian: on/off, enabled/disabled.
- Galeri: widgetbook/molecules/toggle_row_use_case.dart; tes: test/toggle_row_test.dart.
- Acuan Pencil: SW1pv; selisih dicatat di docs/progress/fase-1.md.

## LockedRow
- Berkas: lib/shared/widgets/molecules/locked_row.dart.
- API dan contoh: label/lockLabel wajib; description opsional. LockedRow(label: label, lockLabel: status). Tanpa callback/interaksi. icon opsional untuk ikon pendamping.
- Varian: utama dan opsi tambahan pada API.
- Galeri: widgetbook/molecules/locked_row_use_case.dart; tes: test/locked_row_test.dart.
- Acuan Pencil: aSIwH; selisih dicatat di docs/progress/fase-1.md.
- Status kunci menempel ke tepi kanan baris (tanpa flex), sehingga sejajar dengan tepi
  switch pada ToggleRow; label utama memakai sisa lebar.


Atom Fase 1 mengikuti registry; field stateful untuk lifecycle controller. Tanpa provider,
model bisnis, navigasi, atau dependensi baru. Formatter Dart: `dart format`.
Parameter warna/ukuran pada pemakaian harus berasal dari `core/theme`.

## AppText

- Berkas: `lib/shared/widgets/atoms/app_text.dart`.
- Parameter: `data` wajib; `variant = body`, `color = AppColors.ink`,
  `textAlign`, `maxLines`, `overflow`, `semanticsLabel`, `key`.
- Varian `AppTextVariant`: titleRoot, titleSub, section, figure, body,
  bodyStrong, input, label, caption, cta, numpad, monoLabel, monoReceipt.
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

## AppTextField
- Berkas: lib/shared/widgets/atoms/app_text_field.dart (99 baris).
- Parameter: label wajib (aksesibilitas, bukan label visual); value = ''; hint/errorText;
  onChanged/onSubmitted; keyboardType/textInputAction/inputFormatters; enabled = true;
  readOnly/obscureText/selectAllOnFocus = false; minLines/maxLines = 1; key.
- Contoh: AppTextField(label: label, value: value, errorText: error, onChanged: onChange).
- Varian galeri: kosong, terisi, error, disabled, readOnly, password, multiline.
- Controller dimiliki widget dan dibuang di dispose. Perubahan value eksternal mengganti teks
  dan memindah caret ke akhir; echo nilai yang sama tidak mengubah selection/composing.
- FocusNode dimiliki widget dan dibuang di dispose. selectAllOnFocus memilih seluruh teks
  saat mendapat fokus (termasuk fokus ulang), agar ketikan mengganti nilai awal.
- Validasi/format bisnis milik pemanggil. Label visual disusun LabeledField pada tahap molecules.
- obscureText dikontrol pemanggil; tombol toggle mata pada j6ZtZV belum disediakan.
- Tes: entry/filter, submit, value eksternal, error, disposal dan opsi varian.
- Acuan kmkgP/sfkVN/LRZzT: radius 8, borderStrong, input 16/24 w400.
- Selisih: tinggi baku 48 mengikuti token, beberapa frame 44. Multiline galeri 72 cocok LRZzT,
  tetapi isi rata atas dibanding contoh satu baris rata tengah di desain.

## AppSearchField
- Berkas: lib/shared/widgets/atoms/app_search_field.dart (88 baris).
- Parameter: label dan clearLabel wajib; value = ''; hint; onChanged/onSubmitted; enabled = true; key.
- Contoh: AppSearchField(label: label, clearLabel: clearLabel, value: query, onChanged: onQuery).
- Varian galeri: kosong, terisi dengan clear, disabled terisi. Tidak ada debounce internal.
- Controller internal, sinkronisasi value eksternal dan dispose seperti AppTextField.
- Ikon search/close lewat AppIcon. Clear muncul saat teks ada, mengosongkan controller dan
  memanggil onChanged('') sekali. Disabled mematikan ketikan dan clear.
- ValueListenableBuilder memperbarui clear tanpa setState; TextInputAction.search untuk submit.
- Suffix IconButton transparan + AppIcon menjaga border tetap terlihat.
- Tes: entry, clear, submit, callback, sinkronisasi, selection, disabled dan disposal.
- Acuan T24HQe: putih, radius 8, borderStrong, ikon 20, teks 16/24, tinggi 48.
- Selisih: placeholder satu baris dibanding contoh panjang yang membungkus di frame;
  clear tambahan saat terisi; glyph Ionicons sesuai Kit Agen.

## AppSkeleton
- Berkas: lib/shared/widgets/atoms/app_skeleton.dart (25 baris).
- Parameter: width = double.infinity, height = AppInputStyles.skeletonHeight (20), key.
- Contoh: AppSkeleton(width: AppInputStyles.skeletonShort).
- Persegi panjang statis tanpa shimmer; radius input 8, chipIdle. Ukuran positif;
  width default memerlukan parent berlebar terbatas. Dikecualikan dari semantik.
- Galeri: 96x16, 192x22, lebar penuh x20 dan x48.
- Tes: ukuran, warna, ExcludeSemantics dan tidak ada frame animasi terjadwal.
- Acuan Q1YznQ/e48H25/dStCL/E2wCq; cocok ukuran/bentuk/warna.

## AppNumpadKey
- Berkas: lib/shared/widgets/atoms/app_numpad_key.dart (54 baris).
- Parameter: value (AppNumpadKeyValue) wajib; onPressed/semanticLabel opsional; key.
- Enum: zero sampai nine, tripleZero, decimal (koma), backspace.
- semanticLabel wajib untuk backspace (assert); label lain dapat diganti untuk aksesibilitas.
- Contoh: AppNumpadKey(AppNumpadKeyValue.decimal, onPressed: onDecimal).
- Tidak merakit angka atau menghitung uang/berat; parent Numpad menentukan urutan dan aksi.
- Tinggi minimum 56, radius 12, surfaceLow; token angka numpad 18/24 w700.
- onPressed null menonaktifkan aksi; hapus melalui AppIcons.backspace.
- Galeri 13 tombol + disabled; tes label/ikon, tinggi, callback dan disabled.
- Acuan f0G1R/TU6VH/ONyEv; cocok ukuran/warna/tipografi, glyph hapus Ionicons berbeda dari Lucide.

## Verifikasi visual kelompok input
- Empat galeri Flutter dan perluasan AppText diperiksa tanpa overflow.
- Screenshot MCP Pencil: docs/progress/fase-1-inputs-visuals/.
- AppText mendapat varian numpad untuk memakai token baru tanpa gaya teks di luar tema.
- Frame error/focus/disabled khusus field belum terverifikasi; menggunakan token errorTint,
  error/errorInk, primary, chipIdle/ink3. State tersebut perlu tinjauan pengguna.
- Contoh galeri adalah label teknis, bukan data bisnis. Keyboard/IME dan pembaca layar
  Android/iOS belum diuji pada perangkat; tes widget dijalankan di Windows.

## BottomNavBar
- Berkas: lib/shared/widgets/organisms/bottom_nav_bar.dart.
- API: activeIndex 0..3 (Antrean/Pelanggan/Laporan/Lainnya), onSelected(int),
  onCreate opsional, createLabel default Transaksi. Tanpa state/navigasi internal.
- Lima slot; tengah aksi, bukan tab. Semantics Transaksi baru, selalu tidak aktif.
- Tombol primary 56 dp terangkat 56/3 dp, cincin surface 4 dp, ikon AppIcons.add.
  Dua token baru di AppDimensions; tanpa warna baru atau gradien.
- Contoh: BottomNavBar(activeIndex: tab, onSelected: pilih, onCreate: buat).
- Galeri empat tab aktif dan disabled; tes callback, semantics, area terangkat,
  320 px/teks 2x dan golden. Acuan R2 nav-referensi.png menggantikan nav lama .pen.
## ServiceRow
- Berkas: lib/shared/widgets/organisms/service_row.dart.
- API wajib: name, kind (ServiceKind), price int rupiah, durationDays int.
  Opsi: isActive/showSwitch true, onTap, onActiveChanged(bool).
- Varian: kiloan/satuan, aktif/nonaktif, tanpa switch. Nonaktif tetap dapat diedit/diaktifkan.
- Contoh: ServiceRow(name: name, kind: kind, price: price, durationDays: days, onTap: edit).
- Galeri semua enam layanan master dan tanpa switch; tes callback toggle tidak membuka baris.
- Referensi yI3rK/G7SU6: padding/radius 16 cocok; jenis berupa teks tanpa pill,
  tidak ada titik/ikon jam dekoratif, tidak memakai opacity 0.75 yang belum ada di token.

## CustomerRow
- Pemakaian layar: /pelanggan (spec 12-daftar-pelanggan.md), statistik dan filter reaktif.
- Berkas: lib/shared/widgets/organisms/customer_row.dart.
- API wajib: name, phone. Opsi: initials, orderCount/historyTotal/savings/outstanding/paid = 0,
  onTap, onContact. Semua nominal int rupiah. Data saldo/statistik dihitung pemanggil.
- Varian: netral, piutang belum bayar/DP, tabungan, fallback avatar, kontak disabled.
- Contoh: CustomerRow(name: name, phone: phone, savings: balance, onTap: open).
- Galeri: customer_row_use_case.dart; tes memeriksa saldo dan callback kontak terpisah.
- Referensi gv4k0/adwTE: avatar 40, kartu 16 dan strip riwayat cocok.
  Status bayar teks tanpa pil mengikuti PRD, warna DP amber; AppIconButton tidak
  memiliki latar lingkaran. Initials disiapkan pemanggil, bukan ditebak widget.

## SavingsRow
- Pemakaian layar: Detail Pelanggan (spec 13); saldo dihitung dari ledger penuh sebelum mengambil tiga mutasi terbaru.
- Berkas: lib/shared/widgets/organisms/savings_row.dart.
- API wajib: label, timeLabel (hasil Formatters), kind SavingsKind, amount int, balance int.
  Opsi: methodLabel, reference, note. Tidak ada aksi edit ledger.
- Varian: setor (+), pakai (-), penyesuaian bertanda; rincian opsional.
- Contoh: SavingsRow(label: label, timeLabel: time, kind: kind, amount: amount, balance: balance).
- Galeri: savings_row_use_case.dart; tes render nominal, golden, lebar 320 dan skala teks 2x.
- Referensi i9q8b/gpqMH/Wt1NN: susunan dibuat vertikal agar teks besar membungkus;
  judul tanpa pill, ikon wallet mengganti titik, InfoRow tanpa latar tinted di frame.

## ExpenseRow
- Berkas: lib/shared/widgets/organisms/expense_row.dart.
- API wajib: category, note, amount int positif, timeLabel hasil Formatters.
  Opsi: vendor kosong, onTap. Nominal dirender negatif berwarna error.
- Varian: vendor ada/kosong, interaktif/noninteraktif. Contoh:
  ExpenseRow(category: category, note: note, amount: amount, timeLabel: time, onTap: edit).
- Galeri: expense_row_use_case.dart; tes nominal/callback, golden dan teks 2x.
- Referensi vHZ7O: nominal kanan dan merah, catatan membungkus. Kategori tanpa pill;
  row berupa kartu sendiri dibanding wadah kelompok tanggal bersama; tidak menambah tombol foto.
  Teks vendor/catatan mengikuti DATA MASTER, bukan teks tambahan yang hanya ada di .pen.
- Nominal bukan flex: menempel ke tepi kanan kartu, bukan berbagi sisa lebar dengan kolom teks.

## OrderCard
- Berkas: lib/shared/widgets/organisms/order_card.dart (100 baris).
- API wajib: orderNo, customerName, summary, total int, status OrderStatus, payStatus PayStatus.
  Opsi: timeLabel/detail kosong, paid int 0, compact/needsReview/cancelRequested false,
  onTap/onAction. Data yang sudah diformat dibuat lewat Formatters oleh pemanggil.
- Varian: semua lima status dan tiga status bayar; rail normal/amber/merah; aksi/ringkas.
  Rail merah diprioritaskan atas amber. Status final tidak menampilkan aksi progres.
- Contoh: OrderCard(orderNo: number, customerName: name, summary: items, total: total,
  status: status, payStatus: payment, onAction: advance).
- Galeri: order_card_use_case.dart; tes callback tidak memicu onTap induk, prioritas rail,
  golden dan teks 2x. Mapping badge/status bayar dilakukan di organism.
- Referensi JrA3v/V6p3J: kartu, badge, CTA outline, nominal mengikuti token.
  Mono w400 vs w600 di .pen; tidak ada titik status; header wrap saat sempit.
  needsReview/cancelRequested hanya penanda rail; onAction tetap aksi progres status.
  Keputusan usulan batal menggunakan ProposalCard/callback pemanggil, tidak diproses kartu ini.


## NotaCard
- Berkas: lib/shared/widgets/organisms/nota_card.dart.
- API wajib: orderNo, customerName, summary, total int, status OrderStatus, payStatus PayStatus.
  Opsi: timeLabel kosong (hasil Formatters), paid int 0, onTap.
- Varian: lima status order, tiga status bayar, callback aktif/nonaktif; tanpa aksi progres.
- Contoh: NotaCard(orderNo: number, customerName: name, summary: items, total: total,
  status: status, payStatus: payment, paid: paid, onTap: open).
- Galeri: nota_card_use_case.dart; tes DP/callback, golden, lebar 320 dengan teks 2x.
- Referensi Sx8tY: struktur ringkas cocok; mono w400 mengikuti token, nama/angka dari
  DATA MASTER. Header membungkus bila ruang sempit, tinggi mengikuti isi.

## ProposalCard
- Berkas: lib/shared/widgets/organisms/proposal_card.dart.
- API wajib: customerName, summary. Opsi: timeLabel/reviewText kosong,
  needsReview false, onApprove/onReject. onApprove membuka pemeriksaan saat needsReview.
- Varian: ragu (rail amber, Periksa), yakin (Setujui), disabled; selalu ada Tolak.
- Contoh: ProposalCard(customerName: name, summary: source, needsReview: true,
  reviewText: uncertainPart, onApprove: review, onReject: reject).
- Galeri: proposal_card_use_case.dart; tes pergantian tombol/rail/callback, golden dan teks 2x.
- Referensi i1jkP: rail, hierarki dan pasangan tombol sesuai token. CalloutAi yang ada
  tidak menyediakan kotak tinted; tidak diubah. Tidak ada titik pemisah judul/waktu.
- Kontrak Proposal minimal belum memiliki certainty/uncertainPart. Galeri mendemonstrasikan
  state visual memakai teks fixture yang sama; tidak menambah hasil interpretasi AI palsu.
  Pemanggil kelak memasok bagian ragu. Label sumber WhatsApp mengikuti cakupan PRD.

## PiutangCard
- Berkas: lib/shared/widgets/organisms/piutang_card.dart.
- API wajib: customerName, orderNo, summary, total int, paid int, ageLabel netral.
  Opsi: dateLabel kosong (hasil Formatters), onPay, onRemind.
  total > 0 dan 0 <= paid < total; sisa dihitung total - paid.
- Varian: belum bayar/DP, tombol aktif/disabled; tidak ada jatuh tempo.
- Contoh: PiutangCard(customerName: name, orderNo: number, summary: items, total: total,
  paid: paid, ageLabel: age, onPay: pay, onRemind: remind).
- Galeri lima piutang master (total Rp400.500); tes saldo/warna usia/callback,
  golden dan lebar 320 dengan teks 2x.
- Referensi C4RpY: usia ink3, dua tombol dan sisa cocok. DP amber sesuai PRD,
  bukan hijau di desain; header wrap, nomor nota mono w400.

## ReceiptFormatter
- Berkas: lib/core/domain/receipt_formatter.dart + receipt_layout.dart.
- API: receiptLines(business, order, items, payments, customerName, settings,
  savingsBalance) -> List<String> 32 kolom. Murni; tanpa Flutter/Riverpod/jam sistem.
- Baris kondisional mengikuti receipt_template.md: tabungan, metode bayar, sisa tabungan,
  catatan. Status LUNAS/LUNAS (TABUNGAN)/DP/BELUM BAYAR. Formatters.tanggalStruk baru
  (16 Okt 2026) dipakai untuk tanggal struk.
- Contoh: receiptLines(business: profile, order: order, items: items, payments: payments,
  customerName: name, settings: settings, savingsBalance: balance).
- Tes: receipt_formatter_test.dart (A-0143 persis template), settings test, layout helpers.

## ReceiptPreview
- Berkas: lib/shared/widgets/organisms/receipt_preview.dart; clipper di core/theme.
- API: lines List<String> hasil ReceiptFormatter; widget hanya merender, tanpa format.
- Varian: struk penuh dan struk dengan alamat/pelanggan/tabungan/catatan disembunyikan.
- Contoh: ReceiptPreview(lines: receiptLines(...)).
- Galeri: receipt_preview_use_case.dart; tes 26 baris, golden, lebar 320 dan teks 2x.
- Referensi C/Struk A-0143: mono 11/16, hitam, latar putih, tepi bergerigi 8 px,
  padding 16/16. Alamat DATA MASTER (memuat Bandung) membungkus dua baris seimbang,
  sedangkan frame memakai satu baris tanpa kota; perbedaan dicatat.

## ReceiptToggleList
- Berkas: lib/shared/widgets/organisms/receipt_toggle_list.dart.
- API wajib: showAddress, showCustomer, showSavings, showNote (bool) dan callback
  onAddressChanged/onCustomerChanged/onSavingsChanged/onNoteChanged opsional.
- Varian: semua aktif, sebagian nonaktif, dan dua baris terkunci.
- Contoh: ReceiptToggleList(showAddress: true, showCustomer: true, showSavings: true,
  showNote: true, onAddressChanged: setAddress).
- Galeri: receipt_toggle_list_use_case.dart; tes empat AppSwitch, dua label terkunci,
  dan callback baris pertama.
- Referensi frame Printer dan Struk: ToggleRow/LockedRow yang ada dipakai ulang tanpa
  perubahan. Label membungkus dua baris pada 390 px karena ikon + switch; frame 48 px.

## Numpad
- Berkas: lib/shared/widgets/organisms/numpad.dart.
- API wajib: onKey(AppNumpadKeyValue). Opsi: variant standar/desimal, amounts int rupiah,
  selectedAmount, onNominalSelected. Tanpa logika uang dan tanpa tombol Reset (C).
- Varian: 000/0/hapus, koma/0/hapus, dengan atau tanpa baris NominalChips.
- Contoh: Numpad(onKey: appendDigit, variant: NumpadVariant.decimal).
- Galeri: numpad_use_case.dart; tes key 7, chip nominal, varian desimal mengganti 000.
- Referensi C/Numpad Desimal dan 3-Column Numpad Grid: AppNumpadKey 56/12, gap 8,
  surfaceLow; chips memakai NominalChips +Rp dari atom lama.

## AppBottomSheet
- Berkas: lib/shared/widgets/organisms/app_bottom_sheet.dart.
- API: `AppBottomSheet.show<T>(context, title, child, subtitle)` mengembalikan Future<T?>;
  widget langsung menerima title/subtitle/child.
- Varian: dengan/tanpa subtitle, isi bebas dari halaman; tutup lewat ikon close.
- Contoh: AppBottomSheet.show<void>(context: context, title: 'Pembayaran',
  subtitle: 'Nota A-0143 · Pak Dedi', child: PaymentSheet(...)).
- Galeri: app_bottom_sheet_use_case.dart; tes buka/tutup lewat show.
- R1: show memakai useSafeArea, batas tinggi 90% layar dan padding viewInsets keyboard.
  Slot child fleksibel agar SheetScaffold menggulir body dan menjaga footer tetap terlihat.
  Galeri tambahan app_bottom_sheet_keyboard_use_case.dart membuka modal dengan input.
- Referensi C/Sheet: radius 28, drag handle 40x4 borderStrong, padding 12/16 dan 4/16,
  judul section 16/22, subjudul caption. AppIconButton close berlatar putih sedangkan
  frame chipIdle; atom tidak diubah.

## ConfirmModal
- Berkas: lib/shared/widgets/organisms/confirm_modal.dart.
- API: `ConfirmModal.show(context, title, message, confirmLabel, cancelLabel, destructive,
  icon)` -> Future<bool?>; true untuk konfirmasi, false untuk kembali.
- Varian: tombol utama biasa (action) dan destruktif (destructiveFilled).
- Contoh: ConfirmModal.show(context: context, title: 'Hapus pengeluaran ini?',
  message: summary, confirmLabel: 'Hapus', destructive: true, icon: AppIcons.alert).
- Galeri: confirm_modal_use_case.dart; tes hasil true/false, golden dan teks 2x.
- Referensi C/Modal: 326 px, radius 16, padding 24, gap 12, ikon 48 primaryTint.
  Isi dapat digulir agar teks 2x tidak overflow. Frame selalu memakai ikon info;
  ikon dapat diganti pemanggil.

## ReportSummary
- Pemakaian layar: tab Laporan (spec 18); totals dan jumlah piutang mengikuti repository, aksi membuka Daftar Piutang.
- Berkas: lib/shared/widgets/organisms/report_summary.dart.
- API wajib: totals ReportTotals, expenseSummary, unpaidCount int; opsi onOutstandingTap.
- Varian: laba positif/nol, piutang aktif, interaktif/noninteraktif.
- Contoh: ReportSummary(totals: totals, expenseSummary: 'Deterjen & operasional',
  unpaidCount: 5, onOutstandingTap: openPiutang).
- Galeri: report_summary_use_case.dart; tes angka mingguan dan callback piutang.
- Referensi Laporan - Ringkasan: laba figure, chipIdle sub-grid, kartu kewajiban, piutang
  error + chevron. Batas 110 baris membuat metrik menjadi dua baris teks dan kewajiban
  digabung dalam satu kartu; ikon lingkaran piutang tidak dipakai. Selisih dicatat.

## TopServices
- Berkas: lib/shared/widgets/organisms/top_services.dart.
- API wajib: services List<ServiceRevenue>; opsi totalRevenue (default jumlah layanan)
  dan title. Persentase dibulatkan dari revenue/total; unit kosong menjadi "Lainnya".
- Varian: empat peringkat, pendapatan nol, kuantitas kg/pcs/tanpa kuantitas.
- Contoh: TopServices(services: weekTopServicesFixtures).
- Galeri: top_services_use_case.dart; tes nama, kuantitas, nominal, persentase.
- Referensi Layanan Terlaris: pil peringkat 20, progress 8, persen primary untuk rank 1.
  Tanpa paket chart; kuantitas Lainnya disembunyikan sesuai catatan prompt 11.

## WeeklyBarChart
- Berkas: lib/shared/widgets/organisms/weekly_bar_chart.dart.
- API wajib: labels dan amounts (List<int?>; null = belum terjadi); opsi title,
  averageLabel, peakLabel. Tinggi grafik 128 dan bertambah saat skala teks naik.
- Varian: hari terjadi, hari belum terjadi (batang putus-putus), puncak.
- Contoh: WeeklyBarChart(labels: days, amounts: values, averageLabel: average,
  peakLabel: 'Puncak: Kamis').
- Galeri: weekly_bar_chart_use_case.dart; tes label, nilai ringkas, garis putus-putus.
- Referensi Aktivitas omzet harian: label 340k, batang primary, garis putus borderStrong.
  Batang memakai radius AppRadius.input (8 semua sudut), frame hanya sudut atas.

## RootScaffold
- Berkas: lib/shared/widgets/templates/root_scaffold.dart.
- API wajib: title, accountLabel, activeIndex 0..3, body. Opsi: syncState,
  onAccount, onTabSelected, onCreate. Tanpa fabLabel/onFab atau FAB.
- AppBarRoot + SyncIndicator, body, BottomNavBar dengan aksi tengah.
- Contoh: RootScaffold(title: nama, accountLabel: akun, activeIndex: tab,
  onTabSelected: pilih, onCreate: buat, body: content).
- Widgetbook: navigasi dan Transaksi, offline. Tes tanpa FAB, callback,
  golden dan 320 px/teks 2x. R2 menggantikan FAB pil lama di frame .pen.
## SubScaffold
- Berkas: lib/shared/widgets/templates/sub_scaffold.dart.
- API wajib: title, backLabel, body. Opsi: onBack, trailing, fabLabel/onFab (berpasangan).
- Varian: dengan/tanpa aksi kanan atau FAB; tanpa nav bawah. FAB primary berikon add,
  disembunyikan saat viewInsets.bottom > 0. Pemanggil menyisakan ruang bawah daftar.
- Contoh: SubScaffold(title: 'Detail order', backLabel: 'Kembali', onBack: back,
  trailing: AppText('Ubah'), body: content).
- Galeri: sub_scaffold_use_case.dart; tes judul, trailing, callback kembali, golden.
- Referensi WiQtw/Detail Order: AppBarSub 64 + SafeArea; body memakai SafeArea bawah.
  Tombol kembali memakai AppIconButton berkotak putih (atom) vs ikon transparan frame.

## FormScaffold
- Berkas: lib/shared/widgets/templates/form_scaffold.dart.
- API wajib: title, backLabel, body, footer. Opsi: summary, onBack, trailing, padding
  (default 16). Body dapat digulir; footer memakai FooterBar sticky.
- Varian: dengan/tanpa ringkasan; trailing opsional.
- Contoh: FormScaffold(title: 'Catat pengeluaran', backLabel: 'Kembali', body: fields,
  summary: total, footer: AppButton('Simpan pengeluaran', onPressed: save)).
- Galeri: form_scaffold_use_case.dart; tes body, ringkasan, footer, golden.
- R1: footer diberi padding viewInsets agar berada di atas keyboard; body tetap dapat digulir.
  Varian galeri Input dan keyboard; tes keyboard bersama sheet pada 390x844 dan 320x640,
  keyboard 300 dp, dengan safe area. Golden tanpa keyboard dipertahankan.
- Referensi Catat Pengeluaran/uqTPF: app bar sub + body gulir + footer sticky bertabayang.
  Frame memakai padding 8/16 pada stack; template memakai 16 agar konsisten.

## SheetScaffold
- Berkas: lib/shared/widgets/templates/sheet_scaffold.dart.
- API wajib: child. Opsi: footer, padding (default 16). Body dapat digulir; footer tetap
  di bawah. Template ini adalah isi sheet, bukan surface: pakai sebagai child AppBottomSheet.
- Varian: dengan/tanpa footer.
- Contoh: AppBottomSheet(title: 'Input berat', child: SheetScaffold(child: form,
  footer: AppButton('Simpan berat', onPressed: save))).
- Galeri: sheet_scaffold_use_case.dart (dibungkus AppBottomSheet + Scaffold); tes body,
  footer, golden.
- Referensi C/Sheet Transaksi - Pembayaran/Input Berat: header/handle dari AppBottomSheet,
  padding 16, footer di luar area gulir. Tanpa scrim sendiri.

## AuthScaffold
- Berkas: lib/shared/widgets/templates/auth_scaffold.dart.
- API wajib: child. Tanpa app bar, nav, atau provider.
- Varian: satu (konten auth bebas).
- Contoh: AuthScaffold(child: Column(children: [brand, fields, AppButton('Masuk')])).
- Galeri: auth_scaffold_use_case.dart; tes tanpa AppBar, golden, 320 px + teks 2x.
- Referensi Auth - Masuk: latar bg, konten selebar layar dikurangi 32, mulai 96 px dari
  atas layar (SafeArea bawah tetap aktif), dapat digulir saat keyboard muncul.

## Layar dan navigasi Fase 2

### AntreanPage
- Berkas: lib/features/orders/pages/antrean_page.dart (100 baris),
  state/antrean_controller.dart, state/antrean_data.dart,
  widgets/antrean_status_section.dart.
- Rute: /antrean di dalam StatefulShellRoute cabang Antrean.
- Data: antreanDataProvider menggabungkan order/items/payment/customer/proposal dari
  repository publik; tanpa membaca fixture di page.
- Komposisi: RootScaffold (app bar root, sync, nav, aksi Transaksi tengah), SectionHeader, ChipBar,
  ProposalCard di Perlu dicek, OrderCard di Sedang berjalan.
- State: loading tiga AppSkeleton; error dengan Coba lagi; kosong; filter kosong;
  banner WhatsApp + tombol Hubungkan saat koneksi palsu terputus.
- Aksi: OrderCard memajukan satu status + OrderEvent; guard klik ganda dan status usang;
  Tolak mengubah usulan tanpa membatalkan order; Periksa membuka placeholder.
- Tes: antrean_page_test, antrean_controller_test, antrean_states_test,
  antrean_golden_test, app_router_test; 7 golden termasuk 320 px dan teks 2x.
- Selisih: tiga usulan master tampil, tanggal memakai tahun, banner dan tombol Hubungkan
  terpisah karena BannerMessage tanpa slot aksi, tombol tengah berada di nav.

### Root shell dan router
- Berkas: lib/features/shell/pages/{app_router,root_shell_page,placeholder_page,
  placeholder_routes}.dart dan lib/features/shell/state/shell_state.dart.
- app_router: GoRouter dengan StatefulShellRoute.indexedStack lima cabang; rute PRD A 8
  yang belum dibuat memakai PlaceholderPage.
- Rute placeholder: /masuk, /antrean/usulan/:id, /transaksi/*, /order/:id[/edit],
  /pelanggan/*, /laporan/piutang, /lainnya/*.
- RootShellPage: nama usaha dari businessProfileProvider, SyncService, akun ke tab
  Lainnya, aksi Transaksi tersedia di semua tab, banner WhatsApp di atas daftar.
- shell_state: businessClockProvider (dummy 16 Okt 2026 12.00), businessProfileProvider,
  shellSyncProvider, whatsappConnectionProvider palsu.
- Catatan: placeholder daftar turunan (mis. /lainnya/layanan) masih memakai SubScaffold
  tanpa nav bawah; aturan nav daftar turunan diterapkan saat layarnya dibangun.
- Entry point: main.dart dan main_dummy.dart memakai createAppRouter dan
  dummyRepositoryOverrides yang sama.

### Fase 3: transaksi baru
- Rute nyata: /transaksi/baru (TransactionPage) dan /transaksi/baru/layanan
  (ServicePickerPage); /transaksi/baru/bayar tetap placeholder prompt 32.
- TransactionPage: FormScaffold, TransactionCustomerSection, SectionHeader Layanan,
  MenuRow per DraftLine, TransactionDetailsSection, FooterBar total + Bayar.
- Potongan layar di features/transactions/widgets: TransactionCustomerSection,
  TransactionDetailsSection, AddCustomerFormSection (dipakai inline, pola AntreanStatusSection).
- Sheet: CustomerPickerSheet, AddCustomerSheet, ContactPickerSheet,
  TransactionLineSheet, WeightInputSheet, DiscountSheet.
- Provider: transactionDraftProvider (global, bertahan antar layar), serviceSearchProvider,
  customerSearchProvider, customerCatalogProvider, customerBalanceProvider,
  serviceCatalogProvider, weightEditProvider, discountInputProvider, addCustomerFormProvider.
- Draf: DraftLine menghitung total via lineTotal; qty kg 0,5 kg step, pcs 1; total =
  subtotal - diskon; clear saat keluar; guard ConfirmModal bila berisi.
- Pelanggan: pencarian AppSearchField, normalisasi nomor 62/8 ke 0, duplikat menampilkan
  nama pemilik + Pakai pelanggan ini, kontak palsu lewat ContactPickerSheet.
- Estimasi memakai estimateReady dan teks 'Mengikuti layanan terlama'.
- Selisih: pencarian pelanggan di sheet, baris layanan MenuRow, detail estimasi InfoRow,
  Pilih Layanan berupa halaman (frame sheet S25), chip berat AppChip, sheet pelanggan
  dibatasi 500 px, tombol footer sheet full-width (perubahan SheetScaffold).
- Tes: transaction_draft, transaction_page, service_picker, add_customer, app_router,
  3 golden; 245 tes total, REPO_MAP 363 berkas.

### Fase 4: printer dan struk
- Rute /lainnya/printer (PrinterPage) menggantikan placeholder.
- PrinterPage: FormScaffold; PrinterConnectionSection, PrinterSettingsSection,
  PrinterPreviewSection; footer Simpan pengaturan + Cetak uji.
- PrinterSettingsProvider (AsyncNotifier): ReceiptSettings + BusinessProfile; edit
  langsung, save ke BusinessRepository. PrinterConnectionProvider (Notifier): status,
  devices, connected, notice.
- PrintService: PrintStatus, PrinterDevice, ReceiptData(lines/paperMm/fontSize),
  discover/connect/printReceipt/enableBluetooth/disconnect. Fake bisa gagal/bluetooth off.
- Sheet: PrinterDeviceSheet dan BluetoothSheet.
- Pratinjau memakai ReceiptFormatter 32 kolom + A-0143; ReceiptPreview width 320/384.
- Selisih: tanpa tab Printer/Tampilan struk, tanpa perataan header, huruf Normal/Besar
  (11/13), cetak/koneksi palsu. iOS belum diuji; risiko Bluetooth Classic vs BLE.
- Tes: printer_service (4), printer_page (4) + golden printer_page; 253 tes, 375 berkas.

### Fase 3 lanjutan: pembayaran dan nota
- Rute /transaksi/baru/bayar (PaymentPage) dan /transaksi/nota/:id (ReceiptPage).
- PaymentPage: PaymentSummarySection (total + status chip), PaymentSavingsSection (switch
  tabungan), PaymentMethodSection (metode + uang diterima), CashInputSheet.
- Checkout: checkoutControllerProvider (metode/mode/received/useSavings), quotePayment,
  saveCheckout membuat Order/OrderItem/Payment/OrderEvent + SavingsEntry; nomor A-0143.
- ReceiptPage: ReceiptStatusSection, ReceiptPreview data tersimpan, receiptPrintProvider
  (PrintService + ExternalLauncher), banner gagal cetak + Coba lagi/Pengaturan printer.
- Tombol: Cetak struk, Kirim lewat WhatsApp, Transaksi baru, Lihat order.
- Catatan atomicity: saveOrder atomik untuk order/item/payment/event; SavingsEntry ditulis
  setelahnya karena repository terpisah. Validasi saldo sebelum simpan; rollback belum ada.
- Selisih: pembayaran berupa halaman (frame sheet), tanpa simpan kelebihan ke tabungan;
  kedua tombol footer tidak mencetak otomatis; struk dicetak manual di Nota.
- Tes: checkout_controller, payment_page, receipt_page + golden payment_page dan
  receipt_page; 258 tes, 391 berkas.

## R3 - Transaksi (tervalidasi otomatis 31 Oktober 2026)
- SubScaffold: fabLabel/onFab memakai FloatingActionButton.extended mengikuti pola
  FAB lama RootScaffold. Widgetbook menambahkan varian FAB dan keyboard.
- ServicePickerListSection: services (List<ServiceItem>), query, onSearch,
  onSelect. Stateless tanpa provider; Page memuat katalog dan menangani navigasi.
- TransactionCustomerSection: customer (Customer?), balance (int rupiah), onChoose,
  onCreate. Tanpa pelanggan: pilih melebar + Baru; terpilih: MenuRow lama.
  Provider dan aksi sheet hanya di TransactionPage. Utang Section 25 -> 24.
- Tes ditulis di sub_scaffold_fab_test, service_picker_list_section_test,
  transaction_customer_section_test dan r3_*_test. Lulus check_all 31 Oktober 2026 (387 tes total).
- Golden service_picker dan add_customer_sheet ditinjau dan diperbarui;
  transaction_page (pelanggan terpilih) tetap sama.
