# STATE Laurum
Diperbarui: 2026-11-11 | Cabang newdesign

## Sesi aktif
Layar 02 Buat Transaksi; dasar commit d156170.
FigCraft terhubung; pengguna memilih 691, dibaca sekali (tersimpan dalam spec).
Pasangan frame 752 + adaptasi pembayaran/estimasi/catatan menunggu jawaban.

## Status irisan
- Header detail/subjudul/Draft, kartu pelanggan kosong dan dua aksi, footer total
  + Bayar sejajar sudah diterapkan. Body memakai padding 24 dp sesuai frame.
- Kartu pelanggan terpilih masih MenuRow lama dalam AppCard; layanan terisi,
  tombol sampah, Ringkasan dan susunan detail BELUM dikerjakan.
- TransactionFooterSection baru (data/callback); tidak ada komponen bersama baru.
- Paritas awal di spec 02 belum dicentang. Provider/aksi/state/rute tetap.
- Snapshot/screenshot: 0. Visual belum diverifikasi manual; iOS belum diuji.

## Keputusan pengguna terbaru
Akurat dengan FigCraft; sampah dan edit berat harus sama-sama tersedia.
Ambang usage 10%: persentase akun tidak tersedia di alat; siapkan handoff sebelum
kapasitas habis. Pilihan aktif yang dibaca setelah pengguna bertanya ID adalah 691.
Pertanyaan async terbuka: pakai pasangan 752 untuk isi, bayar/COD tetap di langkah
Pembayaran, estimasi/catatan setelah Ringkasan. Jangan menganggap sudah disetujui.

## Belum di-commit
Progres awal disimpan dalam commit wip; FigCraft pengguna dikecualikan.
File baru: transaction_footer_section.dart dan transaction_footer_section_test.dart.
Stash f7a9e49 lama sudah diterapkan; jangan apply ulang.

## Langkah berikutnya
1. Tunggu jawaban pertanyaan async; baca 752 sekali hanya jika disetujui.
2. Selesaikan layanan + sampah + edit berat, Ringkasan dan detail; aksi lama tetap.
3. Cek diskon saat hapus: remove saat ini mempertahankan diskon, berpotensi total
   negatif bila subtotal menurun. State beku; minta izin jika perlu memperbaiki.
4. Tes/golden/keyboard/320 dp/2x; check_all sekali di akhir, paritas dan diff.
5. Satu commit feat(ui) akhir, lalu tinjauan pengguna. Jangan push/merge.

## Blocker
UI-4/UI-9/UI-10: acuan varian isi dan penempatan fungsi di luar frame belum
dikonfirmasi. Jangan menambah pilihan PayStatus manual (Lunas) dari frame.

## Bukti terakhir
- Tes footer/pelanggan/Page 9 lulus; keyboard catatan/Bayar 300 dp 1 lulus.
- Scoped flutter analyze 3 berkas: no issues; check_arch OK; diff --check bersih.
- Finder diubah hanya label Baru -> Pelanggan baru dan kapitalisasi judul;
  tes pelanggan memakai font Inter asli agar pengujian 320 dp/2x akurat.
- check_all belum dijalankan karena irisan belum selesai; golden belum diperbarui.