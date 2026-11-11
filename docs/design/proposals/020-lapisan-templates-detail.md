# 020 � Lapisan templates: FormScaffold header detail
Status: DISETUJUI pengguna 11 Nov 2026; baru dikerjakan setelah 019 selesai/hijau.
Acuan: header dan footer frame FigCraft 512 dan 612.

## API
FormScaffold tambah subtitle String? = null dan
appBarVariant AppBarSubVariant = AppBarSubVariant.standard.
Semua parameter lama, summary/footer/padding, callback dan perilaku default tetap.

- standard tetap appBar lama 64 dp, tidak menggeser layar lain.
- detail memakai AppBarSub detail dengan tinggi intrinsik sebagai header tetap
  di atas area gulir; konten memakai Expanded + SingleChildScrollView di template.
  Dengan ini teks besar dapat membungkus tanpa tinggi appbar yang memotong isi.
- FooterBar dan SafeArea tetap. Keyboard 300 dp harus menyisakan field fokus dan
  aksi simpan/setuju yang terlihat. Metadata header boleh ditata ringkas ketika
  keyboard terbuka; aksi kembali dan aksi halaman tetap tersedia.
- Hanya dua Page sasaran mengaktifkan detail; Page tidak membuat Scaffold/scroll
  sendiri. Tidak mengubah path/parameter rute atau navigasi.

## Bukti sebelum Page/Section
Tes default lama, header tetap saat menggulir, teks 2x/320 dp, kembali/trailing,
keyboard 300 dp dan footer. Golden varian detail baru; galeri default harus tetap.
check_all hijau sebelum menerapkan Page/Section.

## Adaptasi perilaku yang dipertahankan pada Page
- Usulan: pesan lengkap, nama/telepon pelanggan baru, pilihan layanan dan alamat
  tetap dapat diedit dengan callback lama; validasi, dialog dan pending tetap.
- Frame memiliki Isi berat/jadwal jemput yang belum didukung draft/state usulan.
  Tidak ditambahkan sebagai tombol mati atau fitur baru; berat tetap dilengkapi
  setelah persetujuan lewat Edit order. Jadwal jemput tidak ditambahkan.
- Skor AI hanya contoh berlabel pada main_dummy dari fixture yang sudah diizinkan;
  tidak menampilkan skor buatan pada data nyata.
- Order: semua nilai termasuk subtotal/diskon/catatan, pembayaran dan seluruh
  aktivitas tetap ditampilkan. Mode sederhana mengikuti footer ikon Edit/Hapus;
  mode status aktif, cetak struk, COD tertahan dan order final mempertahankan aksi.
