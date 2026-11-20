# 031 — Irisan Tambah layanan
Status: DISETUJUI14Nov2026: "Ya lakukan"; dasar0e81c8d; frame4294968237.
Acuan: LAURUM · Tambah Layanan,390×844, pilihan aktif pengguna di FigCraft.

## Komponen bersama (UI-13; satu persetujuan)
- AppCard: gradient=false opsional; mode true untuk primary memakai gradient
  diagonal heroGradientStart→heroGradientEnd yang sudah ada; bubble tetap.
- AppBadge: varian inverse, latar illustration dan teks onPrimary untuk chip
  pratinjau; semua varian/default lama tetap.
- AppTextField: prefixText=null opsional, diteruskan melalui dekorasi tema,
  untuk Rp; hint0 tetap kosong; scroll atas field padat menjaga tepi saat keyboard.
- SelectionTile: compact=false opsional; mode true berikon, judul/subjudul,
  latar selected primaryTint/idle surfaceLow, tanpa radio; default lama tetap.
- Nilai warna/radius/font/spacing memakai token yang tersedia; tanpa dependensi.
- Ikon tas/power dipetakan ke Ionicons terpasang; tidak membuat SVG baru.

## Page/Section (hanya tambah)
- FormScaffold detail yang sudah ada: header/subjudul, padding24, konten scroll.
- Izin UI-8: baca profil usaha yang sudah ada hanya untuk subjudul nama usaha;
  jangan menyalin contoh Shanum Laundry. Provider form dan aksi simpan tetap.
- Pratinjau reaktif nama, tipe, harga/unit dan durasi memakai ServiceEditState.
- Kartu Informasi layanan dan Durasi & status; catatan ketersediaan di kasir.
- Footer Batal/Simpan sejajar; bertumpuk bila sempit/font besar/keyboard perlu.
- Edit layanan mempertahankan layout/binding lama; tidak redesign layar lain.
- Default kiloan, harga kosong,2hari,aktif; validasi/error/busy/urut fokus tetap.
- Tidak mengubah state/data/repository/rute/perhitungan uang atau perilaku simpan.
## Verifikasi
- Tes semua varian baru/default, callback/validasi/simpan/batal/akses dari kasir.
- Golden tambah dan komponen berubah; font1–2×,280–600dp, keyboard300dp.
- check_all akhir; satu commit irisan setelah hijau; tanpa push/merge.
