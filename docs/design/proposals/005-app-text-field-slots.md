# 005 - AppTextField: parameter `leadingIcon`, `trailing`, `dense`

**Status:** diterapkan sementara untuk redesign 29-masuk-google; menunggu persetujuan
pengguna (aturan 13 / UI-13: perubahan API widget registry).

## Alasan

Frame `LAURUM · Masuk` memakai field 48 dp dengan ikon di dalam field (envelope,
gembok, tombol mata) dan placeholder kecil (10.5). `AppTextField` lama tidak punya
slot ikon/trailing dan memakai gaya input 16.

## Perubahan API (aditif, kompatibel)

```dart
AppTextField(
  ...,
  AppIcons? leadingIcon,  // ikon kiri 16 dp di dalam field
  Widget? trailing,       // slot kanan (mis. tombol mata 28x28)
  bool dense = false,     // gaya auth: radius 12, border #DDE3E8, tinggi 48,
                          // padding 14/10, teks 10.5/13, warning scrollPadding 240
)
```

- Default `dense = false` → tampilan field lama tidak berubah.
- Token baru di `lib/core/theme/app_field_styles.dart` (`AppFieldStyles`).
- `scrollPadding` 240 saat `dense` agar field fokus + tombol simpan tetap
  terlihat di keyboard 300 dp (aturan 16e).

## Dampak

Hanya layar yang memakai `dense: true` (29-masuk-google; 31-daftar menyusul).
Semua pemakaian lama tetap identik.

## Persetujuan

- [ ] Setujui penambahan 3 parameter opsional ini ke `AppTextField`
