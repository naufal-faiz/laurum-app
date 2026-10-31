# R4: Detail Order dan penyelesaian

- Pertahankan tampilan dan transisi mode status aktif.
- Mode sederhana: Edit, Hapus (pembatalan ledger), Selesaikan.
- Cetak dengan ReceiptView/PrintService; simpan selesai dan event sesudah berhasil.
- Gagal/batal cetak: order tetap aktif; konfirmasi terpisah untuk tanpa cetak.
- Guard ketukan ganda, perubahan order/mode selama cetak, serta order final.
- Keputusan pengguna 31 Okt: order lama Menunggu jemput boleh langsung selesai.
- Migrasikan ContentSection menjadi Stateless; teruskan policy ke ringkasan.
- Tes logika dahulu, tes layar/Section, check_all, STATE dan commit.
- Toggle pengaturan tetap belum ditampilkan sampai seluruh integrasi R4 siap.
