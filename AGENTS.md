# AGENTS.md - Laurum (aplikasi kasir laundry, Flutter)

## Baca dulu (urutan)
1. docs/prd/prd-a-ui.md (tampilan) dan docs/prd/prd-b-backend.md (sistem)
2. docs/design/widget_registry.yaml (daftar TERTUTUP widget)
3. docs/design/screens/<layar yang dikerjakan>.md (template: _TEMPLATE.md)
4. docs/design/tokens.md, data_master.md, receipt_template.md
Acuan visual: docs/design/laurum-ready.pen. Jika spec layar dan .pen berbeda, spec layar menang; catat selisihnya.

## Platform
Satu basis kode untuk Android dan iOS. Saat ini HANYA Android yang bisa diuji. Jangan menulis kode khusus satu platform tanpa pengecekan Platform dan jangan mengasumsikan perilaku Android (izin, Bluetooth, kontak). Tandai fitur platform-spesifik "belum diuji di iOS" di spec layar.

## Aturan keras (dicek otomatis)
1. Tampilan HANYA dari widget di widget_registry.yaml. Dilarang membuat widget baru, kelas widget privat (_Foo), atau method pembangun widget (Widget _buildX()). Pengecualian: kelas *Page/*Sheet di features/*/pages/ dan widget akar di lib/app.dart.
2. Butuh widget yang belum ada? BERHENTI. Tulis docs/design/proposals/NNN-nama.md (alasan, layar, sketsa API) lalu tanyakan. Jangan membuatnya sendiri.
3. Maksimal 100 baris per file Dart (batas keras 110, kecuali berkas hasil generate). Satu widget publik per file. Pecah ke widget registry yang ada.
4. Tanpa setState dan tanpa StatefulWidget, kecuali widget bertanda stateful di registry (AppTextField, AppSearchField). State memakai Riverpod (Notifier/AsyncNotifier). Tanpa codegen Riverpod.
5. Hanya Pages yang membaca provider. Atoms/molecules/organisms/templates menerima data lewat konstruktor dan aksi lewat callback. Dilarang mengimpor flutter_riverpod di shared/widgets.
6. Aturan impor lapisan: atoms tidak mengimpor lapisan lain; molecules hanya atoms; organisms hanya atoms+molecules; templates tidak mengimpor features.
7. Ikon: hanya lewat AppIcon (enum AppIcons di core/icons/app_icons.dart yang membungkus Ionicons) atau AppSvg (berkas di assets/icons/). Dilarang Icons.*, Icon() langsung, SVG inline, SvgPicture.string.
8. Warna, TextStyle, radius, bayangan hanya di lib/core/theme/. Dilarang Color(0x..), Colors.*, TextStyle() di luar tema.
9. Format uang/berat/tanggal/jam/telepon hanya lewat Formatters. Uang int rupiah, berat int gram. Dilarang double untuk uang.
10. Dilarang print, ignore lint tanpa alasan tertulis, dan menambah dependensi tanpa persetujuan.
11. Data dummy hanya dari fixture di features/*/data/ yang isinya persis docs/design/data_master.md. Jangan menulis angka atau nama di widget.
12. Jangan menebak versi paket dari ingatan: gunakan flutter pub add dan versi yang di-resolve.

## Alur kerja setiap tugas
1. Baca spec layar dan daftar widget yang dipakai. Buka Widgetbook/registry untuk melihat API widget.
2. Tulis rencana singkat: widget registry yang dipakai, provider, fixture, rute. Jika ada kebutuhan di luar registry, hentikan (aturan 2).
3. Implementasi. Setelah tiap berkas: dart format.
4. Jalankan: dart run tool/check_all.dart (format, flutter analyze, dart analyze termasuk plugin Riverpod, check_arch, test). Semua harus hijau.
5. Perbarui spec layar bila ada keputusan baru. Laporkan: berkas yang diubah, widget yang dipakai, selisih terhadap .pen, hal yang tidak pasti.

6. Selalu catat kemajuan, keputusan, hasil pemeriksaan, dan pekerjaan tertunda di `docs/progress/fase-N.md` sesuai fase. Jangan menulis catatan progres di `docs/prompts/`. Perbarui catatan pada setiap tugas, termasuk saat terhambat.

## Dilarang tanpa izin
Mengubah registry, tema/token, aturan lint, struktur folder, atau PRD. Menambah fitur di luar PRD (kurir, stok, jatuh tempo, paket layanan, dsb).

## Perintah
flutter run -t lib/main_dummy.dart      # data dummy
dart run tool/check_all.dart            # wajib hijau; dart analyze memeriksa lint Riverpod
