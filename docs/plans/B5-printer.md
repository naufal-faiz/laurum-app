# B5 — Printer thermal nyata

Status: irisan 1 dan 2 SELESAI 12 Nov 2026 (encoder, kontrak transport, adapter BLE).
Verifikasi "cetak 58 mm identik preview" menunggu printer fisik. Acuan: PRD B §13,
§17; ROADMAP baris B5.

## Ruang lingkup

1. **Irisan 1 — tanpa dependensi (selesai):**
   - `features/printer/data/esc_pos_encoder.dart`: baris `ReceiptFormatter` (32 kolom)
     menjadi byte ESC/POS. Font besar = tinggi ganda agar 32 kolom tidak pecah.
     Hanya ASCII; karakter lain menjadi `?` (code page default bukan Unicode).
     Tanpa perintah potong karena banyak printer 58 mm tidak punya cutter.
   - `features/printer/data/printer_transport.dart`: kontrak sempit `PrinterTransport`
     (`isBluetoothOn`, `discover`, `connect`, `write`, `disconnect`).
   - `features/printer/data/esc_pos_print_service.dart`: `PrintService` nyata di atas
     transport; status `bluetoothOff/connecting/connected/printing/error/disconnected`.
2. **Irisan 2 — adapter BLE (selesai):**
   - `ble_printer_scanner.dart`: pindai 8 detik lewat `flutter_blue_plus`, hanya
     perangkat bernama; galat izin/radio dilempar bila tidak ada hasil.
   - `ble_printer_discovery.dart`: nama platform lalu nama iklan, tanpa nama dibuang.
   - `printer_write_target.dart`: pilih karakteristik writable (UUID thermal umum lalu
     fallback), pecah byte per 180 byte agar aman di MTU iOS.
   - `ble_printer_transport.dart`: connect 15 detik, discoverServices, tulis per chunk,
     putuskan aman. `printServiceProvider` memakai layanan ini hanya saat build backend
     (`drift`); dummy/tes tetap `FakePrintService`.
   - Izin: AndroidManifest (BLE scan/connect + legacy) dan Info.plist iOS
     (`NSBluetoothAlwaysUsageDescription`).

## Keputusan

- BLE, bukan Bluetooth Classic: sesuai PRD B §17, iOS hanya mendukung BLE.
- Satu dependensi plugin: `flutter_blue_plus 1.34.5` (versi yang di-resolve proyek).
  Encoder ESC/POS tetap milik sendiri, tanpa `esc_pos_utils`.
- Preview dan cetakan memakai baris yang sama; tidak ada format struk kedua.
- Ukuran huruf "Besar" (13) = `GS ! 0x01` (tinggi ganda, lebar tetap).
- Aplikasi tidak bisa menyalakan Bluetooth diam-diam (Android 12+/iOS);
  `enableBluetooth` hanya memeriksa ulang setelah pengguna menyalakannya.
- Karakteristik ditulis dengan response bila didukung (flow control printer);
  tanpa response hanya bila printer tidak menyediakan write biasa, dengan jeda 20 ms.
- `fontSize` 80 mm belum didukung: formatter selalu 32 kolom. Menunggu keputusan.

## Verifikasi

- Unit: `flutter test test/printer` (encoder, status transport, pemilihan
  karakteristik, chunk, pemetaan nama pindai).
- Perangkat Android:
  1. Nyalakan printer, buka Lainnya → Printer dan struk → Cari printer.
  2. Hubungkan, "Cetak uji"; bandingkan dengan preview (32 kolom, teks penutup).
  3. Matikan Bluetooth → status dan sheet "Aktifkan Bluetooth".
  4. Putuskan printer saat mencetak → pesan gagal, aplikasi tidak crash.
  5. Cetak struk nyata dari layar struk; cocokkan angka dan baris.
  6. Tutup-buka aplikasi; printer terakhir harus bisa dipilih lagi.
- iOS: belum ada lingkungan uji; adapter BLE sudah disiapkan, tetapi fitur
  **belum diuji di iOS** dan printer Classic tidak didukung.

## Risiko

- Banyak printer 58 mm murah memakai Bluetooth Classic, yang tidak didukung iOS.
- Perintah ESC/POS di luar teks (potong, logo) berbeda antar vendor; verifikasi
  dengan perangkat nyata sebelum menambah fitur.
- Nama iklan kosong atau UUID vendor tak dikenal dapat membuat printer tidak muncul
  atau karakteristik salah; log sementara tidak dipakai, jadi uji perangkat wajib.
