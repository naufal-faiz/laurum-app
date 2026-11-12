# 08 - Nota Tersimpan
Rute: /transaksi/nota/:id   Fase: 3   Frame FigCraft: 4294967599
Template: FormScaffold detail, pratinjau gulir dan footer sticky tanpa nav.

## Redesign frame 4294967599 (11 Nov 2026)
Frame dibaca sekali lewat MCP FigCraft. Pengguna lalu memilih frame yang sama dan
meminta snapshot: selection 4294967599 dikonfirmasi, snapshot 1 diambil sebagai acuan terbaru.
Ekspor PDF/dependensi dan penempatan tautan disetujui pengguna pada proposal 023.
Urutan Figma: header kembali/judul/nomor nota/pelanggan/status; label pratinjau;
kartu struk putih di area abu-abu; footer terbaru Selesai, WhatsApp, Unduh, Cetak satu baris.
Pemetaan: FormScaffold detail, ReceiptStatusSection, ReceiptDocument + ReceiptRows,
ReceiptActionsSection, AppIconButton tileSuccess/tilePrimary/tileNeutral, AppButton dan AppText.
Pratinjau grafis mengikuti snapshot terpilih; keluaran formatter cetak/WhatsApp tetap utuh.
Font minimum 11 dan warna/jarak memakai token global; radius 18 dipetakan ke card 16.

### Paritas redesign
Tabel dibuat sebelum implementasi; centang sesudah kode dan verifikasi.

| Butir | Sumber/aksi/keadaan yang dipertahankan | Terverifikasi |
|---|---|---|
| Nota | receiptViewProvider(orderId): order/items/payments/customer/business/settings/savingsBalance | [x] |
| Isi | receipt.lines identik formatter; paperMm 80 -> lebar 384, lainnya 320 | [x] |
| Status | paidAmount/payStatus/paymentLabel turunan; Lunas/Sisa/COD | [x] |
| Cetak state | receiptPrintProvider: printing/error/notice; controller yang sama | [x] |
| Penyelesaian | orderCompletionProvider(orderId), query complete=1; _print dan guard lama | [x] |
| Printer | printServiceProvider: status dan connectedPrinter.name | [x] |
| Sibuk | printing.printing atau completion.busy atau download.busy; semua aksi footer nonaktif | [x] |
| Unduh | receiptDownloadProvider/service: dokumen sama, dialog simpan PDF, cegah duplikasi | [x] |
| Hasil unduh | sukses/error ditampilkan; batal tanpa pesan sukses/error; state dilepas saat meninggalkan layar | [x] |
| Cetak/retry | _print(ref, receipt, completing) dengan argumen tetap | [x] |
| Printer settings | context.push('/lainnya/printer') | [x] |
| WhatsApp | controller.sendWhatsApp(receipt) | [x] |
| Selesai | pengganti label Ke beranda: context.go('/antrean'), tidak menyelesaikan order | [x] |
| Detail | context.push('/order/$orderId') | [x] |
| Catat bayar | openOrderPayment(context, ref, orderId); hanya sisa > 0 dan tidak batal | [x] |
| Kembali | context.canPop() ? context.pop() : context.go('/antrean') | [x] |
| Memuat | enam AppSkeleton; tidak ada aksi nota | [x] |
| Gagal/kosong | Gagal memuat nota / Nota tidak ditemukan; ikon lama | [x] |
| Error/notice | error completion/cetak sesuai mode, retry, Pengaturan printer, notice | [x] |
| Key/akses | tidak ada Key eksplisit di Page/Section; semantics/tooltip Cetak struk tetap | [x] |
| Teks besar | footer dan Catat pembayaran terbaca/terjangkau pada 320 px, teks 2x | [x] |

