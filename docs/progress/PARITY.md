# Paritas Aksi: UI Baru dan Backend

Aturan: AGENTS.md, Mode Backend (BE-2 sampai BE-6). Agent mengisi fakta dan menerapkan
aturan BE-4/BE-5; kasus BE-7 menunggu keputusan pengguna.

## Audit awal (jalankan sekali di branch backend-newdesign)
Daftar perubahan newdesign di zona logika dibanding dev2backend:

    git diff --stat dev2backend..newdesign -- lib/features/*/state lib/features/*/data \
      lib/core/persistence lib/core/sync supabase tool lib/app.dart lib/main.dart \
      lib/main_dummy.dart pubspec.yaml

Setiap file di daftar itu: tentukan apakah memuat perilaku baru (aksi, state, data), lalu
catat sebagai baris di tabel.

## Tabel
Diverifikasi 12 Nov 2026 di branch backend-newdesign terhadap kode, spec layar, PRD A/B,
dan proposal. Kelima baris titik awal sudah diganti fakta; baris 6-10 adalah perilaku baru
dari daftar diff di atas. Tidak ada kasus BE-7 pada daftar ini.

| Layar | Aksi | Lama | Baru | Sumber logika | Tujuan dan sumbernya | Keputusan | Status |
|---|---|---|---|---|---|---|---|
| Navigasi | Laporan | ada di nav bawah (`app_router.dart` dev2backend:93) | ada, di luar nav bawah; dibuka dari kartu Beranda dan menu Lainnya (`settings_operational_section`) | `reportViewProvider` | PRD A Laporan ringkasan; proposal 012 (slot nav dikorbankan sementara) | BE-4a: tetap terjangkau dari dua tempat | terverifikasi |
| Antrean | Cari | tidak ada (`git grep Cari dev2backend -- lib/features/orders/pages` kosong) | ada; menyaring nama/nota/ringkasan/nota usulan | `features/orders/state/antrean_search.dart` di atas `antreanDataProvider` | spec 01-antrean-beranda:42 | BE-5a: data dari repository yang sudah ada | terverifikasi |
| Beranda | Ringkasan (layar) | tidak ada (`lib/features/beranda` tidak ada di dev2backend) | ada | `beranda_view.dart`, `beranda_services.dart` dari `antreanDataProvider`, `customerDirectoryProvider`, `weeklyReportViewProvider`, `businessProfileProvider` | spec 01-beranda:11-16,51-53 | BE-5a: semua angka dari provider nyata, tanpa provider baru | terverifikasi |
| Beranda | Omzet minggu berjalan terpisah dari periode Laporan | tidak ada | ada | `weeklyReportViewProvider` (`report_view.dart`, periode 1) | spec 01-beranda:16,71-76; izin pengguna 12 Nov 2026 | BE-5a | terverifikasi |
| Usulan AI | Nilai akurasi | tidak ada (file baru dibanding dev2backend) | hanya di build dummy; provider produksi `{}` | `proposal_demo_accuracy.dart`, fixture `proposal_demo_accuracy_fixture.dart` di `main_dummy.dart` | fixture contoh visual 10 Nov 2026 | BE-6: build backend merender peta kosong, bukan skor | terverifikasi |
| Usulan AI | Berat draf opsional (min 0,5 kg) dipakai order | tidak ada | ada | `proposal_draft.dart` (`weightMilli`, `weightError`), `proposal_order.dart` (`lineTotal`) | spec 25-detail-usulan-ai:114-118 | BE-5a | terverifikasi |
| Transaksi | Hapus baris ikut membatasi diskon ke subtotal baru | tidak ada (dulu hanya `setDiscount` yang menjaga) | ada | `transaction_draft.dart` `remove()` clamp | spec 02-buat-transaksi:111-113 (izin pengguna) | BE-5a | terverifikasi |
| Nota tersimpan | Unduh PDF dari pratinjau struk | tidak ada | ada | `receipt_document.dart`, `receipt_download.dart` (`FileReceiptDownloadService`) | spec 08-nota-tersimpan:28-29,44 | BE-5a | terverifikasi |
| Aplikasi | Gate loader data lokal | tidak ada (`lib/app.dart` dev2backend hanya menunggu penyimpanan) | ada | `lib/app.dart` menunggu `antreanDataProvider`, `customerDirectoryProvider`, `weeklyReportViewProvider` | spec 01-beranda:76 | BE-5a: provider setara ada di build Drift/backend | terverifikasi |
| Auth | Buat password baru dari tautan pemulihan | tidak ada (layar baru; `change_password_sheet` menuntut password lama) | ada: `/password-baru`, dipaksa router selama sesi recovery | `auth_form.dart` (`AuthFormKind.recovery`) → `auth_session.recoverPassword` → `AuthService.setRecoveredPassword` → gateway `changePassword` | prompt B3b:3-4; PRD B pemulihan password | BE-5a: tujuan ada di PRD, sesi dari tautan recovery | terverifikasi |

