# Token desain Laurum

Sumber tunggal nilai desain. Semua nilai di sini hidup HANYA di `lib/core/theme/` (`AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadius`, `AppShadows`). Widget tidak boleh menulis hex, ukuran font, radius, atau bayangan sendiri (dicek `tool/check_arch.dart`).

## Warna (`AppColors`)

| Nama | Hex | Pemakaian |
| --- | --- | --- |
| `primary` | `#00653B` | tombol utama, chip aktif, tab aktif, avatar, ikon aksen, tautan |
| `onPrimary` | `#FFFFFF` | teks/ikon di atas `primary` |
| `primaryTint` | `#E1F3E8` | latar badge hijau, avatar inisial, lingkaran ikon, banner info |
| `brightAccent` | `#A0F5BE` | dekorasi, hanya di tempat yang sudah memakainya di desain |
| `ink` | `#131B2E` | teks utama |
| `ink2` | `#3E4947` | teks sekunder, ikon |
| `ink3` | `#6E7977` | teks pendukung (misalnya usia piutang "4 hari lalu") |
| `placeholder` | `#3E4947` alfa 60% (`0x993E4947`) | placeholder input |
| `bg` | `#F8F9FF` | latar layar |
| `surface` | `#FFFFFF` | kartu, sheet, modal |
| `surfaceLow` | `#F2F3FF` | tombol numpad |
| `chipIdle` | `#EFF4FF` | chip tidak aktif, skeleton |
| `border` | `#E5E7EB` | border kartu, pemisah |
| `borderStrong` | `#D1D5DB` | border input, tombol netral |
| `error` | `#DC2626` | teks/border error, "Belum bayar", tombol destruktif |
| `errorInk` | `#9B1C1C` | teks bantu error, badge dibatalkan |
| `errorTint` | `#FEF2F2` | hanya banner dan field error |
| `warningBorder` | `#B45309` | rail dan border "Perlu dicek" |
| `warningInk` | `#92400E` | teks peringatan, status DP |
| `warningTint` | `#FFFDF5` | latar callout AI dan banner peringatan |
| `blue` / `blueTint` / `blueInk` | `#1D5FA8` / `#E3EEFA` / `#174A85` | hanya badge "Diproses" |
| `slate` / `slateTint` / `slateInk` | `#475569` / `#EEF1F5` / `#334155` | badge "Menunggu jemput" dan "Selesai" |
| `scrim` | `#131B2E` alfa 40% (`0x66131B2E`) | latar modal dan sheet |
| `appBarBg` | `#F8F9FF` alfa 85% (`0xD9F8F9FF`) | latar app bar |
| `receiptInk` | `#000000` | hanya di `ReceiptPreview` |

**Dihapus, jangan dipakai:** `#2A7F52`, `#01653B` (diganti `primary`), `#3F4941`, `#4B5563` (diganti `ink2`), `#8F3E49` (diganti `errorInk`).

### Pemetaan status

| Elemen | Gaya |
| --- | --- |
| Badge Diproses | latar `blueTint`, teks `blueInk` |
| Badge Siap | latar `primaryTint`, teks `primary` |
| Badge Menunggu jemput, Selesai | latar `slateTint`, teks `slateInk` |
| Badge Dibatalkan | latar `errorTint`, teks `errorInk` |
| Status bayar (teks, tanpa pil) | Lunas `primary`, Belum bayar `error`, DP `warningInk` (12/16 w600) |
| Rail kartu | `warningBorder` (perlu dicek) atau `error` (usulan batal), lebar 4 |

## Gradien (`AppColors` + Dart `LinearGradient`)

| Nama | Nilai | Pemakaian |
| --- | --- | --- |
| `authHeroGradient` | Linear top-left→bottom-right: start `#2E7FD8`, end `#1B5FA3` | Hero zone Masuk & Daftar |

## Warna auth (frame `LAURUM · Masuk` / `· Daftar`)

| Nama | Hex | Pemakaian |
| --- | --- | --- |
| `authPrimary` | `#2675C9` | tombol Masuk, link "Lupa password?"/"Daftar", ikon fitur bar |
| `authPrimaryInk` | `#174B83` | ikon mata dalam field |
| `authInk` | `#26364A` | teks tombol Google dan label fitur bar |
| `authLabel` | `#7C8DA3` | label field, "atau", trust bar |
| `authPlaceholder` | `#B7C2CF` | placeholder field auth |
| `authFieldBorder` | `#DDE3E8` | border field 48 dp dan tombol Google |
| `authDivider` | `#E7EDF4` | garis pemisah "atau" |
| `authChipBg` | `#F4F6F8` | tombol mata, fitur bar |
| `authEyeBorder` | `#E9EEF4` | border tombol mata |
| `authIllustration` | `#4A90DA` | lingkaran ilustrasi hero |
| `authHeroTagline` | `#DCEBF9` | tagline hero |
| `authHeroBlob` / `authHeroBlobSoft` / `authHeroDot` | putih 10% / 8% / 50% | ornamen hero |
| `authGoogleBlue` / `authGoogleBorder` | `#4285F4` / `#E3E9F0` | huruf G dan border kotak G |

## Tipografi auth (`AppAuthTextStyles`, Inter)

