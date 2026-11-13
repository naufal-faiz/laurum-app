# STATE Laurum
Diperbarui: 2026-11-13 | Cabang backend-newdesign

## Sesi aktif
Perbaikan fatal sinkron dua HP satu akun; dasar 55de839, tercakup commit ini.
APK pembaruan 1.0.2 (3) selesai; tanpa push/merge atau perubahan cloud/migrasi.

## Status irisan
- Bug direproduksi: startup tidak fetch, pull SQL tidak menotifikasi query,
  profil/struk ganda membuat getSingleOrNull gagal, enum tidak mengenali conflict
  yang sudah disimpan SQLite sehingga profil/pelanggan/antrean gagal dibaca.
- AccountStore.start mencoba sync sebelum setup; kegagalan jaringan menjaga lokal.
  Timeout request 15 dtk/bootstrap 20 dtk; retry pull menuntaskan setup tanpa relogin.
- Pull commit memberi notifyUpdates agar halaman kontak/antrean tidak tetap nol.
- Profil/struk ganda memakai baris aktif tertua created_at/id yang stabil;
  baris lain tidak dihapus. RecordSyncState kini mengenali conflict.
- Push tertahan tetap mencoba pull; manual sync menunggu siklus berjalan.
- Coba lagi menutup/membuka storage; disposal menunggu sync/SQL selesai.
  Keluar akun dari recovery mempertahankan berkas/outbox. Tidak mengubah nilai uang.
- Tes nyata Supabase lokal: dua sesi/satu akun bertukar pelanggan dan dua transaksi,
  profil legacy ganda, serta isolasi dua akun/all tables. Seluruh suite hijau.
- Docker aktif oleh pengguna. Stack DB/Auth/RPC minimal berjalan; stack penuh gagal
  storage-api. Tidak reset data. Kunci lokal hanya environment proses tes.
- APK: build/app/outputs/flutter-apk/laurum-harian-1.0.2-arm64-release.apk
  28709594 byte (27,4 MiB); versionCode 3; ID com.cashier.laurum; tidak debuggable.
  Tanda tangan v2 valid dan cocok v1.0.1; binary libapp ARM64 berubah.

## Keputusan pengguna terbaru
- Kedua HP sempat menyimpan data. HP kedua melihat halaman kontak/antrean 0 tetapi
  kontak muncul di pemilih transaksi; lalu transaksi/sync dan relogin terkunci.
- Pertahankan data kedua HP. Pembaruan dipasang tanpa uninstall/hapus DB/outbox.
- Hanya Nama wajib; struk PNG + pesan WhatsApp; tanpa nomor share umum.
- Data safety Play Store wajib mencantumkan Contacts; iOS belum diuji.

## Belum di-commit
Kode/tes/spec 22/30/PARITY/REPO_MAP dan catatan ini dicakup commit perbaikan sinkron.
AGENTS.md dan docs/design/new-design-laurum.figcraft milik pengguna, dikecualikan.
android/build/ tak terlacak dikecualikan. APK dan kunci tidak masuk Git.

## Langkah berikutnya
1. Pasang APK 1.0.2 sebagai update di KEDUA HP, tanpa uninstall/hapus data.
2. Online: buka akun yang sama, coba Sinkron sekarang dan periksa kontak/antrean.
3. Uji cetak 58 mm/iOS dan Data safety Contacts; B2e foto pengeluaran tertunda.

## Blocker
Tidak ada blocker kode/build. Verifikasi kedua HP fisik dengan APK baru belum dilakukan.

## Bukti terakhir
- check_all SEMUA HIJAU: 1207 lulus, 0 skip; REPO_MAP 1176; dua analyzer/arch OK.
- Tes lama disesuaikan: blocked push tetap pull + outbox utuh; startup menjalankan sync.
- Build release main.dart, drift, .env.local produksi: berhasil (243,6 dtk).
- APK SHA256: 851AB260CAF2F6028F1DFA8457DD5DCF7E31778DA9229F511740E3C629ED336D
