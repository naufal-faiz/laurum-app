# Golden Antrean — proposal 015

Daftar sebelum update-goldens, dari pembandingan 10 Nov 2026:

- antrean_normal.png
- antrean_proses.png
- antrean_kosong.png
- antrean_filter_kosong.png
- antrean_loading.png
- antrean_error.png
- antrean_whatsapp.png
- r4_antrean_sederhana.png
- r9_cod_queue.png
- app_card.png — galeri menampilkan rail info/success baru. Terungkap pada
  pembandingan seluruh suite; galeri ini diverifikasi ulang setelah daftar diperbarui.
- app_icon.png — ikon options/sparkles dari Ionicons untuk filter dan rekomendasi.
- order_card.png — susunan komponen bersama mengikuti frame (juga dipakai Laporan).
- beranda.png — tombol small tetap visual 40 dp, hit target menjadi 48 dp agar
  lolos aksesibilitas; posisi tombol banner dapat bergeser sedikit.
- app_button.png — galeri ukuran small memperlihatkan hit target 48 dengan visual 40.

Alasan: header tetap LAURUM/Antrean/pencarian, ringkasan order/perlu dicek + sync di body,
kartu usulan dan pesanan tersusun ulang, CTA status biru. Build dummy mendapat
badge akurasi bertanda contoh sesuai permintaan pengguna. Mode sederhana tetap
tanpa CTA status; COD tetap menampilkan pelunasan dan penahanan pembayaran.
Semua assertion perilaku dipertahankan. Pergeseran visual menunggu tinjauan pengguna.
