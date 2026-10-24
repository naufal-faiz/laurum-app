# STATE Laurum
Diperbarui: 2026-10-24 | Cabang dev1

## Posisi
Fase 1 dan prompt 20 selesai. Prompt 30-transaksi-a.md SELESAI.
check_all: SEMUA HIJAU; 245 tes; kedua analyzer bersih; check_arch OK.
REPO_MAP 363 berkas. Berhenti menunggu tinjauan sebelum prompt 31-printer.md.

## Selesai
- Fase 1: 60/60 widget, domain inti, data dummy, Widgetbook.
- Prompt 20: router lima tab, Antrean - Beranda, state kosong/loading/error/WhatsApp.
- Prompt 30: /transaksi/baru (Buat Transaksi) dan /transaksi/baru/layanan nyata;
  /transaksi/baru/bayar tetap placeholder sampai prompt 32.
- Draf nota global (transactionDraftProvider) bertahan antar layar; total memakai lineTotal,
  diskon dibatasi 0..subtotal, dibersihkan saat keluar.
- Pelanggan: pencarian di sheet, tambah cepat dengan validasi nama/nomor, normalisasi
  62/8 ke 0, duplikat menampilkan nama + 'Pakai pelanggan ini', kontak HP palsu.
- Layanan aktif saja, Sering dipakai, Kiloan/Satuan, pencarian.
- Input Berat/Jumlah: Numpad desimal/standar, chip +0,5/+1/+5 kg, StepperField.
- Estimasi estimateReady + 'Mengikuti layanan terlama'; catatan dan diskon tersimpan.
- 13 tes baru dan 3 golden (transaction_page, service_picker, add_customer_sheet).

## Sedang dikerjakan
- Tidak ada. Tunggu tinjauan pengguna sebelum prompt berikutnya.

## Antrean
1. Tinjau alur Buat Transaksi di HP/emulator (keyboard, sheet, FAB tidak berlaku di sini).
2. Berikutnya: docs/prompts/31-printer.md (Printer dan Struk, PrintService palsu).
3. APK/NDK, iOS, TalkBack/VoiceOver, SafeArea perangkat masih ditunda.

## Keputusan dan batas
- Rute transaksi berada di luar shell sehingga nav bawah tidak tampil; Bayar menuju
  placeholder Pembayaran sampai prompt 32.
- Pelanggan dipilih lewat CustomerPickerSheet berisi AppSearchField; hasil kosong
  menawarkan AddCustomerSheet. Nomor disimpan ternormalisasi 0... dan dicek unik.
- AddCustomerSheet dibatasi 500 px agar form dapat digulir; footer SheetScaffold kini
  full-width (perubahan template).
- Estimasi memakai estimateReady dari businessClockProvider (16 Okt 2026 12.00).
- DraftLine: kg default 1 kg/langkah 0,5 kg, pcs default 1/langkah 1 pcs; qtyMilli.
- Keluar dengan draf berisi memunculkan ConfirmModal; draf kosong langsung keluar.
- Subhalaman TransactionCustomerPage/TransactionDetailsPage/AddCustomerFormPage dipakai
  inline mengikuti pola AntreanStatusPage; bukan rute.
- Formatters.nomorNota masih kunci A; penyimpanan order belum dibuat (prompt 32).
- Atom/token/registry/lint/PRD tidak diubah. Tanpa dependensi baru.
- Selisih visual lama dipertahankan: Ionicons, mono w400, nav 61 px, DP amber, field 48.

## Pemeriksaan dan batas
- Android/iOS perangkat, TalkBack/VoiceOver, keyboard/safe area nyata belum diuji.
- Screenshot Pencil frame Buat Transaksi/Pilih Layanan/Input Berat/Tambah Pelanggan
  sudah dibaca; golden Flutter dipakai untuk perbandingan.
- Tidak push/merge. Jangan mulai prompt 31 tanpa instruksi pengguna.
