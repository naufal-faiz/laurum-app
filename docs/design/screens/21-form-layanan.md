# Redesign Tambah layanan031 — 14Nov2026
Frame pilihan4294968237 LAURUM · Tambah Layanan dibaca sekali dari FigCraft aktif.
Dasar0e81c8d; proposal031 mencakup semua varian bersama yang diperlukan.
Irisan hanya /lainnya/layanan/baru; form Edit tetap memakai komposisi lama.

## Snapshot dan pemetaan
- Kanvas390×844: header x24/y56/w342/h44; AppBarSub detail melalui FormScaffold.
- Kembali bundar, judul Tambah layanan, subjudul Layanan baru dan nama usaha aktual.
- Konten latar netral, margin24, jarak14; padding memakai token terdekat yang ada.
- Pratinjau342×141: kartu gradient biru+bubble, ikon baju, nama/fallback Layanan baru,
  petunjuk Atur nama, tarif, dan durasi pengerjaan; chip tipe, rupiah/unit dan hari.
- Informasi layanan: kartu putih berisi nama, pilihan Kiloan/per kg atau Satuan/per pcs,
  harga per unit dengan prefix Rp, hint0, suffix unit dan helper nominal sebelum diskon.
- Durasi & status: kartu putih berisi Estimasi selesai, pilihan1–5hari, pemisah dan
  ToggleRow aktif berikon; catatan layanan aktif tersedia di kasir setelah disimpan.
- Footer putih Batal kiri/Simpan layanan berikon kanan; responsif saat font besar.
- Status bar dan home indicator dari OS; tidak menyalin bentuk/teks jam contoh.

## Paritas redesign031
| Butir | Sumber/perilaku yang dipertahankan | Verifikasi |
|---|---|---|
| Provider | serviceEditProvider(serviceId); id kosong=baru | [ ] |
| Draft | name/kind/priceText/price/unitLabel/durationDays/isActive | [ ] |
| Default | nama kosong, kiloan, harga kosong,2hari,aktif dari ServiceEditState | [ ] |
| Nama | actions.setName; nama wajib, pesan Nama layanan wajib diisi. | [ ] |
| Tipe | actions.setKind(index0/1); unit kg/pcs dan label harga mengikuti state | [ ] |
| Harga | actions.setPrice; digit saja, maksimum9digit, tanpa nol depan | [ ] |
| Input | nilai kosong+hint0, selectAllOnFocus jika nonkosong; nama sebelum harga | [ ] |
| Validasi | harga>0; pesan Harga harus lebih dari Rp0.; tombol memicu validasi lama | [ ] |
| Durasi | actions.setDuration(index+1), pilihan1–5hari, default2bukan contoh Figma | [ ] |
| Aktif | actions.setActive(value:value); ketersediaan kasir melalui repository lama | [ ] |
| Simpan | notifier.save() tanpa argumen; berhasil dan mounted lalu context.pop() | [ ] |
| Batal/kembali | Batal context.pop; kembali canPop?pop:go('/lainnya/layanan') | [ ] |
| Busy | nama/harga/tombol/aktif disabled; binding tipe/durasi/kembali lama tetap | [ ] |
| Keadaan | loading2skeleton; not-found EmptyState; notice BannerMessage error | [ ] |
| Edit | path/id/provider, catatan harga, field dan footer Edit tetap | [ ] |
| Key/fokus | tiada Key fitur eksplisit; TextField0nama/1harga dan label aksi lama | [ ] |
| Akses kasir | FAB pemilih layanan membuka form; simpan/kembali memuat katalog lama | [ ] |
| Aksesibilitas | font1–2x/280–600dp, keyboard300dp, input aktif dan Simpan terjangkau | [ ] |

## Selisih desain dan izin031
- Komponen bersama default dipertahankan; varian opt-in AppCard gradient,
  AppBadge inverse, AppTextField prefixText dan SelectionTile compact perlu izin UI-13.
- Warna pratinjau memakai heroGradientStart/heroGradientEnd yang sudah ada;
  radius20/18px dan font8–10px memakai token global terdekat/minimum global.
- Nama/angka/nomor usaha contoh Figma tidak disalin ke UI atau fixture.
- Nama usaha memerlukan satu pembacaan provider profil usaha di Page (izin UI-8);
  tidak menambah provider/metode/repository atau mengubah sumber draft layanan.
- Kartu pratinjau memakai draft aktual, tanpa data baru atau aksi tambahan.
- Label Tipe dan Harga mengikuti frame; tes lama boleh menyesuaikan finder struktur
  dan label, seluruh assertion nominal/simpan/katalog/error tetap dipertahankan.
- Varian baru dipakai hanya pada form Tambah; Edit tidak ikut berubah.
- Belum mengubah kode/tes/registry; implementasi menunggu persetujuan proposal031.
# 21 - Tambah dan Edit Layanan
Rute: /lainnya/layanan/baru dan /lainnya/layanan/:id   Prompt: 70
Frame .pen: "Lainnya - Tambah Layanan" dan "Lainnya - Edit Layanan".
Template: FormScaffold (satu form dipakai keduanya).

Audit 100: harga baru kosong dengan hint 0 (bukan contoh 9000); mengikuti AGENTS 16a.

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

R3: form baru juga dibuka dari FAB Pilih Layanan via push. Simpan/kembali
mengembalikan pengguna ke pemilih; katalog dimuat ulang. Tes alur disiapkan,
lulus pemeriksaan SDK pada 31 Oktober 2026 (387 tes total).


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
