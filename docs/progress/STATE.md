# STATE Laurum
Diperbarui: 2026-11-11 | Cabang newdesign

## Sesi aktif
Layar 02 Buat Transaksi selesai; dasar d156170, WIP awal eec4bfc.
Frame 691/752 dibaca masing-masing sekali, ringkasan di spec 02.
Commit feat(ui) irisan Transaksi memuat berkas ini; lihat git log -1.

## Status irisan
Header detail/Draft; pelanggan kosong/terpilih + Ganti; layanan kosong/terisi,
sampah terpisah dari Ubah berat/jumlah; Ringkasan; estimasi/catatan; footer sejajar.
Section footer/services/item/summary hanya menyusun widget registry.
TransactionDetailsSection tetap ConsumerWidget utang lama, provider tetap.
remove membatasi diskon ke subtotal baru; DraftLine dipisah/diekspor ulang
untuk batas baris. Paritas spec 02 seluruhnya Selesai.
Golden 3: transaction_page, transaction_empty (baru), add_customer_sheet (backdrop).
Snapshot/screenshot 0; visual belum diverifikasi manual; iOS belum diuji.

## Keputusan pengguna terbaru
Pasangan 691+752 disetujui; pembayaran tetap langkah lama; estimasi/catatan
sesudah Ringkasan. PayStatus tidak dipilih manual dari frame.
Izin spesifik: clamp diskon saat hapus + tes regresi dan pemisahan DraftLine.
Terbaru: tombol Pilih pelanggan menjadi Impor kontak; kartu kosong membuka
pemilihan. Kontak ditinjau di formulir lama sebelum simpan/pilih pelanggan.
Padding atas body dari 24 menjadi 8 dp, sisi tetap 24 dp.
Ambang usage 10%; persentase akun tidak tersedia di alat. FigCraft pengguna
selalu dikecualikan dari commit; tidak ada push/merge.

## Belum di-commit
Hanya docs/design/new-design-laurum.figcraft milik pengguna setelah commit.
Stash f7a9e49 lama sudah diterapkan; jangan apply ulang.
Pengecualian zona beku berizin: transaction_draft.dart, transaction_line.dart,
transaction_remove_discount_test.dart. Rute/data/token/dependensi tetap.

## Langkah berikutnya
1. Tunggu tinjauan pengguna terhadap Transaksi; satu irisan selesai.
2. Kerjakan hanya koreksi/layar berikut yang diminta pengguna.

## Blocker
Tidak ada. Saran di luar lingkup: audit diskon saat kuantitas berkurang (bukan
jalur hapus); jangan ubah state tambahan tanpa izin.

## Bukti terakhir
- dart run tool/check_all.dart: SEMUA HIJAU; 1086 lulus, 1 skip, exit 0.
- Log TEMP/laurum-transaction-import-final.log; REPO_MAP 1091 berkas.
- Scoped analyze no issues; check_arch OK; keyboard 300 dp 2 lulus.
- Tes impor/pelanggan/transaksi 13 lulus; layout/golden 320dp/2x 5 lulus.
- Finder mengikuti label/jalur visual; assertion perilaku lama tetap.
- Regresi diskon saat hapus sesuai izin pengguna; tidak ada state tambahan.
