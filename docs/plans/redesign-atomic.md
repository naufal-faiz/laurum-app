# Rencana Redesign UI per Lapisan Atomic

Status: usulan (menunggu persetujuan pengguna). Aturan kerja: AGENTS.md, Mode Redesign UI,
UI-21 sampai UI-29. Keputusan global: docs/design/redesign/decisions.md.

## Mengapa diubah
Snapshot branch newdesign (9 Nov 2026) menunjukkan redesign baru menyentuh layar 29 dan 31:
- Desain baru berlaku global (biru + Inter di semua 30 frame), tetapi tema global masih hijau +
  Plus Jakarta Sans. Token baru hidup di namespace auth (`AppColors.auth*`, `AppAuthTextStyles`,
  `AppFieldStyles`, `AppRadius.auth*`, `AppShadows.auth*`), dipakai 16 berkas di
  features/auth/widgets dan atom AppTextField.
- Auth melewati atom: tombol utama dan Google dibuat dari Material+InkWell (bukan AppButton),
  tombol kembali dari GestureDetector+ColorFiltered, dua hero dan dua kartu form duplikat, dua
  link section identik kecuali dua string, 12 dari 23 Section memakai primitif mentah,
  halaman tidak memakai template AuthScaffold.
- `tool/check_arch.dart` tidak melarang primitif seperti Material/InkWell/Container di Section.
- File FigCraft: 0 komponen, 0 variabel, 0 style; 938 frame hasil salin.
- Kabar baik: 54 Section di fitur lain hampir tanpa primitif dekoratif, disusun dari 17 atom,
  21 molekul, 17 organisme, 5 template. Restyle token dan atom akan merambat ke seluruh aplikasi.

## Lapisan

### 0. Keputusan dan Figma (tanpa kode)
- Pengguna mengisi decisions.md (5 butir).
- Di FigCraft: buat variabel (warna, radius, spacing, tipografi) dan komponen untuk pola
  berulang: Kembali (23x), Avatar (19x), Baris Pelanggan (4x), Baris Nota (4x), Nav Bawah (3x),
  Tombol Transaksi (3x), Cari (3x), Header (10x). Nama komponen sejajar registry.
- Selesai bila: decisions.md terisi, komponen dan variabel ada di dokumen FigCraft.

### 1. Token (proposal NNN-lapisan-token)
- Ganti isi token global sesuai keputusan 1-3: AppColors (primer, ink, label, border, status),
  AppTextStyles (font dan skala), AppRadius, AppShadows, AppSpacing/AppDimensions.
- Migrasikan utang auth (UI-23): hapus app_auth_text_styles.dart dan app_field_styles.dart
  setelah pemakainya pindah ke token global; hapus entri auth* dari AppColors/AppRadius/AppShadows.
- Perbarui docs/design/tokens.md. Selesai bila: tidak ada namespace token per layar, check_all hijau,
  daftar golden layar lama yang bergeser dilaporkan (UI-28).

### 2. Atoms (proposal NNN-lapisan-atoms)
- AppButton: ukuran besar/sedang/kecil (keputusan 4), varian outlined untuk Google (iconAsset
  sudah ada), keadaan busy. Menggantikan AuthSubmitSection dan tombol Google buatan sendiri.
- AppIconButton: varian di atas hero (lingkaran 36, ikon putih). Menggantikan tombol kembali auth.
- AppTextField: rapikan slot leadingIcon/trailing/dense (proposal 005) ke token global.
- AppDivider: dukung label tengah ("atau") atau jadikan molekul pada lapisan 3.
- AppCard: varian elevated (radius 24, shadow) bila belum ada.
- Selesai bila: tes widget/golden atom diperbarui, API lama tetap jalan.

### 3. Molecules (proposal NNN-lapisan-molecules)
- LabeledDivider ("atau"), InlineLinkRow ("Belum punya akun? Daftar" dan "Sudah punya akun? Masuk"
  = satu komponen berparameter), FeatureBar/TrustBar bila dipakai lebih dari satu layar.
- Periksa LabeledField dan BannerMessage terhadap desain baru.

### 4. Organisms (proposal NNN-lapisan-organisms)
- AuthHero (gradient + blob; tinggi sebagai parameter: 340 untuk Masuk, 230 untuk Daftar),
  AuthCard (kartu putih r24 + shadow + padding), plus restyle organisme lain
  (BottomNavBar, CustomerRow, NotaCard, OrderCard, dst.) mengikuti Figma.

### 5. Templates (proposal NNN-lapisan-templates)
- Perbarui AuthScaffold agar menerima slot hero dan kartu (menggantikan Scaffold+Stack di
  sign_in_page dan sign_up_page). Periksa RootScaffold, SubScaffold, FormScaffold, SheetScaffold.

### 6. Page dan Section
- Mulai dari auth (UI-29): rework layar 29 dan 31 menjadi komposisi murni.
- Lalu layar lain sesuai urutan dari pengguna, satu layar per sesi, dengan tabel paritas (UI-7).

## Risiko dan mitigasi
- Restyle token/atom menggeser tampilan layar yang belum didesain ulang (tinggi tombol dan field,
  warna). Mitigasi: golden layar lama dilaporkan sebagai daftar diff untuk disetujui (UI-28);
  perubahan hanya visual, API komponen tetap.
- Ukuran font Figma sangat kecil (72% teks 10,5 px atau kurang). Mitigasi: keputusan 3 dan
  verifikasi di perangkat Android.
- Pengaman mesin belum ada untuk UI-24 sampai UI-26. Opsional: tambahkan rule di
  tool/check_arch.dart SETELAH auth dirapikan (UI-29); menyalakannya sekarang akan membuat
  check_all gagal pada Section auth saat ini. tool/ tetap beku sampai pengguna mengizinkan.

## Di luar cakupan rencana ini
Perilaku, state, data, rute, dan backend (UI-6). T&C pada halaman Daftar (proposal 004) tetap ditunda.
