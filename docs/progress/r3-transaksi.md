# R3 - Transaksi (30 Oktober 2026)
Status: SEDANG / BELUM TERVALIDASI. Pengguna mengizinkan coding tanpa SDK dan
melarang pemasangan SDK di laptop sementara. Tidak ada tes/analyzer/format Dart dijalankan.

## Perubahan
- SubScaffold menerima fabLabel/onFab berpasangan; pola FAB lama dipertahankan.
  FAB hilang saat keyboard muncul dan kembali ketika keyboard ditutup.
- ServicePickerPage memakai FAB Layanan baru, push form yang ada, lalu invalidate
  serviceCatalogProvider ketika kembali. Berlaku transaksi baru dan edit order.
- ServicePickerListSection baru menyusun daftar lama, menerima data/callback,
  menjaga pengelompokan/pencarian, dan menyisakan padding bawah 112 dp.
- TransactionCustomerSection dimigrasikan ke StatelessWidget. Data/customerBalance
  dan aksi dibaca TransactionPage. Tombol Baru langsung membuka sheet forOrder=true,
  memilih hasil simpan di draf; pembatalan tidak mengubah draf.
- Utang Section menyusut 25 -> 24. Tidak menambah registry, tema atau dependensi.

## Tes yang ditulis (belum dijalankan)
- sub_scaffold_fab_test: FAB, callback, keyboard sembunyikan/tampilkan.
- service_picker_list_section_test: pencarian dan callback pemilihan.
- transaction_customer_section_test: kosong/terpilih, tombol 320 px dan teks 2x.
- r3_service_creation_test: dua alur (transaksi baru dan edit order), simpan layanan,
  katalog dan repository sama, pilih layanan tanpa kehilangan draf sebelumnya.
- r3_service_picker_keyboard_test: pencarian di atas keyboard, FAB tersembunyi,
  baris layanan terakhir dapat disentuh di atas FAB.
- r3_customer_creation_test: simpan/pilih pelanggan dari Baru + keyboard 300 dp,
  batal mempertahankan draf.

## Pemeriksaan yang tersedia di laptop ini
- git diff --check bersih; impor lokal ditemukan, encoding UTF-8 terbaca,
  seluruh berkas Dart yang diubah < 100 baris, Section tanpa provider/router.
  Ini pemeriksaan teks, bukan analyzer/compiler Dart.
- Periksa impor lokal, batas baris sumber, dan Section tanpa Riverpod/go_router.
- REPO_MAP belum diregenerasi karena generator membutuhkan Dart; gunakan daftar
  berkas baru di atas serta service_picker_list_section.dart untuk konteks.

## Langkah di perangkat berikutnya
1. Baca STATE, git status/log. Jangan memasang SDK di laptop sementara.
2. Jalankan dart format lib test widgetbook tool; perbaiki hasil analyze.
3. Jalankan enam berkas tes baru dan tes service_picker_test, add_customer_test,
   transaction_page_test, sub_scaffold_test serta keyboard_audit_test.
4. Render/tinjau golden transaction_page.png, service_picker.png; periksa apakah
   add_customer_sheet.png ikut berubah. Jangan menerima golden otomatis tanpa tinjauan.
5. Jalankan dart run tool/check_all.dart (meregenerasi REPO_MAP), tinjau R3 Android,
   lalu tandai R3 selesai. Jangan menganggap 366 tes lama membuktikan perubahan R3.
6. Setelah R3 tervalidasi, lanjut R4-status-order.md.
