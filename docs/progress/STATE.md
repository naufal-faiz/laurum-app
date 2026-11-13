# STATE Laurum
Diperbarui: 2026-11-13 | Cabang backend-newdesign

## Sesi aktif
APK release harian 1.0.1 (versionCode 2), sumber kode 65c0816.
Pengguna mengonfirmasi aplikasi bekerja baik lalu meminta APK harian.

## Status irisan
- 65c0816: WhatsApp daftar pelanggan membuka chat; refresh struk memakai loader
  dan alert koneksi, tanpa cetak/penyelesaian order; jalur cetak/COD tetap.
- Modal printer langsung tampil selama discover/connect; kontrol dan guard busy
  mencegah duplikasi, termasuk restore. Printer terakhir tersimpan lokal melalui
  printer_id/printer_name lama, tanpa cloud/skema baru. Bluetooth mati cukup warning.
- Banner success hijau, warning jingga, error merah, info biru dengan ikon/teks.
  Dua Section printer dipindah ke data/callback; utang Consumer berkurang dua.
- Golden printer_page/receipt_page/banner_message diperbarui dan diperiksa.
- Build release main.dart, target android-arm64, LAURUM_STORE=drift,
  konfigurasi publik backend dari .env.local. Tidak mengubah kode/dependensi.
- APK: build/app/outputs/flutter-apk/laurum-harian-1.0.1-arm64-release.apk
- Manifest: com.cashier.laurum, 1.0.1 (2), INTERNET ada, tidak debuggable.
  libapp/libflutter hanya arm64-v8a; tanda tangan APK v2 valid (apksigner).
- Build Gradle assembleRelease berhasil 191,6 detik; APK belum dipasang agen.

## Keputusan pengguna terbaru
- Pengguna menyetujui revisi, menyatakan aplikasi bekerja baik, meminta build harian.
- Refresh hanya menghubungkan ulang; Bluetooth mati tanpa modal aktivasi.
- Debug 42e284f sebelumnya belum berkedip menurut uji pengguna; tidak ada
  workaround renderer eksperimental tersisa. Hasil release terbaru menunggu uji HP.
- Hanya Nama wajib; struk PNG + pesan WhatsApp; tanpa nomor share umum.
- READ_CONTACTS disetujui; Data safety Play Store wajib mencantumkan Contacts.

## Belum di-commit
Catatan build dicakup commit ini; berkas APK adalah artefak lokal, tidak masuk Git.
AGENTS.md dan docs/design/new-design-laurum.figcraft milik pengguna, dikecualikan.
android/build/ artefak Gradle tak terlacak tetap dikecualikan; .gitignore belum diubah.

## Langkah berikutnya
1. Pasang APK harian 1.0.1 di HP, uji printer/kontak/WhatsApp dan kembali ke aplikasi.
2. Uji cetak 58 mm/iOS dan lengkapi Data safety Contacts sebelum Play Store.
3. B2e foto pengeluaran memerlukan keputusan antrean/migrasi/kompresi.

## Blocker
Tidak ada blocker build. APK release terbaru belum diuji manual di HP.

## Bukti terakhir
- Kode 65c0816: check_all SEMUA HIJAU; 1191 lulus/1 skip, REPO_MAP 1162.
- R4 retry melalui Cetak; asersi ledger/status tetap, Refresh terbukti tidak mencetak.
- flutter build apk --release --target-platform android-arm64: berhasil.
- Versi 1.0.1 (2), tanda tangan valid; SHA256:
  CD09B29A602826F5F878A274F8D15768BCAD6061C8E69805CA3E09C7F8D1C930
