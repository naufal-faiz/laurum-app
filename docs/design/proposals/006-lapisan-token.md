# 006 - Lapisan 1: Token Global (Redesign UI)

Status: **menunggu persetujuan pengguna** (gerbang UI-21). Sesi 10 Nov 2026 tidak
mengubah kode. Keputusan global: `docs/design/redesign/decisions.md` (5 butir, disetujui
pengguna 10 Nov 2026). Rencana lapisan: `docs/plans/redesign-atomic.md`.

## Lingkup dan izin

- Hanya menyentuh `lib/core/theme/`, `docs/design/tokens.md`, dan pemakainya pada
  migrasi utang auth (UI-23). Tidak ada perubahan perilaku, state, data, rute.
- Perubahan `pubspec.yaml` (registrasi Inter sebagai font global, penghapusan
  Plus Jakarta Sans) dimintakan izin berkas terpisah sesuai decisions butir 2.
  File Inter-Regular/SemiBold/Bold.otf sudah ada di `assets/fonts/`.
- Token global. Dilarang namespace per layar (UI-12): semua `auth*` dibubarkan.

## (a) Tabel token global lama ke baru

### Warna (`AppColors`)

| Token | Lama | Baru | Catatan |
|---|---|---|---|
| `primary` | `#00653B` | `#2675C9` | biru dominan Figma |
| `primaryInk` | – (baru) | `#174B83` | aksen gelap, ikon di atas tint |
| `primaryTint` | `#E1F3E8` | `#E3EEFA` | latar badge/avatar biru |
| `success` | – (baru) | `#2F7D4F` | hijau lama dipindah ke status |
| `successTint` | – (baru) | `#E9F5EE` | |
| `successInk` | – (baru) | `#1F6B41` | usulan turunan (cek kontras) |
| `ink` | `#131B2E` | `#26364A` | teks utama |
| `ink2` | `#3E4947` | `#4E5F76` | usulan turunan |
| `ink3` | `#6E7977` | `#7C8DA3` | label/teks pendukung |
| `placeholder` | `#3E4947` @60% | `#B7C2CF` | |
| `bg` | `#F8F9FF` | `#F8F9FF` | tetap |
| `surface` | `#FFFFFF` | `#FFFFFF` | tetap |
| `surfaceLow` | `#F2F3FF` | `#F4F6F8` | |
| `chipIdle` | `#EFF4FF` | `#F4F6F8` | |
| `border` | `#E5E7EB` | `#E7EDF4` | sekaligus `divider` |
| `borderStrong` | `#D1D5DB` | `#DDE3E8` | border field |
| `error`, `errorInk`, `errorTint` | tetap | tetap | |
| `warningBorder`, `warningInk`, `warningTint` | tetap | tetap | |
| `slate`, `slateTint`, `slateInk` | tetap | tetap | status netral |
| `blue`, `blueTint`, `blueInk` | `#1D5FA8`/`#E3EEFA`/`#174A85` | alias ke `primaryInk`/`primaryTint`/`primary` | badge Diproses; dihapus setelah pemakai pindah |
| `scrim`, `appBarBg`, `receiptInk`, `brightAccent` | tetap | tetap | |
| `heroGradientStart` | – (`auth` baru) | `#2E7FD8` | |
| `heroGradientEnd` | – (`auth` baru) | `#1B5FA3` | |
| `heroTagline` | – (`auth` baru) | `#DCEBF9` | |
| `heroBlob` / `heroBlobSoft` / `heroDot` | – (`auth` baru) | `#1AFFFFFF` / `#14FFFFFF` / `#80FFFFFF` | ornamen hero |
| `illustration` | – (`auth` baru) | `#4A90DA` | lingkaran ilustrasi |
| `backBorder` | – (`auth` baru) | `#8FBCEB` | border tombol kembali di hero |
| `brandGoogleBlue` / `brandGoogleBorder` | – (`auth` baru) | `#4285F4` / `#E3E9F0` | hanya untuk aset/logo Google |
| `authEyeBorder` | `#E9EEF4` | **dihapus** | tidak dipakai setelah kotak mata dihapus |

### Tipografi (`AppTextStyles`; Plus Jakarta Sans → Inter)

