# STATE Laurum
Diperbarui: 2026-11-14 | Cabang ui/pelanggan

## Sesi aktif
Redesign Detail Pelanggan selesai; dasar36fdffe, persiapan158074d.
Frame4294969558 dari docs/design/new-design-laurum.figcraft; snapshot/paritas spec13.

## Status irisan
- Proposal028 disetujui: profil biru, statistik2×2, aksi sejajar, riwayat ringkas.
- StatTile/SavingsRow/NotaCard.compact dan SubScaffold detail opsional; default tetap.
- Statistik tinggi intrinsik per baris; teks besar/layar sempit menjadi satu kolom.
- Pasangan aksi responsif; label/nama/alamat/catatan membungkus tanpa tinggi tetap.
- Header intrinsik tetap saat scroll; provider detail dibaca sekali untuk header/body.
- Lihat semua mutasi ke rute lama; order awal3, ekspansi seluruh riwayat per pelanggan.
- Callback/data uang/guard nonaktif tetap; SavingsSection kini callback murni.
- Pengecualian zona beku sesuai izin028: state ekspansi baru dan hapus satu entri debt.
- Tidak ada perubahan repository/skema/rute/token/registry/dependensi/perhitungan uang.
- Dua golden detail baru diperiksa; tidak ada golden default/layar lain berubah.
- Visual belum diverifikasi manual pada HP; screenshot emulator tidak diambil.

## Keputusan pengguna terbaru
- Proposal028 disetujui dan diminta aman terhadap perbedaan font HP pengguna.
- Tes font langsung tanpa pembatas aplikasi; hanya inisial dekoratif avatar maks1×
  agar tidak terpotong; nama lengkap dan isi tetap mengikuti ukuran teks pengujian.
- Merge ke backend-newdesign HARUS melalui persetujuan eksplisit pengguna.
- Pertahankan data kedua HP; jangan uninstall/hapus DB/outbox.
- Hanya Nama wajib; WhatsApp tanpa nomor tetap; Contacts Data safety wajib.

## Belum di-commit
Seluruh irisan dicakup satu commit feat(ui) penyelesaian sesi ini.
android/build/ tetap artefak tak terlacak sesi sebelumnya; tidak dimasukkan Git.

## Langkah berikutnya
1. Pengguna meninjau detail pelanggan di HP; hot restart R atau jalankan build terbaru.
2. Periksa profil/empat statistik/aksi tabungan/riwayat dan font HP yang biasa dipakai.
3. Lihat semua order muncul hanya bila pelanggan punya lebih3 order tersimpan.
4. Koreksi visual sesuai tinjauan; layar baru menunggu pilihan pengguna.
5. Merge ke backend-newdesign hanya dengan persetujuan eksplisit pengguna.

## Blocker
Tidak ada untuk irisan ini; Supabase lokal tidak tersedia, dua tes integrasi dilewati.

## Bukti terakhir
- Tes terarah40lulus; 16kombinasi lebar280/320/390/600 × font0,85/1/1,3/2.
- Teks panjang/nominal besar/avatar/action/header/grid dan ekspansi3ke4 teruji.
- dart run tool/check_all.dart: SEMUA HIJAU,1244lulus/2skip,exit0.
- Format1113berkas tanpa perubahan; Flutter analyze/dart analyze bersih; check_arch OK.
- REPO_MAP1191berkas; tes keyboard/edit/nonaktif/navigasi lama tetap; iOS belum diuji.
