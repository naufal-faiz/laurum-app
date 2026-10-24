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
- Berkas: lib/shared/widgets/atoms/app_text_field.dart (88 baris).
- Parameter: label wajib (aksesibilitas, bukan label visual); value = ''; hint/errorText;
  onChanged/onSubmitted; keyboardType/textInputAction/inputFormatters; enabled = true;
  readOnly/obscureText = false; minLines/maxLines = 1; key.
- Contoh: AppTextField(label: label, value: value, errorText: error, onChanged: onChange).
- Varian galeri: kosong, terisi, error, disabled, readOnly, password, multiline.
- Controller dimiliki widget dan dibuang di dispose. Perubahan value eksternal mengganti teks
  dan memindah caret ke akhir; echo nilai yang sama tidak mengubah selection/composing.
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
- API: activeIndex 0..4 wajib, onSelected(int) opsional. Tanpa navigasi/state internal.
- Varian: lima tab aktif dan disabled. Ikon terisi untuk aktif; primary + label semibold.
- Contoh: BottomNavBar(activeIndex: tab, onSelected: selectTab).
- Galeri: widgetbook/organisms/bottom_nav_bar_use_case.dart; tes: bottom_nav_bar_test.dart.
- Referensi MurpB: lima kolom, padding vertikal 8, gap 4, ikon 24.
  Tinggi dinamis 60 + divider/SafeArea, dibanding frame 96; tidak menebak inset perangkat.

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
