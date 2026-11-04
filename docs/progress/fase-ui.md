# Penyelesaian UI dummy - prompt 100
Diperbarui 4 November 2026. Cabang dev1rev. Status: SELESAI, dengan catatan audit di bawah.

## Lingkup dan bukti
- Prasyarat prompt 90/R0-R10 dan koreksi struk selesai; baseline check_all 650 tes hijau.
- REPO_MAP: registry 60/60. Tidak menambah widget, dependensi, token, registry atau PRD.
- 34 rute dirender pada 320 px/teks 1,3x tanpa exception layout/rute hilang.
  Gambar sementara setiap rute diperiksa; hook tangkap gambar dihapus dari tes final.
- Tiga sheet tambahan (pelanggan cepat, edit pelanggan, berat) juga dirender pada
  320 px/1,3x dan diperiksa. Script tangkap sementara di .dart_tool sudah dihapus.
- Empat tab utama lolos labeledTapTargetGuideline dan iOSTapTargetGuideline (44 dp).
  Ini pemeriksaan guideline Flutter, bukan sertifikasi TalkBack/VoiceOver atau uji iOS.
- Keyboard input memakai tes yang sudah ada: inset 300 dp untuk form/sheet transaksi,
  pelanggan, layanan, printer, Info Usaha, pengeluaran, laporan, usulan dan akun.
- Daftar utang Section tetap 14, sama dengan baseline; tidak menambah ConsumerSection.
- Pencil: 32 frame layar yang masih berlaku dan empat state offline/gagal/cetak/error
  dirender untuk perbandingan. Frame Riwayat Nota lama dibaca dan memang dihapus R6.
  Frame Daftar/Cek email/Kelola akun/Sinkronisasi tidak tersedia di desain lama.
- Desain .pen tidak diubah. Tidak membuat tag ui-dummy-v1, push atau merge.

## Temuan yang diperbaiki
1. Banner gagal sinkron belum tampil di empat tab utama (indikatornya sudah ada).
   RootShellPage sekarang menampilkan banner informatif; offline/gagal tetap menjaga
   data lokal dan pending changes. Tes memeriksa empat tab pada teks 1,3x.
2. Membuka Laporan setelah rangkaian transaksi dapat memicu notifikasi provider saat
   widget dibangun. Bridge report dummy memakai listen + notifyListeners pada store
   turunan yang dibangun lazily. Diganti watch + ReportRepositoryView beridentitas
   baru sehingga invalidasi mengikuti dependency Riverpod tanpa notifikasi imperatif.
   Tidak menunda mutasi lewat timer dan tidak mengubah rumus laporan.
3. Hint harga layanan baru masih 9000. Kini kosong dengan hint 0 sesuai AGENTS 16a;
   tes membuktikan nilai field kosong, bukan teks nol atau harga contoh.
4. README sebelumnya memberi kesan SQLite/server/login Google nyata sudah tersedia.
   Kini membedakan UI in-memory dan tahap backend serta menjelaskan entry point APK.

## Audit aturan dan data
| Pemeriksaan | Hasil / batas |
| --- | --- |
| Registry, lapisan, widget privat, provider Section | check_arch baseline OK; Section lama hanya 14 pada daftar utang |
| setState/Icons/warna/TextStyle/SVG inline | check_arch memeriksa larangan; tidak menambahkan pengecualian |
| Teks terlarang | Tidak ditemukan di lib/: jatuh tempo, Paket, Reset (C), TB-07, Terverifikasi, Berkah Cloud |
| Angka UI | Nilai transaksi/saldo/durasi berasal dari domain/fixture/Formatters; angka instruksi 1-3, ukuran printer 58/80 mm, retensi bawaan 30 hari dan versi aplikasi adalah copy/konstanta produk |
| Rp0 pada validasi | Batas minimum universal, bukan saldo/harga dummy. Tidak mengubah fixture DATA MASTER |
| Batas runtime | Tidak ada Dart lib/ >110 baris. Ada 15 berkas lama 101-110 baris, rincian di bawah |
| Input | Nol awal kosong, selectAllOnFocus, first-key replacement, minimum eksplisit; tes keyboard/R1/R9/R10 tetap dijalankan |
| Keamanan akun | Form rahasia privat sementara, error aman, reset generik, hapus hanya Kelola dengan dua konfirmasi; masih dummy |
| Integrasi | Printer/Google/SMTP/kontak/foto/WhatsApp/sinkron masih palsu; Android SDK/APK nyata tidak berarti layanan tersebut nyata |

