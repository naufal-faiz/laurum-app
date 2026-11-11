# 023 - Irisan Struk Pembayaran
Status: DISETUJUI pengguna 11 Nov 2026, termasuk layanan/state ekspor dan dependensi PDF.
Dasar 71da260; frame terpilih 4294967599 dikonfirmasi lewat selection; snapshot 1.

## Tampilan yang diminta
- Kartu struk membulat, label Pratinjau struk, header nomor nota/pelanggan/status.
- Footer normal satu baris Selesai/WhatsApp/Unduh/Cetak; teks >1,3x menempatkan Selesai di atas ikon.
- Selesai tetap memakai onHome ke /antrean, bukan menyelesaikan status order.
- WhatsApp/cetak tetap callback lama; ikon memiliki tooltip/semantics yang jelas.
- Lihat detail menjadi tautan di body; Catat pembayaran hanya saat masih bersisa.

## Komponen bersama (UI-13, UI-21)
- AppIconButton: varian tilePrimary/tileSuccess/tileNeutral; default lama tetap.
- Molecule ReceiptRows + organism ReceiptDocument ditambah ke registry; ReceiptPreview thermal tetap.
- Data grafis dari nota tersimpan; formatter cetak/WhatsApp 32 kolom tetap utuh.
- Struktur kartu disusun lewat atoms/molecules/organisms registry; tanpa dekorasi di Section.
- Ukuran/radius/warna memakai token global; tile 48 dp mengikuti snapshot pilihan terbaru.

## Izin perluasan fitur untuk Unduh (UI-6/UI-9/UI-20, disetujui)
- Unduh menyimpan PDF yang mengikuti desain kartu struk, dari data nota yang sama.
- Layanan/state ekspor memakai pdf + file_saver (flutter pub add); batal simpan tidak dianggap sukses.
- Pemilih simpan memakai platform yang sesuai Android/iOS; iOS ditandai belum diuji.
- Tidak membuat tombol Unduh mati, placeholder, atau berpura-pura berhasil.
- Izin zona beku dibatasi alur ekspor; logika bayar/cetak/COD/complete=1 tetap.

## Paritas dan verifikasi
- Status printer, error/notice, retry/pengaturan dan guard complete/COD tetap tersedia.
- Barcode/data kasir contoh tidak dipalsukan; hanya data nyata yang tersedia ditampilkan.
- Tes fungsi dan golden terkait; check_all sekali di akhir; satu commit irisan.
- Snapshot frame 1 sudah cukup; FigCraft tetap hanya dibaca.
