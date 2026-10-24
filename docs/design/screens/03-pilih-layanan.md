# 03 - Pilih Layanan
Rute: /transaksi/baru/layanan   Fase: 3   Frame .pen: "Transaksi - Pilih Layanan" (sheet S25)
Template: SubScaffold (AppBarSub, tanpa nav bawah)

Komposisi:
- AppSearchField('Cari layanan', hint 'Cari nama layanan (misal: selimut, karpet)').
- SectionHeader('Sering dipakai') + MenuRow tiga layanan aktif pertama.
- SectionHeader('Kiloan') dan SectionHeader('Satuan') + MenuRow layanan aktif.
- EmptyState 'Layanan tidak ditemukan' saat pencarian kosong hasil.
- Loading memakai AppSkeleton; error memakai EmptyState + Coba lagi.

Data dan provider:
- serviceCatalogProvider (ServiceRepository.getServices, hanya isActive).
- serviceSearchProvider menyimpan kata kunci.
- transactionDraftProvider menerima layanan yang dipilih.

Interaksi:
- Ketuk layanan -> draft.add(service) lalu kembali ke /transaksi/baru.
- Pencarian menyaring seluruh layanan; 'Sering dipakai' hanya tampil saat pencarian kosong.
- Layanan nonaktif (mis. Jas & gaun) tidak pernah tampil.
- Tombol kembali menutup halaman tanpa mengubah draf.

State: daftar normal, hasil pencarian, hasil kosong, loading, error.
Format: Formatters.rupiah untuk harga; satuan kg/pcs dan durasi hari dari ServiceItem.

Selisih terhadap .pen: frame berupa bottom sheet S25 dengan katalog alfabetis; layar ini
memakai halaman SubScaffold, MenuRow (bukan kartu kustom), header Kiloan/Satuan (bukan
grup A-Z), dan tanpa chip kategori.
