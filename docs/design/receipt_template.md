# Template struk (satu-satunya)

Dipakai oleh `ReceiptPreview` (layar Printer dan Nota Tersimpan) dan nanti oleh printer thermal lewat `ReceiptFormatter` (fungsi murni yang sama, sehingga preview dan cetakan identik).

Kertas thermal 58 mm = **32 kolom**. IBM Plex Mono 11/16, teks `#000000`, latar putih, tepi atas dan bawah bergerigi, lebar 320. Garis pemisah tepat 32 tanda `-`. Harga rata kanan. Contoh (nota A-0143):

```
         BERKAH LAUNDRY
   Jl. Melati No. 4, Sukajadi
      Telp 0812-3456-7890
--------------------------------
No. Nota : A-0143
Tanggal  : 16 Okt 2026 10:45
Pelanggan: Pak Dedi
--------------------------------
Cuci setrika            Rp31.500
  3,5 kg @ Rp9.000
Bed cover               Rp25.000
  1 pcs @ Rp25.000
--------------------------------
TOTAL                   Rp56.500
Tabungan dipakai        Rp50.000
Dibayar tunai            Rp6.500
SISA BAYAR                   Rp0
Sisa tabungan                Rp0
STATUS: LUNAS
--------------------------------
Catatan: pewangi lavender,
jangan dicampur pakaian putih
--------------------------------
       Terima kasih atas
        kepercayaan Anda
  Pakaian bersih, wangi & rapi
```

## Aturan baris kondisional
- "Tabungan dipakai" hanya jika ada.
- "Dibayar tunai/QRIS/transfer" hanya jika ada pembayaran non-tabungan.
- "Sisa tabungan" hanya jika pelanggan punya atau memakai tabungan.
- "Catatan" hanya jika diisi.
- Status yang diizinkan: `LUNAS`, `LUNAS (TABUNGAN)`, `DP Rp10.000`, `BELUM BAYAR`.
- Selalu tampil dan tidak bisa dimatikan: nomor nota, tanggal, rincian item, total.
- Tidak ada logo di struk.
