# R4 - Pengaturan "Pakai status order" (revisi 6)
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: R3 SELESAI. Baca: docs/revisi/REVISI-01.md (item 6 dan keputusan R4), spec 01, 09, 10, 19; core/domain/order_rules.dart, business_profile.dart.

## Perilaku
- Pengaturan > kelompok PENGATURAN: ToggleRow "Pakai status order" (default AKTIF). Deskripsi: "Matikan bila usaha tidak melacak tahap cucian. Order baru langsung 'Sedang dikerjakan'."
- AKTIF: perilaku sekarang, tidak berubah.
- NONAKTIF: order baru (kasir maupun usulan AI yang disetujui) langsung berstatus diproses, label tampil "Sedang dikerjakan". Tidak ada tombol maju status di Antrean (kartu hanya bisa dibuka), tidak ada menu Ubah status, chip status Jemput/Proses/Siap disembunyikan (tersisa Semua dan Perlu dicek).
- Detail Order NONAKTIF punya tepat tiga aksi: Edit, Hapus, Selesaikan.
  - Edit: /order/:id/edit (sama seperti sekarang).
  - Hapus: alur batal yang ada (status dibatalkan, riwayat tetap, penyesuaian tabungan sama), teks ConfirmModal "Hapus nota ini?".
  - Selesaikan: membuka alur Cetak struk yang sudah ada (ReceiptView + PrintService palsu). Saat cetak BERHASIL, status berubah menjadi selesai (OrderEvent dicatat) dan order keluar dari antrean. Cetak gagal atau dibatalkan: status tetap diproses, tampil pesan error, dan tersedia pilihan "Selesaikan tanpa cetak" lewat ConfirmModal. Tidak ada tombol Cetak terpisah selama order belum selesai.
  - Order yang sudah selesai atau dibatalkan: perilaku final sekarang (hanya Cetak struk), sama seperti mode AKTIF.
- Selesaikan tidak mensyaratkan lunas; sisa tagihan tetap menjadi piutang seperti perilaku mode AKTIF saat order selesai.
- Mengganti pengaturan tidak mengubah data order yang ada.

## IZIN TERTULIS (25 Okt 2026)
- BusinessProfile: tambah field useOrderStatus (bool, default true) berikut props, repository (in-memory) dan fixture (tetap true agar DATA MASTER utuh); catat di docs/prd/prd-b-backend.md satu baris kolom sinkron.
- OrderCard: tambah parameter opsional showAction (default true) bila onAction null tidak cukup. Perbarui katalog dan tes.
- Tanpa perubahan atoms/tema lain, tanpa dependensi.

## Langkah
1. Tes domain lebih dulu: aturan baru di core/domain/order_rules.dart (selesaikan langsung diproses -> selesai hanya bila useOrderStatus false; mode AKTIF tetap lewat nextStatus), status awal order, label.
2. Profil + repository + provider pengaturan (state/ di fitur settings), ToggleRow di SettingsMenuSection (simpan langsung).
3. checkout_save, persetujuan usulan AI (bila sudah ada), AntreanPage/chips (antreanDataProvider sudah menyaring selesai dan dibatalkan; jangan diubah), OrderDetail (footer dan menu), alur Selesaikan -> cetak (pakai receipt_print_controller yang ada), Daftar Piutang bila menampilkan status, label status.
4. Tes layar: kedua mode untuk Antrean dan Detail Order; alur nyata (matikan pengaturan, buat nota, nota muncul "Sedang dikerjakan", hanya tiga aksi, tombol Selesaikan membuka cetak, cetak berhasil -> status selesai dan nota hilang dari Antrean; cetak gagal -> tetap di antrean dengan opsi Selesaikan tanpa cetak; Hapus -> dibatalkan).
5. Perbarui spec 01, 09, 19 dan STATE.

Prompt berikutnya: R5-laporan-rentang.md.