| Pelanggan | Impor kontak HP | ada UI, tetapi sumber kontak hanya fixture (`FakeContactSource`) | membaca kontak HP asli lewat `DeviceContactSource` (`flutter_contacts` + izin `READ_CONTACTS`); hanya kontak dicentang yang disimpan | `contactSourceProvider` → `contactImportProvider` dan `contactsProvider` | spec 17-impor-kontak:22-25; PRD B:195; izin pengguna 12 Nov 2026 | BE-5b: sumber data nyata ditambahkan, data hanya dari repository pelanggan | terverifikasi |
| Printer dan struk | Printer tersimpan | `printer_id`/`printer_name` ditulis saat connect, tidak pernah dibaca | disambung ulang otomatis saat halaman Printer dibuka (`printerRestoreProvider`), diam bila printer mati | `LocalSettingsRepository` + `PrintService.connect` | spec 06-printer-struk:22; permintaan pengguna 12 Nov 2026 | BE-5a: tanpa state atau tabel baru | terverifikasi |

## Log tugas backend
- 13 Nov 2026, flicker Bluetooth/impor kontak: aksi dan data tersimpan tetap sama.
  DriftChangeMonitor tidak mengirim invalidasi bisnis untuk local_settings/outbox/
  sync_cursors; subscriber sinkronisasi memakai stream sendiri. Kontak HP dibaca
  sekali per sesi impor; perubahan pelanggan hanya memetakan ulang duplikat.
  Printer/daftar impor mempertahankan konten saat reload. Sumber: laporan pengguna,
  spec 06/17; tes device_metadata_refresh/device_work_refresh dan kedua tes visibility.
  Pengguna melarang rebuild APK. Diagnosis ADB nirkabel pada SM-N975F: scan/connect
  berjalan, Skia aktif, pengguna tidak melihat kedip pada percobaan ini di APK lama.
  Layar putih menyeluruh belum berhasil direproduksi; perbaikan refresh teruji otomatis.
  check_all: SEMUA HIJAU (1182 lulus/1 skip), 6 tes regresi baru, tanpa rebuild APK.
- 12 Nov 2026, APK laundry rumah: tidak ada aksi UI yang berubah. Release memakai
  Drift + konfigurasi Supabase publik yang tersedia, DEMO_SEED nonaktif. Izin INTERNET
  tersedia di manifest utama agar login/sinkronisasi berjalan pada release.
  APK ARM64 27,4 MB, non-debug, tanda tangan cocok dengan app-debug untuk pembaruan.
  Verifikasi: check_all SEMUA HIJAU (1172 lulus/1 skip); pemasangan HP menunggu pengguna.
- 12 Nov 2026: izin pengguna membuat hanya Nama pelanggan wajib, serta menyetujui
  url_launcher 6.3.3 dan share_plus 13.3.1 untuk WhatsApp nyata.
  Verifikasi akhir: check_all SEMUA HIJAU (1172 lulus/1 skip), APK debug Android berhasil.
  Lima golden struk diperbarui karena baris No. HP; uji WhatsApp perangkat/iOS menunggu.

| Layar | Aksi | Lama/baru | Hasil | Sumber logika | Tujuan/sumber | Keputusan | Bukti |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Tambah/edit pelanggan | Simpan | ada keduanya | hanya Nama wajib, field lain boleh kosong; tanpa migrasi | AddCustomerForm, CustomerEditController, repository yang sama | arahan pengguna 12 Nov 2026; spec 05/14 | string kosong mempertahankan kontrak data; nomor kosong bukan duplikat | customer_optional_fields_test |
| Struk | WhatsApp | ada keduanya | PNG lengkap + pesan otomatis; nomor kosong memilih penerima; No. HP tampil `-` | ReceiptPrint, receiptDocument, DeviceExternalLauncher | arahan pengguna 12 Nov 2026; spec 08 | Android ACTION_SEND; iOS lembar berbagi, penerima dipilih manual; belum diuji di iOS | whatsapp_share_test, receipt_whatsapp_optional_phone_test |
| Detail pelanggan/order/usulan | WhatsApp | ada keduanya | profil membuka chat; detail order membawa pesan status; usulan membuka chat tanpa pesan; tanpa nomor membuka WhatsApp umum | ExternalLauncher, callback Page | arahan pengguna 12 Nov 2026; spec 09/13/25 | memakai launcher nyata pada build Drift; dummy/tes tetap palsu | customer_profile_section_test, receipt_page_test |

- 12 Nov 2026, B5.3 + B5.4: chip 80 mm menampilkan pesan coming soon; impor kontak
  memakai `DeviceContactSource` pada build Drift; printer tersimpan disambung ulang
  otomatis. Dua baris tabel di atas ditambahkan.
- 12 Nov 2026, B3b irisan state/data: sesi Auth disegarkan dari deep link
  `laurum://auth-callback` dan "Lanjut" pada Cek email memeriksa sesi server. Tidak ada
  aksi UI baru yang dihapus/ditambah, jadi tabel tidak berubah.
- 12 Nov 2026, B3b irisan UI: layar "Buat password baru" (`/password-baru`) mengakhiri
  sesi recovery tanpa menanyakan password lama. Baris tabel di bawah ditambahkan.
