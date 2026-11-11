# 08 - Nota Tersimpan
Rute: /transaksi/nota/:id   Fase: 3   Frame .pen: "Transaksi - Nota Tersimpan"
Template: SubScaffold (AppBarSub, tanpa nav)

## Redesign frame 4294967599 (11 Nov 2026)
Frame dibaca sekali lewat MCP FigCraft. Pengguna lalu memilih frame yang sama dan
meminta snapshot: selection 4294967599 dikonfirmasi, snapshot 1 diambil sebagai acuan terbaru.
Ekspor PDF/dependensi dan penempatan tautan disetujui pengguna pada proposal 023.
Urutan Figma: header kembali/judul/nomor nota/pelanggan/status; label pratinjau;
kartu struk putih di area abu-abu; footer terbaru Selesai, WhatsApp, Unduh, Cetak satu baris.
Pemetaan: FormScaffold detail, ReceiptStatusSection, ReceiptDocument + ReceiptRows,
ReceiptActionsSection, AppIconButton tileSuccess/tilePrimary/tileNeutral, AppButton dan PaymentBadge.
Pratinjau grafis mengikuti snapshot terpilih; keluaran formatter cetak/WhatsApp tetap utuh.
Font minimum 11 dan warna/jarak memakai token global; radius 18 dipetakan ke card 16.

### Paritas redesign
Tabel dibuat sebelum implementasi; centang sesudah kode dan verifikasi.

| Butir | Sumber/aksi/keadaan yang dipertahankan | Terverifikasi |
|---|---|---|
| Nota | receiptViewProvider(orderId): order/items/payments/customer/business/settings/savingsBalance | [ ] |
| Isi | receipt.lines identik formatter; paperMm 80 -> lebar 384, lainnya 320 | [ ] |
| Status | paidAmount/payStatus/paymentLabel turunan; Lunas/Sisa/COD | [ ] |
| Cetak state | receiptPrintProvider: printing/error/notice; controller yang sama | [ ] |
| Penyelesaian | orderCompletionProvider(orderId), query complete=1; _print dan guard lama | [ ] |
| Printer | printServiceProvider: status dan connectedPrinter.name | [ ] |
| Sibuk | printing.printing atau completion.busy; semua aksi footer nonaktif | [ ] |
| Cetak/retry | _print(ref, receipt, completing) dengan argumen tetap | [ ] |
| Printer settings | context.push('/lainnya/printer') | [ ] |
| WhatsApp | controller.sendWhatsApp(receipt) | [ ] |
| Selesai | pengganti label Ke beranda: context.go('/antrean'), tidak menyelesaikan order | [ ] |
| Detail | context.push('/order/$orderId') | [ ] |
| Catat bayar | openOrderPayment(context, ref, orderId); hanya sisa > 0 dan tidak batal | [ ] |
| Kembali | context.canPop() ? context.pop() : context.go('/antrean') | [ ] |
| Memuat | enam AppSkeleton; tidak ada aksi nota | [ ] |
| Gagal/kosong | Gagal memuat nota / Nota tidak ditemukan; ikon lama | [ ] |
| Error/notice | error completion/cetak sesuai mode, retry, Pengaturan printer, notice | [ ] |
| Key/akses | tidak ada Key eksplisit di Page/Section; semantics/tooltip Cetak struk tetap | [ ] |
| Teks besar | footer dan Catat pembayaran terbaca/terjangkau pada 320 px, teks 2x | [ ] |

### Selisih desain
- Bagikan tidak ditambahkan. Unduh PDF memakai layanan nyata dengan dialog simpan file_saver.
- Tidak membuat tombol Unduh mati/placeholder. Barcode contoh tidak dipalsukan.
- Isi preview grafis dari nota tersimpan; formatter cetak/WhatsApp 32 kolom tetap utuh.
- Data kasir tidak ditambahkan; mengikuti isi/pengaturan nota yang sudah tersimpan.
- Printer/status/konfirmasi, retry dan Catat pembayaran lama tetap tersedia.
- Label Ke beranda diganti Selesai sesuai permintaan; callback navigasi tetap, status order tidak berubah.
- Usulan penempatan fungsi lama: status/error di body, Lihat detail sebagai tautan,
  Catat pembayaran di body bila tersedia; empat aksi utama tetap di footer.
- Ekspor memakai pdf 3.13.1 dan file_saver 0.7.0 hasil flutter pub add; pembatalan tidak memunculkan sukses.
- PDF memakai Helvetica dengan fallback aset IBM Plex Mono; pratinjau aplikasi memakai Inter.
- Izin state/layanan/dependensi ekspor dan penempatan aksi tambahan diberikan pengguna 11 Nov.
- WIP: footer normal lolos; teks 2x pada 320 px membuat label Selesai menjadi 132 dp (empat baris).
- Tes callback lama dipertahankan; label judul/beranda/WhatsApp dan finder mengikuti struktur baru.

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


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