| Token | Lama | Baru | Pemakaian |
|---|---|---|---|
| `fontFamily` | Plus Jakarta Sans | **Inter** (400/600/700) | global |
| `hero` | – (baru) | 28/34 w700 | judul hero auth; nanti judul layar bila desain menuntut |
| `brand` | – (baru) | 16/20 w700 | merek di hero |
| `brandSub` | – (baru) | 11/14 w600 | tagline merek (minimum 11) |
| `titleRoot` | 24/32 w700 | 24/32 w700 | judul layar |
| `titleSub` | 18/24 w600 | 18/24 w600 | judul app bar sub |
| `section` | 16/22 w600 | 16/22 w600 | |
| `figure` | 24/32 w700 | 24/32 w700 | angka besar |
| `body` | 14/20 w400 | 14/20 w400 | |
| `bodyStrong` | 14/20 w600 | 14/20 w600 | |
| `input` | 16/24 w400 | **14/20 w400** | nilai input |
| `label` | 12/16 w600 | 12/16 w600 | label, link, badge |
| `caption` | 12/16 w400 | 12/16 w400 | |
| `meta` | – (baru) | 11/15 w400 | "atau", trust, teks bantu |
| `micro` | – (baru) | 11/15 w600 | chip fitur (10,5 → 11) |
| `cta` | 16/22 w700 | **15/20 w600** | teks tombol utama |
| `numpad` | 18/24 w700 | 18/24 w700 | |
| `monoLabel`, `monoReceipt` | 12/16, 11/16 | tetap | struk/nota |

### Radius (`AppRadius`)

| Token | Lama | Baru | Pemakaian |
|---|---|---|---|
| `action` | 8 | **12** | tombol aksi menengah |
| `input` | 8 | **12** | field (sekaligus `field`) |
| `card` | 16 | 16 | kartu biasa |
| `cardLarge` | – (baru) | 24 | kartu auth + modal besar |
| `cta`, `secondary` | 14 | 14 | tombol besar |
| `buttonSmall` | – (baru) | 12 | tombol kecil 40 |
| `bar` | – (baru) | 12 | fitur/toolbar |
| `logo` | – (baru) | 12 | kotak logo/ikon |
| `hero` | – (baru) | bawah 32 | hero auth |
| `chip`, `badge` | 999 | 999 | |
| `sheet` | 28 atas | 28 atas | |
| `numpad` | 12 | 12 | |
| `modal` | 16 | 16 | |
| `authCard/authField/authBar/authLogo/authEye/authHero` | 24/12/12/12/9/32 | **dihapus** | pindah ke token global di atas |

### Bayangan (`AppShadows`)

| Token | Nilai | Pemakaian |
|---|---|---|
| `appBar`, `stepper`, `footer`, `modal` | tetap | |
| `cardElevated` | `0 14 32 #174B83@12.5%` | kartu auth |
| `raised` | `0 3 10 #174B83@5%` | tombol Google/sekunder terangkat |
| `authCard`, `authGoogle` | dihapus | pindah ke dua token di atas |

### Spacing, dimensi, ikon (`AppSpacing`, `AppDimensions`, `AppControlTokens`)

| Token | Nilai | Catatan |
|---|---|---|
| `xxsmall` | 4 | baru |
| `xsmall` | 6 | baru |
| `small` | 8 | baru |
| `smallMedium` | 10 | baru |
| `medium` | 12 | baru (`cardGap` menjadi alias) |
| `mediumLarge` | 14 | baru (padding field/bar) |
| `large` | 16 | baru (`screenPadding`, `cardPadding` alias) |
| `largeX` | 18 | baru (padding kartu auth) |
| `xlarge` | 24 | baru |
| `xxlarge` | 32 | baru |
| `appBarHeight` | 64 | tetap |
| `minTouchTarget` / `touchTarget` | 44 / 48 | tetap, `fieldHeight` = 48 |
| `buttonLarge` | 50 | baru (`ctaHeight` 56 → 50) |
| `buttonMedium` | 44 | baru |
| `buttonSmall` | 40 | baru |
| `barHeight` | 46 | baru |
| `backButton` | 36 | baru |
| `iconTiny` / `iconSmall` / `iconAction` / `icon` / `iconLarge` | 12 / 16 / 20 / 24 / 44 | `iconTiny` dan `iconLarge` baru |

`AppGap` (molekul) tetap; Section wajib memakai token ini, bukan literal (UI-26).

## (b) Rencana migrasi utang token auth (UI-23), per berkas

Hapus setelah migrasi: `lib/core/theme/app_auth_text_styles.dart`,
`lib/core/theme/app_field_styles.dart`, seluruh entri `auth*` di
`app_colors.dart`, `app_radius.dart`, `app_shadows.dart`.

