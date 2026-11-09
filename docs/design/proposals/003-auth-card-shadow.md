# 003 - Token Shadow Auth Card

**Izin pengguna:** 9 Nov 2026 (redesign branch, UI-12)

## Masalah

Figma kartu masuk/daftar (342x hug, radius 24) punya bayangan:
- Warna: biru dengan opacity ~12.5% (tidak murni hitam)
- Offset/blur: halus, kesan mengambang

Saat ini `AppShadows` hanya:
- `appBar` — hitam 0x0A, offset (0,1), blur 7
- `stepper` — hitam 0x0D, offset (0,1), blur 1.75
- `footer` — hitam 0x14, offset (0,-4), blur 14

Token belum ada untuk kartu auth dengan nuansa biru.

## Solusi

Tambah ke `lib/core/theme/app_shadows.dart`:
```dart
static const authCard = [
  BoxShadow(
    color: Color(0x20134B87), // biru tua 12.5% opacity
    offset: Offset(0, 4),
    blurRadius: 12,
  ),
];
```

Alternatif: dekat existing `stepper` jika visual cukup mirip (belum ada screenshot).

## Dampak

- Masuk + Daftar kartu card
- Tertaut proposal 002 (gradient hero)

## Persetujuan

- [ ] Bayangan warna/offset/blur OK
- [ ] Pakai `authCard` atau tukar dengan existing shadow?
