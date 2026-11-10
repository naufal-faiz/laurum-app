# 011 - Lapisan 6 (UI-29): Perapian Section auth

**Status:** usulan, menunggu persetujuan pengguna (aturan 2: komponen bersama baru).
Prasyarat: lapisan 1-5 selesai (`b7a9292`, `9b3905e`, `3159e7f`, `686bb40`,
`a6c5fce`). Perilaku, state, data, rute, dan `Key` tidak berubah (UI-8, UI-11).

## Temuan (UI-24)

Section layar 29/31 masih membuat dekorasi sendiri:

| Berkas | Primitif | Isi |
| --- | --- | --- |
| `sign_in_brand_section.dart` | `DecoratedBox` + `BoxDecoration` + `Stack`/`Positioned` | kotak logo putih 38, radius 12 |
| `sign_in_illustration_section.dart` | `DecoratedBox` + `BoxDecoration` | kotak ilustrasi 118, radius 16, ikon 44 |
| `sign_in_feature_bar_section.dart` | `Container` + `BoxDecoration` | strip 46, latar `surfaceLow`, radius 16, 3 ikon + label |
| `auth_trust_section.dart` | `Row` + `Text` bergaya `meta`, ikon 14 | baris "data aman & terenkripsi" |

Tidak ada lagi `Material`, `InkWell`, `GestureDetector`, `ColorFiltered`, atau
`showModalBottomSheet` di Section auth.

## Komponen baru (registry: molecules)

### 1. `IconTile` — `lib/shared/widgets/molecules/icon_tile.dart`

```dart
IconTile({required AppIcons icon, required double size, required double iconSize,
          Color background = AppColors.surface, Color foreground = AppColors.primary,
          BorderRadius radius = AppRadius.chip})
IconTile.logo()          // 38, ikon 18, radius logo, putih + primary (Masuk)
IconTile.illustration()  // 118, ikon 44, radius chip, illustration + surface (Masuk)
```

Kotak ikon dekoratif: `DecoratedBox` + `SizedBox` + `Center` + `AppIcon` di dalam
molekul. Preset menaruh angka 38/18/118/44 di molekul, bukan di Section (UI-26).

### 2. `BrandLockup` — `lib/shared/widgets/molecules/brand_lockup.dart`

```dart
BrandLockup({required String name, required String tagline})
```

`Row[IconTile.logo(), gap 10, Column(name `AppTextStyles.brand`, tagline
`AppTextStyles.brandSub`)]`. Menggantikan logo + dua teks di satu tempat; teks
memakai token global, warna `surface`/`heroTagline` seperti sekarang.

### 3. `FeatureStrip` — `lib/shared/widgets/molecules/feature_strip.dart`

```dart
FeatureStrip({required List<({AppIcons icon, String label})> items})
```

Strip statis tinggi `AppDimensions.barHeight` (46), padding horizontal
`AppSpacing.mediumLarge`, latar `surfaceLow`, radius `AppRadius.bar`; setiap item
`Expanded[AppIcon 13, gap 6, Text 11/600]` dengan ellipsis. Tanpa aksi/state.

### 4. `TrustNote` — `lib/shared/widgets/molecules/trust_note.dart`

```dart
TrustNote({required String text})
```

Baris tengah: ikon `privacy` 14 `ink3` + teks `meta` `ink3`. Dipakai Section trust
auth (Masuk, Daftar, dan layar auth lain yang memakai Section yang sama).

## Perubahan `AuthHero` (organisme lapisan 4)

Slot brand dan ilustrasi diposisikan oleh hero, bukan oleh Section:

```dart
AuthHero({… , Widget? brand, Widget? illustration, VoidCallback? onBack})
```

- `brand` (varian tinggi) di `left: 24, top: 58` (bukan `Positioned.fill`).
- `illustration` (varian tinggi) di `right: 28, top: 150`.
- Geometri hero tetap milik organisme; Section tidak lagi memakai `Stack`.

## Section yang diubah

| Section | Sesudah |
| --- | --- |
| `SignInBrandSection` | `BrandLockup(name: 'LAURUM', tagline: 'LAUNDRY MANAGEMENT')` |
| `SignInIllustrationSection` | `IconTile.illustration()` |
| `SignInFeatureBarSection` | `FeatureStrip(items: [3 entri yang sama])` |
| `AuthTrustSection` | `TrustNote(text: text)` |
| `SignInHeroSection` | meneruskan `illustration: SignInIllustrationSection()` lagi |

Tidak berubah: label/teks, urutan, `Key`, callback, jumlah widget yang dicari tes.

## Dampak visual

- Diharapkan **tidak ada** golden lama yang bergeser; semua ukuran, warna, jarak,
  dan gaya teks dipertahankan (38/18/118/44/46/13/14/10/6 px, token yang sama).
- Golden baru per molekul: `icon_tile`, `brand_lockup`, `feature_strip`,
  `trust_note`. Bila ada selisih 1 px, dilaporkan sebelum commit.

## Tes

- Tes widget + galeri untuk 4 molekul baru.
- `test/auth_scaffold_test.dart` dan tes perilaku auth tidak diubah; tes visual
  layar 29/31 harus tetap lulus tanpa update golden.
- `check_all` hijau dengan bukti keluaran; zona beku tidak boleh tersentuh.

## Ditunda

- T&C Daftar (proposal 004).
- Migrasi Section auth lain di luar layar 29/31 (Cek Email, Lupa Password, OTP,
  Password Baru) menunggu frame per layar; komponen di atas dipakai ulang saat itu.
- Aturan mesin UI-24/UI-26 di `tool/check_arch.dart` (tool beku) menyusul setelah
  seluruh auth bersih.
