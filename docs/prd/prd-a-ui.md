# PRD A — Tampilan Aplikasi Laurum (Flutter)

Versi 1.0 · 20 Oktober 2026 · Sumber desain: `laurum-ready.pen` (33 layar + 33 varian state). Pasangan dokumen: PRD B (Sistem dan Backend) dan Kit Agen (AGENTS.md, linter, registry).

## 1. Ringkasan

**Tujuan fase ini:** aplikasi Flutter yang berjalan penuh di atas **data dummy in-memory**, sehingga alur kasir bisa dirasakan langsung di HP. Backend (SQLite + Supabase), AI, dan fitur Pro menyusul dan tidak menghalangi preview.

**Prinsip:**

- Setiap tampilan disusun **hanya dari widget terdaftar** (atomic design). Tidak ada widget ad hoc.
- Maksimal **\~100 baris per file** (batas keras 110).
- State dengan **Riverpod**. Tidak ada `setState`/`StatefulWidget` di layar.
- Ikon hanya lewat **Ionicons** atau **SVG di folder aset**. Tidak ada SVG inline.
- Aturan di atas **ditegakkan oleh alat** (linter + `tool/check_arch.dart`), bukan hanya imbauan.

## 2. Hasil pemeriksaan file .pen

File bisa dibaca (format JSON, 8.939 node, 36 objek tingkat atas).

| Temuan | Implikasi |
| --- | --- |
| 33 layar + frame `State` berisi 33 varian (modal, kosong, error, validasi, loading) | Cakupan desain sudah lengkap. Tidak perlu revisi desain lagi sebelum coding. |
| **0 komponen reusable, 0 instance**: semua elemen digambar inline | File ini tidak bisa jadi sumber komponen. Katalog widget di dokumen ini (bagian 5) menjadi acuan. `.pen` hanya acuan visual. |
| Warna bersih: `#00653B` dipakai 1.121 kali, hijau lama 0 kali. Variabel hanya 7, dua di antaranya sama (`hijau-kasir` dan `hijau-tua`) | Token Dart cukup satu `primary`. |
| Ikon: 915 node dari **dua pustaka berbeda** (Lucide dan Material), 40 nama | Disatukan ke Ionicons (tabel pemetaan di Kit Agen). |
| Font: Plus Jakarta Sans (2.119 teks) dan IBM Plex Mono (181) | Kedua font dibundel di aset (aplikasi offline-first, jangan unduh saat runtime). |

## 3. Lingkup

**Dalam lingkup:** 33 layar dan state-nya, tema dan token, navigasi, katalog komponen, Widgetbook, data dummy dari DATA MASTER (Prompt 0 di dokumen sebelumnya), tes widget dasar.

**Di luar lingkup fase ini:** backend nyata dan sinkronisasi (PRD B), AI nyata, printer Bluetooth nyata (diganti `FakePrintService`), Play Billing, notifikasi, dark mode, tablet/landscape, bahasa selain Indonesia.

## 4. Stack UI

- Flutter stable terbaru. Satu basis kode untuk **Android dan iOS**; pengujian awal hanya di Android (belum ada lingkungan uji iOS, lihat PRD B bagian 17). Target API 36 untuk Play Store.
- `flutter_riverpod` (tanpa codegen), `go_router`, `equatable`, `intl` (locale `id_ID`), `ionicons`, `flutter_svg`.
- Dev: `flutter_lints`, `custom_lint` + `riverpod_lint`, `widgetbook`.
- Agen **tidak boleh menebak nomor versi**. Pasang dengan `flutter pub add <paket>` dan pakai versi yang di-resolve.
- Font dibundel di `assets/fonts/`. Jangan pakai `google_fonts` runtime.

## 5. Atomic design dan katalog widget

### 5.1 Aturan lapisan

| Lapisan | Boleh berisi | Boleh mengimpor | Dilarang |
| --- | --- | --- | --- |
| Atoms | elemen terkecil (teks, ikon, tombol, chip, badge) | hanya `core/` | provider, model bisnis, teks bisnis |
| Molecules | gabungan atom (field berlabel, banner, app bar) | atoms | provider, navigasi |
| Organisms | blok fungsional (kartu order, numpad, nav bawah) | atoms, molecules | provider (data lewat konstruktor) |
| Templates | kerangka layar (slot app bar, body, footer) | atoms, molecules, organisms | provider |
| Pages | satu per layar, di `features/<fitur>/pages/` | semua lapisan, provider | membuat widget baru |

Aturan tambahan: satu widget publik per file; tanpa kelas widget privat (`_Foo`); tanpa method pembangun widget (`Widget _buildX()`); semua data lewat konstruktor, aksi lewat callback.

