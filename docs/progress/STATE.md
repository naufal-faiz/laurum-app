# STATE Laurum
Diperbarui: 2026-11-16 | Cabang review/android-ui-20261116

## Sesi aktif
Integrasi Android: layanan d46e62e/c00909d dan printer 13a1741/2918491.
Dasar bersama 7e85870; tidak mengubah branch/worktree agen printer.

## Status irisan
- Tambah layanan dan revisi daftar layanan tergabung dengan printer/struk.
- Konflik hanya catatan STATE, digabung dengan mempertahankan kedua pekerjaan.
- Regresi printer terkonfirmasi: overflow 111 px pada 320 dp/font 2x, diperbaiki.
- Kontrol kini minimum 44 dp dan bertumbuh sesuai teks; format tersusun adaptif.
- Golden printer diperbarui dan ditinjau; belum diverifikasi manual di Android/iOS.

## Keputusan pengguna terbaru
- Pengguna meminta analisis commit printer dan satu branch untuk tinjauan Android.
- Jangan push; merge backend-newdesign tetap perlu izin tersendiri.
- Jangan uninstall atau menghapus DB/outbox perangkat.
- Draf FigCraft lokal tidak masuk commit.

## Belum di-commit
Draf FigCraft, figma_map dan spec20 dipulihkan; tidak masuk commit integrasi.
Stash ddd0c6a tetap sebagai salinan pengaman draf lokal.
android/build/ tetap artefak lokal, tidak disertakan Git.

## Langkah berikutnya
1. Tinjau branch aktif di Android: flutter run -t lib/main_dummy.dart -d <device-id>.
2. Uji cetak Bluetooth sungguhan; iOS belum diuji.

## Blocker
Tidak ada.

## Bukti terakhir
- Revisi layanan: analyze bersih; tes ServiceRow 2 dan directory 4 lulus.
- Sebelum integrasi: check_arch OK.
- Tambah layanan: check_all 1314 lulus/2 skip pada commit d46e62e.
- Printer integrasi: 7 tes terarah lulus, termasuk regresi font2x dan callback.
- dart run tool/check_all.dart: SEMUA HIJAU; 1315 lulus/2 skip, exit 0.
- Format1159 tanpa perubahan; flutter analyze/dart analyze bersih; check_arch OK.
- REPO_MAP1237 berkas; skip2 perlu Supabase lokal; semua golden lulus.
- newdesign dan ui/pelanggan keduanya ancestor HEAD; state/data/rute/deps tidak berubah.
