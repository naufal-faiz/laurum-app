# 009 - Lapisan 4: Organisms

**Status:** disetujui pengguna 10 Nov 2026 ("disetujui"). Prasyarat: FigCraft MCP
tersambung (127.0.0.1:9876), lapisan 1-3 selesai (`b7a9292`, `9b3905e`, `3159e7f`).

## Lingkup lapisan ini

Dua organisme auth yang dipakai berulang di frame auth:

1. `AuthHero` — hero gradient 390 x `height` dengan ornamen, judul, subjudul,
   slot brand + ilustrasi (Masuk) atau tombol kembali (Daftar dan layar auth
   berikutnya).
2. `AuthCard` — kartu putih radius 24, shadow `cardElevated`, padding 18, jarak
   anak 12. Pola yang sama muncul di 5 frame auth (Masuk `4294968715`, Daftar
   `4294968764`, Lupa Password `4294968995`, Verifikasi OTP `4294969062`,
   Password Baru `4294969124`), jadi diangkat (UI-25).

Organisme lain (`BottomNavBar`, `CustomerRow`, `NotaCard`, `OrderCard`, dst.)
**ditunda**: frame layar pemakainya belum diberikan pengguna per sesi (UI-4),
dan restyle-nya butuh pembandingan frame masing-masing. Akan dikerjakan saat
frame layar itu ditugaskan, dengan proposal lapisan organisms tambahan.

## Padanan Figma (dibaca lewat MCP, read-only)

| Elemen | Node | Nilai Figma | Hasil |
| --- | --- | --- | --- |
| Hero Masuk | `4294968693` | 390x340, gradient `#2E7FD8 → #1B5FA3`, sudut bawah 32, ornamen 210 di (236,-80), 120 di (300,120), 3 dot 4 px di (250,96)/(266,112)/(284,130), brand di (24,58), judul (24,140), sub (24,174), ilustrasi 118 di (244,150) | `AuthHero(height: 340, brand: …, illustration: …)` |
| Hero Daftar | `4294968749` | 390x230, ornamen 210 di (250,-90), 110 di (320,120), kembali 36 di (24,56), judul (24,110), sub (24,144) | `AuthHero(height: 230, backLabel: 'Kembali', onBack: …)` |
| Kartu Masuk | `4294968715` | 342, radius 24, padding 18, gap 12, shadow `0 14 32 #174B83@12.5%` | `AuthCard` |
| Kartu Daftar | `4294968764` | 342, radius 24, padding 18, gap 12 | `AuthCard` |

## Perubahan API (aditif)

```dart
AuthHero({
  required double height,
  required String title,
  required String subtitle,
  Widget? brand,          // non-null = layout tinggi (Masuk); slot memuat logo,
                          // nama, tagline, dan ilustrasi
  VoidCallback? onBack,   // tombol kembali berlabel 'Kembali' (tooltip)
})

AuthCard({required List<Widget> children})
```

- `AuthHero` memilih ornamen/posisi judul dari ada tidaknya `brand`; tinggi tetap
  parameter (340 / 230, nanti 240-280 untuk layar auth lain). Ilustrasi ikut di
  dalam slot `brand` supaya organisme tidak menebak isi merek.
- Tombol kembali memakai `AppIconButton.hero` (lingkaran 36, area 44). Lingkaran
  diletakkan di y=56 sesuai Figma (kotak sentuh 44 digeser 4 px ke atas).
- `AuthCard` membungkus `AppCard.elevated` + `Column(spacing: 12)`. Isi tetap
  dikirim Section lewat `children`; tidak ada state.

## Pemakaian di layar (bagian dari lapisan ini)

- `SignInHeroSection` → `AuthHero` (brand `SignInBrandSection`, yang kini juga
  memuat ilustrasi baju); `SignInBrandSection` hanya logo + nama + tagline
  (judul/sub pindah ke organisme).
- `SignUpHeroSection` → `AuthHero` (tombol kembali).
- `SignInFormCardSection`, `SignUpFormCardSection` → `AuthCard(children: […])`.
  Urutan, data, callback, dan `Key` tidak berubah.
- Registry: `AuthHero`, `AuthCard` masuk daftar organisms.

## Dampak visual

- Ornamen, judul, dan sub hero memakai posisi Figma persis; sub Masuk 178 → 174,
  sub Daftar 148 → 144, lingkaran kembali 4 px lebih tinggi (56).
- Kartu auth memakai satu sumber (`AuthCard`), tampilan sama (radius 24, padding
  18, gap 12).
- Golden layar auth 29/31 dan `auth_scaffold` bergeser; daftar lengkap dilaporkan
  di `docs/progress/STATE.md` (UI-28).

## Tes

- `test/auth_hero_test.dart`: brand + judul + sub tampil, tombol kembali memicu
  callback, ornamen tidak overflow; golden `auth_hero` (dua varian).
- `test/auth_card_test.dart`: anak tersusun dengan gap 12 dan padding 18; golden
  `auth_card`.
- Tes perilaku auth lama (`r10_*`, keyboard, aksesibilitas) tidak diubah.

## Ditunda

- Organisme lain: menunggu frame per layar (UI-4).
- Strip fitur, kotak logo, dan lingkaran ilustrasi masih Section dengan
  `Container`/`DecoratedBox` dekoratif; padanan registry-nya (mis. tile ikon dan
  strip fitur) diusulkan saat lapisan 6 (UI-29) karena belum ada di registry.
- Template `AuthScaffold` (slot hero/kartu) → lapisan 5.

## Hasil penerapan (10 Nov 2026)

- `lib/shared/widgets/organisms/auth_hero.dart`: gradient + dua ornamen + 3 dot
  (varian tinggi), judul/subjudul, slot `brand` (dengan ilustrasi di dalamnya),
  tombol kembali `AppIconButton.hero` di x=24 (lingkaran y=56). 108 baris.
- `lib/shared/widgets/organisms/auth_card.dart`: `AppCard.elevated` + padding 18
  + `Column(spacing: 12)`.
- `SignInHeroSection`/`SignUpHeroSection` kini hanya menyusun `AuthHero`;
  `SignInBrandSection` menyimpan logo/brand/tagline + ilustrasi (judul dan sub
  pindah ke organisme). `SignInIllustrationSection` tetap dipakai dari brand.
- Kedua kartu form memakai `AuthCard`; urutan, data, callback, dan `Key` sama.
- Registry dan katalog komponen diperbarui; galeri widgetbook dan golden baru.
- Figma dibaca lewat MCP (hero `4294968693`/`4294968749`, kartu
  `4294968715`/`4294968764`, kembali `4294968760`); tidak ada node yang diubah.
- Golden bergeser: 7 lama (`auth_signin`, `auth_signin_error`, `r10_signin`,
  `r10_signin_error`, `r10_signin_error_320_2x`, `r10_signup`,
  `r10_signup_320_2x`) + 2 baru (`auth_hero`, `auth_card`). Alasan: posisi
  ornamen/judul/sub sesuai Figma, kotak sentuh kembali 4 px lebih tinggi, kartu
  auth lewat satu komponen.
- Tes baru: `test/auth_hero_test.dart`, `test/auth_card_test.dart`. Tes perilaku
  lama tidak diubah.
- Verifikasi: `dart analyze` bersih, `check_arch` OK, 985 tes lulus (1 skip),
  `check_all` hijau.
