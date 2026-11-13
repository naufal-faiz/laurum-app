# STATE Laurum
Diperbarui: 2026-11-13 | Cabang backend-newdesign

## Sesi aktif
Revisi UX Struk/Printer dan tautan WhatsApp daftar pelanggan.
Dasar: 140ae28; alur normal disetujui pengguna. Tanpa push/merge/build APK.

## Status irisan
- Daftar pelanggan: ikon WhatsApp memakai launchWhatsApp, menggantikan tel:.
- Refresh struk: PrinterReconnect dengan loader dan alert hasil koneksi.
  Tidak memanggil cetak atau penyelesaian order; jalur cetak/COD tetap.
- Modal printer langsung tampil selama discover/connect, kontrol nonaktif saat
  sibuk; guard controller menolak proses ganda termasuk restore otomatis.
- Modal menampilkan printer terakhir tersimpan di perangkat dan hasil pindai,
  tanpa duplikasi; preferensi printer_id/printer_name lama, tanpa cloud/skema baru.
- Bluetooth mati: peringatan aktifkan terlebih dahulu; tombol/modal aktivasi
  tidak lagi dipanggil dari UI. API layanan Bluetooth lama tetap dipertahankan.
- BannerMessage success memakai token hijau; warning jingga, error merah, info biru.
  Koneksi/cetak/unduh/simpan berhasil memakai success, disertai ikon dan teks.
- Dua Section printer dipindah ke data/callback, utang Consumer berkurang dua.
- Golden berubah: printer_page, receipt_page, banner_message (3 berkas).
- Tes perilaku baru: WhatsApp, reconnect, loader, tanpa cetak/penyelesaian,
  modal saat scan, saved printer, deduplikasi, blokir duplikasi, alert dan callback.
- check_all hijau; 3 golden diperiksa. Visual revisi belum diuji manual di HP.

## Keputusan pengguna terbaru
- Lanjut bertahap dengan alur normal untuk Struk (>3 berkas/6 tool call).
- Kerjakan kontak dahulu, kemudian refresh, modal pencarian/memori, alert semantik.
- Refresh hanya menghubungkan ulang; Bluetooth mati cukup alert tanpa aktivasi modal.
- Debug kode 42e284f sebelumnya belum berkedip setelah uji berulang pengguna.
  Ini belum membuktikan release bebas kedip; tidak ada workaround renderer tersisa.
- Hanya Nama wajib; struk PNG + pesan WhatsApp; tanpa nomor share umum.
- READ_CONTACTS disetujui; Data safety Play Store wajib mencantumkan Contacts.

## Belum di-commit
Revisi kontak/printer/struk, tes, golden, spec/PARITY dan utang dicakup commit ini.
AGENTS.md dan docs/design/new-design-laurum.figcraft milik pengguna, dikecualikan.
android/build/ artefak Gradle tak terlacak tetap dikecualikan; .gitignore belum diubah.

## Langkah berikutnya
1. Pengguna meninjau UI debug: scan, koneksi ulang, WhatsApp dan printer tersimpan.
2. Uji cetak ulang melalui Cetak; Refresh hanya menghubungkan ulang tanpa cetak.
3. Uji release hanya saat diminta; cetak 58 mm/iOS dan Data safety Contacts tertunda.
4. B2e foto pengeluaran memerlukan keputusan antrean/migrasi/kompresi.

## Blocker
Tidak ada blocker implementasi. Verifikasi manual revisi di HP belum dilakukan.

## Bukti terakhir
- dart run tool/check_all.dart: SEMUA HIJAU; 1191 lulus/1 skip, REPO_MAP 1162.
- Format, flutter analyze, Riverpod lint dan check_arch: OK.
- r4_finish_flow: finder retry diganti Cetak; asersi ledger/status tetap,
  ditambah bukti Refresh tidak mencetak/menyelesaikan. Tes terarah 3 lulus.
- printer_page: Bluetooth mati memakai warning + retry; receipt_page: tooltip
  menjadi Refresh printer. Golden printer_page/receipt_page/banner_message diperbarui.
