# 002 - Token Gradient Hero Auth (Masuk & Daftar)

**Izin pengguna:** 9 Nov 2026 (redesign branch, UI-12)

## Masalah

Figma hero zone (Masuk, Daftar) pakai gradient linear diagonal biru:
- Start: `#2E7BD9` (biru cerah)
- End: `#1B5FA3` (biru gelap)
- Arah: ~45° (top-left to bottom-right)

Token warna sekarang hanya solid. Tidak ada `authGradient` atau `heroGradient` di `AppColors`.

## Solusi

Tambah ke `lib/core/theme/app_colors.dart`:
- `authHeroGradient` → `LinearGradient(colors: [Color(0xFF2E7BD9), Color(0xFF1B5FA3)], ...)`

Atau: constant `authGradientStart` + `authGradientEnd` (warna saja), buat gradient di widget.

## Dampak

- Masuk + Daftar hero zone
- Proposal 003 (shadow) akan tertaut

## Persetujuan

- [ ] Gradient warna & arah OK
- [ ] Pilih: LinearGradient const di theme vs colors saja
