# 30 - Transaksi baru bagian 1
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: prompt 20 SELESAI. Baca: frame "Transaksi - Pilih Layanan", "Buat Transaksi", "Input Berat", "Tambah Pelanggan Cepat" dan varian State terkait.

Layar: Buat Transaksi (/transaksi/baru), Pilih Layanan (/transaksi/baru/layanan), Input Berat (sheet), Tambah Pelanggan Cepat (sheet).

Aturan:
- Draf nota di Notifier yang bertahan antar layar alur (bukan autoDispose) dan dibersihkan setelah disimpan atau dibatalkan.
- Pilih pelanggan lewat pencarian (AppSearchField); jika tidak ada hasil, tawarkan "Tambah pelanggan baru" yang membuka sheet.
- Tambah Pelanggan Cepat: validasi nama dan nomor; nomor duplikat menampilkan "Nomor ini sudah terdaftar atas nama <nama>." dengan tautan "Pakai pelanggan ini". "Ambil dari kontak HP" memakai ContactSource palsu.
- Pilih Layanan: hanya layanan aktif, dikelompokkan Kiloan dan Satuan, ada Sering dipakai dan pencarian.
- Berat: kotak nilai yang bisa diketuk membuka sheet Input Berat (Numpad desimal, NominalChips +0,5/+1/+5 kg, ringkasan "3,5 kg x Rp9.000 = Rp31.500"). StepperField langkah 0,5 kg atau 1 pcs.
- Estimasi selesai dari estimateReady dengan teks "Mengikuti layanan terlama". Total dan diskon dari fungsi domain.
- Keluar dengan draf berisi memunculkan ConfirmModal "Keluar tanpa menyimpan?".
- Footer "Bayar" menuju /transaksi/baru/bayar (placeholder sampai prompt 32).
Spec: 02, 03, 04, 05 di docs/design/screens/.
