# 08 - Nota Tersimpan
Rute: /transaksi/nota/:id   Fase: 3   Frame .pen: "Transaksi - Nota Tersimpan"
Template: SubScaffold (AppBarSub, tanpa nav)

Komposisi:
- ReceiptStatusSection: AppCard Nomor nota, AppStatusText Lunas/DP/Belum bayar,
  konfirmasi pembayaran tersimpan atau dicatat saat diterima, status printer (nama + Terhubung / belum terhubung).
- BannerMessage error 'Struk gagal dicetak. Pastikan printer menyala dan Bluetooth aktif.'
  + AppButton 'Coba lagi' dan 'Pengaturan printer'.
- ReceiptPreview dari receiptLines data tersimpan; lebar 320/384 sesuai ReceiptSettings.
  Kertas dan blok monospasi terpusat; perataan antar baris formatter tetap dipertahankan.
- ReceiptActionsSection: WhatsApp + AppIconButton cetak; Lihat detail + Ke beranda.
  Tombol cetak hanya ikon printer berborder, tooltip/semantics Cetak struk (4 Nov 2026).

Data dan provider:
- receiptViewProvider(:id): Order, OrderItem, Payment, Customer, BusinessProfile,
  ReceiptSettings, saldo tabungan; nota tidak ditemukan -> EmptyState.
- receiptPrintProvider: printing/error/notice; PrintService.printReceipt(ReceiptData).
- ExternalLauncher.launchWhatsApp (palsu) untuk kirim nota.

Interaksi:
- Cetak struk mengirim 32 kolom + paperMm/fontSize; sukses notice, gagal banner + retry.
- Pengaturan printer membuka /lainnya/printer.
- Kirim lewat WhatsApp memakai nomor pelanggan dan teks struk; gagal menampilkan banner.
- Ke beranda ke /antrean; Lihat detail ke /order/:id.
- Dibuka dari Selesaikan pada Detail dengan query complete=1: ikon cetak dan retry
  memakai orderCompletionProvider. Cetak berhasil baru menyelesaikan order; gagal
  atau kembali tetap aktif. Guard memeriksa ulang mode/status/COD saat mencetak.
  Membuka struk biasa tetap hanya mencetak tanpa mengubah status.
- Kembali ke /antrean bila tidak ada tumpukan rute.

State: loading skeleton, gagal memuat, nota tidak ditemukan, cetak sukses/gagal,
WhatsApp sukses/gagal, printer belum terhubung.

Format: struk identik ReceiptFormatter 32 kolom; pelanggan memakai nama lengkap kecuali
fixture nota yang memang menyimpan nama pendek.

Selisih terhadap .pen: struk tidak dicetak otomatis saat nota dibuka (tombol Cetak struk);
status printer berasal dari FakePrintService, bukan Bluetooth nyata. iOS belum diuji;
printer Bluetooth Classic tidak didukung iOS non-MFi.

## R9 - pembayaran lanjutan
ReceiptStatusSection kini Stateless: data cetak/printer dan callback disuplai Page.
Label bayar memakai pemetaan state bersama: Lunas, Sisa Rp X, COD - sisa Rp X.
ReceiptActionsSection menambah Catat pembayaran selama ada sisa dan nota tidak batal,
termasuk nota selesai. Aksi membuka PaymentRecordSheet yang sama dengan Detail/Piutang.
Membuka atau mencetak struk COD tidak menyelesaikan order. Struk menampilkan sisa/COD,
bukan label DP/Belum bayar. Keberhasilan pembayaran memuat ulang preview dan label.
Penyimpanan pembayaran/kelebihan tabungan atomik lewat TransactionRunner R8.
Selisih .pen: aksi pembayaran tambahan dan label sisa; tes callback, alur dan 320 px/2x.

## Susunan aksi - koreksi lanjutan 4 Nov 2026
- Semua tombol berukuran sama: dua kolom sama lebar, tinggi 48 dp dan teks bodyStrong
  14 sp. Urutan WhatsApp, cetak, Catat pembayaran bila bersisa, Lihat detail, Ke beranda.
- Cetak memakai AppButton actionOutline tanpa teks, ikon terpusat dan border yang sama;
  seluruh bidang bisa ditekan. WhatsApp/Catat pembayaran memakai action (font sama).
- Teks >1,3x: satu kolom; tinggi seragam mengikuti dua baris teks atau minimum 48 dp.
  Semua aksi nonaktif saat cetak. Tidak mengecilkan skala teks aksesibilitas.
- Isi struk dan API widget bersama tetap; ReceiptPreview memusatkan blok teks dengan
  lebar intrinsik. Belum diuji manual di Android/iOS atau printer nyata.
