# R4 - Mode status order (parsial)
Diperbarui: 31 Oktober 2026. Fondasi/repository tervalidasi; Detail terhubung.
R4 belum selesai: toggle, Antrean, checkout dan persetujuan AI belum terhubung.

## Fondasi
- BusinessProfile.useOrderStatus default true, termasuk equality. Fixture memakai
  default true. withOrderStatus(enabled: ...) menyalin data dan metadata.
- Info Usaha membaca profil terkini saat menyimpan; copyProfile printer ikut
  mempertahankan mode. Dua belas tes fondasi/preservasi profil lulus.
- nextStatus dan Order.withStatus menerima useOrderStatus, default true. Hanya mode
  false yang mengizinkan diproses/menunggu jemput langsung selesai; pembatalan/final terjaga.
- initialOrderStatus dan orderStatusLabel tersedia untuk integrasi checkout/AI/UI.

## Repository (kelompok 31 Oktober)
- OrderRepository.saveOrder dan updateOrderStatus menerima useOrderStatus opsional,
  default true. InMemoryOrderRepository meneruskannya hingga writeOrderStore.
- Snapshot yang dibentuk dengan mode false tetap ditolak jika disimpan melalui
  repository dalam mode aktif. Kedua jalur harus memakai policy yang sama.
- Sembilan tes baru lulus: default/normal chain, penyelesaian langsung order belum
  lunas dengan event dan ledger tetap, status final tidak bisa dibuka kembali,
  pembatalan final, item tidak valid gagal atomik, dan larangan pembatalan berbayar
  tanpa koreksi ledger. Tes baru gagal sebelum kontrak API ditambahkan, lalu lulus.
- Berkas sumber repository tetap <= 100 baris. Tidak ada dependensi/registry/tema baru.

## Detail Order (kelompok lanjutan 31 Oktober)
- Mode aktif tetap memakai menu dan CTA lama. Mode sederhana: Edit/Hapus/Selesaikan;
  order final hanya Cetak struk. Hapus memakai pembatalan/koreksi ledger yang ada.
- Selesaikan membuka konfirmasi cetak, memakai ReceiptView segar dan ReceiptPrint.
  Hanya sukses cetak yang menyimpan selesai + OrderEvent; utang tetap tercatat.
- Gagal/exception/batal: tetap aktif, error dan aksi tanpa cetak. Tanpa cetak wajib
  konfirmasi terpisah; membatalkan konfirmasi tidak mengubah data.
- ReceiptPrint mengembalikan bool, menangani exception dan menolak cetak bersamaan.
  Controller per order memblokir ketukan ganda dan memeriksa ulang order/profil
  sesudah cetak, sehingga pembatalan/perubahan saat cetak tidak ditimpa.
- Keputusan pengguna: order lama Menunggu jemput boleh langsung selesai dalam mode
  sederhana setelah cetak sukses. Policy dan tes fondasi disesuaikan; mode aktif tetap.
- ContentSection menjadi Stateless; utang Section 24 -> 23. Empat Section Detail
  tercakup tes layar. Golden baru r4_order_detail.png ditinjau pada 390 x 844.
- 12 tes baru: penyelesaian belum lunas, exception/gagal/batal/fallback, modal Hapus,
  order lama, mode berubah, ketukan/cetak ganda, dan navigasi Edit. Tes logika dibuat
  dahulu dan gagal karena API belum tersedia, lalu lulus. Pemeriksaan penuh hijau.
- Tidak ada dependensi, registry, tema atau PRD diubah. Spec 09 diperbarui; variasi
  footer R4 dicatat sebagai selisih .pen. Printer nyata/Android/iOS belum diuji.

## Bukti validasi terakhir
Perintah: dart run tool/check_all.dart, 31 Oktober 2026.
```text
Formatted 460 files (0 changed)
flutter analyze: No issues found!
dart analyze: No issues found!
check_arch: OK
+408: All tests passed!
REPO_MAP diperbarui: 528 berkas
check_all: SEMUA HIJAU
```
Log lengkap: TEMP/laurum-r4-detail-all.log. Repository sebelumnya lulus 396 tes.
Sebelumnya validasi draf awal juga lulus 387 tes setelah lint dan dua golden R3
(dirender dan ditinjau) diperbaiki. R3 selesai otomatis; Android/iOS manual R3/R4
belum dilakukan pada sesi ini.

## Langkah berikutnya
1. Provider/toggle pengaturan: baca profil terkini dan simpan langsung; migrasikan
   SettingsMenuSection yang disentuh menjadi Stateless dengan callback.
2. Antrean: sembunyikan aksi maju/menu status/chip Jemput-Proses-Siap dalam mode
   sederhana; pertahankan Semua/Perlu dicek. Migrasikan Section utang saat disentuh.
3. Checkout/AI: teruskan profile.useOrderStatus saat membuat order baru dan menyimpan
   ke repository; mode false langsung diproses. Detail sudah tersambung, tetapi
   jangan aktifkan toggle sebelum semua caller/layar tersambung.
4. Catat kolom businesses.use_order_status bool default true di PRD B sesuai izin
   tertulis R4; spec 09 selesai, perbarui spec 01/19 dan tes layar dua mode.
5. Tiap kelompok: format/analyzer/check_all, tinjau golden bila berubah, STATE,
   commit. R5 menunggu R4 selesai. Tidak push/merge tanpa izin pengguna.
