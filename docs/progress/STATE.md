# STATE Laurum
Diperbarui: 2026-11-11 | Cabang `newdesign`

## Fokus terakhir pengguna: koreksi Periksa Usulan AI, lalu hentikan sesi
- Dasar sesi 49dd172; commit terakhir f08cdcb (penerapan awal layar 25).
- Pengguna membatasi fokus ke layar 25. Detail Order DITUNDA; perubahan lokal
  disimpan dapat dipulihkan di stash@{0}: wip: Detail Order ditunda, fokus koreksi usulan AI.
  Jangan terapkan stash atau lanjutkan Order sebelum diminta.
- FigCraft live dibaca read-only: 512; rincian 537/586 dibaca ulang saat koreksi.
- Graph codebase transport closed; REPO_MAP/sumber langsung menjadi bukti.

## Gerbang komponen yang selesai
- 018 molecules: 9307a5c, check_all 1047 lulus/1 skip, REPO_MAP 1060.
- 019 CustomerContactCard: 4325a7c, 1051 lulus/1 skip, REPO_MAP 1063.
- 020 FormScaffold detail: 333fadf, 1054 lulus/1 skip, REPO_MAP 1064.
- Layar 25 awal: f08cdcb, check_all 1060 lulus/1 skip, REPO_MAP 1071.
  Android SM-N975F + keyboard alamat diperiksa; semua data/aksi lama tetap.

## Selesai: koreksi 021 (lapisan molecules + komposisi layar 25)
- Header judul/sub tanpa gap tambahan, badge ditengah tinggi kelompok teks.
- Sumber dan akurasi satu Row spaceBetween, tidak membungkus ke baris terpisah.
- Kartu layanan: nama, berat belum diketahui, tarif, pemisah; pilihan layanan
  tetap inline sesuai adaptasi 020, tidak menambah aksi berat/jadwal jemput.
- Alamat: hilangkan label berulang, padding ringkas dan field dense; maxLines3,
  selectAll, callback tetap. Ikon perisai center.
- CalloutAi.compact opt-in: caption + badge Periksa bagian ini, ikon center;
  ProposalCard dan pemanggil default tetap.
- Pengguna mengubah BannerMessage ke caption lalu menegaskan berlaku GLOBAL.
  Semua banner caption13, ikon center, info primaryInk agar tetap tegas.
- Proposal 021 mencatat otorisasi dari instruksi koreksi pengguna.
- Tes posisi/perilaku akhir 17 lulus, golden/layout usulan akhir 6 lulus.
  Golden komponen 12 lulus. Header/320dp/2x/keyboard diuji.
- Golden total yang berubah 16: 6 lingkup layar 25 dan 10 dampak banner global
  (add_customer_sheet, ai_settings_disconnected, antrean_whatsapp,
  auth_signin_error, printer_page, r10_signin_error, r10_signin_error_320_2x,
  sync_offline, whatsapp_connected, whatsapp_waiting); daftar resmi di proposal 021
  untuk persetujuan UI-28.
- Android akhir diperiksa: header/pesan/akurasi/kartu/alamat/badge/perisai serta
  keyboard/selectAll/footer lulus; TEMP/laurum-ai-corrected-*.png.
- check_all akhir: SEMUA HIJAU, 1063 lulus/1 skip, REPO_MAP 1072.
- Artefak test/failures dikembalikan ke HEAD dan yang tidak terlacak dihapus.

## Langkah berikutnya (hanya AI)
1. HENTIKAN sesi: pengguna meninjau koreksi 021 dan daftar 16 golden.
2. Setelah disetujui, lanjut layar berikutnya sesuai rencana redesign-atomic.
3. Detail Order tetap DITUNDA di stash@{0} sampai pengguna meminta.

## Batas dan lingkungan
- Provider/draf/validasi/aksi/argumen tetap. Skor AI hanya contoh dari scope dummy.
- State/data/domain/rute/Formatters/repository/PRD/lint/dependensi tidak diubah.
- FigCraft pengguna sudah dirty sebelum sesi, tidak ikut commit.
- Peninjauan otomatis menolak restore massal; alternatif git stash menyimpan
  seluruh perubahan Order tanpa membuang edit. Tidak ada blokir tersisa.
- SDK: . ./tool/windows_native_sdk.ps1; BOT=true; SM-N975F wireless tersambung.
- iOS belum diuji. Loader49dd172/auth5860dd7 tetap; backend menunggu B3b/B2e+.
- Rencana 018; proposal018-021; spec25/09; riwayat state-history-2026-11-10.md.
