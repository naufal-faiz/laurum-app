# 018 � Lapisan molecules: header dan status detail
Status: DISETUJUI pengguna 11 Nov 2026 (setujui ketiganya). Acuan: FigCraft 512 dan 612 dibaca 11 Nov 2026.
Lapisan UI-21: 3; token dan atoms yang diperlukan sudah tersedia, tidak diubah.

## API dan tampilan
- AppBarSub: tambah subtitle String? = null dan variant AppBarSubVariant.standard
  (standard/detail). Default mempertahankan tampilan seluruh pemanggil lama.
- detail: judul primaryInk, subjudul ink3, kembali lewat SVG cursor-back yang sudah
  ada, target sentuh 48 dp. Susunan intrinsik membungkus ketika sempit/teks besar;
  status dan menu tetap dapat dicapai. Tidak memotong judul dengan ellipsis.
- SectionHeader: tambah trailing Widget? = null untuk informasi seperti jumlah
  layanan di kanan, tanpa membuat tombol mati. Action lama tetap tersedia.
- PaymentBadge baru: PaymentBadge({required String label, required PayStatus status}).
  Hanya presentasi label turunan yang sudah ada; lunas memakai successTint/Ink,
  DP warningTint/Ink, sisa belum lunas errorTint/Ink. Tidak menghitung pembayaran.
  Susun atom AppText + radius/padding/palet yang sudah ada, tanpa fitur/provider.
- AppIcons.edit/dot dipetakan ke padanan Ionicons sesuai UI-14 bila belum tersedia;
  tidak menambah dependensi. Sumber ikon dan padanannya dicatat saat implementasi.

## Lingkup dan dampak
Berkas: app_bar_sub.dart, section_header.dart, payment_badge.dart, registry
(molecules), app_icons.dart bila perlu. Tidak ada nilai warna/ukuran/font baru.
Layar sasaran: Periksa Usulan AI dan Detail Order. Pemanggil lama default tetap.

## Bukti wajib sebelum lapisan 4
Tes header default/detail, kembali/menu, sempit 320 dp dan teks 2x, status dan
warna badge termasuk label COD panjang, trailing informatif tanpa callback.
Golden baru komponen; app_icon.png bila palet menambah entri. Tidak memperbarui
layar lama tanpa daftar alasan. check_all hijau sebelum lanjut ke lapisan 4.

Bukti selesai: check_all exit 0, 1047 tes lulus/1 skip, REPO_MAP 1060 berkas.
10 tes komponen + 1 palet ikon lulus. Golden baru detail_molecules.png; satu
golden lama app_icon.png berubah karena glyph edit/dot, sesuai daftar dampak.
Log lokal: TEMP/laurum-detail-layer3-check.log. API lama default tetap.
