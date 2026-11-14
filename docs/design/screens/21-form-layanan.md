# Redesign Tambah layanan031 — 14Nov2026
Frame pilihan4294968237 LAURUM · Tambah Layanan dibaca sekali dari FigCraft aktif.
Dasar0e81c8d; proposal031 disetujui14Nov2026 melalui jawaban "Ya lakukan".
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
| Provider | serviceEditProvider(serviceId); id kosong=baru | [x] |
| Draft | name/kind/priceText/price/unitLabel/durationDays/isActive | [x] |
| Default | nama kosong, kiloan, harga kosong,2hari,aktif dari ServiceEditState | [x] |
| Nama | actions.setName; nama wajib, pesan Nama layanan wajib diisi. | [x] |
| Tipe | actions.setKind(index0/1); unit kg/pcs dan label harga mengikuti state | [x] |
| Harga | actions.setPrice; digit saja, maksimum9digit, tanpa nol depan | [x] |
| Input | nilai kosong+hint0, selectAllOnFocus jika nonkosong; nama sebelum harga | [x] |
| Validasi | harga>0; pesan Harga harus lebih dari Rp0.; tombol memicu validasi lama | [x] |
| Durasi | actions.setDuration(index+1), pilihan1–5hari, default2bukan contoh Figma | [x] |
| Aktif | actions.setActive(value:value); ketersediaan kasir melalui repository lama | [x] |
| Simpan | notifier.save() tanpa argumen; berhasil dan mounted lalu context.pop() | [x] |
| Batal/kembali | Batal context.pop; kembali canPop?pop:go('/lainnya/layanan') | [x] |
| Busy | nama/harga/tombol/aktif disabled; binding tipe/durasi/kembali lama tetap | [x] |
| Keadaan | loading2skeleton; not-found EmptyState; notice BannerMessage error | [x] |
| Edit | path/id/provider, catatan harga, field dan footer Edit tetap | [x] |
| Key/fokus | tiada Key fitur eksplisit; TextField0nama/1harga dan label aksi lama | [x] |
| Akses kasir | FAB pemilih layanan membuka form; simpan/kembali memuat katalog lama | [x] |
| Aksesibilitas | font1–2x/280–600dp, keyboard300dp, input aktif dan Simpan terjangkau | [x] |

## Selisih desain dan izin031
- Komponen bersama default dipertahankan; varian opt-in AppCard gradient,
  AppBadge inverse, AppTextField prefixText dan SelectionTile compact disetujui031.
- Warna pratinjau memakai heroGradientStart/heroGradientEnd yang sudah ada;
  radius20/18px dan font8–10px memakai token global terdekat/minimum global.
- Nama/angka/nomor usaha contoh Figma tidak disalin ke UI atau fixture.
- Nama usaha memerlukan satu pembacaan provider profil usaha di Page (izin UI-8);
  tidak menambah provider/metode/repository atau mengubah sumber draft layanan.
- Kartu pratinjau memakai draft aktual, tanpa data baru atau aksi tambahan.
- Label Tipe dan Harga mengikuti frame; tes lama boleh menyesuaikan finder struktur
  dan label, seluruh assertion nominal/simpan/katalog/error tetap dipertahankan.
- Varian baru dipakai hanya pada form Tambah; Edit tidak ikut berubah.
- Prefix Rp selalu tampak melalui slot prefixIcon pada mode field biasa/padat; nilai
  input tetap kosong. Rp, nilai dan suffix unit sejajar vertikal.
- Scroll field padat mendapat ruang atas24 dari token xlarge agar tepi field tidak
  terpotong13px saat keyboard300dp muncul; ruang bawah330 lama tetap.
- AppTextField memakai part internal app_text_field_widget.dart untuk konfigurasi;
  controller/fokus tetap di app_text_field.dart, seluruh file di bawah110baris.
- Ikon tas/power memakai AppIcons.bag/AppIcons.power dari Ionicons yang terpasang.
- service_directory_page_test hanya mengganti finder tipe menjadi SelectionTile,
  label Harga per pcs dan memastikan kontrol5hari terlihat; seluruh assertion
  validasi/nominal/penyimpanan/katalog tetap. Tes perilaku non-widget tidak diubah.
- Enam Section baru menerima data/callback; tidak ada provider/router dalam Section.
- Footer mempertahankan urutan Tab Simpan lalu Batal melalui FocusTraversalGroup/
  FocusTraversalOrder; posisi visual Batal kiri tetap mengikuti frame.
- app_badge_test menambah ekspektasi onPrimary untuk inverse; assertion lama tetap.
- Gradasi akhir Figma#1E5FA8 dipetakan ke heroGradientEnd#1B5FA3 yang terdekat.
  Radius pratinjau20/kartu18 dipetakan ke AppRadius.card16; font minimal global.
- Golden baru service_create_1x/2x; galeri app_badge/app_icon mengikuti varian baru.
- Regresi terarah41tes lulus, akun27tes lulus; setelah pengurutan fokus,14tes
  fokus/keyboard/viewport/golden lulus. check_all akhir SEMUA HIJAU:
  1314tes lulus/2skip, exit0; format/analyzer/lint/arsitektur bersih; REPO_MAP1231berkas.
# 21 - Tambah dan Edit Layanan
Rute: /lainnya/layanan/baru dan /lainnya/layanan/:id   Prompt: 70
Frame .pen: "Lainnya - Tambah Layanan" dan "Lainnya - Edit Layanan".
Template: FormScaffold (satu form dipakai keduanya).

Audit 100: harga baru kosong dengan hint 0 (bukan contoh 9000); mengikuti AGENTS 16a.

Komposisi lama (tetap untuk Edit, Tambah mengikuti snapshot031 di atas):
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
- Simpan baru: ID lewat IdGenerator (UUID), owner dari AuthService, createdAt jam usaha,
  sortOrder terakhir + 1. Simpan edit mempertahankan id/createdAt.
- serviceRepositoryProvider.saveService membuat direktori dan katalog reaktif.

Validasi dan state:
- Nama kosong -> 'Nama layanan wajib diisi.'.
- Harga 0/kosong -> 'Harga harus lebih dari Rp0.'.
- Busy menonaktifkan field/tombol; gagal simpan menampilkan BannerMessage.
- Layanan tidak ditemukan -> EmptyState; loading memakai AppSkeleton.

Selisih Edit terhadap .pen (layout lama, tidak diubah031):
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
