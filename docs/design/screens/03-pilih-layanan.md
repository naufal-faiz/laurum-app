# 03 - Pilih Layanan
Rute: /transaksi/baru/layanan dan /order/:id/edit/layanan   Fase: 3   Frame .pen: "Transaksi - Pilih Layanan" (sheet S25)
Template: SubScaffold (AppBarSub, tanpa nav bawah)

Komposisi:
- AppSearchField('Cari layanan', hint 'Cari nama layanan (misal: selimut, karpet)').
- SectionHeader('Sering dipakai') + MenuRow tiga layanan aktif pertama.
- SectionHeader('Kiloan') dan SectionHeader('Satuan') + MenuRow layanan aktif.
- EmptyState 'Layanan tidak ditemukan' saat pencarian kosong hasil.
- Loading memakai AppSkeleton; error memakai EmptyState + Coba lagi.
- FAB Layanan baru (primary, ikon add) membuka /lainnya/layanan/baru dengan push.
  FAB disembunyikan saat keyboard terbuka; ruang bawah daftar 112 dp.

Data dan provider:
- serviceCatalogProvider (ServiceRepository.getServices, hanya isActive).
- serviceSearchProvider menyimpan kata kunci.
- transactionDraftProvider menerima layanan yang dipilih.

Interaksi:
- Ketuk layanan -> draft.add(service) lalu kembali ke /transaksi/baru.
- Pencarian menyaring seluruh layanan; 'Sering dipakai' hanya tampil saat pencarian kosong.
- Layanan nonaktif (mis. Jas & gaun) tidak pernah tampil.
- Tombol kembali menutup halaman tanpa mengubah draf.
- Setelah form layanan ditutup, katalog dimuat ulang dari repository yang sama
  dengan Daftar Layanan. Draf transaksi/edit order tetap; memilih layanan baru
  menambah 1 kg / 1 pcs lalu kembali ke pemanggil.

State: daftar normal, hasil pencarian, hasil kosong, loading, error.
Format: Formatters.rupiah untuk harga; satuan kg/pcs dan durasi hari dari ServiceItem.

Selisih terhadap .pen: frame berupa bottom sheet S25 dengan katalog alfabetis; layar ini
memakai halaman SubScaffold, MenuRow (bukan kartu kustom), header Kiloan/Satuan (bukan
grup A-Z), dan tanpa chip kategori.

R3 (30 Oktober 2026): ServicePickerListSection menerima services/query/onSearch/onSelect.
Kode dan tes dua rute, keyboard serta baris terakhir disiapkan tanpa SDK; tervalidasi otomatis 31 Oktober 2026 (check_all: 387 tes).
Selisih baru dari .pen: FAB mengikuti revisi R3. Golden R3 ditinjau; Android/iOS perangkat belum ditinjau.