Domain font `Inter` (`assets/fonts/Inter-Regular.otf`, `Inter-SemiBold.otf`,
`Inter-Bold.otf`; bobot 400/600/700). Revisi UX 9 Nov 2026: ukuran dinaikkan dari
nilai frame agar ramah dibaca, hierarki tetap.
Token: `heroTitle` 28/700, `heroBrand` 16/700, `heroBrandSub` 9/600, `heroSub` 13/400,
`label` 12/600, `input` 14/400, `button` 15/600, `body` 12/400, `bodyStrong` 12/600,
`meta` 11/400, `google` 14/600, `chip` 10.5/600.

## Bayangan (`AppShadows`)

| Nama | Warna/Offset/Blur | Pemakaian |
| --- | --- | --- |
| `authCard` | `#174B83` 12.5%, offset (0,14), blur 32 | Kartu Masuk & Daftar |
| `authGoogle` | `#174B83` 5%, offset (0,3), blur 10 | Tombol Google |

## Radius auth (`AppRadius`)

`authCard` 24, `authField` 12, `authBar` 12, `authLogo` 12, `authEye` 9,
`authHero` sudut bawah 32.

## Tipografi (`AppTextStyles`; Plus Jakarta Sans)

Nilai `height` Flutter = tinggi baris / ukuran font.

| Nama | Ukuran/tinggi baris | Bobot | Catatan |
| --- | --- | --- | --- |
| `titleRoot` | 24/32 | 700 | letter-spacing -0.6 |
| `titleSub` | 18/24 | 600 | judul app bar sub |
| `section` | 16/22 | 600 | judul section |
| `figure` | 24/32 | 700 | angka ringkasan besar |
| `body` | 14/20 | 400 | |
| `bodyStrong` | 14/20 | 600 | |
| `input` | 16/24 | 400 | nilai input |
| `label` | 12/16 | 600 | chip, badge, label kecil |
| `caption` | 12/16 | 400 | |
| `cta` | 16/22 | 700 | teks tombol CTA |

**IBM Plex Mono** (`AppTextStyles.mono*`) HANYA untuk nomor nota (`A-0143`), jam di kartu order, label sumbu grafik, dan struk (11/16).

## Bentuk

| Token | Nilai |
| --- | --- |
| Padding layar / jarak kartu / padding kartu | 16 / 12 / 16 |
| Tinggi app bar | 64 |
| Area sentuh | minimal 44, baku 48 |
| Radius | kartu 16, tombol aksi 8, CTA dan secondary 14, input 8, chip dan badge pil (999), sheet atas 28, numpad 12, modal 16 |
| Bayangan | app bar `0 1 7 #131B2E0A`; stepper `0 1 1.75 #0000000D`; footer sticky `0 -4 14 #131B2E14` (frame Footer - Sticky Bottom Bar Menempel); modal tanpa bayangan (semua frame C/Modal pada State tidak memiliki effect) |

Kartu memakai border `border`, bukan bayangan.

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

## Token dasar tambahan Fase 1 (izin pengguna, 22 Oktober 2026)

- AppDimensions.iconSmall = 16 (ikon D4sARD/Gembok).
- AppDimensions.iconAction = 20 (ikon sW6dC pada Antrean).
- AppDimensions.icon = 24 (ikon navigasi qN76G).
- AppDimensions.line = 1 (stroke kartu i1jkP/JrA3v dan separator plTzD).
- AppBorders.card: border AppColors.border, satu logical pixel, tanpa bayangan.

Nilai lama tidak diubah. Beberapa label mono di .pen memakai w600; monoLabel
proyek tetap w400. Separator plTzD memakai chipIdle; AppDivider generik memakai
border sesuai aturan pemisah di dokumen ini. Selisih dicatat di component_catalog.md.

## Token kontrol Fase 1 (tambahan yang diperlukan, izin pengguna)
- AppControlTokens: CTA 56 (B4bt3y); padding horizontal 12 dan gap ikon 8 (h8n1Hk).
- Badge padding 2 vertikal / 10 horizontal (s9ip1); avatar 40 (SlEQS).
- Switch: track tinggi 28, thumb 24, inset 2 (ZOUFH/qcTo3); lebar/area 48 memakai touchTarget.
- AppButtonStyles memakai radius/warna lama dan border default Flutter 1 logical pixel
  (sama dengan AppDimensions.line). Tidak ada token lama yang diubah.
- Disabled: foreground ink3, latar chipIdle, border border; switch opacity 0.5.
  Nilai opacity ini keputusan implementasi yang belum memiliki referensi disabled terverifikasi.
- CTA/secondary tetap memakai cta w700 sesuai PRD meskipun frame memakai w600.

## Token input dan numpad Fase 1 (tambahan yang diperlukan, izin pengguna)
- AppTextStyles.numpad: Plus Jakarta Sans 18/24 w700 (f0G1R/TU6VH),
  melalui AppTextVariant.numpad. Token sebelumnya tetap.
- AppInputStyles: padding field 12, padding ikon kiri 12/kanan 8, tinggi minimum 48;
  borderStrong normal, primary fokus, error/errorInk + errorTint untuk error.
- Skeleton lebar contoh 96/192, tinggi default 20 (Q1YznQ/e48H25/dStCL).
- Numpad tinggi 56, radius numpad 12, surfaceLow; skeleton radius input 8, chipIdle.
- Default field 48 mengikuti area sentuh baku, berbeda dari frame input 44.
- State focus/disabled/error field mengikuti token; referensi screenshot khusus belum terverifikasi.
