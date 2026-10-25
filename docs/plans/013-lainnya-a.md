# 013 - Lainnya bagian 1 (prompt 70)

Tujuan: tab Lainnya, Daftar Layanan, Tambah/Edit Layanan, Info Usaha.

Berkas:
- features/settings/pages/settings_page.dart: menu berkelompok, NoticeAi, versi,
  Keluar lewat ConfirmModal.
- features/services/pages/service_directory_{page,list_page,data,providers}.dart:
  6 layanan, pencarian, header total, toggle aktif, tombol Tambah.
- features/services/pages/service_edit_{state,controller,form_page,fields_page}.dart
  dan service_copy.dart: satu form tambah/edit, validasi, simpan reaktif.
- features/business/pages/business_info_{state,controller,page}.dart: profil usaha,
  simpan, AppBarRoot/struk ikut berubah.
- app_router.dart + placeholder_routes.dart: rute nyata menggantikan placeholder.
- docs/design/screens/19..22: spec layar.
- test: settings, direktori layanan, form layanan, info usaha, router.

Batasan:
- Tanpa widget, dependensi, registry, tema, atau PRD baru.
- Sinkronisasi, email/hapus akun, dan Keluar tujuan /masuk masih placeholder
  sampai prompt 90; Pengeluaran tetap placeholder prompt 71.
- Harga int rupiah; input hanya digit. Nama wajib; harga > 0.
- Catatan harga hanya di form Edit.
- Perubahan layanan langsung terlihat di Pilih Layanan lewat repositori reaktif.
- Info Usaha hanya mengubah receiptFooter; receiptNote tetap di layar Printer.
