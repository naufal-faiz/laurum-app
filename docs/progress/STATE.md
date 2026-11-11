# STATE Laurum
Diperbarui: 2026-11-11 | Cabang `newdesign`

## Sesi aktif dan keputusan
- Koreksi terbaru pengguna: loader ditujukan untuk gate Membuka data lokal di
  lib/app.dart, terpusat di layar dengan deskripsi tetap; hilangkan loading berulang.
- Belum diterapkan: MCP FigCraft tidak tersedia (prasyarat redesign gagal).
  Git dasar 2c96aa1, hanya FigCraft sudah berubah sebelum tugas; kode belum diubah.
- Dasar sesi 948f5ef: Antrean 015 selesai, check_all 1036 lulus/1 skip.
- Sesi 016: koreksi Antrean dan implementasi loader 014 diminta pengguna.
- Prasyarat: branch newdesign, frame FigCraft 408 berhasil dibaca ulang via MCP.
- Header LAURUM label hasil perubahan pengguna dipertahankan; slot tinggi 64
  mengikuti skala teks. Ringkasan tanpa padding vertikal; jarak sebelum chip
  hanya dari padding daftar. Jumlah dan sync tetap di body.
- Subjudul Rekomendasi AI / Antrean berjalan warna primary sesuai permintaan.
  Selisih frame (primaryInk) dicatat pada spec Antrean.
- Filter memakai AppBottomSheet pada navigator utama agar menutupi nav/Transaksi;
  lima opsi, provider, callback, COD, query, seluruh data/aksi lama tetap.
- Loader: permintaan pengguna menjadi izin implementasi proposal 014, paket
  Lottie dan registrasi AppLoader. flutter pub add meresolusikan lottie 3.8.2.
- Implementasi memilih aset refined, disalin utuh ke assets/animations/.
  Ukuran token global 96; semantics; reduced motion/TickerMode memakai frame 50%
  yang terlihat (frame awal aset kosong). Tidak menambah penundaan/data/state.
- Loading Beranda dan Antrean memakai AppLoader. Kosong/error/retry tetap.
- Lapisan token/atom/molekul/organisme/template dan komposisi mengikuti lingkup
  koreksi 016 + proposal 014; tidak ada perubahan state/domain/repository/rute.

## Verifikasi
- Tes terarah 14 lulus (loader/aset/semantics, jarak/warna, modal root,
  perubahan status, loading->kosong, keyboard 300 dp, pencarian/nav).
- Tes golden terkait 13 lulus; sembilan berkas terdampak tercantum di proposal 016.
- Golden loading statis sudah diperiksa: logo rumah/mesin tampil, bukan kosong.
- check_all HIJAU, exit 0: format 977 (0 berubah), analyze/Riverpod bersih,
  check_arch OK, 1040 tes lulus/1 skip, REPO_MAP 1055 berkas.
  Bukti lokal: TEMP/laurum-loader-check-all-complete.log (10 Nov 2026).
- Android SM-N975F: jarak ringkasan, warna, modal di atas nav/Transaksi dan
  pencarian dengan keyboard terbuka diverifikasi. Pengguna mengaktifkan mode status.
  Loader visual via golden; gerakan/berhenti via tes. iOS belum diuji.
- Tes lama: finder loading AppSkeleton->AppLoader, host disableAnimations default
  false; golden loading reduced motion. Signup menguji tanpa ikon, callback/busy
  tetap utuh; berkas dirapikan dari 121 ke 110 baris, tidak ada tes yang dibuang.
- Rincian paritas: docs/design/screens/01-antrean-beranda.md dan proposals/016.

## Langkah berikutnya
1. Setelah FigCraft tersedia, koreksi sasaran loader lokal dan loading sekunder;
   pertahankan deskripsi, error/retry dan perilaku data. Uji gate + perpindahan state.
2. Auth final + sembilan golden sudah disimpan dalam commit 5860dd7.
   Total sembilan golden Antrean + sembilan auth; daftar/alasan pada proposal 016.

## Batas dan backend
- UI100/R0-R10, BP0, B1a-f, B0, B2a-d, B3a, B3c selesai; B3b dan B2e+ menunggu.
- Backend berikut: cloud/workmanager Android, Google login, lalu B3b;
  docs/plans/B3-auth.md. Drift/wire v5, cloud 5/5 oleh pemilik.
- PayStatus turunan, COD bersisa ditahan, multi-repo TransactionRunner.

## Lingkungan dan Git
- Sebelum Dart/Flutter: . ./tool/windows_native_sdk.ps1; BOT=true.
- FigCraft tidak disertakan commit; perubahan auth final + golden diizinkan pengguna.
  Header Antrean label pengguna dipertahankan sebagai bagian tata letak 016.
- Jangan push/merge. Riwayat lama: docs/progress/state-history-2026-11-10.md.
