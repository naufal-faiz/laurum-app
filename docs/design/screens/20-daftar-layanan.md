# 20 - Daftar Layanan
Rute: /lainnya/layanan   Prompt: 70
Frame .pen: "Lainnya - Daftar Layanan".
Template: SubScaffold + FooterBar.

Komposisi:
- AppSearchField 'Cari layanan' (placeholder 'Cari layanan laundry...').
- SectionHeader 'Total 6 layanan (5 aktif)' dihitung dari semua layanan.
- ServiceRow per layanan urut sortOrder: nama, jenis, harga/satuan, durasi,
  switch aktif; 'Jas & gaun' tampil Nonaktif.
- FooterBar: AppButton 'Tambah layanan'.

Data dan provider:
- serviceDirectoryProvider = ServiceRepository.getServices(includeInactive: true).
- serviceDirectorySearchProvider menyimpan kata pencarian.
- DATA MASTER: enam layanan; lima aktif; Jas & gaun Rp35.000/pcs, 4 hari.

Interaksi:
- Ketuk baris -> /lainnya/layanan/:id (form Edit).
- Switch menyimpan isActive lewat repositori; katalog Pilih Layanan ikut berubah.
- Tambah layanan -> /lainnya/layanan/baru.
- Pencarian tanpa hasil menampilkan EmptyState 'Layanan tidak ditemukan'.

State layar: loading (AppSkeleton), error + 'Coba lagi', pencarian kosong.
Layar 320 px dan teks 2x diuji.

Selisih terhadap .pen:
- Tanpa kontrol 'Urutkan'; urutan tetap sortOrder.
- Header memakai SectionHeader, bukan baris teks dengan aksi.
- Label pencarian 'Cari layanan', bukan 'Nama pelanggan' (salah salin di .pen).
