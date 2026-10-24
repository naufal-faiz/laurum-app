# 05 - Tambah Pelanggan Cepat
Rute: sheet dari CustomerPickerSheet   Fase: 3
Juga dipakai dari /pelanggan lewat navigator utama agar tidak terpotong area tab.
Frame .pen: "Pelanggan - Tambah Pelanggan Cepat" (sheet S21) + State Validasi nama,
Validasi nomor WhatsApp, Nomor pelanggan sudah ada.
Template: AppBottomSheet + SheetScaffold

Komposisi:
- AppBottomSheet(title: 'Tambah pelanggan cepat', subtitle 'Tersimpan ke kontak usaha.').
- BannerMessage info 'Pelanggan yang disimpan langsung dipilih untuk nota ini.'.
- LabeledField + AppTextField: Nama pelanggan (wajib), Nomor WhatsApp (wajib),
  Alamat (opsional, multiline), Catatan (opsional).
- Saat nomor duplikat: AppButton('Pakai pelanggan ini') di bawah field nomor.
- Footer AppButton('Simpan pelanggan') + AppButton('Ambil dari kontak HP').

Data dan provider:
- addCustomerFormProvider (nama, nomor, alamat, catatan, error, duplicate).
- CustomerRepository.getCustomers/saveCustomer; ContactSource palsu untuk kontak.
- AuthService.currentUserId dan businessClockProvider untuk ownerId/createdAt.

Interaksi:
- Simpan memvalidasi nama dan nomor; nomor dinormalkan ke 0... (62/8 -> 0).
- Nomor yang sudah dipakai menampilkan 'Nomor ini sudah terdaftar atas nama <nama>.'
  dan tautan 'Pakai pelanggan ini' memilih pelanggan tersebut.
- 'Ambil dari kontak HP' membuka ContactPickerSheet; memilih kontak mengisi nama/nomor.
- Simpan berhasil membuat Customer baru, memilihnya untuk draf, lalu menutup sheet.
- Dari Daftar Pelanggan: forOrder=false mengganti banner menjadi 'Pelanggan yang
  disimpan akan muncul di daftar pelanggan.'; tidak mengubah draf transaksi.

State: kosong, error nama, error nomor, duplikat, daftar kontak/loading/kosong.
Format: Formatters.telepon untuk tampilan nomor; nomor disimpan dalam bentuk 0...

Selisih terhadap .pen: tinggi sheet dibatasi 500 px agar dapat digulir; tidak ada field
+62 terpisah (normalisasi otomatis); tombol Simpan memakai label 'Simpan pelanggan'
(frame S21: 'Simpan dan pakai'); ContactPickerSheet adalah sheet tambahan.
