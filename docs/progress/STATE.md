# STATE Laurum
Diperbarui: 2026-11-11 | Cabang `newdesign`

## Sesi aktif: Periksa Usulan AI + Detail Order
- Dasar 49dd172. Pengguna meminta dua layar berurutan dalam sesi ini.
- Frame FigCraft dibaca read-only: Detail Usulan AI 512, Detail Order 612.
- Codebase-memory transport closed; REPO_MAP + sumber langsung menjadi bukti.
- Proposal 018 molecules, 019 organisms, 020 templates DISETUJUI pengguna
  ("Setuju, terapkan ketiganya"). Jalankan berurutan dengan gerbang check_all.
- Pengguna menyetujui adaptasi: tidak menambah input berat/jadwal jemput baru
  pada usulan. Field/draf/validasi/aksi lama tetap; berat melalui Edit order
  sesudah persetujuan. Skor AI hanya contoh berlabel pada scope dummy yang ada.
- Paritas awal dan selisih dicatat di spec 25 dan 09; belum ditandai selesai.

## Lapisan aktif UI-21
- Lapisan 3 (018) diterapkan: AppBarSub subtitle + variant detail intrinsik,
  SectionHeader trailing informatif, PaymentBadge; default lama tetap.
- AppIcons.edit/dot: Ionicons pencilOutline/ellipse terverifikasi pada paket
  terpasang 0.2.3. Tidak menambah dependensi atau token.
- Tes terarah komponen 10 lulus; palet ikon 1 lulus; golden baru detail_molecules.
  Header 320 dp/teks 2x tidak overflow, kembali/menu dan badge diuji.
- Lapisan 3 HIJAU: check_all exit 0, 1047 tes lulus/1 skip, REPO_MAP 1060.
  Bukti: TEMP/laurum-detail-layer3-check.log; lapisan aktif berikutnya 4 (019).
- Lapisan 3 disimpan di 9307a5c. Lapisan 4 (019) diterapkan: CustomerContactCard.
  Tes komponen 4 lulus; check_all HIJAU: 1051 lulus/1 skip, REPO_MAP 1063.
  Bukti: TEMP/laurum-detail-layer4-complete-check.log (exit 0).
- 020 belum diterapkan; FormScaffold detail menunggu 019 hijau.
- Page/Section kedua layar BELUM diubah; tunggu gerbang lapisan di atas.

## Langkah berikutnya
1. Simpan 019 yang sudah hijau, lalu terapkan 020 dengan tes keyboard.
2. Gerbang 020: golden default tetap dan check_all hijau sebelum kedua Page.
3. Terapkan Page/Section 25 lalu 09, semua data/callback/provider lama tetap.
4. Golden dampak dicatat sebelum update; verifikasi Android termasuk keyboard
   usulan, check_all akhir, STATE dan commit. Jangan push/merge.

## Batas paritas penting
- Usulan: pelanggan baru/terdaftar, sumber pesan lengkap, cancel/tolak/approve,
  alamat kurang pasti, pending/error/final, idempotensi dan tombol WhatsApp tetap.
- Order: subtotal/diskon/catatan, semua pembayaran/aktivitas, mode status/sederhana,
  COD held/final, menu, Edit/Hapus/cetak/complete/terima pembayaran tetap.
- State/data/domain/repository, rute, Formatters, PRD/lint/dependensi tidak diubah.
- Tidak ada warna/font/ukuran baru; token global dan target sentuh yang ada dipakai.

## Sebelumnya dan lingkungan
- Loader lokal 017 selesai (49dd172): satu gate terpusat + deskripsi, menunggu
  data awal; refresh tidak melepas navigator. 1042 tes lulus/1 skip, Android diuji.
- Auth final 5860dd7; UI 015/016 selesai. iOS belum diuji.
- Backend: B3b/B2e+ menunggu; Drift/wire v5, cloud 5/5 oleh pemilik.
- Sebelum Dart/Flutter: . ./tool/windows_native_sdk.ps1; BOT=true.
- FigCraft sudah berubah sebelum sesi, tidak masuk commit implementasi.
- Rencana: docs/plans/018-detail-ai-order.md; proposal 018/019/020; spec 25/09.
- Riwayat lama: docs/progress/state-history-2026-11-10.md.
