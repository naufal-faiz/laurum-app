# STATE Laurum
Diperbarui: 2026-11-12 | Cabang backend-newdesign

## Sesi aktif
B5 printer nyata SELESAI (irisan 1 dan 2): encoder ESC/POS, kontrak transport,
adapter BLE `flutter_blue_plus`, izin Android/iOS, dan penyambungan provider pada
build backend. Verifikasi cetak 58 mm menunggu printer fisik. B3b selesai
sebelumnya. Jangan push/merge.

## Status irisan
- B3b: deep link menyegarkan sesi, Cek email memakai sesi server, layar `/password-baru`
  (sementara, tanpa Figma) dengan guard recovery. Tes 21 lulus.
- B5.1: `esc_pos_encoder.dart` (baris 32 kolom → ESC/POS, besar = tinggi ganda, ASCII,
  tanpa cut), `printer_transport.dart`, `esc_pos_print_service.dart` (status nyata).
- B5.2: `ble_printer_scanner.dart`, `ble_printer_discovery.dart`,
  `printer_write_target.dart`, `ble_printer_transport.dart`. Pindai 8 detik, hanya
  perangkat bernama, connect 15 detik, karakteristik writable dengan fallback vendor,
  tulis per 180 byte. `printServiceProvider` memakai layanan ini saat build `drift`;
  dummy/tes tetap `FakePrintService`.
- Izin BLE: AndroidManifest + `NSBluetoothAlwaysUsageDescription`; spec 06 diperbarui.
- Rencana/arahan uji B5: `docs/plans/B5-printer.md`; bukti: `docs/progress/b5.md`.
- PARITY.md: baris "Buat password baru" (B3b) sudah terverifikasi.

## Keputusan pengguna terbaru
Mode Backend BE-1..BE-9 aktif; Mode Redesign UI dijeda. Satu tugas backend per sesi,
tanpa push/merge. Printer: BLE, dan satu dependensi plugin disetujui
(`flutter_blue_plus 1.34.5`). B3 perangkat dan B2e ditunda.

## Belum di-commit
AGENTS.md dan docs/design/new-design-laurum.figcraft milik pengguna, dikecualikan.

## Langkah berikutnya
1. Uji cetak 58 mm di perangkat Android dan bandingkan dengan preview.
2. Putuskan dukungan 80 mm (formatter masih 32 kolom).
3. B2e unggah foto pengeluaran: butuh keputusan antrean/migrasi dan kompresi (BE-7).
4. Verifikasi perangkat B3 (tautan pemulihan, Cek email) dengan akun uji + SMTP.
5. Uji iOS saat lingkungan tersedia; adapter hanya BLE, Classic tidak didukung.

## Blocker
Tanpa printer fisik, "cetak 58 mm identik preview" belum bisa dibuktikan. iOS belum
memiliki lingkungan uji.

## Bukti terakhir
- flutter test test/printer: 15 lulus; analyze lib/features/printer lib/main.dart
  test/printer bersih; check_arch OK.
- dart run tool/check_all.dart: SEMUA HIJAU, 1159 lulus/1 skip, REPO_MAP 1136 berkas.
