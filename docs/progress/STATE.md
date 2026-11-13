# STATE Laurum
Diperbarui: 2026-11-13 | Cabang backend-newdesign

## Sesi aktif
Verifikasi debug nirkabel setelah laporan seluruh UI berkedip putih.
Kode perbaikan: 42e284f. Tanpa push/merge.

## Status irisan
- 42e284f: metadata local_settings/outbox/sync_cursors tidak menginvalidasi query
  bisnis; kontak sekali per sesi impor; konten printer/impor tetap saat reload.
- Pengguna sempat tidak melihat kedip, lalu terjadi lagi setelah kembali dari
  WhatsApp struk ketika printer terhubung pada APK release lama.
- APK lama diuji memakai software rendering dan TextureView lewat parameter
  peluncuran. Keduanya tetap berkedip; perubahan native eksperimental DIBATALKAN.
- Log tidak menunjukkan crash Flutter/EGL. SurfaceFlinger mencatat pesan izin
  InputPolicyFlags, tetapi hubungannya dengan kedip tidak terbukti.
- Pengguna menghapus aplikasi/data uji lalu meminta debug kode terbaru.
- Flutter run debug main.dart + .env.local + LAURUM_STORE=drift berhasil dibuat,
  dipasang dan dijalankan pada SM-N975F Android 12 melalui ADB nirkabel.
- Pengguna mengonfirmasi belum berkedip setelah dicoba berulang pada debug terbaru.
  Log: 2 startScan, 1 connect, 0 error Flutter. Tidak ada perubahan renderer tersisa.
- Pemantauan Flutter dilepas dengan d; aplikasi debug tetap terpasang untuk uji.
- B5 BLE 58 mm/kontak nyata/restore printer selesai; 80 mm coming soon.
  Rincian sebelumnya di docs/progress/b5.md dan PARITY.md.

## Keputusan pengguna terbaru
- Semula tanpa rebuild. Setelah menghapus APK lama, pengguna mengizinkan build dan
  debug ulang kode terbaru di HP, termasuk restart karena data masih uji.
- APK release tetap tidak dibangun ulang. Jangan hapus data tanpa permintaan baru.
- Hanya Nama pelanggan wajib; struk PNG + pesan WhatsApp, tanpa nomor share umum.
- READ_CONTACTS disetujui; Data safety Play Store wajib mencantumkan Contacts.
- BLE disetujui; Impeller dimatikan untuk Samsung; printer 80 mm ditunda.

## Belum di-commit
Catatan diagnosis dan verifikasi debug; tidak ada perubahan kode setelah 42e284f.
AGENTS.md dan docs/design/new-design-laurum.figcraft milik pengguna, dikecualikan.
android/build/ artefak Gradle tak terlacak tetap dikecualikan; .gitignore belum diubah.

## Langkah berikutnya
1. Lanjutkan uji debug; bila kedip kembali, sambungkan ADB dan tangkap error/VM state.
2. Uji release dengan perbaikan 42e284f hanya saat pengguna meminta build baru.
3. Uji cetak 58 mm/iOS; Data safety Contacts sebelum Play Store.
4. B2e foto pengeluaran memerlukan keputusan antrean/migrasi/kompresi.

## Blocker
Debug terbaru belum berkedip menurut uji pengguna. Hasil ini belum membuktikan
release akan bebas kedip; APK release lama belum memuat perbaikan 42e284f.

## Bukti terakhir
- check_all: SEMUA HIJAU, 1182 lulus/1 skip; REPO_MAP dirapikan ke 1152 berkas.
- flutter run --debug melalui ADB nirkabel: build, install, launch berhasil.
- Eksperimen native dan tes eksplorasi sementara dihapus; kode aplikasi sama 42e284f.
- APK release tetap: build/app/outputs/flutter-apk/laurum-rumah-1.0.0-arm64-release.apk,
  28709590 byte; terakhir berubah 12 Nov 2026 19:47:02. Tidak dibangun ulang.
