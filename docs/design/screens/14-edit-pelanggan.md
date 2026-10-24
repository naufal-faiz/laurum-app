# 14 - Edit Pelanggan
Rute: sheet dari Detail Pelanggan   Prompt: 50
Frame .pen: "Pelanggan - Edit Pelanggan".
Template: AppBottomSheet + SheetScaffold (tinggi isi 500 px).

Komposisi:
- LabeledField + AppTextField: Nama pelanggan, Nomor WhatsApp, Alamat (opsional),
  Catatan (opsional); BannerMessage bila penyimpanan gagal.
- AppButton Simpan perubahan dan Nonaktifkan pelanggan (destructiveOutline).
- ConfirmModal untuk nonaktif.

Provider: customerEditProvider (CustomerEditState/CustomerEditController).
Draf diisi dari Customer; form tidak mengubah repository sebelum Simpan.
Nama wajib, telepon dinormalisasi ke 0... dan harus cocok 08 + 8..11 digit.
Nomor pelanggan aktif lain ditolak; nomor milik sendiri diperbolehkan.
Simpan mempertahankan id/ownerId/createdAt; updatedAt memakai jam usaha dan sync pending.
State busy menonaktifkan input/tombol dan mencegah pengiriman ganda.
Kegagalan simpan mempertahankan draf dan menampilkan 'Perubahan gagal disimpan. Coba lagi.'.

Konfirmasi baru (tidak tersedia sebagai frame State):
- Judul: 'Nonaktifkan pelanggan?'
- Pesan: 'Pelanggan tidak lagi muncul di daftar aktif. Riwayat nota, piutang, dan tabungan tetap tersimpan.'
- Konfirmasi: 'Ya, nonaktifkan'; batal: 'Kembali'.
Nonaktif memakai saveCustomer(isActive: false), bukan deleteCustomer. Tidak menerapkan
perubahan draf yang belum disimpan. Detail tetap dapat dibuka; daftar aktif berkurang.
Data keuangan tidak disentuh. Pelanggan diambil ulang saat simpan untuk memvalidasi status.

Selisih .pen: tinggi isi dibatasi 500 px dan form dapat digulir; teks validasi/konfirmasi
ditambahkan. Tanpa widget/token baru. Tutup sheet membuang draf tanpa menyimpan.
Tes: nama kosong/nomor duplikat, normalisasi nomor sendiri, simpan profil,
batal konfirmasi, nonaktif dan preservasi histori.
Keyboard/perangkat nyata belum diuji; belum diuji di iOS.