### Selisih desain
- Bagikan tidak ditambahkan. Unduh PDF memakai layanan nyata dengan dialog simpan file_saver.
- Tidak membuat tombol Unduh mati/placeholder. Barcode contoh tidak dipalsukan.
- Isi preview grafis dari nota tersimpan; formatter cetak/WhatsApp 32 kolom tetap utuh.
- Data kasir tidak ditambahkan; mengikuti isi/pengaturan nota yang sudah tersimpan.
- Alamat pelanggan di bawah nama maksimal 2 baris, mengikuti showCustomer; kosong tidak ditampilkan.
- Header/ucapan dirapatkan ke xxsmall; receiptFooter memakai variant label (tebal), catatan caption.
- Bar status memakai label, centang dan successTint saat lunas; metode rata kanan (spaceBetween).
- PDF mengikuti alamat/status/metode/tebal footer dari data yang sama; formatter thermal tetap.
- Kartu printer dipindah ke atas pratinjau dan hanya berisi info printer;
  status lunas dan kalimat Pembayaran tersimpan pada kartu itu dihapus sesuai pengguna.
- Reload (tooltip Coba lagi) saat error dan gerigi Pengaturan printer berada di satu kartu;
  callback, pesan error/notice serta Catat pembayaran tetap.
- Label Ke beranda diganti Selesai sesuai permintaan; callback navigasi tetap, status order tidak berubah.
- Usulan penempatan fungsi lama: status/error di body, Lihat detail sebagai tautan,
  Catat pembayaran di body bila tersedia; empat aksi utama tetap di footer.
- Ekspor memakai pdf 3.13.1 dan file_saver 0.7.0 hasil flutter pub add; pembatalan tidak memunculkan sukses.
- PDF memakai Helvetica dengan fallback aset IBM Plex Mono; pratinjau aplikasi memakai Inter.
- Izin state/layanan/dependensi ekspor dan penempatan aksi tambahan diberikan pengguna 11 Nov.
- Pada teks >1,3x, Selesai berada di atas tiga ikon agar tetap terbaca; skala teks tidak dikecilkan.
- Tes callback lama dipertahankan; label judul/beranda/WhatsApp dan finder mengikuti struktur baru.

Komposisi:
- ReceiptDocument: kartu grafis berisi identitas usaha, nomor/tanggal/pelanggan, item,
  subtotal/diskon/total/pembayaran/sisa, status turunan dan footer; nomor nota tidak diulang.
- ReceiptStatusSection: satu AppCard printer di atas pratinjau, nama/status terhubung,
  ikon reload saat error dan gerigi pengaturan; tanpa duplikasi status bayar/konfirmasi.
- BannerMessage error 'Struk gagal dicetak. Pastikan printer menyala dan Bluetooth aktif.'
  + AppIconButton reload 'Coba lagi' dan gerigi 'Pengaturan printer' di dalam kartu.
- Lebar kartu 320/384 sesuai ReceiptSettings; ReceiptPreview thermal lama tetap utuh.
- ReceiptActionsSection: Selesai + tiga ikon WhatsApp/Unduh/Cetak, tooltip/semantics tetap.
- ReceiptLinksSection di body: Lihat detail, serta Catat pembayaran bila tersedia.

Data dan provider:
- receiptViewProvider(:id): Order, OrderItem, Payment, Customer, BusinessProfile,
  ReceiptSettings, saldo tabungan; nota tidak ditemukan -> EmptyState.
- receiptPrintProvider: printing/error/notice; PrintService.printReceipt(ReceiptData).
- ExternalLauncher.launchWhatsApp: DeviceExternalLauncher pada build Drift, palsu untuk dummy/tes.

