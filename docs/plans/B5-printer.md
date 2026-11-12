# B5 — Printer thermal nyata

Status: irisan 1 SELESAI 12 Nov 2026 (encoder + kontrak transport). Irisan 2
(adapter Bluetooth) DIBLOKIR keputusan pengguna: tipe printer dan izin dependensi.
Acuan: PRD B §13, §17; ROADMAP baris B5. Target selesai: cetak 58 mm identik preview.

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
2. **Irisan 2 — adapter Bluetooth (belum):** satu implementasi `PrinterTransport`
   memakai paket plugin, lalu `printServiceProvider` disambungkan hanya pada build
   backend. Mode dummy tetap `FakePrintService`.

## Keputusan

- Preview dan cetakan memakai baris yang sama; tidak ada format struk kedua.
- Ukuran huruf "Besar" (13) = `GS ! 0x01` (tinggi ganda, lebar tetap).
- Aplikasi tidak bisa menyalakan Bluetooth diam-diam (Android 12+/iOS);
  `enableBluetooth` hanya memeriksa ulang setelah pengguna menyalakannya.
- iOS hanya mendukung BLE (PRD B §17). Printer Classic SPP berarti Android saja dan
  harus ditandai "belum diuji di iOS" di spec layar.

## Keputusan yang menunggu pengguna

1. Merek/tipe printer 58 mm dan mode koneksinya: BLE, Bluetooth Classic (SPP),
   atau Wi-Fi/LAN.
2. Izin menambah dependensi (aturan 10): kandidat `flutter_blue_plus` untuk BLE;
   `blue_thermal_printer` bila perangkat hanya Classic. Encoder tetap milik sendiri,
   jadi tidak perlu `esc_pos_utils`.
3. Apakah 80 mm ikut didukung. Formatter saat ini selalu 32 kolom (58 mm), jadi
   80 mm akan tercetak lebih sempit kecuali dibuat formatter 48 kolom.

## Verifikasi

- Unit: `flutter test test/printer` (encoder + status transport).
- Perangkat Android (setelah irisan 2):
  1. Nyalakan printer, buka Lainnya → Printer dan struk → Cari printer.
  2. Hubungkan, "Cetak uji"; bandingkan dengan preview (32 kolom, teks penutup).
  3. Matikan Bluetooth → status dan sheet "Aktifkan Bluetooth".
  4. Putuskan printer saat mencetak → pesan gagal, aplikasi tidak crash.
  5. Cetak struk nyata dari layar struk; cocokkan angka dan baris.
  6. Tutup-buka aplikasi; printer terakhir harus bisa dipilih lagi.
- iOS: belum ada lingkungan uji; catat "belum diuji di iOS".

## Risiko

- Banyak printer 58 mm murah memakai Bluetooth Classic, yang tidak didukung iOS.
- Perintah ESC/POS di luar teks (potong, logo) berbeda antar vendor; verifikasi
  dengan perangkat nyata sebelum menambah fitur.
