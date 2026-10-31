# R3 - Transaksi
Status: SELESAI otomatis (31 Oktober 2026). Draf awal dibuat 30 Oktober tanpa SDK;
SDK kini tersedia dan pengguna meminta pemeriksaan sebelum meneruskan pekerjaan.

## Hasil
- FAB Layanan baru pada SubScaffold/Pilih Layanan, tersembunyi saat keyboard terbuka.
- Pembuatan layanan dari transaksi baru dan edit order kembali ke katalog yang sama;
  draf tidak hilang dan layanan baru dapat dipilih. Padding bawah daftar 112 dp.
- Tombol Baru langsung membuka AddCustomerSheet dalam mode forOrder=true (default),
  hasil simpan dipilih di draf, penutupan tanpa simpan mempertahankan draf.
- TransactionCustomerSection Stateless dengan data/callback; utang Section 25 -> 24.
- Enam berkas tes R3 (sembilan skenario), seluruh regresi lama dan fondasi R4 lulus.
- Golden service_picker.png dan add_customer_sheet.png ditinjau dari hasil render
  lalu diperbarui: perubahan hanya FAB dan tombol Baru di latar sheet.
  Golden transaction_page.png dengan pelanggan terpilih tetap sama.
- Formatter dan lint draf dibersihkan. Argumen forOrder:true yang redundan dibuang;
  tes tetap memastikan sheet memakai forOrder=true. Registry/tema/dependensi tetap.

## Bukti
Perintah: dart run tool/check_all.dart, 31 Oktober 2026.
```text
Formatted 449 files (0 changed)
flutter analyze: No issues found!
dart analyze: No issues found!
check_arch: OK
+387: All tests passed!
REPO_MAP diperbarui: 517 berkas
check_all: SEMUA HIJAU
```
Jumlah tersebut mencakup 366 tes sebelumnya, sembilan skenario R3 dan 12 fondasi R4.
Android/iOS perangkat untuk R3 belum diuji pada sesi ini; pemeriksaan keyboard
memakai tester dengan viewInsets 300 dp. Lanjut integrasi R4 sesuai catatannya.
