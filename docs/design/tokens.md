# Token desain Laurum

Sumber tunggal nilai desain. Semua nilai di sini hidup HANYA di `lib/core/theme/`
(`AppColors`, `AppTextStyles`, `AppMonoTextStyles`, `AppSpacing`, `AppDimensions`,
`AppRadius`, `AppShadows`, `AppControlTokens`, `AppInputStyles`, `AppFieldDecoration`).
Widget tidak boleh menulis hex, ukuran font, radius, atau bayangan sendiri.

Lapisan token global disetujui 10 Nov 2026 (`docs/design/proposals/006-lapisan-token.md`).
Token global; tidak ada namespace per layar (UI-12).

## Warna (`AppColors`)

| Nama | Hex | Pemakaian |
| --- | --- | --- |
| `primary` | `#2675C9` | tombol utama, chip/tab aktif, tautan, ikon aksen |
| `primaryInk` | `#174B83` | aksen gelap, ikon di atas tint |
| `primaryTint` | `#E3EEFA` | latar badge biru, avatar inisial, banner info |
| `onPrimary` | `#FFFFFF` | teks/ikon di atas `primary` |
| `success` | `#2F7D4F` | status sukses/“Siap”, teks “Lunas” |
| `successTint` | `#E9F5EE` | latar badge sukses |
| `successInk` | `#1F6B41` | teks di atas `successTint` |
| `ink` | `#26364A` | teks utama |
| `ink2` | `#4E5F76` | teks sekunder, ikon |
| `ink3` | `#7C8DA3` | label field, teks pendukung |
| `placeholder` | `#B7C2CF` | placeholder input |
| `bg` | `#F8F9FF` | latar layar |
| `surface` | `#FFFFFF` | kartu, sheet, modal |
| `surfaceLow` | `#F4F6F8` | field pasif, bar, numpad |
| `chipIdle` | `#F4F6F8` | chip tidak aktif, skeleton, disabled |
| `border` | `#E7EDF4` | border kartu, pemisah, garis “atau” |
| `borderStrong` | `#DDE3E8` | border input, tombol netral |
| `error` | `#DC2626` | teks/border error, “Belum bayar”, aksi destruktif |
| `errorInk` | `#9B1C1C` | teks bantu error, badge dibatalkan |
| `errorTint` | `#FEF2F2` | banner dan field error |
| `warningBorder` | `#B45309` | rail/border “Perlu dicek” |
| `warningInk` | `#92400E` | teks peringatan, status DP |
| `warningTint` | `#FFFDF5` | latar callout AI dan banner peringatan |
| `slate` / `slateTint` / `slateInk` | `#475569` / `#EEF1F5` / `#334155` | badge “Menunggu jemput” dan “Selesai” |
| `blue` / `blueTint` / `blueInk` | alias `primaryInk` / `primaryTint` / `primary` | badge “Diproses”; alias sementara sampai lapisan molekul membersihkan pemakai |
| `scrim` | `#131B2E` alfa 40% (`0x66131B2E`) | latar modal dan sheet |
| `appBarBg` | `#F8F9FF` alfa 85% (`0xD9F8F9FF`) | latar app bar |
| `receiptInk` | `#000000` | hanya `ReceiptPreview` |
| `brightAccent` | `#A0F5BE` | dekorasi lama, dipertahankan |
| `heroGradientStart` / `heroGradientEnd` | `#2E7FD8` / `#1B5FA3` | gradient hero (Masuk/Daftar) |
| `heroTagline` | `#DCEBF9` | teks sekunder di atas hero |
| `heroBlob` / `heroBlobSoft` / `heroDot` | putih 10% / 8% / 50% | ornamen hero |
| `illustration` | `#4A90DA` | lingkaran ilustrasi hero |
| `backBorder` | `#8FBCEB` | border tombol kembali di hero |
| `brandGoogleBlue` / `brandGoogleBorder` | `#4285F4` / `#E3E9F0` | merek Google (aset SVG) |

**Dihapus, jangan dipakai:** seluruh `AppColors.auth*`, `#00653B` sebagai primer,
`#2A7F52`, `#01653B`, `#3F4941`, `#4B5563`, `#8F3E49`.

### Pemetaan status

| Elemen | Gaya |
| --- | --- |
| Badge Diproses | latar `blueTint`, teks `blueInk` (alias ke palette primer) |
| Badge Siap | latar `successTint`, teks `success` |
| Badge Menunggu jemput, Selesai | latar `slateTint`, teks `slateInk` |
| Badge Dibatalkan | latar `errorTint`, teks `errorInk` |
| Status bayar (teks, tanpa pil) | Lunas `success`, Belum bayar `error`, DP `warningInk` (12/16 w600) |
| Rail kartu | `warningBorder` (perlu dicek) atau `error` (usulan batal), lebar 4 |

## Tipografi (`AppTextStyles`, Inter)

Font global **Inter** (`assets/fonts/Inter-Regular.otf`, `Inter-SemiBold.otf`,
`Inter-Bold.otf`; bobot 400/600/700). Plus Jakarta Sans dihapus dari aset.
Nilai `height` Flutter = tinggi baris / ukuran font.

