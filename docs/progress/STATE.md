# STATE Laurum
Diperbarui: 2026-11-11 | Cabang `newdesign`

## Sesi aktif
- Dasar e6d138f (catatan koreksi), implementasi sebelumnya 2c96aa1.
- Koreksi 017 selesai: pengguna menegaskan sasaran loader adalah Membuka data lokal
  di lib/app.dart, bukan indikator tambahan di Beranda/Antrean.
- Prasyarat branch newdesign + baca FigCraft frame 408 berhasil.
- Codebase-memory transport closed; penelusuran memakai sumber langsung.
- Ikon gate lokal diganti AppLoader; judul/deskripsi asli dipertahankan dalam
  grup Center layar penuh. Error penyimpanan dan retry sama persis.
- Gate menggabungkan pembukaan store dan pembacaan awal provider antrean,
  pelanggan dan laporan yang sudah ada. Tidak ada provider/data/state baru.
- Hanya pembacaan tanpa nilai awal menahan gate. Refresh yang mempunyai data
  tidak melepas navigator; error query diteruskan ke error/retry halaman.
- AppLoader sekunder Beranda/Antrean dilepas; skeleton halaman lama dipulihkan.
  Pada startup lokal nyata, halaman tampil setelah data awal siap.
- Padding kecil AntreanPage yang sudah ditambahkan pengguna dipertahankan.
- Tidak ada perubahan token, registry, dependensi, repository, rute atau PRD.

## Bukti dan verifikasi
- Tes terarah awal 9 lulus: storage/error/retry, pembacaan bertahap satu loader,
  navigator tetap saat refresh, Drift create/payment/empty dan state Antrean.
- Suite golden + regresi query error/retry 15 lulus.
- Golden 5 berkas: local_storage_loading baru; antrean_loading kembali skeleton;
  antrean_normal/proses/whatsapp mengikuti padding manual pengguna.
- Android SM-N975F: gate produksi dipratinjau dengan entry diagnostik TEMP
  (store sengaja pending, tanpa perubahan data); loader/judul/deskripsi terpusat.
  Perangkat dikembalikan ke lib/main.dart normal; Beranda tampil dengan data lokal
  tersimpan, tanpa entry diagnostik. Tidak ada aksi perubahan data dilakukan.
- check_all HIJAU, exit 0: format 979 (0 berubah), analyze/Riverpod bersih,
  check_arch OK, 1042 tes lulus/1 skip, REPO_MAP 1057 berkas.
  Bukti lokal: TEMP/laurum-local-loader-check-all-complete.log.
- iOS belum diuji. Detail paritas dan golden: proposals/017-loader-data-lokal.md.

## Langkah berikutnya
1. Tinjauan pengguna atas loader pembukaan lokal dan transisi ke halaman siap.
2. Lanjutkan hanya sesuai umpan balik; jangan mulai layar lain pada sesi ini.

## Sebelumnya dan backend
- 015 Antrean/nav selesai; 016 jarak, warna dan modal filter selesai.
- 014 AppLoader/aset refined 96 dp, semantics dan reduced motion (frame 50%) tetap.
- Auth final + sembilan golden disetujui pengguna dan disimpan di 5860dd7.
- Bukti terakhir sebelum sesi ini: 1040 tes lulus/1 skip, REPO_MAP 1055.
- UI100/R0-R10, BP0, B1a-f, B0, B2a-d, B3a, B3c selesai; B3b/B2e+ menunggu.
- Backend berikut: cloud/workmanager Android, Google login, lalu B3b;
  docs/plans/B3-auth.md. Drift/wire v5, cloud 5/5 oleh pemilik.
- PayStatus turunan, COD bersisa ditahan, multi-repo TransactionRunner.

## Lingkungan dan Git
- Sebelum Dart/Flutter: . ./tool/windows_native_sdk.ps1; BOT=true.
- FigCraft sudah berubah sebelum sesi, tidak disertakan commit koreksi.
- Jangan push/merge. Riwayat lama: docs/progress/state-history-2026-11-10.md.