### 5.2 Registry (60 widget; padanan nama komponen di desain)

**Atoms (17):** `AppText`, `AppIcon`, `AppSvg`, `AppButton` (varian: cta, secondary, action, actionOutline, destructiveOutline, destructiveFilled), `AppIconButton`, `AppChip`, `AppBadge` (diproses, siap, menungguJemput, selesai, dibatalkan), `AppStatusText` (lunas, belumBayar, dp), `AppAvatar`, `AppCard` (opsi rail kiri amber/merah), `AppDivider`, `AppGap`, `AppSwitch`, `AppTextField`\*, `AppSearchField`\*, `AppSkeleton`, `AppNumpadKey`.

\*Dua-duanya satu-satunya widget stateful yang diizinkan, karena `TextEditingController` butuh lifecycle. Keputusan ini sengaja dan ditandai `stateful` di registry.

**Molecules (21):** `LabeledField` (C/Input), `SectionHeader`, `InfoRow`, `StatTile`, `MenuRow`, `ToggleRow`, `LockedRow`, `BannerMessage` (C/Banner: info, warning, error), `NoticeAi` (C/Notice-AI), `CalloutAi` (C/Callout-AI), `EmptyState` (C/Empty), `SyncIndicator` (C/Sync), `StepperField` (C/Stepper), `NominalChips`, `PeriodTabs`, `ProgressRow`, `ChipBar`, `AppBarRoot`, `AppBarSub`, `FooterBar` (C/Footer-Sticky), `DateGroupHeader`.

**Organisms (17):** `BottomNavBar`, `OrderCard`, `NotaCard`, `ProposalCard`, `CustomerRow`, `PiutangCard`, `ServiceRow`, `SavingsRow`, `ExpenseRow`, `ReportSummary`, `WeeklyBarChart`, `TopServices`, `ReceiptPreview` (C/Struk), `ReceiptToggleList`, `Numpad` (C/Numpad, varian desimal), `ConfirmModal` (C/Modal), `AppBottomSheet` (C/Sheet).

**Templates (5):** `RootScaffold` (app bar root + nav bawah + FAB), `SubScaffold` (app bar sub, tanpa nav), `FormScaffold` (sub + footer sticky), `SheetScaffold`, `AuthScaffold`.

**Aturan penambahan widget:** jika kebutuhan belum tercakup, agen berhenti dan menulis usulan di `docs/design/proposals/NNN-nama.md` (alasan, layar yang butuh, sketsa API). Widget baru baru boleh dibuat setelah kamu menyetujui dan registry diperbarui.

## 6. Token desain

Semua token hidup di `lib/core/theme/` (satu-satunya tempat boleh memakai `Color(0x..)`, `TextStyle(`, radius, bayangan).

**Warna:** `primary #00653B`, `onPrimary #FFFFFF`, `primaryTint #E1F3E8`, `ink #131B2E`, `ink2 #3E4947`, `ink3 #6E7977`, `bg #F8F9FF`, `surface #FFFFFF`, `surfaceLow #F2F3FF`, `chipIdle #EFF4FF`, `border #E5E7EB`, `borderStrong #D1D5DB`, `error #DC2626`, `errorInk #9B1C1C`, `errorTint #FEF2F2`, `warningBorder #B45309`, `warningInk #92400E`, `warningTint #FFFDF5`, biru (`#1D5FA8` / `#E3EEFA` / `#174A85`), slate (`#475569` / `#EEF1F5` / `#334155`), `scrim #131B2E66`.

**Tipografi (Plus Jakarta Sans):** `titleRoot 24/32 w700 ls-0.6`, `titleSub 18/24 w600`, `section 16/22 w600`, `figure 24/32 w700`, `body 14/20 w400`, `bodyStrong 14/20 w600`, `input 16/24 w400`, `label 12/16 w600`, `caption 12/16 w400`, `cta 16/22 w700`. IBM Plex Mono hanya untuk nomor nota, jam di kartu order, label grafik, dan struk.

**Bentuk:** padding layar 16, jarak kartu 12, padding kartu 16, tinggi app bar 64. Radius: kartu 16, tombol aksi 8, CTA dan secondary 14, input 8, chip dan badge pil, sheet atas 28, numpad 12, modal 16. Bayangan hanya untuk app bar, footer sticky, stepper, modal. Area sentuh minimal 44, baku 48.

## 7. State management dan data

**Struktur per fitur:** `domain/` (model dan antarmuka repository), `data/` (repository in-memory + fixture), `providers/` (Notifier/AsyncNotifier), `pages/`.

