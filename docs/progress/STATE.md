# STATE Laurum
Diperbarui: 2026-11-12 | Cabang backend-newdesign

## Sesi aktif
B5 printer + impor kontak SELESAI: encoder ESC/POS, adapter BLE, printer tersimpan
disambung ulang otomatis, kontak HP asli pada build backend, chip 80 mm coming soon.
Verifikasi cetak 58 mm menunggu printer fisik. B3b selesai sebelumnya. Jangan push/merge.

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
- B5.3: chip '80 mm' sengaja dinonaktifkan (coming soon) — menampilkan BannerMessage,
  `paperMm` tetap 58. Kedipan layar di Samsung hilang setelah Impeller dimatikan
  permanen lewat `AndroidManifest.xml` (`EnableImpeller=false`); Flutter menandai opt-out
  ini deprecated, jadi perlu ditinjau saat upgrade Flutter berikutnya.
- B5.4: `DeviceContactSource` (`flutter_contacts 2.6.0`, izin `READ_CONTACTS` Android
  dan `NSContactsUsageDescription` iOS) menggantikan fixture pada build `drift`; hanya
  kontak yang dicentang yang disimpan sebagai pelanggan. `printerRestoreProvider`
  menyambung ulang printer tersimpan saat halaman Printer dibuka (diam bila gagal).
- Rencana/arahan uji B5: `docs/plans/B5-printer.md`; bukti: `docs/progress/b5.md`.
- PARITY.md: baris "Buat password baru" (B3b) sudah terverifikasi.

## Keputusan pengguna terbaru
Mode Backend BE-1..BE-9 aktif; Mode Redesign UI dijeda. Satu tugas backend per sesi,
tanpa push/merge. Printer: BLE, dan satu dependensi plugin disetujui
(`flutter_blue_plus 1.34.5`). B3 perangkat dan B2e ditunda. Printer 80 mm ditunda
(coming soon); yang didukung baru 58 mm. Pengguna menyetujui `flutter_contacts` +
`READ_CONTACTS` untuk impor kontak (12 Nov 2026); hanya kontak dicentang yang disimpan,
deklarasi Data safety Play Store wajib mencantumkan Contacts.

## Belum di-commit
AGENTS.md dan docs/design/new-design-laurum.figcraft milik pengguna, dikecualikan.

## Langkah berikutnya
1. Uji di perangkat: impor kontak (dialog izin Android), sambung ulang printer otomatis,
   dan cetak 58 mm bandingkan dengan preview.
2. Mulai 80 mm hanya bila diminta: formatter 48 kolom, preview 384, encoder per
   ukuran; hapus pesan coming soon setelahnya.
3. B2e unggah foto pengeluaran: butuh keputusan antrean/migrasi dan kompresi (BE-7).
4. Isi Data safety Play Store (Contacts) sebelum rilis; uji iOS (BLE, izin kontak).
5. Verifikasi perangkat B3 (tautan pemulihan, Cek email) dengan akun uji + SMTP.

## Blocker
Tanpa printer fisik, "cetak 58 mm identik preview" belum bisa dibuktikan. iOS belum
memiliki lingkungan uji.

## Bukti terakhir
- flutter test test/device_contact_source_test.dart test/printer_restore_test.dart
  test/printer_page_test.dart test/printer test/customer_import_page_test.dart
  test/transaction_import_contact_test.dart: semua lulus.
- dart run tool/check_all.dart: SEMUA HIJAU, 1163 lulus/1 skip, REPO_MAP 1140 berkas.
- Uji perangkat SM-N975F: printer BLE tersambung (service 18F0, char 2AF1, tulis
  GATT_SUCCESS); kedipan hilang dengan Impeller mati (diputuskan pengguna).
