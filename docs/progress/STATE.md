# STATE Laurum
Diperbarui: 2026-11-13 | Cabang backend-newdesign

## Sesi aktif
Perbaikan login pertama: info usaha dibuka sebelum penyimpanan akun siap.
Dasar ba43064; alur normal termasuk state/auth disetujui pengguna.

## Status irisan
- Reproduksi: signed-out dengan storage null -> login -> storage masih loading.
  Gate lama memakai hasValue sehingga nilai null lama dianggap siap, form membaca
  repository terlalu dini dan menampilkan Gagal memuat info usaha.
- lib/app.dart: storage siap hanya bila punya nilai, tidak loading dan tidak error.
  Pembacaan data awal ditunda sampai pembukaan akun selesai.
- sync_bindings juga menunggu pembukaan storage selesai tanpa error sebelum binding.
- Membuka data lokal tampil selama proses; error storage memakai Coba lagi yang
  sudah ada dengan sesi tetap aktif. Tidak perlu keluar/login ulang sebagai workaround.
- Konfirmasi keluar ketika sengaja meninggalkan setup tetap mengikuti spec 22.
- Regresi baru menguji login tertunda serta storage gagal -> retry -> form tampil,
  sesi tetap aktif, tidak ada signOut dan pesan teknis tidak bocor.
- Tes loader/refresh tetap hijau: refresh query biasa mempertahankan halaman.
- Tidak ada perubahan skema, dependensi, tampilan komponen atau golden.
- check_all hijau; belum diverifikasi manual pada HP dengan kode perbaikan ini.

## Keputusan pengguna terbaru
- Pengguna menyetujui alur normal untuk memperbaiki bug login/state/auth terkait.
- Tugas ini memperbaiki kode; APK tidak dibangun ulang.
- Revisi UX sebelumnya 65c0816: refresh printer tanpa cetak, modal scan/saved lokal,
  alert semantik, WhatsApp pelanggan membuka chat; pengguna menyatakan bekerja baik.
- Hanya Nama wajib; struk PNG + pesan WhatsApp; tanpa nomor share umum.
- READ_CONTACTS disetujui; Data safety Play Store wajib mencantumkan Contacts.

## Belum di-commit
Kode, tes, spec 22, PARITY, REPO_MAP dan catatan ini dicakup commit perbaikan login.
AGENTS.md dan docs/design/new-design-laurum.figcraft milik pengguna, dikecualikan.
android/build/ artefak Gradle tak terlacak tetap dikecualikan; .gitignore belum diubah.

## Langkah berikutnya
1. Uji login pertama/ulang pada HP setelah build berikutnya bila diminta pengguna.
2. APK harian yang ada masih 1.0.1 (2), kode 65c0816, belum memuat fix login ini:
   build/app/outputs/flutter-apk/laurum-harian-1.0.1-arm64-release.apk
3. Uji cetak 58 mm/iOS dan lengkapi Data safety Contacts sebelum Play Store.
4. B2e foto pengeluaran memerlukan keputusan antrean/migrasi/kompresi.

## Blocker
Tidak ada blocker kode. Verifikasi perangkat/build dengan fix login belum dilakukan.

## Bukti terakhir
- Tes regresi sebelum perbaikan gagal pada loader login; sesudah fix lulus.
- Tes terarah onboarding/storage/keyboard/sync: 11 lulus; recovery/isolasi: 4 lulus.
- dart run tool/check_all.dart: SEMUA HIJAU; 1193 lulus/1 skip, REPO_MAP 1163.
- Format, flutter analyze, Riverpod lint, check_arch: OK; tidak ada golden berubah.
