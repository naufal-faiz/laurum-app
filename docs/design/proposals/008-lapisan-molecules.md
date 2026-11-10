# 008 - Lapisan 3: Molecules

**Status:** disetujui pengguna 10 Nov 2026 ("diizinkan, lanjutkan progressnya").
Prasyarat: FigCraft MCP tersambung (127.0.0.1:9876); lapisan 1 (token, `b7a9292`)
dan lapisan 2 (atoms, `9b3905e`) selesai.

## Alasan

Masih ada tiga molekul yang dibuat ulang di dalam Section auth dengan primitif
terlarang (UI-24): pemisah "atau" (`AuthOrSection`), dua tautan "Belum/Sudah punya
akun" (`SignInSignupLinkSection`, `SignUpSigninLinkSection`), dan tombol mata
password (`GestureDetector`). Ketiganya adalah pola molekul, bukan potongan satu
layar: tautan muncul di dua layar, pemisah dipakai dua kartu, tombol mata dipakai
tiga field auth. Lapisan ini mengangkatnya menjadi molekul registry supaya lapisan
6 (UI-29) tinggal menyusun.

Selain itu label `LabeledField` (36 pemakai) masih 14/600 `ink`, sedangkan label
form di Figma 9.5/600 `#174B83` (dipetakan ke 12/600 `primaryInk` sesuai keputusan
skala minimum 11).

## Padanan Figma (dibaca lewat MCP, read-only)

| Elemen | Node | Nilai Figma | Token/molekul hasil |
| --- | --- | --- | --- |
| Pemisah "atau" Masuk | `4294968733` (teks `4294968735`) | baris 306x14, garis 1 px `#E7EDF4`, teks 8.5 regular `#7C8DA3`, gap 10 | `LabeledDivider('atau')`: `AppDivider` + teks `caption` 12/400 `ink3`, gap `AppSpacing.smallMedium` 10 |
| Tautan "Daftar" | `4294968743` | 9 semibold `#2675C9` | `InlineLink`: `AppTextVariant.label` 12/600 `primary`, nonaktif `ink3` |
| "Belum punya akun?" | `4294968742` | 9 regular `#7C8DA3`, gap 4 ke tautan | `InlineLinkRow`: `caption` `ink3` + `InlineLink`, gap `AppMoleculeTokens.smallGap` 4 |
| "Sudah punya akun? Masuk" | `4294968801`, `4294968802` | sama dengan Masuk | `InlineLinkRow` yang sama (satu komponen berparameter) |
| "Lupa password?" | `4294968724` | 8.5 semibold `#2675C9` | `InlineLink` di baris label password |
| Tombol mata password | `4294968728` (ikon `4294968729`) | kotak 28 radius 9 `#F4F6F8`, ikon 15 `#174B83` | kotak sudah dihapus atas keputusan pengguna 9 Nov 2026; jadi `AppIconButton` varian `compact` (area 40, ikon 20, `color` `primaryInk`) |
| Label form non-auth ("Label Nama", "Label Telepon", "Label Alamat") | `1089`, `1092`, `1099` (frame Pelanggan baru `1075`) | 9.5 semibold `#174B83` | `LabeledField` label → `AppTextVariant.label` 12/600 `primaryInk` |

Label auth tetap `ink3` (`#7C8DA3`) karena frame auth memang memakai abu-abu;
hanya label form non-auth yang biru tua.

## Perubahan API (aditif, kompatibel)

### Molekul baru (2 berkas, satu widget publik per berkas)

```dart
LabeledDivider(this.label)                  // garis - label - garis
InlineLink(this.label, {VoidCallback? onTap})
InlineLinkRow({required String question, required String action, VoidCallback? onTap})
```

- `LabeledDivider`: `Row` berisi dua `AppDivider` (`Expanded`) dan teks
  `AppTextVariant.caption` (12/400) `ink3` dengan padding horizontal 10.
- `InlineLink`: `TextButton` tanpa padding/minimum (`shrinkWrap`) berisi teks
  `AppTextVariant.label`; warna `primary` saat aktif, `ink3` saat `onTap` null.
- `InlineLinkRow`: `Row` tengah, `caption` `ink3` + gap 4 + `InlineLink`; kedua
  sisi `Flexible` dengan ellipsis (perilaku lama).
- Aksesibilitas: `TextButton` membawa status tombol; teks tetap dapat dicari tes
  (`find.text('Daftar')`, `find.text('Lupa password?')`).

### AppIconButton

```dart
enum AppIconButtonVariant { plain, hero, compact }
```

- `compact`: area sentuh 40 (`AppControlTokens.buttonSmall`), ikon 20
  (`AppDimensions.iconAction`), tanpa latar, memakai `color` seperti `plain`.
  Dipakai tombol mata di dalam field (slot `trailing` `AppTextField`).
- `plain` dan `hero` tidak berubah.

### LabeledField

- Label: `bodyStrong` 14/600 `ink` → `AppTextVariant.label` 12/600
  `AppColors.primaryInk`. Helper/error, gap, dan API tidak berubah.
- `BannerMessage`: diperiksa; tidak ada banner error di frame baru, varian dan
  warna tetap. `ChipBar`: tidak dipakai frame auth, tidak berubah.

