# 21 - Tambah dan Edit Layanan
Rute: /lainnya/layanan/baru dan /lainnya/layanan/:id   Prompt: 70
Frame .pen: "Lainnya - Tambah Layanan" dan "Lainnya - Edit Layanan".
Template: FormScaffold (satu form dipakai keduanya).

Komposisi:
- AppBarSub: 'Tambah layanan' atau 'Edit layanan'.
- Form Edit: AppText 'Perubahan harga tidak memengaruhi nota yang sudah tercetak.'.
- LabeledField Nama layanan (wajib).
- LabeledField Tipe layanan: ChipBar 'Kiloan (per kg)' / 'Satuan (per pcs)'.
- LabeledField Harga (per kg/pcs): input digit; helper Formatters.rupiah +
  'Nominal sebelum diskon nota transaksi atau promo kasir.'.
- LabeledField Estimasi selesai: ChipBar 1-5 hari; helper 'Standar durasi'.
- ToggleRow 'Layanan aktif' dengan deskripsi kemunculan di kasir.
- FooterBar: 'Simpan layanan'/'Simpan perubahan' dan 'Batal'.

Data dan provider:
- serviceEditProvider(serviceId) memuat ServiceItem; serviceId kosong = baru.
- Simpan baru: id srv-<micros>, owner dari AuthService, createdAt jam usaha,
  sortOrder terakhir + 1. Simpan edit mempertahankan id/createdAt.
- serviceRepositoryProvider.saveService membuat direktori dan katalog reaktif.

Validasi dan state:
- Nama kosong -> 'Nama layanan wajib diisi.'.
- Harga 0/kosong -> 'Harga harus lebih dari Rp0.'.
- Busy menonaktifkan field/tombol; gagal simpan menampilkan BannerMessage.
- Layanan tidak ditemukan -> EmptyState; loading memakai AppSkeleton.

Selisih terhadap .pen:
- Tanpa badge 'Wajib' dan tanpa awalan Rp di dalam field; nilai terformat tampil
  di helper.
- Tanpa 'Paket' dan dropdown satuan, sesuai prompt.
- Catatan harga diletakkan di atas form Edit agar langsung terbaca.
- Footer memakai dua AppButton bertumpuk, bukan baris sejajar.