- Pages adalah satu-satunya lapisan yang membaca provider (`ConsumerWidget`).
- State sementara layar (filter terpilih, tab periode, isi numpad, draf form) memakai `Notifier.autoDispose` per layar. Tidak ada `setState`.
- Repository dipasang lewat provider dan di-override di `main_dummy.dart` (data dummy). Saat backend siap, `main.dart` meng-override dengan repository Drift. **Pages dan widget tidak berubah.**
- Logika murni (hitung total, estimasi selesai, status bayar, saldo tabungan, rumus laporan) ada di `core/domain/` sebagai fungsi tanpa Flutter dan memiliki unit test. Logika yang sama dipakai backend (PRD B).
- Format tampilan lewat satu kelas `Formatters`: `rupiah(int)`, `berat(int gram)`, `tanggal`, `jam`, `telepon`. Widget dilarang memformat sendiri.
- Uang disimpan `int` rupiah, berat `int` gram. Tidak ada `double` untuk uang.

**Data dummy:** satu fixture per entitas (Customer, ServiceItem, Order, OrderItem, Payment, SavingsEntry, Expense, Proposal, BusinessProfile), isi persis DATA MASTER. Tiap file fixture juga maksimal \~100 baris. Aksi dummy harus benar-benar mengubah state (membuat nota menambah order di Antrean, setor tabungan mengubah saldo) agar alur terasa nyata.

## 8. Navigasi

`go_router` dengan `StatefulShellRoute` untuk 5 tab. Sheet dan modal dibuka lewat `AppBottomSheet.show` dan `ConfirmModal.show`.

| Rute | Layar |
| --- | --- |
| `/masuk` | Auth - Masuk |
| `/antrean`, `/antrean/usulan/:id` | Beranda, Detail Usulan AI (dua varian) |
| `/transaksi`, `/transaksi/baru`, `/transaksi/baru/layanan`, `/transaksi/baru/bayar`, `/transaksi/nota/:id` | Riwayat Nota, Buat, Pilih Layanan, Pembayaran, Nota Tersimpan |
| `/order/:id`, `/order/:id/edit` | Detail Order, Edit Order |
| `/pelanggan`, `/pelanggan/:id`, `/pelanggan/:id/tabungan`, `/pelanggan/:id/setor`, `/pelanggan/impor` | Daftar, Detail, Riwayat Tabungan, Setor, Impor |
| `/laporan`, `/laporan/piutang` | Ringkasan, Daftar Piutang |
| `/lainnya`, `/lainnya/layanan`, `/lainnya/layanan/baru`, `/lainnya/layanan/:id`, `/lainnya/info-usaha`, `/lainnya/pengeluaran`, `/lainnya/pengeluaran/baru`, `/lainnya/printer`, `/lainnya/ai`, `/lainnya/ai/riwayat`, `/lainnya/ai/hubungkan`, `/lainnya/sinkronisasi` | Menu dan semua turunannya |

Sheet: Input Berat, Tambah Pelanggan Cepat, Edit Pelanggan, Bluetooth mati.

## 9. Matriks layar (urutan pengerjaan)

Nama layar mengikuti frame di `.pen`. Kolom Fase merujuk bagian 10.

| Fase | Layar |
| --- | --- |
| 2 | Antrean - Beranda (termasuk state kosong, filter kosong, loading, WhatsApp terputus) |
| 3 | Transaksi - Pilih Layanan; Buat Transaksi; Input Berat (sheet); Pelanggan - Tambah Pelanggan Cepat (sheet); Transaksi - Pembayaran; Nota Tersimpan |
| 4 | Lainnya - Printer dan Struk (dengan `FakePrintService`) |
| 5 | Transaksi - Detail Order; Edit Order; Riwayat Nota |
| 6 | Pelanggan - Daftar; Detail dan Tabungan; Setor Tabungan; Riwayat Tabungan; Edit Pelanggan (sheet); Impor Kontak HP |
| 7 | Laporan - Ringkasan; Daftar Piutang |
| 8 | Lainnya - Pengaturan dan Akun; Daftar Layanan; Tambah Layanan; Edit Layanan; Info Usaha; Daftar Pengeluaran; Catat Pengeluaran |
| 9 | AI (dummy): Detail Usulan AI; Detail Usulan (Pelanggan Baru); Riwayat Usulan AI; Pengaturan AI dan WhatsApp; Hubungkan WhatsApp |
| 10 | Auth - Masuk (Google, dummy); layar baru **Sinkronisasi** dan bagian **Akun** (hapus akun) |
| 11 | Penyelesaian: semua state offline/gagal, aksesibilitas, QA, APK dummy |