Pemetaan nilai auth → global (dipakai tabel di bawah):
`authHeroGradientStart/End → heroGradientStart/End`, `authHeroTagline → heroTagline`,
`authHeroBlob/Soft/Dot → heroBlob/Soft/Dot`, `authIllustration → illustration`,
`authPrimary → primary`, `authPrimaryInk → primaryInk`, `authInk → ink`,
`authLabel → ink3`, `authPlaceholder → placeholder`, `authFieldBorder → borderStrong`,
`authDivider → border`, `authChipBg → surfaceLow`, `authBackBorder → backBorder`,
`authGoogle* → brandGoogle*`, `authEyeBorder → hapus`;
`authCard → cardLarge`, `authField → input`, `authBar → bar`, `authLogo → logo`,
`authEye → hapus`, `authHero → hero`; `authCard shadow → cardElevated`,
`authGoogle shadow → raised`;
`heroTitle → hero`, `heroBrand → brand`, `heroBrandSub → brandSub`, `heroSub → body`,
`label → label`, `input → input`, `button → cta`, `body → caption`,
`bodyStrong → label`, `meta → meta`, `google → bodyStrong`, `chip → micro`.

| # | Berkas | Token auth dipakai | Setelah migrasi |
|---|---|---|---|
| 1 | `theme/app_auth_text_styles.dart` | seluruh 12 gaya | **dihapus**; pindah ke `AppTextStyles` |
| 2 | `theme/app_field_styles.dart` | 6 warna, 3 radius, gaya input/meta | **dihapus**; dekorasi field → `AppInputStyles.field()` |
| 3 | `atoms/app_text_field.dart` | `authLabel`, `AppFieldStyles.of/textStyle` | `ink3`, `AppInputStyles.field/textStyle`; parameter `dense/leadingIcon/trailing` tetap |
| 4 | `auth_email_field_section.dart` | `authLabel`, `label` | `ink3`, `label` |
| 5 | `auth_name_field_section.dart` | `authLabel`, `label` | `ink3`, `label` |
| 6 | `auth_or_section.dart` | `authDivider`, `authLabel`, `meta` | `border`, `ink3`, `meta` |
| 7 | `auth_password_field_section.dart` | `authLabel`, `authPrimary`, `authPrimaryInk`, `label` | `ink3`, `primary`, `primaryInk`, `label` |
| 8 | `auth_submit_section.dart` | `authLabel`, `authPrimary`, `button` | `ink3`, `primary`, `cta` (setelah lapisan 2 diganti `AppButton`) |
| 9 | `auth_trust_section.dart` | `authLabel`, `meta` | `ink3`, `meta` |
| 10 | `sign_in_brand_section.dart` | `authHeroTagline`, `authPrimary`, `authLogo`, `hero*` | `heroTagline`, `primary`, `logo`, `hero/brand/brandSub/body` |
| 11 | `sign_in_feature_bar_section.dart` | `authChipBg`, `authInk`, `authPrimary`, `authBar`, `chip` | `surfaceLow`, `ink`, `primary`, `bar`, `micro` |
| 12 | `sign_in_form_card_section.dart` | `authCard`, `authCard` shadow | `cardLarge`, `cardElevated` |
| 13 | `sign_in_hero_section.dart` | `authHero*`, `authHero` radius | `hero*`, `hero` radius |
| 14 | `sign_in_illustration_section.dart` | `authIllustration` | `illustration` |
| 15 | `sign_in_section.dart` | `authFieldBorder`, `authInk`, `authLabel`, `authGoogle` shadow, `body`, `google` | `borderStrong`, `ink`, `ink3`, `raised`, `caption`, `bodyStrong` |
| 16 | `sign_in_signup_link_section.dart` | `authLabel`, `authPrimary`, `body`, `bodyStrong` | `ink3`, `primary`, `caption`, `label` |
| 17 | `sign_up_form_card_section.dart` | `authCard`, shadow | `cardLarge`, `cardElevated` |
| 18 | `sign_up_hero_section.dart` | `authBackBorder`, `authHero*`, `authIllustration`, `authHero`, `hero*` | `backBorder`, `hero*`, `illustration`, `hero`, `hero/brandSub` |
| 19 | `sign_up_signin_link_section.dart` | `authLabel`, `authPrimary`, `body`, `bodyStrong` | `ink3`, `primary`, `caption`, `label` |

Catatan penting: migrasi ini **tidak** merapikan primitif Section (UI-24) atau template
(UI-27/UI-29). Itu lapisan 2–6. Setelah lapisan 1, layar auth masih memakai
Material/InkWell/Container berdekorasi sampai UI-29.

## (c) Layar dan golden yang akan bergeser

Perubahan token bersifat global (font, primer, ink, border, radius, tinggi tombol,
skala teks). Perkiraan: **112 dari 113 golden** berubah; hanya `app_gap` (kotak murni)
tidak terpengaruh. Daftar lengkap untuk persetujuan UI-28:

**Atom (16):** `app_avatar`, `app_badge`, `app_button`, `app_card`, `app_chip`,
`app_divider`, `app_icon`, `app_icon_button`, `app_numpad_key`, `app_search_field`,
`app_skeleton`, `app_status_text`, `app_switch`, `app_text`, `app_text_field`
(dan `app_gap` tetap).

