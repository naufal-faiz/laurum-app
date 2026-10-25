# Usulan sinkronisasi PRD untuk R2 (belum diterapkan)

Auto-review menolak perubahan docs/prd/prd-a-ui.md karena izin eksplisit PRD
belum ditemukan dalam prompt R2. Implementasi dan spec layar sudah mengikuti R2.

Perubahan yang meminta persetujuan pengguna:
1. Bagian 5.2, deskripsi RootScaffold: ganti 'app bar root + nav bawah + FAB'
   menjadi 'app bar root + nav bawah empat tab dan aksi Transaksi tengah, tanpa FAB'.
2. Bagian 8, 'StatefulShellRoute untuk 5 tab': ubah menjadi empat tab
   /antrean, /pelanggan, /laporan, /lainnya. Slot tengah adalah aksi push
   /transaksi/baru, bukan tab dan tidak pernah berstatus aktif.
3. Bagian 8: tegaskan /transaksi sementara tetap rute langsung Riwayat Nota
   sampai pemindahan R6. Tidak ada perubahan daftar fitur atau rute lain.

Risiko bila belum diterapkan: PRD masih menggambarkan lima tab dan FAB lama,
sehingga agen berikutnya bisa mengambil acuan navigasi yang sudah tidak sesuai.
