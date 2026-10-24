# STATE Laurum
Diperbarui: 2026-10-24 | Cabang dev1

## Posisi
Fase 1, prompt 20, 30, dan 31 selesai.
check_all: SEMUA HIJAU; 253 tes; kedua analyzer bersih; check_arch OK.
REPO_MAP 375 berkas. Berhenti menunggu tinjauan sebelum prompt 32-transaksi-b.md.

## Selesai
- Fase 1: 60/60 widget, domain inti, data dummy, Widgetbook.
- Prompt 20: router lima tab dan Antrean - Beranda.
- Prompt 30: Buat Transaksi, Pilih Layanan, Input Berat/Jumlah, Tambah Pelanggan Cepat,
  draf nota global, validasi pelanggan, estimasi, diskon, catatan.
- Prompt 31: /lainnya/printer nyata; PrintService diperluas (discover/connect/
  printReceipt/status/enableBluetooth), ReceiptSettings + teks penutup tersimpan,
  pratinjau ReceiptFormatter, kertas 58/80, huruf 11/13, toggle elemen struk.
- State printer: belum terhubung, Bluetooth mati (sheet), daftar kosong, cetak sukses/gagal.
- 8 tes baru + 1 golden printer_page. 253 tes, 70 berkas golden.

## Sedang dikerjakan
- Tidak ada. Tunggu tinjauan pengguna sebelum prompt berikutnya.

## Antrean
1. Tinjau Printer dan Struk serta alur transaksi di HP/emulator.
2. Berikutnya: docs/prompts/32-transaksi-b.md (Pembayaran, Nota Tersimpan).
3. APK/NDK, iOS, TalkBack/VoiceOver, printer asli, dan SafeArea perangkat masih ditunda.

## Keputusan dan batas
- PrintService memakai printReceipt(ReceiptData) karena nama `print` dilarang check_arch;
  ReceiptData membawa lines 32 kolom + paperMm + fontSize. Fake dapat gagal/bluetooth off.
- PrinterSettings dan PrinterConnection dipisah agar masing-masing Notifier <=100 baris;
  pengaturan disimpan ke BusinessRepository (settings + profile footer/note).
- Pratinjau 80 mm memakai lebar 384 px tetapi isi tetap 32 kolom.
- Tanpa tab Printer/Tampilan struk; satu halaman gulir. Tanpa pengaturan perataan header.
- iOS belum diuji; printer murah Bluetooth Classic (SPP) tidak didukung iOS non-MFi,
  perlu BLE/Wi-Fi sebelum rilis (PRD B bagian 17).
- Transaksi: draf global, pelanggan lewat sheet, nomor dinormalkan 0..., duplikat ditolak,
  Bayar masih placeholder sampai prompt 32.
- Formatters.nomorNota masih kunci A; penyimpanan order belum dibuat.
- Atom/token/registry/lint/PRD tidak diubah. ReceiptPreview width opsional.
- Selisih visual lama dipertahankan: Ionicons, mono w400, nav 61 px, DP amber, field 48.

## Pemeriksaan dan batas
- Android/iOS perangkat, TalkBack/VoiceOver, keyboard/printer nyata belum diuji.
- Screenshot Pencil frame Printer dan Struk serta state Bluetooth/printer sudah dibaca.
- Tidak push/merge. Jangan mulai prompt 32 tanpa instruksi pengguna.
