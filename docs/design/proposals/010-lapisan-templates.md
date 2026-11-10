# 010 - Lapisan 5: Templates

**Status:** usulan, menunggu persetujuan pengguna (gerbang UI-21). Prasyarat:
lapisan 1-4 selesai (`b7a9292`, `9b3905e`, `3159e7f`, `686bb40`), pergeseran
golden lapisan 4 disetujui pengguna 10 Nov 2026.

## Lingkup lapisan ini

Hanya `AuthScaffold` yang berubah. Halaman `SignInPage` dan `SignUpPage` masih
memakai `Scaffold + Stack + SingleChildScrollView` langsung di Page, sehingga
melanggar UI-27. Target: kedua Page menjadi komposisi murni di atas template.

Template lain diperiksa dan **tidak diubah** pada lapisan ini:

| Template | Hasil pemeriksaan | Keputusan |
| --- | --- | --- |
| `RootScaffold` | AppBar root, sync indicator, BottomNavBar, padding bawah nav. Dipakai layar tab. | Tetap; restyle BottomNavBar menunggu frame layar (UI-4). |
| `SubScaffold` | AppBar sub + FAB + SafeArea. | Tetap; sudah sesuai pola layar anak. |
| `FormScaffold` | AppBar sub + scroll body + FooterBar dengan viewInsets. Sudah lolos tes keyboard. | Tetap. |
| `SheetScaffold` | Body scroll + footer lengket di dalam AppBottomSheet. | Tetap. |

## Masalah pada AuthScaffold sekarang

```dart
AuthScaffold({required Widget child})   // padding fromLTRB(16, 96, 16, 16)
```

- Belum punya slot hero, jadi tidak bisa menggantikan Stack di layar auth.
- Padding 16/96 berasal dari layar auth lama (hero belum ada); layar 29/31
  memakai hero 340/230 dengan kartu yang menumpuk 20-30 px.
- Tidak ada pemakai di `lib/` (hanya tes dan galeri), jadi aman diperluas.

## API baru (aditif, default lama tetap jalan)

```dart
AuthScaffold({
  required Widget child,
  super.key,
  Widget? hero,                // AuthHero; digambar di belakang isi
  double contentTop = 0,       // jarak atas isi dari tepi atas layar
  Color background = AppColors.bg,
})
```

- `hero == null` dan `contentTop == 0` → perilaku lama persis (padding 16/96/16/16,
  background `AppColors.bg`), tes dan golden `auth_scaffold` tidak berubah.
- `hero != null` → `Scaffold(background)` + `Stack[hero, scroll]`; scroll memakai
  `EdgeInsets.only(top: contentTop, bottom: AppSpacing.xxlarge)`, tanpa padding
  kiri/kanan (Page yang menaruh padding 24 pada kartu/footer, seperti sekarang).
- Isi scroll dibungkus `SafeArea(top: false)` agar home indicator iOS tidak
  menutup tombol; inset perangkat uji nol sehingga golden tidak bergeser.

## Pemakaian di Page (bagian dari lapisan ini)

`SignInPage`:

```dart
AuthScaffold(
  hero: const SignInHeroSection(),
  contentTop: 320,             // hero 340, kartu menumpuk 20
  background: AppColors.surface,
  child: Column(children: [
    Padding(horizontal 24, child: SignInFormCardSection(...)),   // argumen sama
    SizedBox(AppSpacing.xxlarge),
    Padding(horizontal 24, child: SignInFeatureBarSection()),
    SizedBox(AppSpacing.largeX),
    Padding(horizontal 24, child: AuthTrustSection()),
  ]),
)
```

`SignUpPage` sama dengan `hero: SignUpHeroSection(onBack: ...)`,
`contentTop: 200` (hero 230, tumpuk 30), kartu Daftar, lalu trust.

Yang **tidak** berubah: pembacaan provider, urutan pemanggilan notifier,
argumen callback, `Key`, teks, dan urutan widget. Hanya pembungkus Scaffold,
Stack, dan ScrollView yang pindah ke template.

## Paritas redesign

| Butir | Sebelum | Sesudah |
| --- | --- | --- |
| `authSessionProvider`, `authFormProvider` | dibaca di Page | sama |
| Callback email/password/toggle/submit/Google/lupa/daftar | langsung di Page | sama, urutan sama |
| Navigasi `/lupa-password`, `/daftar`, `/masuk`, `/cek-email` | `context.go` | sama |
| Hero Masuk/Daftar | Section di Stack | slot `hero` template |
| Kartu form + strip fitur + trust | Column di ScrollView | `child` template |
| Latar `AppColors.surface` | Page | parameter `background` |
| Offset kartu 320 / 200 | padding ScrollView | `contentTop` |
| Key dan tes keyboard 16e | ada | tidak berubah |

## Dampak visual

- Diharapkan **tidak ada** golden auth yang bergeser: geometri Stack, offset, dan
  padding dipertahankan persis. Bila ada selisih 1 px, dilaporkan sebelum commit.
- Galeri mendapat varian hero baru; golden baru `auth_scaffold_hero`. Golden
  `auth_scaffold` (varian `child` saja) tetap.
- Layar auth lain (`/cek-email`, `/lupa-password`, `/verifikasi-otp`,
  `/password-baru`) belum disentuh; hero/kartunya baru dipasang saat layarnya
  ditugaskan (UI-4).

## Tes

- `test/auth_scaffold_test.dart`: tambah tes hero tampil di belakang isi dan isi
  mulai di `contentTop`; tes lama (tanpa AppBar) tetap.
- Tes perilaku auth (`r10_*`, keyboard, aksesibilitas) tidak diubah.
- `check_all` wajib hijau dengan bukti keluaran.

## Ditunda

- Pembersihan primitif Section auth (kotak logo, strip fitur, lingkaran
  ilustrasi) → lapisan 6 / UI-29.
- Template layar tab dan form lain menunggu frame per layar (UI-4).