**Molekul (21):** `app_bar_root`, `app_bar_sub`, `banner_message`, `callout_ai`,
`chip_bar`, `date_group_header`, `empty_state`, `footer_bar`, `info_row`,
`labeled_field`, `locked_row`, `menu_row`, `nominal_chips`, `notice_ai`,
`period_tabs`, `progress_row`, `section_header`, `stat_tile`, `stepper_field`,
`sync_indicator`, `toggle_row`.

**Organisme (17):** `app_bottom_sheet`, `bottom_nav_bar`, `confirm_modal`,
`customer_row`, `expense_row`, `nota_card`, `numpad`, `order_card`, `piutang_card`,
`proposal_card`, `receipt_preview`, `receipt_toggle_list`, `report_summary`,
`savings_row`, `service_row`, `top_services`, `weekly_bar_chart`.

**Template (5):** `auth_scaffold`, `form_scaffold`, `root_scaffold`, `sheet_scaffold`,
`sub_scaffold`.

**Layar (54):** `add_customer_sheet`, `ai_settings`, `ai_settings_disconnected`,
`antrean_error`, `antrean_filter_kosong`, `antrean_kosong`, `antrean_loading`,
`antrean_normal`, `antrean_proses`, `antrean_whatsapp`, `auth_signin`,
`auth_signin_error`, `expense_directory`, `expense_form`, `order_detail_actions_1x`,
`order_detail_actions_2x`, `payment_page`, `printer_page`, `proposal_history`,
`proposal_new_customer`, `proposal_rina`, `r10_account`, `r10_account_320_2x`,
`r10_name`, `r10_password`, `r10_password_320_2x`, `r10_phone`, `r10_reset`,
`r10_signin`, `r10_signin_error`, `r10_signin_error_320_2x`, `r10_signup`,
`r10_signup_320_2x`, `r10_verify`, `r4_antrean_sederhana`, `r4_order_detail`,
`r4_settings`, `r5_date_picker`, `r5_report_custom`, `r9_cod_detail`,
`r9_cod_outstanding`, `r9_cod_payment`, `r9_cod_queue`, `receipt_cod_actions_1x`,
`receipt_cod_actions_2x`, `receipt_page`, `service_picker`, `sync_failed`,
`sync_offline`, `sync_saved`, `sync_saving`, `transaction_page`,
`whatsapp_connected`, `whatsapp_waiting`.

Harapan arah perubahan: layar non-auth berubah paling besar (hijau → biru, font Inter,
input 16→14, tombol 56→50, radius input 8→12); layar auth 29/31 berubah paling sedikit
(nilai auth dipindah apa adanya, kecuali sub 13→14, tombol 15/600, tagline 9→11).

## Risiko dan mitigasi

1. **Pergeseran visual luas** (112 golden). Mitigasi: perbarui golden hanya setelah
   proposal ini disetujui, satu commit lapisan 1, daftar diff dilampirkan di STATE.
2. **Tinggi tombol 56 → 50** dapat memengaruhi footer sticky dan tes keyboard 300 dp.
   Mitigasi: jalankan seluruh tes keyboard; jika gagal, pertahankan `ctaHeight` 56
   sebagai `buttonXL` dan pakai 50 hanya untuk tombol di form auth (kembali ke UI-20
   untuk keputusan).
3. **Input 16 → 14** menurunkan keterbacaan; sudah diputuskan (minimum 11) dan
   diverifikasi di perangkat Android.
4. **Kontras `ink2`/`successInk`** adalah usulan turunan; verifikasi kontras ≥4.5:1.
5. **Font global**: perubahan `pubspec.yaml` dan penghapusan Plus Jakarta Sans butuh
   izin berkas terpisah (decisions 2).

## Verifikasi lapisan 1 (setelah disetujui)

- `dart run tool/check_all.dart` hijau (format, analyze, check_arch, seluruh tes,
  repo_map).
- Tidak ada `AppColors.auth`, `AppRadius.auth`, `AppShadows.auth`, `AppAuthTextStyles`,
  `AppFieldStyles` di repo.
- `docs/design/tokens.md` diperbarui sesuai tabel di atas.
- Daftar golden yang berubah dilaporkan ke pengguna (UI-28) sebelum commit final.

## Persetujuan yang diminta

- [ ] Setujui tabel token (a), nilai turunan `ink2`, `successInk`, dan `ctaHeight` 50.
- [ ] Setujui rencana migrasi utang auth (b) dan penghapusan 2 berkas tema + entri auth*.
- [ ] Setujui daftar golden yang bergeser (c) sebagai konsekuensi global.
- [ ] Izin terpisah: ubah `pubspec.yaml` (Inter global, hapus Plus Jakarta Sans).
