# 022 - Irisan UI Pembayaran
Status: disetujui pengguna 11 Nov 2026; jalur biasa untuk irisan pembayaran.
Dasar: 0eee5b6; frame 1146 dibaca lewat MCP, tanpa snapshot.

## Komponen bersama (aturan 2, UI-12, UI-13, UI-21)
- Atom AppCard: tambah AppCardStyle.primary untuk kartu total biru; default tetap outlined.
- Warna/radius/spacing memakai token global yang ada; radius kartu 16 terdekat dari Figma 18.
- Molecule baru SelectionTile: label, selected, onPressed; subtitle dan icon opsional.
- Seluruh baris dapat ditekan, indikator pilihan lewat AppIcon; tanpa provider/state internal.
- SelectionTile dipakai untuk pilihan bayar sekarang/COD dan tiga metode pembayaran.
- Registry ditambah SelectionTile; API widget lama tetap kompatibel.
- Layar terdampak langsung hanya Pembayaran; pemakai AppCard lama tetap memakai default.

## Page/Section setelah komponen disetujui
- FormScaffold varian detail yang sudah ada; nama pelanggan menjadi subtitle.
- Total tagihan biru, pilihan waktu bayar terpisah, metode berupa tiga baris.
- Uang diterima tetap membuka CashInputSheet; nominal dan kembalian diperjelas.
- Tabungan tetap setelah pilihan waktu bayar dan sebelum metode pembayaran.
- Footer satu baris: Kembali (sekunder, kiri) dan Konfirmasi pembayaran (utama, kanan).
- Callback lama tetap: Kembali menyimpan ke antrean; Konfirmasi membuka struk setelah simpan.
- Label Bayar nanti (COD) dan Transfer tetap mengikuti spec/tes perilaku.
- Nomor nota, nama bank dan badge Belum bayar contoh tidak ditambahkan ke draf.
- Tanpa perubahan state/data/rute/token/dependensi; struk di luar irisan ini.

## Verifikasi
- Tes widget komponen + fungsi halaman, COD, tabungan, kelebihan, keyboard dan teks besar.
- Golden hanya komponen/Pembayaran yang berubah; check_all sekali di akhir irisan.
- Snapshot 0; maksimal 1 gambar frame hanya jika struktur node tidak mencukupi.