## Pemakaian di layar (bagian dari lapisan ini)

- `SignInFormCardSection`, `SignUpFormCardSection` → `LabeledDivider('atau')`
  menggantikan `AuthOrSection`; `InlineLinkRow` menggantikan Section tautan.
- `AuthPasswordFieldSection` → `InlineLink('Lupa password?', onTap: busy ? null :
  onForgot)` dan `AppIconButton.compact` untuk mata (label tooltip tetap
  "Tampilkan/Sembunyikan password").
- Section yang dihapus: `auth_or_section.dart`, `sign_in_signup_link_section.dart`,
  `sign_up_signin_link_section.dart` (tidak ada pemakai lain dan tidak ada tes yang
  mengimpornya langsung).
- `docs/design/widget_registry.yaml`: tambah `LabeledDivider`, `InlineLink`,
  `InlineLinkRow` ke daftar molecules (perubahan registry disetujui lewat proposal
  lapisan ini, aturan 13).

## Dampak visual

- Label `LabeledField` 14/600 `ink` → 12/600 `primaryInk` di 36 pemakai (form
  pelanggan, layanan, transaksi, pengaturan, dst.).
- Tombol mata: area 32 → 40, ikon 22 → 20, tanpa kotak (tetap).
- Pemisah "atau": teks 11 (sudah) dengan gap 10; bentuk sama.
- Tautan: 12/600 `primary` (sudah) di baris tengah; bentuk sama.
- Golden yang bergeser dilaporkan sebagai daftar di `docs/progress/STATE.md`
  (UI-28). Tidak ada golden yang diperbarui tanpa daftar itu.

## Tes

- `test/labeled_divider_test.dart`: teks tampil, garis dua sisi, golden
  `labeled_divider`.
- `test/inline_link_row_test.dart`: teks pertanyaan + aksi, tap memicu callback,
  `onTap` null = nonaktif, golden `inline_link_row`.
- `test/app_icon_button_test.dart`: varian `compact` (area 40, ikon 20, tanpa
  latar, `color` dipakai, nonaktif `ink3`).
- Tes perilaku auth (`r10_*`, `auth_*`, keyboard) tidak diubah; finder ikon mata
  dan teks tautan tetap sama.

## Ditunda ke lapisan berikutnya

- `AuthHero` (organisme gradient + blob) dan `AuthCard` (organisme) → lapisan 4.
- `FeatureBar`/`TrustBar` tetap Section auth karena hanya dipakai layar auth.
- T&C "Syarat & Ketentuan" pada Daftar tetap ditunda (proposal 004).

## Hasil penerapan (10 Nov 2026)

- Molekul baru: `labeled_divider.dart` (garis + `caption` `ink3` + garis, gap 10),
  `inline_link.dart` (`TextButton` tanpa padding, `label` `primary`/`ink3`),
  `inline_link_row.dart` (`caption` `ink3` + gap 4 + `InlineLink`).
- `AppIconButtonVariant.compact`: area 40 (`buttonSmall`), ikon 20
  (`iconAction`), tanpa latar, `color` dipakai; dipasang sebagai tombol mata
  di `AuthPasswordFieldSection`.
- `LabeledField` label → `AppTextVariant.label` 12/600 `primaryInk`.
- `AuthPasswordFieldSection`: "Lupa password?" lewat `InlineLink`.
- Kedua kartu auth memakai `LabeledDivider('atau')` + `InlineLinkRow`
  (pertanyaan/aksi masing-masing), menggantikan tiga Section duplikat yang
  dihapus (`auth_or_section.dart`, `sign_in_signup_link_section.dart`,
  `sign_up_signin_link_section.dart`).
- Registry: `LabeledDivider`, `InlineLink`, `InlineLinkRow` masuk daftar
  molecules; katalog komponen dan galeri widgetbook diperbarui.
- Figma dibaca lewat MCP (node `4294968733`, `4294968735`, `4294968743`,
  `4294968742`, `4294968801`, `4294968802`, `4294968728`, `1089`); tidak ada
  node yang diubah.
- Verifikasi: `dart analyze` bersih, `check_arch` OK, seluruh 978 tes lulus
  (1 skip), `check_all` hijau.
- Golden bergeser: 21 lama + 2 baru. Lama: `app_icon_button`, `labeled_field`,
  `add_customer_sheet`, `expense_form`, `printer_page`, `proposal_new_customer`,
  `proposal_rina`, `transaction_page`, `auth_scaffold`, `auth_signin`,
  `auth_signin_error`, `r10_name`, `r10_password`, `r10_password_320_2x`,
  `r10_phone`, `r10_reset`, `r10_signin`, `r10_signin_error`,
  `r10_signin_error_320_2x`, `r10_signup`, `r10_signup_320_2x`. Baru:
  `labeled_divider`, `inline_link_row`.
- Tes yang diubah: `test/app_icon_button_test.dart` (tambah tes varian
  `compact`). Tes perilaku lama tidak diubah. Tes baru:
  `test/labeled_divider_test.dart`, `test/inline_link_row_test.dart`.

