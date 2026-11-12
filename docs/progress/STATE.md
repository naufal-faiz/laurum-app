# STATE Laurum
Diperbarui: 2026-11-12 | Cabang backend-newdesign

## Sesi aktif
Integrasi redesign/backend: pelanggan opsional + WhatsApp nyata.
Dasar commit 31b5944: B5 printer BLE dan impor kontak HP asli selesai. Tanpa push/merge.

## Status irisan
- Tambah/edit: hanya Nama wajib; HP/alamat/catatan boleh kosong (string kosong
  sesuai kontrak yang ada, tanpa migrasi). Nomor kosong tidak dianggap duplikat.
- Usulan AI juga dapat membuat pelanggan tanpa nomor/alamat; nomor terisi tetap valid.
- Build Drift memakai DeviceExternalLauncher; dummy/tes tetap FakeExternalLauncher.
- Struk membagikan PNG lengkap + pesan nama pelanggan/nomor nota/nama usaha.
  Nomor kosong tampil `-` di preview/PDF/PNG/cetak dan share tanpa penerima tertentu.
- Android ACTION_SEND ke WhatsApp/Business; petunjuk nomor melalui jid bila ada.
  WhatsApp bisa tetap meminta pilihan/konfirmasi penerima. iOS lembar berbagi,
  penerima dipilih manual di WhatsApp; belum diuji di iOS.
- Detail pelanggan membuka chat, detail order membawa pesan status order,
  usulan AI membuka chat tanpa pesan. Profil tanpa nomor tetap bisa membuka WhatsApp.
- CustomerProfileSection dimigrasikan ke StatelessWidget + callback Page (aturan 14).
- Lima golden diperbarui karena baris No. HP: receipt_document, receipt_page,
  receipt_cod_actions_1x, printer_page, receipt_preview. Nomor terisi invalid tetap ditolak.
- B5 tetap: BLE 58 mm, kontak asli, restore printer; 80 mm coming soon.
  Rincian: docs/progress/b5.md. B3b recovery selesai; uji perangkat masih menunggu.

## Keputusan pengguna terbaru
- 12 Nov: semua input pelanggan opsional kecuali Nama; WhatsApp sesuai konteks,
  struk berupa gambar + pesan, tanpa nomor berbagi biasa dan struk menampilkan `-`.
- Izin eksplisit url_launcher + share_plus; ter-resolve 6.3.3 dan 13.3.1.
- READ_CONTACTS disetujui; Data safety Play Store wajib mencantumkan Contacts.
- BLE disetujui, Impeller dimatikan untuk Samsung; printer 80 mm ditunda.

## Belum di-commit
AGENTS.md dan docs/design/new-design-laurum.figcraft milik pengguna, dikecualikan.
android/build/ artefak Gradle tak terlacak tetap dikecualikan; .gitignore belum diubah.

## Langkah berikutnya
1. Uji WhatsApp Android: nomor terisi/kosong, PNG+caption, WhatsApp/Business, kembali/batal.
2. Uji impor kontak, restore printer, dan cetak 58 mm dengan printer fisik.
3. Isi Data safety Contacts sebelum rilis; uji iOS dan B3b recovery dengan SMTP.
4. B2e unggah foto pengeluaran memerlukan keputusan antrean/migrasi/kompresi.

## Blocker
Uji penerima/gambar WhatsApp nyata, printer fisik, dan iOS belum dilakukan.

## Bukti terakhir
- dart run tool/check_all.dart: SEMUA HIJAU, 1172 lulus/1 skip; REPO_MAP 1146 berkas.
- Format, flutter analyze, dart analyze (Riverpod), check_arch: OK.
- flutter build apk --debug --dart-define=LAURUM_STORE=drift: berhasil.
- APK: build/app/outputs/flutter-apk/app-debug.apk. Golden struk diverifikasi;
  WhatsApp di perangkat dan iOS belum diverifikasi manual.
