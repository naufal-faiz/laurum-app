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
