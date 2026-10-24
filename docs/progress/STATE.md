# STATE Laurum
Diperbarui: 2026-10-24 | Cabang dev1

## Posisi
Prompt 50 SEDANG: Daftar Pelanggan diimplementasikan; Detail/Edit belum dikerjakan.
Sesi dibatasi satu layar sesuai AGENTS.md. Tunggu tinjauan sebelum bagian berikutnya.
Validasi akhir: check_all SEMUA HIJAU; 276 tes; kedua analyzer bersih; check_arch OK;
format 362 berkas (0 berubah); REPO_MAP 429 berkas.

## Selesai
- Fase 1: 60/60 widget, domain inti, fixture, Widgetbook.
- Prompt 20-40: Antrean, transaksi, pembayaran/nota, printer palsu, Detail/Edit Order,
  dan Riwayat Nota. Baseline sesi: check_all hijau, 269 tes.
- /pelanggan: pencarian nama/nomor normalisasi, tiga filter dengan jumlah dinamis,
  CustomerRow, tambah cepat, loading/kosong/tanpa hasil/error/retry.
- Sheet tambah memakai navigator utama dari tab; banner disesuaikan konteks daftar.
- Tujuh tes baru: data/filter, pembatalan reaktif, pencarian/rute, tambah pelanggan,
  loading/kosong, error/retry, dan layar 320 px pada teks 2x.

## Sedang dikerjakan
- Tidak ada. Daftar Pelanggan selesai; tunggu tinjauan sebelum Detail/Edit.

## Antrean
1. Tinjau /pelanggan di HP/emulator: cari nama/nomor, filter, tambah dengan keyboard.
2. Lanjut docs/prompts/50-pelanggan-a.md bagian Detail Pelanggan, lalu Edit pada
   sesi berikutnya. /pelanggan/:id masih placeholder; prompt 50 belum selesai.
3. Setelah prompt 50: docs/prompts/51-pelanggan-b.md (tabungan dan impor kontak).
4. Tinjauan order prompt 40, APK/NDK, iOS, TalkBack/VoiceOver, printer nyata ditunda.

## Keputusan dan batas
- Daftar pelanggan menghitung jumlah chip dari seluruh pelanggan aktif, tanpa query.
- Piutang/saldo memakai repository terbaru. Riwayat dummy = baseline pelanggan +
  snapshot order kini - fixture awal; order batal/dihapus dikecualikan.
- Tanpa baseline, jumlah order/total dihitung dari order kini; tidak membuat nota fiktif.
- Tambah berhasil mereset query/filter; tidak mengubah draf transaksi dari tab Pelanggan.
- Impor kontak placeholder prompt 51; telepon masih ExternalLauncher palsu.
- Selisih .pen: urutan repository, jumlah Semua/Punya tabungan mengikuti prompt,
  DP tanpa nomor nota, CTA tambah tetap di footer. Spec: 12-daftar-pelanggan.md.
- Order: status maju berurutan; edit mempertahankan ID item dan ditolak bila total
  kurang dari pembayaran. Pembatalan menyimpan koreksi order sebelum penyesuaian
  tabungan; rollback lintas repository belum tersedia.
- GoRouter push dalam shell tidak memperbarui routeInformationProvider; tes memakai
  isi layar/canPop. AppBottomSheet di navigator tab memotong tinggi sheet; pemanggilan
  Daftar kini lewat navigator utama tanpa mengubah widget bersama.
- Atom/token/registry/lint/PRD tidak diubah. Tanpa dependensi baru.

## Pemeriksaan dan batas
- Frame daftar dan state dibaca lewat pen_frame; tidak ada PNG referensi di screens/png.
- Perangkat Android/iOS, TalkBack/VoiceOver, keyboard/telepon nyata belum diuji.
- Tool AI Memory tidak tersedia; konteks tersimpan di repo.
- Tidak push/merge. Tunggu tinjauan layar Daftar sebelum melanjutkan.
