# STATE Laurum
Diperbarui: 2026-11-13 | Cabang backend-newdesign

## Sesi aktif
Perbaikan flicker Bluetooth/printer dan impor kontak; dasar commit ac8b3e2.
Pengguna melarang rebuild APK. Tanpa push/merge.

## Status irisan
- Penyebab yang direproduksi tes: perubahan preferensi printer/metadata sync
  memicu invalidasi semua repository; perubahan pelanggan membaca kontak HP lagi.
- DriftChangeMonitor mengabaikan local_settings, outbox, sync_cursors untuk
  invalidasi query bisnis. Stream outbox/sinkronisasi sendiri tetap berjalan.
- Hasil baca kontak HP dipisahkan dari pemetaan pelanggan: sekali per sesi impor,
  Coba lagi mengambil ulang; keluar/masuk halaman membuat pembacaan baru.
- PrinterPage dan CustomerImportPage mempertahankan konten saat reload data,
  sehingga kontrol/kotak pencarian tidak dilepas dan diganti skeleton berulang.
- Gerbang aplikasi diuji tidak melepas halaman pada refresh; tidak diubah.
- Tes reproduksi gagal sebelum perbaikan; tes terarah sekarang lulus.
- Riwayat: ac8b3e2 memperbaiki transisi/tab dan loading beranda/detail.
  Pelanggan opsional + WhatsApp nyata selesai di 1091715; release di e96ea69.
- B5 BLE 58 mm, impor kontak nyata, restore printer selesai; 80 mm coming soon.
  Rincian sebelumnya di docs/progress/b5.md dan PARITY.md.

## Keputusan pengguna terbaru
- 13 Nov: perbaiki kedip saat proses Bluetooth dan kontak; JANGAN rebuild APK.
- APK rumah tetap release ARM64 27,4 MB, Drift + Supabase publik, tanpa demo.
- Hanya Nama pelanggan wajib; struk PNG + pesan WhatsApp, tanpa nomor share umum.
- READ_CONTACTS disetujui; Data safety Play Store wajib mencantumkan Contacts.
- BLE disetujui; Impeller dimatikan untuk Samsung; printer 80 mm ditunda.

## Belum di-commit
AGENTS.md dan docs/design/new-design-laurum.figcraft milik pengguna, dikecualikan.
android/build/ artefak Gradle tak terlacak tetap dikecualikan; .gitignore belum diubah.

## Langkah berikutnya
1. Jangan rebuild APK tanpa permintaan baru; perbaikan refresh sudah diverifikasi.
2. Jika layar putih berulang lagi, ambil log saat kejadian lewat ADB nirkabel.
3. Uji WhatsApp Android dan cetak 58 mm dengan printer fisik; iOS belum diuji.
4. Isi Data safety Contacts sebelum Play Store; uji B3b recovery dengan SMTP.
5. B2e foto pengeluaran memerlukan keputusan antrean/migrasi/kompresi.

## Blocker
HP SM-N975F tersambung ADB nirkabel. Pengguna mengonfirmasi seluruh UI putih,
bukan skeleton. Percobaan scan/connect kali ini tidak berkedip pada APK lama;
log menunjukkan Skia aktif dan tidak ada error renderer pada percobaan tersebut.
Penyebab layar putih belum terbukti; tes memverifikasi bug refresh yang terpisah.
APK lama belum memuat perbaikan kode ini karena rebuild sengaja tidak dilakukan.

## Bukti terakhir
- Tes terarah printer/impor/storage gate: 13 lulus.
- Tes cache kontak/lifetime/retry + visibility printer/impor: 5 lulus.
- dart run tool/check_all.dart: SEMUA HIJAU, 1182 lulus/1 skip; REPO_MAP 1152 berkas.
- APK tetap: build/app/outputs/flutter-apk/laurum-rumah-1.0.0-arm64-release.apk,
  28709590 byte; terakhir berubah 12 Nov 2026 19:47:02. Tidak dibangun ulang.
