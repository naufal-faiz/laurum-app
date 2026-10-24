# 15 - Setor Tabungan
Rute: /pelanggan/:id/setor   Prompt: 51
Frame .pen: "Pelanggan - Setor Tabungan"; State "Validasi nominal".

Template: FormScaffold (AppBarSub + isi bergulir + FooterBar).

Komposisi:
- AppBarSub(title: 'Setor tabungan', backLabel: 'Kembali').
- AppCard ringkas pelanggan: AppAvatar, AppText nama, AppText telepon.
- StatTile(label: 'Saldo sekarang', value: Formatters.rupiah(saldo)).
- AppText 'Nominal setoran' + AppText figure nominal (Formatters.rupiah).
- NominalChips(+Rp20.000, +Rp50.000, +Rp100.000) sebagai penambah, bukan pengganti.
- Numpad standar (tanpa desimal) untuk mengetik nominal.
- AppText 'Saldo akhir menjadi <rupiah>' (saldo + nominal).
- ChipBar 'Metode setoran': Tunai (0), QRIS (1), Transfer (2).
- AppTextField 'Catatan (opsional)' hint 'Misal: titipan kembalian nota A-0142', maks 2 baris.
- FooterBar: AppButton 'Simpan tabungan (<nominal>)' dan AppText caption
  'Tabungan tidak kedaluwarsa dan otomatis memotong nota transaksi berikutnya.'

Data dan provider:
- Customer (nama, telepon) dan saldo dari customerDetailProvider(:id).
- customerDepositProvider(:id) menyimpan teks nominal, metode, catatan, busy, error validasi.
- Simpan menulis SavingsEntry(kind: setor, amount, method, note, createdAt jam usaha,
  ownerId pengguna aktif, id 'sav-<microsecondsSinceEpoch>').
- Repositori savings reaktif: Detail Pelanggan, Riwayat Tabungan, dan daftar ikut berubah.

Interaksi:
- Numpad mengetik digit; maks 9 digit; 000 menambah tiga nol; hapus digit terakhir.
- Chip nominal menambah ke nominal saat ini (Rp50.000 + chip Rp50.000 = Rp100.000).
- Simpan dengan nominal 0 ditolak: AppText error 'Nominal harus lebih dari Rp0.'
  (State "Validasi nominal") dan tidak menyimpan.
- Simpan berhasil kembali ke halaman sebelumnya; detail menampilkan saldo baru.
- Simpan gagal (repositori error) menampilkan 'Setoran gagal disimpan. Coba lagi.'
  dan mempertahankan draf.
- Pelanggan nonaktif: CTA setor di Detail/Riwayat sudah dinonaktifkan; rute langsung
  dengan id nonaktif menampilkan EmptyState 'Pelanggan tidak ditemukan'.

State layar: validasi nominal, busy (tombol nonaktif), error simpan, pelanggan tidak ada.

Format: nominal int rupiah lewat Formatters.rupiah; tanpa double. Tanggal/jam dari
Formatters di layar lain.

Selisih terhadap .pen:
- Nominal awal kosong (Rp0) agar pengguna mengetik sendiri; .pen menampilkan contoh Rp50.000.
- Metode memakai ChipBar, bukan segmented control (belum ada widget segmented di registry).
- Subtitle app bar memakai judul 'Setor tabungan'; teks bantuan saldo dan judul
  'Nominal setoran' tetap seperti frame.
- Tanpa overlay bottom sheet; memakai halaman penuh sesuai rute yang diminta prompt.
