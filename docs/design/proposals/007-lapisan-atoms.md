# 007 - Lapisan 2: Atoms

**Status:** disetujui pengguna 10 Nov 2026 ("lanjutkan progressnya") dan diterapkan
pada sesi yang sama. Prasyarat: FigCraft MCP tersambung (127.0.0.1:9876).
Lapisan 1 (token) selesai di commit `b7a9292`.

## Alasan

Setelah token global selesai, beberapa atom belum bisa menyatakan desain baru:
tombol auth masih dibuat sendiri (Material + InkWell), tombol Google juga, tombol
kembali memakai GestureDetector + ColorFiltered, dan kartu auth memakai Container
dekoratif di Section. Lapisan ini memindahkan semua itu ke atom registry supaya
Section tinggal menyusun (UI-24, UI-29).

## Padanan Figma (dibaca lewat MCP, read-only)

| Elemen | Node | Nilai Figma | Token/atom hasil |
| --- | --- | --- | --- |
| Tombol utama Masuk | `4294968730` | 50 dp, radius 14, teks 11 semibold, panah 14x10, gap 8 | `AppButton` `cta` → tinggi `buttonLarge` 50, radius `cta` 14, ikon 16, gap 8 |
| Tombol Google | `4294968737` | 48 dp, radius 14, border `#DDE3E8`, shadow `0 3 10 #174B83@5%`, ikon 24 + teks 10.5 | `AppButton` `secondary` + `iconAsset: AppSvgs.google`; tinggi 50 (`buttonLarge`) sebagai pembulatan ke skala 50/44/40 |
| Field email/password | `4294968718`, `4294968725` | 48 dp, radius 12, padding 14/10, ikon 16, border `#DDE3E8` | sudah `AppTextField(dense: true)` + `AppFieldDecoration` (lapisan 1), tanpa perubahan API |
| Garis "atau" | `4294968733` | garis 1 px `#E7EDF4`, teks 8.5 | ditunda ke lapisan 3 sebagai molekul `LabeledDivider` |
| Tombol kembali Daftar | `4294968760` | lingkaran 36, isi `#4A90DA`, border `#8FBCEB`, panah putih 18 | `AppIconButton` varian `hero` (area sentuh 44, lingkaran 36) |
| Kartu Masuk/Daftar | `4294968715`, `4294968764` | radius 24, putih, shadow `0 14 32 #174B83@12.5%`, padding 18, gap 12 | `AppCard(style: elevated)` → radius `cardLarge` 24, `cardElevated`, padding 18 |

## Perubahan API (aditif, kompatibel)

### AppButton

```dart
enum AppButtonSize { large, medium, small }        // 50 / 44 / 40
enum AppButtonIconPlacement { leading, trailing }

AppButton(
  label, {
  variant = AppButtonVariant.cta,
  AppButtonSize? size,            // default: cta -> large, lainnya -> medium
  AppIcons? icon,
  String? iconAsset,
  AppButtonIconPlacement iconPlacement = leading,
  bool busy = false,              // tampil nonaktif + tidak bisa ditekan
  VoidCallback? onPressed,
})
```

- Tinggi: `buttonLarge` 50, `buttonMedium` 44, `buttonSmall` 40 (`AppControlTokens`).
- Radius: `cta`/`secondary` 14, varian lain 12 (tetap).
- Ikon dalam tombol 16 dp (`AppDimensions.iconSmall`), gap `iconGap` 8.
- `busy` hanya status tampil; tidak mengubah perilaku pemanggil.

### AppIconButton

```dart
enum AppIconButtonVariant { plain, hero }

AppIconButton({
  required label,
  AppIconButtonVariant variant = plain,
  AppIcons? icon,
  String? iconAsset,
  Color color = AppColors.primary,   // hanya dipakai varian plain
  VoidCallback? onPressed,
})
```

- `hero`: area sentuh 44, lingkaran 36 `illustration` + border `backBorder`,
  ikon putih 18. Warna `color` diabaikan agar sesuai frame.

### AppCard

```dart
enum AppCardStyle { outlined, elevated }

AppCard({required child, style = outlined, rail = none, padding = 16})
```