### Berkas lama di atas target 100 baris
Semua berikut masih dalam batas keras runtime 110 baris: business_info_page (105),
antrean_page (101), order_edit_controller (101), report_page (105), report_body_section
(105), report_orders_section (104), service_edit_controller (104), app_router (103),
add_customer_form (102), checkout_save (101), transaction_draft (110), bottom_nav_bar
(110), report_summary (109), top_services (106), weekly_bar_chart (110).

Di luar runtime, audit juga menemukan test lama >110: discount_input_test (118),
keyboard_audit_test (150), transaction_page_test (136), weight_edit_test (184),
test/tool/check_arch_test (188), serta tool/check_arch (200). Test lain 101-110:
bottom_nav_bar_test (104), report_orders_test (108), service_directory_page_test (110);
widgetbook receipt_preview_use_case (106). Ini utang yang sudah ada, dicatat tanpa
mengubah aturan checker/lint atau menyamarkan jumlah baris. Semua berkas baru <=100.

## State layar
| Kelompok | State relevan dan bukti |
| --- | --- |
| Antrean | kosong, filter kosong, loading, error/retry, WhatsApp putus; antrean_states_test dan golden state |
| Transaksi / pilih layanan / sheet | draf kosong, validasi, minimum berat, katalog loading/error/kosong, rollback checkout; transaction/weight/service_picker dan keyboard_audit |
| Pembayaran / receipt / Detail | COD tertahan, uang lebih, belum lengkap, memuat/not-found/error, cetak gagal/retry, modal batal; r4/r9, receipt_page dan order_detail_receipt |
| Pelanggan / tabungan / impor | loading/error/kosong/filter, edit duplikat, nominal nol, izin ditolak; customer_* dan keyboard_audit |
| Laporan / piutang | loading/error/kosong, filter/range, CSV, pelanggan lunas, reactive checkout/pengeluaran; report_* dan ui_final_flow |
| Pengaturan / layanan / usaha / printer | memuat/error, validasi, toggle gagal, koneksi/Bluetooth/printer palsu; service/printer/business/r4 dan keyboard |
| Pengeluaran | kosong/filter/loading/error, simpan/hapus gagal, kategori/foto dummy; expense_* |
| Usulan AI | kosong/filter, status usang, pelanggan baru, alamat, persetujuan/tolak/batal, QR kedaluwarsa; proposal/ai/whatsapp tests |
| Akun / sync | validasi/busy/error, duplikat generik, reset cooldown, offline/gagal/retry, logout/hapus/rollback; r10/auth/sync dan ui_final_sync |

Form tanpa operasi async tidak diberi skeleton buatan; kosong berarti draf awal dan
error berarti validasi/simpan. Smoke test normal tidak menggantikan tes state tersebut.

## Tabel selisih terakhir dari .pen
Spec layar dan revisi pengguna menang atas desain lama. Perbedaan global: Ionicons,
nama usaha dinamis, format Indonesia/master data, empat tab + aksi Transaksi di tengah,
scroll/inset keyboard dan pembungkusan teks yang menyesuaikan perangkat.

