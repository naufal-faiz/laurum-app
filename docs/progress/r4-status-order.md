# R4 - Mode status order (parsial)
Diperbarui: 31 Oktober 2026. Fondasi/repository/Detail/Antrean tervalidasi otomatis.
R4 belum selesai: toggle, checkout dan persetujuan AI belum terhubung.

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

## Antrean (kelompok lanjutan 31 Oktober)
- Mode sederhana hanya chip Semua/Perlu dicek. ID internal 0/4 tetap, chip kedua
  memilih usulan. Filter status lama tampil sebagai Semua tanpa mengubah provider
  atau order; mode aktif kembali memakai pilihan lama. Perlu dicek tidak hilang.
- AntreanOrdersSection Stateless menerima domain/view-data dan callback. Tombol
  progres disembunyikan, label diproses 'Sedang dikerjakan', kartu tetap bisa dibuka.
- OrderCard showAction default true (izin R4). statusLabel opsional disetujui
  pengguna 31 Oktober; proposal 001 mencatat izin. Null tetap memakai label enum.
  API label dan visibilitas tombol terpisah; tetap hanya dua mode pengaturan.
- Callback maju lama diblokir setelah membaca profil repository terbaru. Tidak
  mengubah order/event; pending tetap dibersihkan. Mode aktif tetap bisa maju.
- Perlu dicek yang kosong memakai pesan khusus. Tolak tetap hanya mengubah usulan.
- 11 tes baru: pemetaan, guard, callback Section, perpindahan mode/filter, usulan,
  label/visibilitas kartu, serta alur cetak dari Antrean sampai order hilang pada
  390 px dan 320 px/teks 2x. Tes logika gagal dahulu, kemudian lulus.
- Tujuh golden Antrean aktif tetap cocok. Golden r4_antrean_sederhana.png dan
  order_card.png (galeri mendapat varian tambahan) sudah dirender dan ditinjau.
  Spec 01/katalog diperbarui; .pen tidak punya varian sederhana, selisih dicatat.
- Tidak ada perubahan tema/token/registry/dependensi/PRD/fixture. Utang Section tetap
  23; Page 95, OrderCard 99, OrdersSection 50, StatusSection 74 baris.
- check_all penuh hijau setelah empat lint const pada tes baru diperbaiki tanpa ignore.

## Bukti validasi terakhir
Perintah: dart run tool/check_all.dart, 31 Oktober 2026.
```text
Formatted 467 files (0 changed)
flutter analyze: No issues found!
dart analyze: No issues found!
check_arch: OK
+419: All tests passed!
REPO_MAP diperbarui: 535 berkas
check_all: SEMUA HIJAU
```
Log lengkap: TEMP/laurum-r4-antrean-all.log. Detail sebelumnya 408, repository 396 tes.
Sebelumnya validasi draf awal juga lulus 387 tes setelah lint dan dua golden R3
(dirender dan ditinjau) diperbaiki. R3 selesai otomatis; Android/iOS manual R3/R4
belum dilakukan pada sesi ini.

## Langkah berikutnya
1. Provider/toggle pengaturan: baca profil terkini dan simpan langsung; migrasikan
   SettingsMenuSection yang disentuh menjadi Stateless dengan callback.
2. Checkout/AI: teruskan profile.useOrderStatus saat membuat order baru dan menyimpan
   ke repository; mode false langsung diproses. Antrean/Detail sudah tersambung, tetapi
   jangan aktifkan toggle sebelum semua caller/layar tersambung.
3. Uji alur lengkap lewat toggle sungguhan setelah integrasi checkout/AI; termasuk
   gagal cetak tetap di antrean, fallback, Hapus dan piutang. Provider profil perlu
   diinvalidasi saat toggle disimpan agar seluruh layar langsung berubah.
4. Catat kolom businesses.use_order_status bool default true di PRD B sesuai izin
   tertulis R4; spec 01/09 selesai, perbarui spec 19 dan tes layar dua mode.
5. Tiap kelompok: format/analyzer/check_all, tinjau golden bila berubah, STATE,
   commit. R5 menunggu R4 selesai. Tidak push/merge tanpa izin pengguna.
