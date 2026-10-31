# R4 - Mode status order (parsial)
Diperbarui: 31 Oktober 2026. Fondasi dan repository TERVALIDASI.
R4 belum selesai: toggle, integrasi layar dan alur cetak belum terhubung.

## Fondasi
- BusinessProfile.useOrderStatus default true, termasuk equality. Fixture memakai
  default true. withOrderStatus(enabled: ...) menyalin data dan metadata.
- Info Usaha membaca profil terkini saat menyimpan; copyProfile printer ikut
  mempertahankan mode. Dua belas tes fondasi/preservasi profil lulus.
- nextStatus dan Order.withStatus menerima useOrderStatus, default true. Hanya mode
  false yang mengizinkan diproses langsung selesai; pembatalan/final tetap terjaga.
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

## Bukti validasi terakhir
Perintah: dart run tool/check_all.dart, 31 Oktober 2026.
```text
Formatted 451 files (0 changed)
flutter analyze: No issues found!
dart analyze: No issues found!
check_arch: OK
+396: All tests passed!
REPO_MAP diperbarui: 519 berkas
check_all: SEMUA HIJAU
```
Sebelumnya validasi draf awal juga lulus 387 tes setelah lint dan dua golden R3
(dirender dan ditinjau) diperbaiki. R3 selesai otomatis; Android/iOS manual R3/R4
belum dilakukan pada sesi ini.

## Langkah berikutnya
1. Provider/toggle pengaturan: baca profil terkini dan simpan langsung; migrasikan
   SettingsMenuSection yang disentuh menjadi Stateless dengan callback.
2. Teruskan profile.useOrderStatus ke caller repository saat operasi dilakukan;
   caller aplikasi saat ini masih default true. Jangan aktifkan toggle sebelum
   checkout/AI, kartu/chip Antrean, serta menu/footer Detail tersambung.
3. Selesaikan: cetak via ReceiptView/PrintService yang ada. Baru setelah cetak
   berhasil simpan status/event. Gagal/batal tetap aktif; konfirmasi tanpa cetak
   boleh menyelesaikan. Lunas tidak wajib. Hapus memakai alur batal/koreksi ledger.
4. Catat kolom businesses.use_order_status bool default true di PRD B sesuai izin
   tertulis R4; perbarui spec 01/09/19 dan tes layar dua mode.
5. Tiap kelompok: format/analyzer/check_all, tinjau golden bila berubah, STATE,
   commit. R5 menunggu R4 selesai. Tidak push/merge tanpa izin pengguna.
