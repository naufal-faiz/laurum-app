# 01 - Beranda
Rute: `/beranda` (tab 0). Fase: redesign UI. Frame: `LAURUM · Beranda` (ID: 281).
Template: `RootScaffold` pada `RootShellPage` dengan `showAppBar: false` dan slot
`header` berisi merek + notifikasi tetap di posisi AppBar (koreksi pengguna).
Nav bawah mengambang memakai frame 388/494 dengan koreksi proposal 013.

## Paritas redesign (UI-7)

| Butir | Jenis | Centang | Catatan |
|---|---|---|---|
| Nama usaha | Data | ✅ | `businessProfileProvider`, kartu sambutan |
| Tiga layanan dengan pesanan aktif terbanyak + total nota | Data | ✅ | `antreanDataProvider.orders/items`; hitung nota unik per layanan, maksimum 3, kosong tanpa tile |
| Waktu pembaruan | Data | ✅ | `updatedAt`/`createdAt` terbaru, `Formatters.jam` |
| Jumlah pelanggan aktif | Data | ✅ | `customerDirectoryProvider` |
| Pelanggan baru bulan berjalan | Data | ✅ | `Customer.createdAt` vs `businessClockProvider` |
| Omzet minggu berjalan | Data | ✅ | `reportViewProvider` (periode bawaan minggu) |
| Omzet harian untuk grafik | Data | ✅ | `ReportView.daily` (hari mendatang kosong) |
| 3 pelanggan paling sering | Data | ✅ | urut `orderCount` menurun |
| Inisial pelanggan | Data | ✅ | dua huruf awal nama |
| `Kelola antrean` | Aksi | ✅ | `go('/antrean')` |
| `Lihat semua` | Aksi | ✅ | `go('/pelanggan')` |
| Baris pelanggan | Aksi | ✅ | `push('/pelanggan/:id')` |
| Muat / gagal | Keadaan | ✅ | gate lokal AppLoader terpusat (017), skeleton halaman; `EmptyState` + Coba lagi |
| Kosong | Keadaan | ✅ | angka 0, `Belum ada antrean`, teks kosong pelanggan |
| Label nav Beranda/Antrean/Pelanggan/Lainnya | Navigasi | ✅ | aktif mengikuti indeks 0..3 |
| Semantics `Transaksi baru` | Navigasi | ✅ | `CreateAction`, satu `InkWell` |
| `antrean-golden` | Key tes | ✅ | Boundary dari host tes, tidak berubah; Page tidak memiliki Key khusus |

## Komposisi (frame 281)

- `BerandaHeaderSection`: logo 42, `LAURUM`, `Laundry Management`, lonceng 38 + dot;
  di slot AppBar tetap, bukan di ListView.
- `BerandaWelcomeSection` → `WelcomeBanner`: kartu gradient minimum 168 radius 24,
  sapaan, nama usaha, sub, CTA `Kelola antrean` + panah.
  Judul 18, gap antar teks 4, gap tombol 16; tinggi mengikuti isi dan skala teks.
  Tombol small memakai label 13 dan `cursor-back.svg` diputar ke kanan.
- `BerandaQueueSection`: kartu `Antrean aktif` + badge `N pesanan`, tiga
  `MetricTile` layanan terbanyak (maksimal 3), `SegmentedProgress` bila ada layanan.
  Nama layanan dibatasi satu baris dengan ellipsis agar kotak seragam; badge
  total nota berada di kanan. Total per layanan dapat melebihi total nota bila
  satu nota berisi beberapa layanan.
  Kosong: `Belum ada pesanan masuk.` tanpa tile/progress palsu.
- `BerandaStatsSection`: dua kartu 112: `Pelanggan tersimpan` + `AvatarStack` +
  badge `+N baru`; `Pendapatan minggu ini` + `MiniBarChart`.
- `BerandaFrequentSection`: judul + `Lihat semua`, tiga `RankRow` dengan pemisah.
- Jarak halaman 16 kiri/kanan, 12 atas, 16 antar kartu; nav margin 8,
  label utuh, tanpa kotak aktif. Body terlihat di sisi tombol Transaksi.
  Judul pelanggan dapat membungkus; Lihat semua ditempatkan di kanan.

## Provider
`businessProfileProvider`, `antreanDataProvider`, `customerDirectoryProvider`,
`reportViewProvider`, `businessClockProvider`. Tidak ada provider baru; turunan
di `features/beranda/state/beranda_view.dart`.

## Selisih desain
1. Chip pertumbuhan `+12,4%` tidak dibuat: omzet minggu lalu tidak tersedia
   (keputusan pengguna 10 Nov 2026).
2. Lonceng + dot tampil tanpa aksi: fitur notifikasi belum ada (keputusan pengguna).
3. Ikon tab Beranda memakai `AppIcons.home/homeActive` yang tersedia pada kode awal sesi.
4. Koreksi pengguna 10 Nov: layanan diurut jumlah nota aktif terbanyak, bukan status.
5. Detail pelanggan `N kali laundry` tanpa berat kg (agregat belum menyimpan kg).
6. App bar sinkronisasi/akun diganti header merek/notifikasi di Beranda sesuai
   arahan pengguna; tetap ada di tab lain.
7. Warna frame dipetakan ke token terdekat: `#63B8D1` → `illustration`,
   `#EAF3FC`/`#E8F4FA` → `primaryTint`, `#8A9AAD` → `ink3`, radius logo 14 → 12.
8. Tinggi kartu mengikuti isi (IntrinsicHeight) dan teks minimum 11; skala font
   frame 9-10,5 dinaikkan sesuai keputusan UI-22.

## Catatan
- Kartu pendapatan membaca `reportViewProvider` (periode bawaan minggu). Karena
  `/laporan` tidak punya slot nav, periode tidak dapat diubah dari UI saat ini;
  bila nanti Laporan dikembalikan, kartu ini perlu provider khusus Beranda.
- Rute `/laporan` tidak lagi punya slot nav; tetap ada sebagai deep link di
  cabang Lainnya agar perilaku laporan dan tes lama tidak hilang.
- Titik awal aplikasi, selesai login, dan selesai onboarding menuju `/beranda`
  sesuai koreksi pengguna; aturan autentikasi/onboarding lain tetap.
- App bar lama benar-benar dilepas dan diganti header merek. Perpindahan tab
  diuji pada lebar 320 dengan skala teks 2x.
