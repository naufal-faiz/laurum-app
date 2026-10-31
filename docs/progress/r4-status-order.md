# R4 - Mode status order (SELESAI otomatis)
Diperbarui: 31 Oktober 2026. Seluruh integrasi tersedia tervalidasi: 428 tes hijau.
Toggle dapat dipakai di Lainnya -> PENGATURAN -> Pakai status order.

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

## Penutupan: toggle, checkout dan audit AI
- Pengguna meminta R4 hingga selesai, sehingga kelompok tersisa dikerjakan dalam
  sesi yang sama. Toggle tersedia di Lainnya -> PENGATURAN -> Pakai status order.
- Default aktif; simpan langsung melalui repository dengan membaca profil terkini.
  Selama saving/loading switch disabled; error tidak mengubah nilai tersimpan dan
  bisa dicoba lagi. Ketukan ganda tidak menggandakan penyimpanan.
- Profil/ReceiptView diinvalidasi agar Antrean/Detail segera mengikuti pilihan.
  Tidak menulis order/event/payment saat toggle. Metadata/profil lain tetap utuh.
- SettingsMenuSection kini tanpa go_router, navigasi lewat callback. Kelompok
  SettingsOperationalSection menerima data/callback saja. Utang Section 23 -> 22.
- Checkout memakai initialOrderStatus(source kasir, useOrderStatus profil terbaru),
  meneruskan policy ke saveOrder; event created mengikuti status aktual. Helper
  event di checkout_item menjaga checkout_save 100 baris.
- OrderActions.advance memeriksa profil terbaru sehingga callback Detail lama
  tidak melewati syarat penyelesaian/cetak saat mode status nonaktif.
- Audit graph + grep terarah: features/proposals hanya repository/data, rute
  /antrean/usulan/:id masih placeholder prompt 80. Belum ada caller persetujuan
  pembentuk order AI. R4 meminta integrasi bila sudah ada; fitur 80 tidak dibangun.
  initialOrderStatus untuk whatsappAi kedua mode sudah diuji pada fondasi R4.
- Daftar Piutang tidak menampilkan badge status order. Tes alur baru membuktikan
  nota selesai belum lunas tetap menambah piutang; Hapus dengan tabungan mengembalikan
  saldo dan menghapus dampak tagihan melalui ledger koreksi, bukan hard delete.
- Sembilan tes baru: toggle/retry/busy, Section operasional, kedua mode/koneksi,
  checkout setelah toggle -> cetak sukses/gagal/fallback, Hapus bertabungan,
  layar 320 px/teks 2x dan golden r4_settings.png (ditinjau).
- Spec 19/katalog dan satu kolom businesses.use_order_status bool default true
  pada PRD B disinkronkan sesuai izin R4. Registry/tema/dependensi/fixture tetap.
- Lint urutan impor dirapikan; kontrol simulasi save gagal dipindahkan ke objek
  biasa agar helper Notifier tidak punya properti publik. Tanpa ignore/perubahan lint.

## Bukti validasi terakhir
Perintah: dart run tool/check_all.dart, 31 Oktober 2026.
```text
Formatted 475 files (0 changed)
flutter analyze: No issues found!
dart analyze: No issues found!
check_arch: OK
+428: All tests passed!
REPO_MAP diperbarui: 543 berkas
check_all: SEMUA HIJAU
```
Log lengkap: TEMP/laurum-r4-complete-all.log. Antrean sebelumnya 419, Detail 408,
repository 396 tes.
Sebelumnya validasi draf awal juga lulus 387 tes setelah lint dan dua golden R3
(dirender dan ditinjau) diperbaiki. R3 selesai otomatis; Android/iOS manual R3/R4
belum dilakukan pada sesi ini.

## Berikutnya
1. R4 selesai otomatis; tidak ada pekerjaan integrasi R4 yang tertunda pada alur tersedia.
2. Tinjauan perangkat Android/iOS/pembaca layar dan printer nyata belum dilakukan;
   cetak pada sesi ini memakai PrintService palsu sesuai kontrak proyek.
3. Setelah R4 ditutup, prompt berikut R5-laporan-rentang.md; jangan mulai pada sesi
   penutupan R4 ini. Saat prompt 80 membangun persetujuan, wajib memakai policy
   status awal dari profil terkini untuk source whatsappAi.
