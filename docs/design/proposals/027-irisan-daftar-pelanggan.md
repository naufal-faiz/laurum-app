# 027 — Irisan daftar pelanggan

Status: MENUNGGU PERSETUJUAN pengguna (UI-13).
Branch ui/pelanggan dari backend-newdesign, dasar 4f14852.
Merge kembali hanya dengan persetujuan eksplisit pengguna.
Acuan: LAURUM · Pelanggan, frame 4294969460 (390 × 844).

## Komponen bersama
- CustomerRow: padding/jarak lebih rapat menggunakan token global yang ada.
- Susunan: avatar/nama/nomor; status dalam Wrap sejajar; ringkasan order/total di bawah.
- WhatsApp menggunakan varian AppIconButton.tileSuccess yang sudah tersedia.
- Status Belum bayar atau DP + Sisa dan tabungan dipertahankan seluruhnya.
- API nama/parameter/default/callback tetap; tanpa widget/token/dependensi baru.
- Dampak: daftar pelanggan dan galeri CustomerRow; golden terkait diperbarui.

## Page/Section setelah komponen disetujui
- Margin horizontal 24, gap 10/12 memakai AppSpacing yang tersedia.
- Aksi impor/tambah sejajar pada lebar frame; bertumpuk jika ruang/teks memerlukan.
- Tinggi aksi tetap 48 sesuai revisi terdahulu; chip tetap dapat digulir.
- Header tetap memakai jumlah pelanggan; jumlah pemilik piutang memerlukan izin
  tersendiri untuk perubahan pembacaan data RootShell (belum termasuk proposal).
- Seluruh pelanggan tetap dapat digulir; tanpa batas tiga baris atau aksi Lihat semua.
- WhatsApp tanpa nomor tetap disabled di daftar sesuai kode saat ini.
- Detail/struk tanpa nomor tidak diubah dalam irisan visual ini.

## Verifikasi
- Pertahankan tes callback, filter, pencarian, keyboard300dp, viewport320 dan DP/Sisa.
- Tes CustomerRow/Section, golden terdampak, lalu check_all sekali di akhir irisan.
- Satu commit feat(ui) untuk irisan selesai; detail pelanggan adalah irisan berikutnya.