| Nama | Ukuran/tinggi | Bobot | Catatan |
| --- | --- | --- | --- |
| `hero` | 28/34 | 700 | judul hero auth |
| `brand` | 16/20 | 700 | merek di hero |
| `brandSub` | 11/14 | 600 | tagline merek |
| `titleRoot` | 24/32 | 700 | judul layar, letter-spacing -0.6 |
| `titleSub` | 18/24 | 600 | judul app bar sub |
| `section` | 16/22 | 600 | judul section |
| `figure` | 24/32 | 700 | angka ringkasan besar |
| `body` | 14/20 | 400 | |
| `bodyStrong` | 14/20 | 600 | |
| `input` | 14/20 | 400 | nilai input |
| `label` | 12/16 | 600 | label, link, badge |
| `caption` | 12/16 | 400 | |
| `meta` | 11/15 | 400 | “atau”, trust, teks bantu |
| `micro` | 11/15 | 600 | chip fitur |
| `cta` | 15/20 | 600 | teks tombol utama |
| `numpad` | 18/24 | 700 | |

Ukuran minimum teks 11. **IBM Plex Mono** (`AppMonoTextStyles.label` 12/16,
`.receipt` 11/16) HANYA untuk nomor nota (`A-0143`), jam di kartu order, label sumbu
grafik, dan struk.

## Radius (`AppRadius`)

| Token | Nilai |
| --- | --- |
| `action`, `input`/`field`, `buttonSmall`, `bar`, `logo` | 12 |
| `card` | 16 |
| `cardLarge` | 24 |
| `cta`, `secondary` | 14 |
| `hero` | sudut bawah 32 |
| `chip`, `badge` | pil (999) |
| `sheet` | atas 28 |
| `numpad` | 12 |
| `modal` | 16 |

`auth*` (authCard/authField/authBar/authLogo/authEye/authHero) dihapus.

## Bayangan (`AppShadows`)

| Nama | Nilai | Pemakaian |
| --- | --- | --- |
| `appBar` | `0 1 7 #131B2E0A` | app bar |
| `stepper` | `0 1 1.75 #0000000D` | stepper |
| `footer` | `0 -4 14 #131B2E14` | footer sticky |
| `modal` | tanpa bayangan | modal/sheet |
| `cardElevated` | `0 14 32 #174B83@12.5%` | kartu auth |
| `raised` | `0 3 10 #174B83@5%` | tombol Google/sekunder terangkat |

## Spacing dan dimensi

`AppSpacing`: `xxsmall` 4, `xsmall` 6, `small` 8, `smallMedium` 10, `medium` 12,
`mediumLarge` 14, `large` 16, `largeX` 18, `xlarge` 24, `xxlarge` 32.
Alias lama: `screenPadding`=16, `cardGap`=12, `cardPadding`=16, `appBarHeight`=64,
`minTouchTarget`=44, `touchTarget`=48, `railWidth`=4.

`AppDimensions`: `iconTiny` 12, `iconSmall` 16, `iconBack` 18, `iconAction` 20,
`icon` 24, `iconLarge` 44, `line` 1, `fieldHeight` 48, `barHeight` 46,
`backButton` 36, `navCreateSize` 56.

`AppControlTokens`: `buttonLarge` 50 (`ctaHeight`), `buttonMedium` 44,
`buttonSmall` 40, `iconGap` 8, `avatarSize` 40, switch 28/24/2, disabled opacity 0.5.

Tombol (`AppButton`): ukuran 50/44/40; default `cta` 50, varian lain 44. Radius 14
untuk `cta`/`secondary`/`neutralOutline`, 12 untuk varian lain. Ikon dalam tombol 16
(Google 24). `neutralOutline` = putih, border `borderStrong`, teks `ink`, shadow
`raised`.

Tombol ikon (`AppIconButton`): `plain` 48 polos; `hero` area 44 dengan lingkaran 36
`illustration` + border `backBorder`, ikon putih 18.

Field form (`AppFieldDecoration` + `AppInputStyles.field`): tinggi 48, radius 12,
padding kiri 0/kanan 10/atas-bawah 13, ikon kiri 41, slot kanan 38, border
`borderStrong`, fokus `primary`, error `error` + `errorTint`.

Kartu memakai border `border`, bukan bayangan (kecuali kartu auth `cardElevated`).
`AppCard(style: AppCardStyle.elevated)` = radius 24, tanpa border, shadow
`cardElevated`.

## Format penulisan (`Formatters`)

| Jenis | Format | Contoh |
| --- | --- | --- |
| Rupiah | titik ribuan, tanpa spasi; negatif `-Rp` | `Rp31.500`, `-Rp50.000` |
| Berat | koma desimal | `3,5 kg` |
| Jumlah | | `1 pcs` |
| Tanggal | | `Jumat, 16 Okt 2026`; ringkas `16 Okt` |
| Jam di UI | titik, akhiran WIB | `10.15 WIB` |
| Jam di struk | titik dua, tanpa WIB | `10:45` |
| Telepon | | `0813-7788-1122` |
| Nomor nota | | `A-0143` |
| Teks tombol dan judul | sentence case | `Simpan dan cetak` |

Uang disimpan `int` rupiah dan berat `int` gram. Tidak ada `double` untuk uang.

## Riwayat lapisan token (10 Nov 2026)

- Primer hijau `#00653B` → biru `#2675C9`; hijau lama menjadi `success`.
- Plus Jakarta Sans → Inter; skala auth menjadi dasar global (minimum 11).
- Input 16/24 → 14/20; CTA 16/22 w700 → 15/20 w600; radius input/aksi 8 → 12;
  tinggi tombol CTA 56 → 50 dengan tiga ukuran 50/44/40.
- Token auth (`AppAuthTextStyles`, `AppFieldStyles`, `AppColors.auth*`,
  `AppRadius.auth*`, `AppShadows.auth*`) dimigrasikan ke token global dan dihapus.
- Golden seluruh komponen/layar bergeser karena perubahan global; daftar lengkap di
  proposal 006 bagian (c) dan laporan lapisan 1.