Interaksi:
- Cetak struk mengirim 32 kolom + paperMm/fontSize; sukses notice, gagal banner + retry.
- Pengaturan printer membuka /lainnya/printer.
- WhatsApp membagikan gambar PNG berisi seluruh data struk dan pesan otomatis berisi
  nama pelanggan, nomor nota, serta nama usaha. Pengguna mengonfirmasi pengiriman di WhatsApp.
  No. HP kosong ditampilkan `-` pada preview, PDF, gambar, dan cetak; beberapa pelanggan
  boleh tanpa nomor. Tanpa nomor, WhatsApp memilih penerima biasa.
  Android mengirim lampiran lewat ACTION_SEND ke WhatsApp/WhatsApp Business dengan
  petunjuk penerima bila ada nomor; aplikasi WhatsApp bisa tetap meminta pilihan penerima.
  iOS memakai lembar berbagi, dengan penerima dipilih di WhatsApp (belum diuji di iOS).
  Gagal membuka aplikasi menampilkan banner; sukses berarti siap dibagikan, bukan bukti terkirim.
- Selesai ke /antrean; Lihat detail ke /order/:id.
- Unduh membuat PDF dari data pratinjau dan membuka dialog simpan sistem; sukses notice,
  batal tidak mengubah nota atau memunculkan sukses, exception menjadi pesan umum.
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
ReceiptLinksSection menyediakan Catat pembayaran selama ada sisa dan nota tidak batal,
termasuk nota selesai. Aksi membuka PaymentRecordSheet yang sama dengan Detail/Piutang.
Membuka atau mencetak struk COD tidak menyelesaikan order. Struk menampilkan sisa/COD,
bukan label DP/Belum bayar. Keberhasilan pembayaran memuat ulang preview dan label.
Penyimpanan pembayaran/kelebihan tabungan atomik lewat TransactionRunner R8.
Selisih .pen: aksi pembayaran tambahan dan label sisa; tes callback, alur dan 320 px/2x.

## Susunan aksi - redesign 11 Nov 2026
- Ukuran normal: Selesai fleksibel, diikuti ikon WhatsApp, Unduh, Cetak 48 dp satu baris.
- Teks >1,3x: Selesai selebar footer di atas tiga ikon; tidak mengecilkan skala teks.
- Semua aksi footer dan tautan nonaktif saat cetak/penyelesaian/unduh berlangsung.
- Selesai tetap navigasi, bukan perubahan status order; cetak pada complete=1 tetap guard lama.
- Belum diuji manual di perangkat Android/iOS atau printer nyata.

## Perubahan tes dan golden
- business_info_page_test, order_detail_receipt_test, payment_page_test,
  r4_detail_completion_test, r4_detail_print_failure_test: finder judul menjadi Struk Pembayaran.
- receipt_page_test dan ui_final_flow_test: finder judul/Selesai; WhatsApp memakai tooltip,
  detail digulir ke tautan. Assertion cetak/WhatsApp/navigasi/pembayaran tetap.
- r9_receipt_sections_test: pengujian aksi catat bayar mengikuti ReceiptLinksSection.
- receipt_actions_layout_test: ukuran/posisi mengikuti empat aksi; callback lama, semantics,
  batas tinggi teks dan skala 2x dipertahankan; tambahan callback Unduh.
- receipt_cod_visual_test: gulir ke Catat pembayaran di body; Selesai tetap dapat ditekan.
- Tes baru: receipt_download_test/page_test, receipt_icon_tiles_test,
  receipt_document_widget_test (Rows/Document/Content); helper receipt_download_fake.
- Golden 5: receipt_page, receipt_cod_actions_1x/2x, receipt_document (baru), app_icon.
- Snapshot FigCraft tetap 1; UI aplikasi belum diverifikasi manual.
- Revisi lanjutan: receipt_page_test/order_detail_receipt_test/r4_finish_flow_test memakai
  tooltip reload/pengaturan. r9_receipt_sections_test memeriksa COD di ReceiptDocument dan
  callback pengaturan kartu printer; assertion fungsi tetap. receipt_document_widget_test
  memeriksa alamat 2 baris, label/metode, perataan dan callback pada struktur baru.
- Batch koreksi diizinkan lewat jalur biasa, tanpa commit; check_all 12 Nov: 1104 lulus, 1 skip.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
