# 01 - Beranda
Rute: `/beranda` (tab 0). Fase: redesign UI. Frame: `LAURUM · Beranda` (ID: 281).
Template: `RootScaffold` pada `RootShellPage` dengan `showAppBar: false`; halaman
menggambar header merek sendiri dan memakai nav bawah mengambang (frame 388/494).

## Paritas redesign (UI-7)

| Butir | Jenis | Centang | Catatan |
|---|---|---|---|
| Nama usaha | Data | ✅ | `businessProfileProvider`, kartu sambutan |
| Jumlah order per status (jemput/proses/siap) + total | Data | ✅ | `antreanDataProvider`, hanya order aktif |
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
| Muat / gagal | Keadaan | ✅ | skeleton 3 kartu; `EmptyState` + Coba lagi |
| Kosong | Keadaan | ✅ | angka 0, `Belum ada antrean`, teks kosong pelanggan |
| Label nav Beranda/Antrean/Pelanggan/Lainnya | Navigasi | ✅ | aktif mengikuti indeks 0..3 |
| Semantics `Transaksi baru` | Navigasi | ✅ | `CreateAction`, satu `InkWell` |

## Komposisi (frame 281)

- `BerandaHeaderSection`: logo 42, `LAURUM`, `LAUNDRY MANAGEMENT`, lonceng 38 + dot.
- `BerandaWelcomeSection` → `WelcomeBanner`: kartu gradient 148 radius 24,
  sapaan, nama usaha, sub, CTA `Kelola antrean` + panah.
- `BerandaQueueSection`: kartu `Antrean aktif` + badge `N pesanan`, tiga
  `MetricTile` (Jemput/Proses/Siap), `SegmentedProgress`.
- `BerandaStatsSection`: dua kartu 112: `Pelanggan tersimpan` + `AvatarStack` +
  badge `+N baru`; `Pendapatan minggu ini` + `MiniBarChart`.
- `BerandaFrequentSection`: judul + `Lihat semua`, tiga `RankRow` dengan pemisah.
- Jarak halaman 24 kiri/kanan, 12 atas, 16 antar kartu; nav mengambang.

## Provider
`businessProfileProvider`, `antreanDataProvider`, `customerDirectoryProvider`,
`reportViewProvider`, `businessClockProvider`. Tidak ada provider baru; turunan
di `features/beranda/state/beranda_view.dart`.

## Selisih desain
1. Chip pertumbuhan `+12,4%` tidak dibuat: omzet minggu lalu tidak tersedia
   (keputusan pengguna 10 Nov 2026).
2. Lonceng + dot tampil tanpa aksi: fitur notifikasi belum ada (keputusan pengguna).
3. Ikon tab Beranda memakai `droplet` (ikon lama), bukan ikon rumah frame.
4. Label tahap memakai status aplikasi (Jemput/Proses/Siap), bukan nama layanan.
5. Detail pelanggan `N kali laundry` tanpa berat kg (agregat belum menyimpan kg).
6. App bar global (sinkronisasi + akun) tidak tampil di Beranda; tetap ada di tab
   lain. Fungsi tidak dihapus, hanya tidak digambar di layar ini.
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
- Titik awal aplikasi tetap `/antrean` (perilaku auth tidak diubah pada sesi ini).
- App bar global tetap ter-mount di Beranda dengan opacity 0 dan tanpa semantics
  agar perpindahan cabang tidak memicu crash semantik Flutter pada teks 2x.
