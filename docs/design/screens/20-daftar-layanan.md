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

## Koreksi desain 14 Nov 2026 (frame LAURUM · Daftar Layanan)
Frame baru 390×844 mengikuti bahasa desain layar lain (header sub-halaman, konten
abu-abu, kartu putih radius 18).
- Header: tombol kembali bulat, judul "Daftar Layanan" 19, subjudul
  "6 layanan · 5 aktif" 9,5.
- Pencarian: field putih radius 12 dengan ikon cari dan placeholder
  "Cari layanan laundry...".
- Baris hitung "Total 6 layanan · 5 aktif" 9 px di atas daftar.
- Kartu layanan 342×84 (radius 18, padding 12/10): kotak ikon 40 radius 12, nama
  11,5 + jenis 8,5, switch 40×22; baris bawah harga 11,5 biru + "/ kg" atau
  "/ pcs" 8,5 serta durasi 8,5 rata kanan.
- Nonaktif: nama, ikon, dan harga abu; jenis menjadi "Satuan · Nonaktif"; switch
  abu dalam posisi mati.
- Footer: satu tombol "Tambah layanan" (biru, ikon +) dan home indicator.

Selisih desain:
- Jumlah layanan memakai satu baris kecil, bukan SectionHeader beraksi; tidak ada
  kontrol "Urutkan" (urutan tetap sortOrder).
- Jenis tampil sebagai subjudul kartu, bukan chip; status nonaktif dibaca dari
  teks jenis, bukan chip "Nonaktif" terpisah.
- Data kartu memakai DATA MASTER (enam layanan, lima aktif), bukan contoh lain.
- Perilaku di atas (tap baris ke detail, switch menyimpan isActive, pencarian,
  kosong/loading/error) tetap sama.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
