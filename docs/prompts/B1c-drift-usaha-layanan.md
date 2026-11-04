# B1c - Drift: usaha, struk, layanan, pengaturan lokal
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: B1b SELESAI. Baca: AGENTS 19-22, business_repository.dart, service_repository.dart, features/printer/state/printer_settings.dart, features/settings/state/order_status_setting.dart.

## IZIN TERTULIS (4 Nov 2026)
- Antarmuka baru ReceiptSettingsRepository (kertas, font, tampilkan alamat/pelanggan/tabungan/catatan) di core/domain/repositories dengan implementasi InMemory dan Drift; PrinterSettingsController membaca dan menulis lewat antarmuka ini. Perilaku layar Printer tidak berubah.
- Printer terpasang di HP ini disimpan lewat LocalSettingsRepository (bukan tabel sinkron).
- Tanpa perubahan atoms/tema/registry.

## Isi
1. DriftBusinessRepository: profil usaha termasuk use_order_status (default true), simpan satu baris per akun, outbox pada setiap perubahan; "Pakai status order" tetap bekerja lewat repository yang sama.
2. DriftServiceRepository: kiloan/satuan, harga, durasi, is_active, sort_order, soft delete, outbox; urutan katalog stabil.
3. DriftReceiptSettingsRepository (+ InMemory) dan kontrak; migrasi PrinterSettings.
4. AI settings (AiPreferences) TETAP in-memory sampai B7: catat di docs/progress/b1c.md dan STATE sebagai batasan yang diketahui.
5. Kontrak lolos di InMemory dan Drift; tes atomik outbox seperti B1b.

Prompt berikutnya: B1d-drift-order-pembayaran.md.
