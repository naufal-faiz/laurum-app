# STATE Laurum
Diperbarui: 2026-11-13 | Cabang ui/pelanggan

## Sesi aktif
Redesign daftar pelanggan selesai; dasar irisan4f14852, persiapan c07610e.
Frame Pelanggan4294969460 dari docs/design/new-design-laurum.figcraft.
Frame Detail Pelanggan4294969558 dipilih untuk irisan berikutnya.

## Status irisan
- Proposal027 disetujui pengguna: ya lakukan; implementasi/paritas spec12 lengkap.
- CustomerRow padding12, status sejajar/wrap, WhatsApp tileSuccess, ringkasan muted.
- Daftar horizontal24/vertikal12/gap10; aksi sejajar pada ruang cukup, tinggi48.
- Provider, callback, DP/Sisa, tabungan, filter, pencarian dan semua pelanggan tetap.
- Tes lama tetap; dua tes baru untuk aksi sejajar dan DP/Sisa pada kartu sempit.
- Dua golden diperbarui: customer_row/customer_directory; keduanya diperiksa.
- Visual belum diverifikasi manual pada perangkat; screenshot emulator tidak diambil.
- Tidak ada perubahan zona beku, registry, token, dependensi atau desain FigCraft.

## Keputusan pengguna terbaru
- Mode Redesign UI dilanjutkan; branch ui/pelanggan dari backend-newdesign.
- Proposal027 disetujui 13 Nov 2026; detail pelanggan adalah irisan berikutnya.
- Merge kembali ke backend-newdesign HARUS melalui persetujuan eksplisit pengguna.
- Hanya Nama pelanggan wajib; kebijakan detail/struk tanpa nomor tetap berlaku.
- Pertahankan data kedua HP; jangan uninstall/hapus DB/outbox.
- Data safety Play Store mencantumkan Contacts; iOS belum diuji.

## Belum di-commit
Seluruh perubahan irisan dicakup commit feat(ui) penyelesaian sesi ini.
android/build/ tetap artefak tak terlacak sesi sebelumnya; tidak dimasukkan Git.

## Langkah berikutnya
1. Pengguna meninjau daftar pelanggan; bila perlu build untuk uji perangkat.
2. Lanjutkan Detail Pelanggan4294969558 sebagai irisan berikutnya setelah tinjauan.
3. Jumlah pemilik piutang pada header memerlukan izin pembacaan data shell.
4. Merge ke backend-newdesign hanya setelah pengguna memberi persetujuan.

## Blocker
Tidak ada untuk irisan daftar; selisih header jumlah piutang dicatat di spec12.
Supabase lokal tidak tersedia; dua tes integrasi nyata dilewati, bukan dinyatakan lulus.

## Bukti terakhir
- Tes terarah14lulus; analisis lima berkas bersih.
- dart run tool/check_all.dart: SEMUA HIJAU,1218lulus/2skip,exit0.
- Format1101berkas tanpa perubahan; flutter analyze/dart analyze bersih; check_arch OK.
- REPO_MAP1179berkas; diff terhadap4f14852 hanya komponen/Section/tes/golden/docs.
- Key/fokus dan keyboard pelanggan300dp lulus dalam suite penuh; belum diuji di iOS.
