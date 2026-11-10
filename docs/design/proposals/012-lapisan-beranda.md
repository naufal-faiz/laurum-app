# 012 - Lapisan komponen Beranda dan nav bawah baru

**Status:** disetujui pengguna dan diterapkan 10 Nov 2026 (aturan 2 dan UI-13).
Penugasan pengguna 10 Nov 2026: redesign `LAURUM · Beranda` (frame 281) dan nav
bawah (frame 388/494); halaman Laporan dikorbankan sementara; ikon nav yang ada
dipertahankan. Keputusan pengguna pada sesi ini: chip pertumbuhan dilewati
(data minggu lalu belum ada), lonceng tetap tampil sebagai visual, dan halaman
Antrean (frame 408) dikerjakan pada sesi terpisah.

Perilaku, state, data, rute transaksi, dan `Key` tidak berubah (UI-8, UI-11).
Tidak ada provider baru dan tidak ada berkas `features/*/state/` atau
`features/*/data/` yang disentuh.

## Perubahan rute (izin pengguna 10 Nov 2026)

| Berkas | Sekarang | Sesudah |
| --- | --- | --- |
| `placeholder_routes.dart` | `/antrean`, `/pelanggan`, `/laporan`, `/lainnya` | `/beranda`, `/antrean`, `/pelanggan`, `/lainnya` |
| `app_router.dart` | tab 0 `AntreanPage` | tab 0 `BerandaPage`; `AntreanPage` pindah ke tab 1 |
| `RootShellPage` | app bar di semua tab; banner WhatsApp di tab 0 | app bar disembunyikan di tab 0 (Beranda punya header sendiri); banner WhatsApp pindah ke tab 1 (Antrean) |
| `OutstandingPage` | nav aktif indeks 2 (Laporan), fallback `/laporan` | nav aktif indeks 0 (Beranda), fallback `/beranda` |

`/laporan` tidak lagi menjadi cabang tab dan tidak dapat dijangkau dari nav.
`ReportPage` tetap ada untuk dipakai kembali saat pengguna memutuskan letaknya.
Akun tetap menuju Lainnya (indeks 3). Transaksi tetap `push('/transaksi/baru')`.

## Komponen baru

### Atoms

1. `AppIcons.bell` (`Ionicons.notificationsOutline`) — ikon header Beranda.
   Ikon nav tidak berubah: Beranda memakai `AppIcons.droplet` yang sudah ada,
   Antrean `queue`, Pelanggan `customers`, Transaksi `add`, Lainnya `menu`.
2. `IconTile` mendapat parameter opsional `dot` (default false) untuk titik
   notifikasi 7 px di kanan atas. API lama tidak berubah.

### Molecules

3. `MetricTile` — `metric_tile.dart`
   `MetricTile({required String label, required String value, required Color color, String? background})`.
   Kotak `surfaceLow`, radius 12, label 11 `ink3`, angka 18/700 berwarna.
4. `SegmentedProgress` — `segmented_progress.dart`
   `SegmentedProgress({required List<({int value, Color color})> segments})`.
   Bar 6 px radius 3; lebar tiap segmen proporsional; nilai 0 tidak digambar.
5. `MiniBarChart` — `mini_bar_chart.dart`
   `MiniBarChart({required List<int?> amounts, double height = 32})`.
   5-7 batang radius 3; batang terakhir `primary`, batang lain `primaryTint`;
   `null` (hari mendatang) tidak digambar.
6. `AvatarStack` — `avatar_stack.dart`
   `AvatarStack({required List<String> initials, double size = 22})`.
   Lingkaran tumpang 6 px, border `surface` 1,5 px, latar `primaryTint`/`successTint`/`illustration`.
7. `RankRow` — `rank_row.dart`
   `RankRow({required String initials, required String name, required String detail, required String trailing, VoidCallback? onTap})`.
   Avatar 34, nama 12/600 `ink`, detail 11 `ink3`, trailing 12/700 `primary`.