- `elevated`: radius 24, tanpa border, shadow `cardElevated`, padding default 16
  (pemakai auth mengirim 18).
- `outlined` (default): perilaku lama, tanpa shadow.

### AppTextField, AppDivider

- `AppTextField`: tidak ada perubahan API; slot `leadingIcon`/`trailing`/`dense`
  sudah memakai token global sejak lapisan 1.
- `AppDivider`: garis saja; label tengah menjadi molekul `LabeledDivider` di
  lapisan 3 (bukan atom).

## Pemakaian di layar (bagian dari lapisan ini)

- `AuthSubmitSection` → isi diganti `AppButton` (ikon di belakang, `busy`
  menonaktifkan). API Section tetap; tes perilaku tetap.
- `SignInSection` (tombol Google) → `AppButton.secondary` + `AppSvgs.google`,
  banner error dan teks status tetap.
- `SignInFormCardSection`, `SignUpFormCardSection` → `AppCard(style: elevated,
  padding: 18)` menggantikan Container dekoratif.
- `SignUpHeroSection` → tombol kembali memakai `AppIconButton(variant: hero)`;
  `assets/icons/cursor-back.svg` diubah ke `currentColor` supaya bisa diwarnai
  putih lewat `AppSvg` (ColorFiltered di Section dihapus).
- Layar lain: tombol `action`, `actionOutline`, `destructive*` ikut turun dari 48
  ke 44 (keputusan 4) dan ikon 20 → 16.

## Dampak visual

- Tombol non-CTA 48 → 44 di seluruh aplikasi (semua layar), ikon tombol 20 → 16.
- Tombol Google auth 48 → 50; kartu auth pindah dari Container ke `AppCard`
  (tampilan sama: radius 24, shadow, padding 18).
- Golden atom + seluruh golden layar yang memuat tombol/kartu bergeser;
  daftar dilaporkan di STATE (UI-28).

## Tes

- `test/app_button_test.dart`: tinggi per varian/ukuran, ikon di belakang,
  `busy` tidak memicu aksi.
- `test/app_icon_button_test.dart`: varian `hero` (lingkaran 36, area 44, ikon
  putih) tanpa mengubah kontrak varian `plain`.
- `test/app_card_test.dart`: varian `elevated` (radius 24, shadow, tanpa border)
  tanpa mengubah kontrak varian `outlined`.
- Tes perilaku auth (`r10_*`, `auth_*`, keyboard) tidak diubah.

## Ditunda ke lapisan berikutnya

- Tombol mata password (28) dan tautan "Belum punya akun?/Sudah punya akun?"
  masih memakai `GestureDetector` di Section. Tombol mata menjadi varian
  `AppIconButton` (lapisan 3, bersama `InlineLinkRow` untuk tautan) agar Section
  auth bebas primitif pada UI-29.

## Hasil penerapan (10 Nov 2026)

- `app_button_styles.dart`: enum `AppButtonSize`, peta tinggi 50/44/40, varian
  `neutralOutline` (border `borderStrong`, teks `ink`, elevation 3 dengan
  `AppShadows.raised`).
- `app_button.dart`: `size`, `iconPlacement`, `iconSize`, `busy`, ikon 16.
- `app_icon_button.dart`: varian `hero` (area 44, lingkaran 36, ikon putih 18);
  `AppDimensions.iconBack` 18 ditambahkan.
- `app_card.dart`: `AppCardStyle.elevated` (radius 24, shadow `cardElevated`, tanpa
  border) tanpa mengubah varian `outlined` dan rail.
- Auth: `AuthSubmitSection`, `SignInSection`, kedua kartu form, dan
  `SignUpHeroSection` memakai atom di atas; `cursor-back.svg` menjadi
  `currentColor`.
- Figma dibaca lewat MCP (node `4294968730`, `4294968737`, `4294968760`,
  `4294968764`); tidak ada node yang diubah.
- Verifikasi: `dart analyze` bersih, `check_arch` OK, 202 tes gallery/golden lulus
  setelah golden diperbarui, seluruh 972 tes lulus, `check_all` hijau.
- Golden bergeser: 73 dari 113 (daftar di `docs/progress/STATE.md`).
