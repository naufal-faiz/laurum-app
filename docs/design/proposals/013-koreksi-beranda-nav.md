# 013 — Koreksi Beranda dan navigasi Android

Status: diminta pengguna 10 Nov 2026, diterapkan; check_all hijau dan Android
diperiksa. Pergeseran visual 115 golden menunggu tinjauan pengguna.
Dasar: koreksi visual pengguna atas proposal 012; frame 281/312/388 dibaca MCP.

1. Token global terlebih dahulu: body/bodyStrong/input 14/20 → 16/24;
   label/caption 12/16 → 13/18; brandSub/meta/micro 11 → 12 (baris 16),
   CTA 15/20 → 16/22. Tidak membuat token khusus layar.
2. Molekul: NavItem tanpa kotak aktif, lebar mengikuti slot, label utuh;
   MetricTile membatasi nama layanan satu baris ellipsis; RankRow memakai bodyStrong/caption.
3. Organisme: nav memakai margin 8 dp dan lima slot sama lebar; ruang label
   mengikuti ukuran teks. Tombol Transaksi tetap menonjol, area sekitarnya
   transparan dan menampilkan body; semua callback tetap.
4. Template: AppBar akun diganti header merek/notifikasi tetap di Beranda
   (arahan susulan pengguna); slot opsional `RootScaffold.header`, default null.
   Tinggi header mengikuti skala teks. Body menggambar sampai
   belakang nav, dengan inset gulir agar kontrol akhir dapat dijangkau.
5. Page/Section: padding horizontal 16 dp; judul pelanggan boleh membungkus,
   Lihat semua rata kanan; label statistik utuh.

Koreksi susulan pengguna: kotak layanan dibatasi satu baris label dengan ellipsis;
badge jumlah nota rata kanan tanpa Flexible/FittedBox. Banner memakai judul
titleSub 18 (sebelumnya titleRoot 24); tombol small memakai label 13, tetap
40 dp, ikon cursor-back SVG diputar 180 derajat ke kanan. AppButton mendapat
parameter opsional iconQuarterTurns (default 0), tanpa perubahan pemanggil lama.
Arahan susulan: header manual pengguna dipertahankan (`Laundry Management`).
Banner memakai susunan konten intrinsik (minimum 168, sebelumnya tinggi tetap 148),
gap teks 4, jarak tombol 16, padding 18; nama usaha maksimal dua baris. Dekorasi
tetap di Stack, teks/tombol tidak lagi Positioned sehingga tidak bertumpuk pada 2x.

Izin perubahan perilaku spesifik dari permintaan pengguna:
- Tujuan awal, selesai login, dan selesai onboarding ke /beranda.
- Antrean aktif mengelompokkan layanan berdasarkan serviceId, menghitung nota
  aktif unik per layanan, urut jumlah turun lalu nama, maksimal tiga. Abaikan
  item terhapus/nonaktif; satu nota dengan dua layanan masuk kedua hitungan.
  Total badge tetap jumlah nota, sehingga jumlah per layanan bisa melebihi total.
- Data tetap antreanDataProvider; item yang sudah tersedia diteruskan ke pemetaan
  BerandaView. Tidak mengubah repository, fixture, atau penyimpanan.

Zona beku yang diizinkan permintaan ini: pemetaan BerandaView, rute awal/auth,
tes pemetaan dan redirect terkait, token global. Perilaku lain dipertahankan.
Golden terdampak token/nav wajib didaftar sebelum diperbarui, lalu check_all.
Visual Android diperlukan; bila perangkat tidak tersedia tulis belum diverifikasi.

Regresi token global: WeeklyBarChart menambah ruang vertikal saat teks diperbesar
(faktor 160 → 192) agar label 320 dp/2x tidak overflow. Tes perilaku tetap utuh.
Daftar awal 115 golden terdampak: `013-golden-impact.md` (hasil tes sebelum update).

## Tes yang berubah dan alasan

- app_badge_test: tinggi 20 → 22 karena tinggi baris label 16 → 18.
- auth_routes_test: tambah bukti URI /beranda setelah login dan onboarding.
- widget_test: bukti entry dummy membuka merek/header Beranda.
- beranda_view_test: status diganti hitungan layanan sesuai permintaan; tambah
  tes nota unik, item terhapus/nonaktif, maksimum tiga, satu layanan, dan kosong.
- beranda_sections_test: finder header manual `Laundry Management`, contoh nama
  layanan, empty state tanpa tile palsu, SVG berputar kanan, jarak tombol pada 320/2x.
- beranda_page_test: posisi header terhadap konten, header tetap saat digulir,
  perpindahan tab berulang pada 320/2x; golden Beranda diperbarui.
- root_scaffold_test: AppBar tersembunyi benar-benar dilepas; tes slot merek.
- raised_navigation_test: body melewati tepi atas nav agar sisi tombol tetap
  menampilkan konten; assertion ketuk/gulir/aksi Transaksi dipertahankan.
- drift_app_test, drift_empty_test, storage_gate_test: initialLocation /antrean
  eksplisit agar semua assertion perilaku Antrean lama tetap diperiksa setelah
  default aplikasi beralih ke /beranda.
- Semua tes/golden lain mempertahankan assertion perilakunya; daftar pergeseran
  visual 115 berkas ada di 013-golden-impact.md.

## Visual Android

Build `flutter run -t lib/main_dummy.dart` berhasil dipasang di SM-N975F (wireless),
10 Nov 2026. Diperiksa: awal langsung Beranda, header tanpa toolbar kosong,
banner dan jarak tombol, layanan teratas + ellipsis + badge kanan, label nav utuh,
konten terlihat di samping tombol Transaksi, serta perpindahan ke Antrean.
Header manual pengguna dipertahankan; perangkat dikembalikan ke Beranda.
Screenshot lokal: TEMP/laurum-beranda-android.png dan TEMP/laurum-nav-check.png.
Lebar 320/teks 2x diperiksa lewat widget test. iOS belum diuji.

## Verifikasi akhir

`dart run tool/check_all.dart`, exit 0 (TEMP/laurum-beranda-check-all-final.log):
```
Formatted 961 files (0 changed)
flutter analyze: No issues found!
dart analyze (Riverpod lint): No issues found!
check_arch: OK
+1020 ~1: All tests passed!
REPO_MAP diperbarui: 1039 berkas
check_all: SEMUA HIJAU
```
Zona beku yang berubah sesuai izin spesifik pengguna: app_dimensions,
app_text_styles, beranda_view + beranda_services, app_router, auth_routes,
dan tes pemetaan/redirect terkait. Persistence, sync, data/repository, Supabase,
dependensi, aturan lint, tool, dan PRD tidak berubah.