8. `NavItem` — `nav_item.dart`
   `NavItem({required String label, required AppIcons icon, required bool selected, AppIcons? activeIcon, VoidCallback? onTap})`.
   Slot 60x46 radius 14, aktif `primaryTint` + `primary`, nonaktif `ink3`.
9. `CreateAction` — `create_action.dart`
   `CreateAction({required String label, VoidCallback? onPressed})`.
   Cincin 58 `primaryTint`, lingkaran 52 `primary`, ikon `add` 20, label
   `Transaksi` di bawahnya; satu `InkWell` + semantics `<label> baru`.

### Organisms

10. `WelcomeBanner` — `welcome_banner.dart`
   `WelcomeBanner({required String greeting, required String businessName, required String subtitle, required String actionLabel, VoidCallback? onAction})`.
   Kartu gradient `primary` → `primaryInk`, radius 24, tinggi 148, dekor lingkaran
   putih `heroBlob`/`heroBlobSoft`, ilustrasi tetes 64, CTA
   `AppButton.secondary` kecil + ikon `arrowForward` (putih, teks `primary`).
   Semua geometri dekoratif tinggal di organisme, bukan Section (UI-24/UI-26).

### Templates dan organisme nav

11. `RootScaffold` mendapat parameter opsional `showAppBar` (default true).
   Saat false, app bar tidak digambar dan `SafeArea` atas diserahkan ke isi.
   AppBarRoot tetap ter-mount (opacity 0, `IgnorePointer`, `ExcludeSemantics`)
   karena melepas app bar saat pindah cabang memicu crash semantik Flutter pada
   teks 2x. `extendBodyBehindAppBar` selalu true dan body diberi padding atas
   setinggi app bar saat `showAppBar: true`, sehingga tata letak layar lama tidak
   bergeser.
   `extendBody` menjadi false agar konten tidak tertutup pil nav.
12. `BottomNavBar` digambar ulang sesuai frame 388/494:
    - total tinggi 87 + jarak bawah 8 + safe area; pil 342x64 putih, border `borderStrong`,
      radius 24, jarak samping 24, jarak bawah 8.
    - 4 item 60x46 radius 14; item aktif berlatar `primaryTint`, ikon dan label
      `primary`; nonaktif `ink3` (`#8A9AAD` dipetakan ke `ink3`), label 11.
    - tombol tengah: cincin 58 `primaryTint` + lingkaran 52 `primary` + ikon
      `add` 20 putih, menonjol 23 px di atas pil; semantics `Transaksi baru`.
    - `activeIndex` tetap 0..3 dengan urutan Beranda, Antrean, Pelanggan, Lainnya;
      slot tengah tetap aksi, bukan tab.
    - label/ikon memakai token; tidak ada warna literal di organisme.

## Section Beranda (fitur baru `features/beranda/`)

Turunan data berada di `state/beranda_view.dart` (kelas view-data tanpa provider,
tanpa impor Flutter) supaya Page tetap di bawah 100 baris.
| Section | Data (dari provider yang ada) | Aksi |
| --- | --- | --- |
| `BerandaHeaderSection` | teks merek statis | lonceng visual (tanpa aksi) |
| `BerandaWelcomeSection` | nama usaha (`businessProfileProvider`) | `Kelola antrean` → tab Antrean |
| `BerandaQueueSection` | jumlah order per status + total + waktu update (`antreanDataProvider`) | buka tab Antrean |
| `BerandaCustomersSection` | jumlah pelanggan aktif + jumlah baru bulan ini + 3 inisial (`customerDirectoryProvider`) | buka tab Pelanggan |
| `BerandaRevenueSection` | omzet minggu ini + omzet harian (`reportViewProvider`) | — (tanpa aksi) |
| `BerandaFrequentSection` | 3 pelanggan dengan order terbanyak (`customerDirectoryProvider`) | buka detail pelanggan / tab Pelanggan |