## 10. Fase pengerjaan

**Fase 0 — Inisiasi.** Buat proyek, pasang dependensi, bundel font, tema dan token, `analysis_options.yaml`, `tool/check_arch.dart`, `AGENTS.md`, folder `docs/design/` (registry, katalog, spec layar), skeleton Widgetbook, skrip `tool/check_all.dart`, CI. *Selesai bila* `flutter run -t lib/main_dummy.dart` menampilkan layar kosong bertema dan semua pemeriksaan hijau.

**Fase 1 — Komponen (sebelum layar apa pun).** Kerjakan per lapisan: atoms, molecules, organisms, templates. Per widget: file (≤100 baris), use-case Widgetbook (semua varian), tes widget, entri registry. **Gerbang:** kamu meninjau Widgetbook sebelum Fase 2 dimulai.

**Fase 2–11.** Satu kelompok layar per sesi sesuai bagian 9, berurutan.

**Definition of Done tiap layar:**

1. Hanya memakai widget registry (checker lolos). Tidak ada widget baru.
2. Visual dibandingkan berdampingan dengan frame `.pen` (hanya selisih yang tercatat).
3. Semua teks, angka, dan format berasal dari fixture dan `Formatters`.
4. Variasi state layar tersebut (kosong, error, loading, modal) ikut selesai.
5. Alur dummy berfungsi (aksi mengubah state).
6. `dart format`, `flutter analyze`, `custom_lint`, `check_arch`, `flutter test` semuanya hijau.
7. Spec layar `docs/design/screens/NN-nama.md` diperbarui.

## 11. Penyimpangan dari desain .pen (disengaja)

| Layar/area | Perubahan | Alasan |
| --- | --- | --- |
| Auth - Masuk | Tombol "Lanjutkan dengan Google" menggantikan email dan kata sandi | Login memakai OAuth Supabase |
| Auth - Lupa Kata Sandi | **Tidak dibuat** | Tidak ada kata sandi |
| State - Offline | Berubah dari banner pemblokir menjadi informasi: "Mode offline. Data tersimpan di HP dan disinkronkan otomatis." | Aplikasi offline-first |
| `SyncIndicator` | Ditampilkan di `AppBarRoot` dan layar Sinkronisasi baru | Status sinkron harus terlihat |
| Pengaturan dan Akun | Tambah baris Sinkronisasi dan bagian Akun (email Google, hapus akun, keluar) | Diwajibkan Play Store untuk akun |
| Semua ikon | Lucide/Material diganti Ionicons | Satu pustaka |
| Nama usaha di app bar | Dinamis dari Info Usaha, bukan teks tetap | Dipakai banyak pengguna |
| Fitur Pro | Tidak ada tampilan. Cukup pembungkus `FeatureGate` yang selalu membuka | Semua gratis sekarang |

## 12. Kriteria penerimaan global

- Alur utama berjalan tanpa putus di data dummy: buat nota (pelanggan baru dari sheet, layanan, berat, bayar dengan tabungan + tunai) → nota tersimpan → muncul di Antrean → tandai siap → serahkan → laporan ikut berubah.
- Struk di layar Printer dan Nota Tersimpan **identik** (satu `ReceiptFormatter`, 32 kolom).
- Tidak ada file Dart di `lib/` lebih dari 110 baris (kecuali berkas hasil generate).
- Tidak ada `setState`, SVG inline, `Icons.`, atau warna di luar tema (diperiksa otomatis).
- Aplikasi jalan di HP Android nyata dengan APK debug dari `main_dummy.dart`.

## 13. Risiko dan keputusan terbuka

- **Batas 100 baris vs kompleksitas layar.** Layar kompleks (Buat Transaksi, Laporan) harus dipecah ke organism. Jika agen merasa perlu widget baru, ia mengajukan usulan, bukan membuat sendiri.
- **`AppTextField` stateful.** Pengecualian tunggal; alternatifnya `flutter_hooks` (`useTextEditingController`) bila kamu mau menghindari stateful sepenuhnya.
- **Kompatibilitas `custom_lint`/`riverpod_lint`** dengan versi Riverpod dan analyzer terbaru: agen memverifikasi saat Fase 0 dan melapor bila perlu mengganti pendekatan.
- **Nama aplikasi dan application ID** (misalnya `com.<namamu>.laurum`) perlu diputuskan sebelum Fase 0.
- **Impor kontak massal** memerlukan izin sensitif (lihat PRD B, bagian Play Store). UI tetap dibuat dulu dengan kontak dummy.
