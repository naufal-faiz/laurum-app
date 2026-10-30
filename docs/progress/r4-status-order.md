# R4 - Fondasi pengaturan status order
Tanggal: 30 Oktober 2026. Status: DRAF PARSIAL / BELUM TERVALIDASI.
Pengguna meminta melanjutkan bagian yang bisa dikerjakan tanpa SDK. R3 tetap belum
tervalidasi; ini persiapan fondasi R4, bukan pernyataan bahwa prasyarat R3 lulus.

## Perubahan pada kelompok ini
- BusinessProfile.useOrderStatus bool default true, termasuk props Equatable.
  Fixture tetap true agar DATA MASTER dan perilaku lama tidak berubah.
- withOrderStatus mengembalikan profil baru, mempertahankan seluruh data serta
  metadata; updatedAt bisa diberikan eksplisit. Repository bisnis in-memory sudah
  menyimpan objek profil utuh, sehingga tidak memerlukan penyimpanan field terpisah.
- Simpan Info Usaha membaca profil terkini sebelum menyalin metadata/mode; pilihan
  mode yang berubah setelah formulir dibuka tidak kembali ke nilai snapshot lama.
- copyProfile pengaturan printer ikut mempertahankan useOrderStatus.
- nextStatus menerima useOrderStatus opsional default true. Hanya jika false,
  diproses dapat langsung selesai. Pembatalan dan proteksi status final tetap.
- Order.withStatus meneruskan flag eksplisit ke validasi domain.
- initialOrderStatus: kasir diproses; WhatsApp AI menungguJemput saat mode aktif,
  diproses saat nonaktif. orderStatusLabel memakai Sedang dikerjakan untuk diproses
  pada mode nonaktif; label lain mengikuti label lama.

## Tes ditulis, belum dijalankan
- r4_order_policy_test: enam skenario default/transisi, pembatalan/final, status
  awal, label, serta perubahan status objek Order dan preservasi nominal/identitas.
- r4_business_profile_test: tiga skenario default, equality/salinan/metadata, serta
  salinan teks struk yang mempertahankan mode.
- r4_profile_persistence_test: tiga skenario repository tidak mengubah order/struk,
  simpan Info Usaha dengan snapshot lama, dan simpan pengaturan printer.
- Pemeriksaan yang bisa dilakukan sekarang: diff/whitespace, impor lokal,
  encoding UTF-8, batas baris, dan peninjauan statis. Bukan analyzer/compiler Dart.

## Belum dihubungkan (penting)
- Toggle Pengaturan BELUM dibuat; semua caller aplikasi masih memakai default true.
- OrderRepository.updateOrderStatus dan writeOrderStore masih menggunakan guard
  mode aktif. Menambahkan flag ke Order.withStatus SAJA belum mengizinkan transisi
  langsung melalui repository; guard ini sengaja tidak dilonggarkan pada kelompok ini.
- Berikutnya teruskan policy melalui jalur penyimpanan repository secara konsisten,
  dengan tes yang memastikan transisi diproses->selesai tetap ditolak saat mode aktif.
- Buat provider pengaturan dan toggle, lalu hubungkan status awal checkout/AI,
  label/kartu/chip Antrean, serta menu dan footer Detail Order sesuai prompt R4.
- Alur Selesaikan harus menunggu cetak berhasil sebelum mencatat status/event;
  gagal/batal tidak mengubah status, opsi Selesaikan tanpa cetak memakai konfirmasi.
  Sisa tagihan tidak menghalangi selesai. Hapus memakai alur batal dan koreksi ledger.
- Kolom sinkron use_order_status bool default true pada businesses di PRD B masih
  perlu dicatat ketika integrasi R4 dilanjutkan (izin tertulis di prompt R4).
- Spec 01/09/19, tes layar dua mode, golden dan REPO_MAP belum diperbarui untuk R4.

## Di perangkat berikutnya
Jalankan dart format dan analyzer, tiga tes R4, tes domain_schedule_test,
domain_models_1_test, business_info_page_test, printer_page_test dan tes R3;
kemudian check_all. Jangan klaim perubahan R3/R4 hijau berdasarkan 366 tes R2 lama.
Tidak memasang SDK pada laptop sementara, dan tidak push/merge tanpa permintaan.

Pemeriksaan teks: git diff --check bersih; impor lokal/UTF-8/batas 100 baris lolos.
