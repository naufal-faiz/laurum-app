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
- Paritas 25 selesai; paritas 09 menunggu penerapan.

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
- 019 disimpan di 4325a7c. Lapisan 5 (020) diterapkan: FormScaffold detail.
  Enam tes terarah lulus termasuk default, 320 dp/2x dan keyboard 300 dp.
  Golden baru detail_form; check_all HIJAU: 1054 lulus/1 skip, REPO_MAP 1064.
  Bukti: TEMP/laurum-detail-layer5-check.log, exit 0; default golden tetap.
- 020 disimpan di 333fadf. Lapisan aktif 6: layar 25 diterapkan.
  Header/kontak/pesan/layanan/alamat/privasi/footer; data/aksi lama tetap.
  Tes lama 11 + baru 6 lulus, golden rina/new_customer diperbarui (4 tes lulus).
  Android SM-N975F: dibandingkan frame 512, alamat + footer di atas keyboard.
  check_all HIJAU: 1060 lulus/1 skip, REPO_MAP 1071, exit 0.
  Bukti TEMP/laurum-detail-ai-final-check.log. Detail Order belum disentuh.

## Langkah berikutnya
1. Simpan layar 25 yang sudah hijau, lalu terapkan layar 09.
2. Detail Order: nota/status/kontak/rincian/pembayaran/timeline/footer sesuai mode.
3. Golden dampak sudah dicatat; Android, check_all akhir, STATE dan commit.
   Jangan push/merge.

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