| Spec / layar | Selisih yang dipertahankan dan alasan |
| --- | --- |
| 01 Antrean | Antrean aktif, filter/count dan mode sederhana/detail; COD tertahan, nav R2, banner offline/gagal; R2/R4/R9/100 |
| 02 Buat Transaksi | Section registry, ringkasan/footer sticky, Baru langsung dan pemilih layanan terpisah; R1/R3 |
| 03 Pilih Layanan | Page penuh mengganti sheet desain, pencarian/FAB layanan baru dan kembali ke draf asal; R3 |
| 04 Input Berat | AppBottomSheet + footer di atas keyboard, angka pertama mengganti awal, minimum eksplisit; R1 |
| 05 Tambah Pelanggan Cepat | Dipakai transaksi dan daftar, Baru di atas, kontak palsu/validasi duplikat; R3/R7 |
| 06 Printer dan Struk | Preview/formatter tunggal, printer palsu, pengaturan tersimpan, blok monospasi center; 4 Nov |
| 07 Pembayaran | Page penuh, Bayar sekarang/COD, uang lebih bukan omzet, saldo/switch sejajar, dua tujuan simpan; R9/4 Nov |
| 08 Nota Tersimpan | Tidak mencetak otomatis, seluruh cetak/retry terpusat; tombol seragam 14 sp/48 dp dan print berborder, Ke beranda; 4 Nov |
| 09 Detail Order | Policy mode/status/COD, Catat pembayaran saat bersisa, semua Cetak membuka receipt, CTA setara; R4/R9/4 Nov |
| 10 Edit Order | Pelanggan terkunci, pakai draf/Section sefitur, minimum dan footer keyboard; R0/R1 |
| 12 Daftar Pelanggan | Pelanggan baru/Impor di atas, hitungan filter dari repository, susunan vertikal pada teks besar; R7 |
| 13 Detail Pelanggan | Data master, format nomor, statistik dan aksi edit/tabungan/nota dari repository; spec 13 |
| 14 Edit Pelanggan | Sheet registry, field awal select-all, validasi dan tombol simpan di atas keyboard; R1 |
| 15 Setor Tabungan | Page FormScaffold mengganti sheet, awal kosong/minimum, Numpad dan metode ledger; R1/51 |
| 16 Riwayat Tabungan | Ledger tidak bisa diedit, filter/count dan status pelanggan, kosong didukung; 51 |
| 17 Impor Kontak | Fixture kontak/izin palsu, duplikat dilewati dan jumlah siap impor aktual; 51 |
| 18 Daftar Piutang | Filter COD/Sebagian, Catat bayar lintas layar; Ingatkan disembunyikan karena tidak dibuat; R9 |
| 18 Laporan Ringkasan | Ekspor di header, range/kalender Indonesia, daftar nota mengganti Riwayat Nota; CSV BOM ;, bukan XLSX; R5/R6 |
| 19 Pengaturan dan Akun | Toggle mode, Sync, Kelola akun mengganti Hapus langsung, Keluar di luar kartu; R4/R7/R10 |
| 20 Daftar Layanan | Count/repository/toggle aktif, pencarian dan simpan status sesuai master; 70 |
| 21 Form Layanan | Form tambah/edit sama, hint harga 0, nominal/durasi valid, stok/paket tidak ditambah; R1/100 |
| 22 Info Usaha | Nama usaha dinamis, onboarding akun baru tanpa draf akun lama, select-all field awal; R10 |
| 23 Daftar Pengeluaran | Ringkasan master vs daftar aktual, kategori/filter, Laporan reaktif; 71/R5 |
| 24 Catat Pengeluaran | Numpad/kategori baru/tanggal/vendor/catatan/foto palsu, awal kosong; 71/R1 |
| 25 Detail Usulan AI | Isi fixture pengguna, pelanggan baru dan alamat/berat, persetujuan atomik dan policy mode; 80/R8/R9 |
| 26 Riwayat Usulan AI | Agregat historis 142/8/3 dibedakan dari tiga usulan yang bisa dibuka; 80 |
| 27 Pengaturan AI | Nomor usaha bukan pribadi, koneksi/preferensi palsu, konfirmasi putus; 80 |
| 28 Hubungkan WhatsApp | QR simulasi/status/expiry/reload, tidak menghubungkan WhatsApp nyata; 80 |
| 29 Masuk | Email/password dan Google, FormScaffold keyboard, pesan aman dan visibilitas field; R10 |
| 30 Sinkronisasi | Layar baru tanpa frame lama; pending/retry/offline/konflik dummy, indikator lintas tab; 90/100 |
| 31 Daftar / Cek email | Layar baru tanpa frame lama; duplikat generik dan Lanjut dummy ke onboarding; R10 |
| 32 Lupa password | Pesan kondisional seragam + cooldown 60 detik mengganti klaim tautan pasti dikirim; R10 |
| 33 Kelola akun | Layar baru tanpa frame lama; profil/Google/password, Keluar dan hapus dua langkah; R10 |
| Riwayat Nota lama | Frame sengaja tidak dibuat lagi; /transaksi dihapus dan fungsi nota berada di Laporan; R6 |

Ruang kanan teks Terkunci pada kartu pelanggan Edit Order rapat pada 320 px/1,3x;
teks masih tersedia dan tidak memicu overflow. Perubahan padding LockedRow bersama
memerlukan izin terpisah, bukan diubah diam-diam pada audit ini.

