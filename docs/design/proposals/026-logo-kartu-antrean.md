# Logo dan posisi harga kartu antrean

Disetujui pengguna melalui "Lanjutkan" pada 13 Nov 2026.
Tambahan pada persetujuan yang sama: PNG WhatsApp menyerupai preview struk.

- IconTile: parameter opsional imageAsset (default null), memakai PNG asli
  dengan BoxFit.contain; preset logo memakai assets/laurum-logo.png.
- BrandLockup tetap memakai preset logo dengan ukuran 38; header Beranda 42.
  Ilustrasi dan ikon lainnya tidak berubah, teks merek tetap di tempatnya.
- OrderCard: harga dipisahkan dari Wrap metadata ke footer paling bawah,
  rata kanan. Aksi di kiri; pada ruang sempit footer dapat turun baris.
  Label, status, nilai uang dan seluruh callback dipertahankan.
- PNG WhatsApp: render ReceiptDocument yang sama dengan preview, seluruh
  tinggi dokumen, resolusi 2x; lebar logis 320/384 mengikuti pengaturan struk.
- Tanpa widget registry/dependensi/token baru. Aset PNG didaftarkan di pubspec.
- Tes terarah: logo, harga pada label COD panjang, PNG vs preview dan struk panjang.
- Golden hanya komponen/layar terdampak; perubahan font maksimum 100% sebelumnya
  ikut disimpan dan diverifikasi dalam batch ini.
