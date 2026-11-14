# STATE Laurum
Diperbarui: 2026-11-14 | Cabang ui/pelanggan

## Sesi aktif
Redesign Tambah layanan031 selesai; dasar7e85870 (kode awal0e81c8d).
Frame4294968237 dibaca sekali; snapshot dan paritas lengkap di spec21.
Desain lain: frame Daftar Layanan4294969685 dibuat di FigCraft; belum kode/tes.

## Status irisan
- Pratinjau gradient reaktif nama/tipe/harga/durasi, kartu informasi dan durasi/status.
- Prefix Rp selalu terlihat; harga baru kosong/hint0, unit/harga sejajar vertikal.
- Header membaca nama usaha aktual; Footer Batal/Simpan responsif saat font besar.
- Urutan Tab tetap Simpan lalu Batal; nama/harga dan seluruh binding lama tetap.
- Enam Section baru Stateless, data/callback; Edit tetap memakai komposisi lama.
- Empat varian bersama opt-in disetujui; ikon bag/power via Ionicons terpasang.
- Field padat diberi ruang scroll atas24 agar tepi tidak terpotong saat keyboard.
- AppTextField config di part internal; controller/fokus tetap di atom field utama.
- check_all SEMUA HIJAU:1314tes lulus/2skip; paritas031 penuh, siap tinjauan.
- 4golden:Tambah layanan1x/2x baru; galeri AppBadge/AppIcon diperbarui.
- Visual golden ditinjau; visual belum diverifikasi manual di HP; iOS belum diuji.

## Keputusan pengguna terbaru
- Proposal031 disetujui14Nov2026 melalui jawaban Ya lakukan.
- Pakai nama usaha aktual/draft yang ada; contoh Figma tidak menjadi fixture.
- Mendukung font1–2x dan keyboard300dp; perilaku simpan/validasi/katalog tetap.
- Merge ke backend-newdesign harus melalui persetujuan eksplisit pengguna.
- Jangan uninstall atau menghapus DB/outbox perangkat.

## Belum di-commit
Kode/tes/golden/spec031/STATE/REPO_MAP dan baris Tambah di peta dicakup commit ini.
Perubahan desain lain yang muncul selama sesi dipertahankan, tidak masuk commit031:
- docs/design/new-design-laurum.figcraft: frame Daftar Layanan (jangan di-commit).
- docs/design/screens/20-daftar-layanan.md dan baris/frame Daftar di figma_map.md.
android/build/ tetap artefak tak terlacak, tidak disertakan Git.

## Langkah berikutnya
1. Pengguna meninjau Tambah layanan di HP, termasuk font besar dan keyboard.
2. Desain Daftar layanan20 sudah disiapkan terpisah; implementasi hanya jika diminta.
3. Jangan push/merge sampai pengguna mengizinkan secara eksplisit.

## Blocker
Tidak ada blocker implementasi/pemeriksaan otomatis.

## Bukti terakhir
- Regresi terarah41tes lulus; akun27tes lulus; fokus/keyboard/viewport14tes lulus.
- dart run tool/check_all.dart: SEMUA HIJAU;1314lulus/2skip, CHECK_ALL_EXIT=0.
- Format1153berkas0perubahan; flutter analyze/dart analyze bersih; check_arch OK.
- REPO_MAP diperbarui1231berkas; tidak ada perubahan backend/state/data/rute/tool/dependensi.
- Izin UI-8 hanya pembacaan profil usaha di Page; sumber draft dan aksi simpan tetap.