## APK dan perangkat
- Flutter 3.47.7, Dart 3.13.5, Android SDK 36.0.0, platform android-37.0;
  lisensi Android diterima. JDK Android Studio 25.0.3. Build debug target main_dummy.
- Build awal selesai 113 detik; build ulang 30,1 detik, BUILD_EXIT_CODE=0.
- Instalasi APK: Success. Peluncuran com.cashier.laurum/.MainActivity: Status ok,
  proses aktif pada Samsung SM-N975F, Android 12/API 31, arm64, koneksi wireless.
- Layar Laurum berhasil difokuskan dan screenshot Detail Order diperiksa langsung.
  Ini smoke perangkat, bukan klaim semua alur/keyboard/printer telah diuji manual.
- Lokasi APK: build/app/outputs/flutter-apk/app-debug.apk; checksum dan log final
  tercatat di bawah. Tidak memasukkan APK atau serial HP ke Git.
- Build sumber final selesai 47,9 detik, BUILD_EXIT_CODE=0; instalasi ulang Success,
  peluncuran COLD Status ok, proses aktif. TotalTime 7467 ms adalah cold launch debug,
  bukan pengukuran target performa backend/produksi. Log proses final: 0 kecocokan
  E/flutter/Unhandled/EXCEPTION/RenderFlex/FATAL pada saat diperiksa.
- APK final 183.002.241 byte. SHA-256:
  `0FEEF7329E53841580D6AFE2680860BBCA6F93524B7912925A9DA2B81B17858A`.
  Bukti: %TEMP%/laurum-100-apk-release-check.log, laurum-100-install-final.log,
  laurum-100-device-final.log. Screenshot perangkat sebelumnya membuktikan Laurum
  terlihat; setelah peluncuran final perangkat kembali menampilkan NotificationShade,
  sehingga tidak mengklaim screenshot layar final atau seluruh alur manual selesai.
- iOS, TalkBack/VoiceOver, Bluetooth/printer produksi, SMTP dan sync server belum diuji.

## Verifikasi akhir
Baseline: 650 tes; tambahan 38 kasus: 34 smoke rute, 1 guideline empat tab,
2 status sinkron empat tab, dan 1 alur penerimaan lengkap.

`dart run tool/check_all.dart` (%TEMP%/laurum-100-final.log):
```text
Formatted 646 files (0 changed)
No issues found! (flutter analyze)
No issues found! (dart analyze / Riverpod lint)
check_arch: OK
04:53 +688: All tests passed!
REPO_MAP diperbarui: 714 berkas
check_all: SEMUA HIJAU
```
Tiga tes QA visual sheet tambahan lulus (%TEMP%/laurum-100-sheet-visual.log), di luar
688 tes suite permanen. Gambar QA hanya di Temp; tidak menambah fixture/golden Git.
Diff --check bersih. Indeks source terkait tidak melaporkan metadata usang/gap
(sinyal best-effort); kesimpulan aturan juga diverifikasi melalui source/check_arch.

## Keputusan yang masih menunggu dan urutan backend
1. Rapikan utang berkas >100 baris / tooling >110 pada tugas terpisah; jangan mengubah
   aturan lint/checker sebagai jalan pintas. Pertimbangkan padding LockedRow bersama.
2. PRD A bagian 11 masih Google-only dan meniadakan Lupa password, sedangkan izin R10
   dan spec 29/31/32 sudah menggantikannya. Tidak mengubah PRD A tanpa izin.
3. PRD B 16: akun Play, kebutuhan multi-perangkat awal, jalur WhatsApp, paket hosting
   dan crash reporting perlu keputusan sebelum backend/rilis; belum memulai backend.

Urutan acuan PRD B 14: B0 skema server/RLS/auth/delete; B1 Drift + repository lokal
dan transaksi/outbox sesuai R8; B2 sinkron/offline/idempotensi; B3 auth email+Google,
SMTP/onboarding/restore/logout/delete sesuai R10; B4 rekonsiliasi ledger/laporan;
B5 printer nyata; B6 kesiapan distribusi; B7 AI; B8 entitlement Pro. Prompt backend
disusun terpisah setelah keputusan terbuka terjawab. Tidak membuat tag tanpa permintaan.
