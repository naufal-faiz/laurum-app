# STATE Laurum
Diperbarui: 2026-11-13 | Cabang ui/pelanggan

## Sesi aktif
Revisi daftar pelanggan: batas10/Lihat semua/ikon impor/teks tombol; dasar da59bdd.
Frame Pelanggan4294969460; snapshot spec12, tidak dibaca ulang.
Frame Detail Pelanggan4294969558 menunggu irisan berikutnya.

## Status irisan
- Awal maksimal10 hasil setelah filter/pencarian; Lihat semua membuka seluruh hasil.
- Footer jumlah ditampilkan/total; link hanya bila hasil melebihi10; kosong tanpa footer.
- Jumlah chip tetap dari seluruh pelanggan; pencarian tetap menemukan di luar10 awal.
- Ekspansi memakai CustomerDirectoryExpansion; reset saat filter/search berubah.
- Hanya Page membaca provider baru; Section menerima data/callback.
- Tombol impor memakai AppIcons.download; kedua aksi AppButtonSize.small, tinggi48.
- Tidak ada perubahan repository/skema/rute/shared/token/dependensi/uang.
- Golden customer_directory diperbarui dan diperiksa; tes lama tidak dilemahkan.
- Empat tes baru: state reset, ekspansi10ke48, pencarian terakhir, footer sempit/callback.
- Visual belum diverifikasi manual pada HP; tidak mengambil screenshot emulator.

## Keputusan pengguna terbaru
- Pengguna meminta batas10, Lihat semua, ikon impor dan teks tombol lebih kecil.
- Pengguna eksplisit mengizinkan melewati batas AGENTS.md yang diperlukan;
  izin dipakai untuk perilaku baru dan berkas state ekspansi, dicatat juga di spec12.
- Merge kembali ke backend-newdesign HARUS melalui persetujuan eksplisit pengguna.
- Pertahankan data kedua HP; jangan uninstall/hapus DB/outbox.
- Hanya Nama wajib; kebijakan detail/struk tanpa nomor tetap; Contacts Data safety wajib.

## Belum di-commit
Revisi dicakup satu commit fix(ui) penyelesaian sesi ini.
android/build/ tetap artefak tak terlacak sesi sebelumnya; tidak dimasukkan Git.

## Langkah berikutnya
1. Tinjau revisi di HP melalui hot restart/build branch ui/pelanggan.
2. Lanjutkan Detail Pelanggan4294969558 setelah daftar ditinjau.
3. Header jumlah pemilik piutang belum diubah; lihat selisih spec12.
4. Merge ke backend-newdesign hanya dengan persetujuan pengguna.

## Blocker
Tidak ada untuk revisi; Supabase lokal tidak tersedia, dua tes integrasi dilewati.

## Bukti terakhir
- Tes terarah15lulus; golden daftar diperiksa.
- dart run tool/check_all.dart: SEMUA HIJAU,1222lulus/2skip,exit0.
- Format1105berkas tanpa perubahan; Flutter analyze/dart analyze bersih; check_arch OK.
- REPO_MAP1183berkas; keyboard pelanggan300dp dan viewport320 lulus suite penuh.
- Satu lint urutan impor diperbaiki sebelum check_all terakhir; iOS belum diuji.
