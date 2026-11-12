# 025 — Header halaman bersama
Status: DISETUJUI pengguna12 Nov2026 untuk diuji/revisi/rollback; hasil final diterima dan commit diizinkan. Dasar88addea.
Tujuan: satu desain LAURUM → judul halaman → subjudul untuk Antrean/Pelanggan/Lainnya.
## Komponen dan API
- Organism baru `AppPageHeader` di shared/widgets/organisms; daftarkan ke registry.
- API: `title`, `subtitle` wajib String; `action`, `status` opsional Widget.
- LAURUM tetap di atas; judul/subjudul diganti lewat parameter kode, bukan form pengguna.
- Brand label, judul titleRoot, subjudul caption; seluruh gaya memakai token yang ada.
- Action menampung tombol cari/akun; status menampung SyncIndicator yang sudah ada.
- Judul/brand satu baris; subjudul boleh membungkus agar data tidak hilang.
- Pada ruang <320dp/teks >1.3, status pindah baris; tinggi mengikuti isi aktual.
- Satu perhitungan/tata letak tinggi di komponen/template; hapus hitungan88/112 per fitur.
- RootScaffold mendapat slot opsional pageHeader=null yang mengakomodasi tinggi intrinsik;
  AppBarRoot lama, header Beranda dan penggunaan template lainnya tetap bawaan.
## Penerapan dan paritas
- Antrean: title Antrean; subtitle jumlah order aktif + perlu dicek; tombol cari/tutup,
  status sinkronisasi, banner offline/WhatsApp dan semua aksi tetap.
- Pelanggan: title Pelanggan; subtitle jumlah pelanggan dari provider yang sudah ada.
  Pindahkan judul/jumlah dari body ke header; impor/tambah/cari/filter/daftar tetap.
- Izin UI-8 spesifik: RootShell boleh membaca customerDirectoryProvider secara kondisional
  untuk memindahkan jumlah pelanggan; tidak membuat/mengubah provider atau state.
- Lainnya: title Lainnya; subtitle Pengaturan toko · Laurum v1.0.0;
  avatar inisial usaha/aksi akun dan status simpan tetap. Judul bisa diganti via parameter.
- Section header fitur diganti/delegasikan; tidak lagi menyimpan gaya/tinggi sendiri.
- Beranda, rute/router, repository, perhitungan laporan dan dependensi tidak berubah.
## Verifikasi dan batas
- Tes komponen satu sumber:320/390px,skala1/2,judul/subjudul panjang,semua status/aksi.
- Tes integrasi3halaman dan golden terkait; pertahankan assertion perilaku lama.
- Target termasuk menyelesaikan overflow2px pada implementasi header lama.
- Analyze/check_arch; check_all sekali akhir integrasi. Tanpa screenshot; commit final telah diizinkan pengguna.