Semua turunan dihitung di `BerandaPage` dari provider yang sudah ada; tidak ada
provider baru. Berat (kg) pelanggan tidak tersedia di agregat, jadi detail baris
menampilkan `N kali laundry` (selisih desain). Chip pertumbuhan tidak dibuat.

## Layar dan golden terdampak

- Nav bawah global berubah: `bottom_nav_bar`, `root_scaffold`, dan seluruh golden
  layar yang memuat nav (antrean, pelanggan, laporan/piutang, transaksi, struk,
  pengaturan, AI, auth?) akan bergeser. Daftar lengkap dilaporkan setelah
  `--update-goldens` untuk persetujuan UI-28.
- Golden baru: Beranda (390), Beranda teks 2x/320, 5 molekul baru, 1 organisme.
- Tes perilaku tidak diubah; finder label nav diperbarui (Laporan → Beranda,
  urutan tab) dan tes `Piutang` menyesuaikan indeks 0.

## Hasil penerapan (10 Nov 2026)

- Tab: Beranda, Antrean, Pelanggan, Lainnya + aksi Transaksi; `/beranda` aktif,
  `/laporan` tetap deep link tanpa slot nav (cabang Lainnya).
- Tes yang diubah (hanya finder/struktur, bukan assertion perilaku):
  `bottom_nav_bar_test` (label/urutan), `root_scaffold_test` (Laporan→Pelanggan +
  tes app bar tersembunyi), `r2_navigation_test` (urutan tab, indeks Piutang 0,
  `/laporan` tidak di `tabRoutes`), `raised_navigation_test` (geometri nav baru:
  badan tidak menutupi nav), `report_orders_test` dan `ai_settings_pages_test`
  (`ensureVisible` sebelum mengetuk kontrol yang kini dapat tergulir di atas nav).
- Tes baru: 5 Section Beranda, `beranda_view`, 8 komponen, halaman Beranda +
  golden 390, dan 320 px teks 2x.
- Golden: 19 berkas lama bergeser + 1 baru `beranda.png`. Lama:
  `ai_settings`, `ai_settings_disconnected`, `antrean_error`, `antrean_filter_kosong`,
  `antrean_kosong`, `antrean_loading`, `antrean_normal`, `antrean_proses`,
  `antrean_whatsapp`, `app_icon` (ikon lonceng di galeri), `bottom_nav_bar`,
  `expense_directory`, `proposal_history`, `r4_antrean_sederhana`, `r4_settings`,
  `r5_report_custom`, `r9_cod_outstanding`, `r9_cod_queue`, `root_scaffold`.
  Alasan: pil nav baru (tinggi/posisi/ikon/label) menggeser semua layar yang
  menampilkan nav; `app_icon` bertambah satu ikon; Beranda baru.
  Golden layar tanpa nav (auth, detail, sheet, transaksi, struk) tidak berubah.
- Verifikasi: `dart analyze` bersih, `check_arch: OK`, 1015 tes lulus (1 skip),
  `check_all: SEMUA HIJAU` (REPO_MAP 1038 berkas).
- Visual di emulator Android belum dijalankan; pengguna akan audit.


## Selisih desain yang dicatat

1. Chip `+12,4%` tidak dibuat (data minggu lalu belum ada; keputusan pengguna).
2. Lonceng + dot tampil tanpa aksi (keputusan pengguna; belum ada fitur notifikasi).
3. Ikon Beranda memakai `droplet` (ikon lama), bukan ikon rumah frame.
4. Label tahap memakai status aplikasi: Jemput / Proses / Siap, bukan nama
   layanan pada frame.
5. Detail pelanggan tanpa berat kg.
6. App bar global (sync + akun) tidak tampil di Beranda; tetap ada di tab lain.
7. Warna `#63B8D1` dipetakan ke `illustration`, `#EAF3FC` ke `primaryTint`,
   `#8A9AAD` ke `ink3`, radius logo 14 ke `AppRadius.logo` 12.
