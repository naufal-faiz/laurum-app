# STATE Laurum
Diperbarui: 2026-11-13 | Cabang backend-newdesign

## Sesi aktif
Revisi logo, harga antrean, PNG WhatsApp dan font; dasar 62e404c.
Alur normal/perubahan komponen bersama disetujui pengguna; proposal 026.

## Status irisan
- Beranda dan header login memakai assets/laurum-logo.png melalui IconTile.
- Tombol Edit/Hapus detail order memakai latar tile yang sudah tersedia.
- Harga OrderCard selalu di footer kanan bawah, termasuk label COD panjang.
- PNG WhatsApp memakai ReceiptDocument yang sama dengan preview, seluruh tinggi
  struk, resolusi 2x; lebar 320/384 mengikuti pengaturan. PDF/thermal tetap.
- Font maksimum 100% sesuai font_scale 1.0 HP acuan; ukuran lebih kecil tetap.
- Callback, data uang, guard COD, penerima dan pesan WhatsApp tidak berubah.
- Golden 23 yang terdampak logo/kartu/footer/font diperbarui + 2 PNG baru.
  Tes host antrean kini mengharapkan font 100%; assertion viewport/keyboard tetap.
- Visual golden logo/kartu/PNG diperiksa; belum diuji manual di HP/iOS.
- APK belum dibangun ulang untuk batch ini. APK terakhir: 1.0.2 code 3,
  build/app/outputs/flutter-apk/laurum-harian-1.0.2-arm64-release.apk.
- Perbaikan sinkron lintas HP sudah di commit 62e404c; data lokal dipertahankan.

## Keputusan pengguna terbaru
- Lanjutkan revisi komponen bersama dan samakan PNG WhatsApp dengan preview.
- Hanya Nama pelanggan wajib; tanpa nomor, WhatsApp berbagi umum.
- Pertahankan data kedua HP; pembaruan tanpa uninstall/hapus DB/outbox.
- Data safety Play Store wajib mencantumkan Contacts; iOS belum diuji.

## Belum di-commit
Batch ini dicakup commit fix(ui): app/font, logo/aset/pubspec, OrderCard, footer detail,
renderer PNG, tes/golden, proposal 026, spec 08, PARITY, REPO_MAP dan STATE.
Milik pengguna dikecualikan: AGENTS.md, FigCraft, ikon launcher Android.
android/build/ dan APK tidak masuk Git.

## Langkah berikutnya
1. Tinjau logo, harga COD dan PNG WhatsApp di perangkat setelah build berikutnya.
2. Uji kedua HP online dengan akun sama dan APK 1.0.2 tanpa menghapus data.
3. Uji cetak/iOS dan Data safety Contacts; B2e foto pengeluaran tertunda.

## Blocker
Supabase lokal tidak tersedia saat pemeriksaan ini; dua tes integrasi membutuhkan
layanan tersebut. Tes integrasi nyata sebelumnya lulus pada commit 62e404c.

## Bukti terakhir
- Tes terarah golden komponen/layar: 89 lulus.
- Harga COD panjang pada 280/320/390: 6 lulus; PNG vs preview/struk panjang: 3 lulus.
- check_all SEMUA HIJAU: 1215 lulus, 2 skip (Supabase lokal); REPO_MAP 1179.
- Flutter analyze/dart analyze tanpa masalah; check_arch OK; 1101 berkas terformat.
- Helper molecule_gallery menunggu precacheImage agar golden logo deterministik;
  4 tes logo lolos tanpa mengubah golden/toleransi untuk menutupi perbedaan.
