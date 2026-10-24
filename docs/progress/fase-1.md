# Kemajuan Fase 1

## 22 Oktober 2026 — kelompok atom pertama

Lingkup: AppText, AppIcon, AppGap, AppDivider, AppCard, AppSvg.
Tidak mengerjakan kelompok berikutnya sampai tinjauan pengguna.

### Implementasi

| Widget | Baris Dart |
| --- | ---: |
| AppText | 64 |
| AppIcon | 27 |
| AppGap | 19 |
| AppDivider | 16 |
| AppCard | 47 |
| AppSvg | 29 |

- Seluruh atom memakai token core/theme dan enum ikon yang sudah tersedia.
- Tambahan AppDimensions (ukuran ikon 16/20/24, garis/border 1) diizinkan pengguna;
  nilai token lama tidak diubah.
- Lima use-case Widgetbook mencakup seluruh varian. AppSvg ditunda sesuai instruksi
  sampai aset produksi pertama; daftar AppSvgs kosong.
- Enam tes widget dan lima golden galeri memakai font lokal.
- Katalog parameter, varian, contoh, dan batas pemakaian ada di
  docs/design/component_catalog.md.
- AGENTS.md diperbarui agar semua catatan kemajuan berada di docs/progress,
  bukan docs/prompts. File prompt tidak diubah oleh tugas ini.
- Tidak ada provider, fixture bisnis, rute, widget di luar registry, atau paket baru.
- dart format dipakai karena Prettier tidak mendukung Dart.

### Visual dan hal yang belum pasti

- Kelima galeri Flutter telah dirender dengan font lokal; semua varian terlihat,
  tidak ada overflow. PNG ada di test/goldens/.
- Perbandingan .pen berhasil melalui server MCP visual_studio_code yang diberikan
  pengguna. Konektor sesi salah mengarah ke desktop; berkas desain tidak diubah.
- Referensi Antrean - Beranda: i1jkP, Xa0qs, JrA3v (kartu); VHueK, D6n7xs,
  XjlWD (teks); gxvLY/gKNjY (gap); plTzD (separator); qN76G (ikon navigasi).
  Screenshot referensi disimpan di docs/progress/fase-1-visuals/.
- Cocok: radius/padding kartu 16, rail 4, border 1, gap 12, judul 24/32 w700
  ls -0.6, body 14/20, section 16/22 w600; tanpa bayangan kartu.
- Selisih: glyph Ionicons menggantikan Lucide/Material sesuai PRD; divider generik
  memakai border, sementara plTzD memakai chipIdle; monoLabel memakai token w400,
  sementara nomor nota NAfLI di .pen w600. Token lama tidak diubah.
- SVG produksi belum ada; hanya fixture pengujian. Use-case AppSvg ditunda.
- Belum diuji di iOS atau perangkat Android pada tugas ini; golden dibuat di Windows.
- Perubahan lokal yang sudah ada saat mulai (.metadata, web/, konfigurasi lint,
  PRD dan catatan Fase 0) dipertahankan.

### Pemeriksaan

SELESAI untuk kelompok ini; menunggu tinjauan pengguna sebelum kelompok berikutnya.

- dart run tool/check_all.dart: SEMUA HIJAU (format, flutter analyze, dart analyze, check_arch, 16 tes).
- dart format --set-exit-if-changed widgetbook: lulus.
- flutter build bundle -t widgetbook/main.dart: lulus.
- 6 tes atom + 5 golden galeri baru; 5 tes fondasi tetap lulus.
- Seluruh berkas Dart baru maksimal 100 baris. Registry dan aturan lint tidak diubah.

Tinjau melalui flutter run -d chrome -t widgetbook/main.dart (target web sudah tersedia di workspace), atau lihat galeri PNG di test/goldens/.

## 22 Oktober 2026 — kelompok atom kontrol

Lingkup: AppButton, AppIconButton, AppChip, AppBadge, AppStatusText, AppAvatar, AppSwitch.
Pengguna meminta melanjutkan pengembangan setelah pembacaan prompt terbaru.

| Widget | Baris Dart |
| --- | ---: |
| AppButton | 54 |
| AppIconButton | 40 |
| AppChip | 40 |
| AppBadge | 31 |
| AppStatusText | 22 |
| AppAvatar | 36 |
| AppSwitch | 50 |

- Tujuh use-case, tujuh tes widget dan tujuh golden baru; total 30 tes lulus.
- check_all SEMUA HIJAU: format, flutter analyze, dart analyze, check_arch, test, repo_map.
- Tidak mengubah registry/aturan lint atau menambah paket/provider/layar/fixture bisnis.
- Token kontrol tambahan berdasarkan desain; nilai token lama tetap.
- Semantik chip digabung untuk status selected dan aksi; switch menerima value/callback eksternal.
- Screenshot Pencil dibandingkan dengan galeri Flutter; tidak ada overflow.
- Referensi: B4bt3y/Ax5fO/h8n1Hk/azFlV/xpKx9/e32I1Q (tombol), jo0oP (ikon),
  VFXLp/EciH5 (chip), s9ip1 (badge), G8xEZi (bayar), SlEQS (avatar), ZOUFH/qcTo3 (switch).
- Selisih: CTA/secondary w700 token vs w600 desain; Ionicons mengganti glyph;
  status bayar tanpa titik dekoratif, sesuai PRD berupa teks.
- Disabled memakai token yang tersedia; opacity switch 0.5 belum punya frame acuan terverifikasi.
- Referensi PNG: docs/progress/fase-1-controls-visuals/; detail API di component_catalog.md.
- Android SDK 36.0.0/JDK 25 terdeteksi dan lisensi lengkap. Belum ada perangkat tersambung.
- Build awal gagal karena NDK 28.2.13676358 belum terpasang dan SDK Manager baru memecah
  identifier paket lama. Pemasangan langsung ndk/28.2.13676358 berhasil mulai mengunduh; dihentikan sekitar 14% atas permintaan pengguna. APK ditunda.
- iOS belum diuji (Windows tanpa Xcode).
- flutter build bundle -t widgetbook/main.dart: lulus.
- Pengguna memilih menunda APK dan menutup kelompok widget; unduhan NDK dihentikan.
- Kelompok kontrol selesai dan menunggu tinjauan. Tidak memulai kelompok selanjutnya.

## 23 Oktober 2026 — kelompok atom input

Lingkup: AppTextField, AppSearchField, AppSkeleton, AppNumpadKey.

| Widget | Baris Dart |
| --- | ---: |
| AppTextField | 88 |
| AppSearchField | 88 |
| AppSkeleton | 25 |
| AppNumpadKey | 54 |

- Empat use-case dan empat berkas tes baru (lima kasus), empat golden baru.
- AppText diperluas dengan varian numpad 18/24 w700 dari desain; golden teks diperbarui.
- Controller hanya pada field yang diizinkan registry; tanpa setState atau provider.
- Tes mencakup entry/filter/submit, value eksternal, selection, clear, disposal, varian field,
  skeleton statis dan seluruh key numpad. Pemeriksaan sebelumnya lulus 39 tes.
- Bundle Widgetbook berhasil dikompilasi; pemeriksaan akhir check_all dijalankan kembali.
- Semua galeri diperiksa tanpa overflow. Tombol clear diperbaiki agar tidak menutupi border.
- Screenshot Pencil disimpan di docs/progress/fase-1-inputs-visuals/.
- Acuan T24HQe/kmkgP/LRZzT (field), Q1YznQ/e48H25/dStCL/E2wCq (skeleton),
  f0G1R/TU6VH/ONyEv (numpad). Warna/radius/tipografi sesuai token.
- Selisih: field baku 48 vs beberapa frame 44; placeholder search satu baris vs frame
  panjang membungkus; multiline rata atas vs contoh satu baris rata tengah; glyph Ionicons.
- Toggle mata pada field password belum disediakan; obscureText dikontrol pemanggil.
- Fokus/error/disabled menggunakan token, tetapi frame state khusus belum terverifikasi.
- Tidak ada dependensi/registry/aturan lint baru; APK tetap ditunda sesuai keputusan pengguna.
- Keyboard/IME dan aksesibilitas perangkat Android/iOS belum diuji.
- Dokumentasi sempat tertunda karena batas penggunaan peninjau persetujuan otomatis;
  dilanjutkan 23 Oktober setelah pengguna meminta continue.
- Pemeriksaan akhir 23 Oktober: check_all SEMUA HIJAU (format, flutter analyze,
  dart analyze, check_arch, 39 tes, repo_map 75 berkas); format Widgetbook juga lulus.
- Kelompok selesai. Semua 17 atom registry tersedia; berhenti menunggu tinjauan pengguna.

## Molecules M1 — 23 Oktober 2026
- Delapan widget, delapan use-case semua varian, delapan tes perilaku dan delapan golden.
- Acuan Pencil tersimpan di docs/progress/fase-1-m1-visuals/.
- SectionHeader (ogqS8): judul sesuai section; garis bawah dan teks kanan statis pada frame belum menjadi opsi khusus (aksi opsional tersedia).
- InfoRow (pA7A7): frame berupa ikon/alamat inline; API menyediakan pasangan label/nilai fleksibel untuk pemakaian umum.
- StatTile (C2MvH3): padding 16 vs 14, nilai figure 24 vs frame sekitar 18, ikon tanpa kotak latar. Menggunakan token/atom yang tersedia.
- DateGroupHeader (DaGCC): latar, dot 8, padding 10/16 sesuai; teks berasal dari pemanggil.
- ProgressRow (ZFy5T): track pill 8 dan warna sesuai; label/nilai di atas track.
- MenuRow (MkVX5): ikon langsung tanpa kotak latar frame; glyph Ionicons menggantikan Lucide.
- ToggleRow (SW1pv): target switch 48 plus padding vertikal 6 menghasilkan baris minimum 60 vs frame 48; tidak memperkecil target sentuh.
- LockedRow (aSIwH): label dan ikon lock sesuai; tinggi mengikuti isi/padding, bukan dikunci 48.
- Tidak mengubah atoms. Opsi ikon pendamping tersedia pada ToggleRow/LockedRow. Data galeri teknis, bukan fixture bisnis.
- AppBarRoot nanti memakai slot syncIndicator dari pemanggil agar tidak mengimpor molecule lain.
- APK tetap ditunda; runtime iOS dan pembaca layar perangkat belum diuji.
- Checkpoint M1: check_all SEMUA HIJAU, 55 tes, repo_map 102 berkas (23 Oktober).

## Molecules M2 — 23 Oktober 2026
- LabeledField, BannerMessage, NoticeAi, CalloutAi, EmptyState, SyncIndicator selesai diimplementasikan.
- Enam galeri Flutter diperiksa tanpa overflow; referensi di docs/progress/fase-1-m2-visuals/.
- LabeledField jbLdH: label 14/20 dan gap 6 cocok; atom field tetap 48 vs frame 44. Error wrapper tidak mengubah border child; pilih satu lokasi error agar tidak duplikat.
- BannerMessage XFgML: info radius 12/padding 12/gap 8 sesuai. Warning/error memakai palet tema; frame khusus belum ditemukan.
- NoticeAi K1Xa3y/FnvUf: kalimat persis, radius 12/padding 12 dan body 14/20 sesuai.
- CalloutAi s45lh: isi dan label sesuai; ikon Ionicons 16 vs Lucide 12x15; jarak antarbaris mengikuti line height tanpa tambahan 2 px frame.
- EmptyState nKUPl: lingkaran 64/ikon 28, heading dan gap sesuai; lebar teks responsif vs frame fixed 280.
- SyncIndicator I3YmrS/ARosk: tersimpan/offline cocok padding 4/8, ikon 12, pill; glyph berbeda. Menyimpan/gagal belum memiliki frame terverifikasi, memakai chipIdle/errorTint dan ikon refresh/alert. Refresh statis, tanpa timer/provider.
- Tidak ada perubahan atom atau kebutuhan widget di luar registry. iOS/perangkat tetap belum diuji.
- Checkpoint M2: check_all SEMUA HIJAU; 67 tes, repo_map 121 berkas. Pengguna meminta AppChip tetap tanpa icon; selisih PeriodTabs dicatat pada M3.

## Molecules M3 — 23 Oktober 2026
- Tujuh widget M3 dibuat; 21/21 molecules tersedia, masing-masing satu galeri dan tes perilaku/golden.
- Galeri ToggleRow/LockedRow juga dilengkapi opsi ikon pendamping.
- Seluruh galeri diperiksa pada viewport 390x900 tanpa overflow. Referensi: docs/progress/fase-1-m3-visuals/.
- ChipBar/PeriodTabs XNjrV: tinggi 48/gap 8/pill/palet sesuai; ikon info/check tidak tampil. Pengguna meminta AppChip tetap, selisih diterima untuk tinjauan.
- NominalChips rtceE: tinggi/pill/warna sesuai; lebar mengikuti label dan membungkus, bukan tiga chip sama lebar. Nilai int rupiah lewat Formatters.
- StepperField K8zXI: tombol 48, simbol teks 18, gap 4 dan radius sesuai; bayangan frame belum diterapkan, padding nilai 16 vs sekitar 20, teks nilai 14 vs frame 16. Tidak menghitung nilai sendiri.
- AppBarSub WiQtw: tinggi 64/title 18 sesuai; AppIconButton berkotak putih dengan glyph 20 vs ikon transparan 24 pada frame.
- AppBarRoot C1rcX: tinggi/title/status sesuai; akun AppIconButton putih 48/glyph 20 vs lingkaran primary 32/ikon putih 24. Atom tetap.
- FooterBar uqTPF: surface/padding 16/gap 12/shadow sesuai token. Sticky ditangani template; SafeArea bawah tersedia. Summary dan tombol berupa slot.
- PRD 5.2 tidak merinci semua parameter; API disusun dari frame dan komposisi atoms, tercatat di katalog untuk tinjauan.
- AppBarRoot menerima SyncIndicator lewat slot; tidak ada impor antarmolecules/provider/navigasi.
- Tidak mengubah atoms/registry/lint/dependensi. Tema tambahan: AppMoleculeTokens dan AppMoleculeStyles, token lama tetap.
- Frame warning/error banner dan menyimpan/gagal sync belum terverifikasi. iOS/perangkat/aksesibilitas belum diuji. APK tetap ditunda.

### Jumlah baris widget Molecules
| M1 | Baris | M2 | Baris | M3 | Baris |
| --- | ---: | --- | ---: | --- | ---: |
| SectionHeader | 37 | LabeledField | 35 | ChipBar | 29 |
| InfoRow | 28 | BannerMessage | 41 | PeriodTabs | 29 |
| StatTile | 35 | NoticeAi | 17 | NominalChips | 31 |
| DateGroupHeader | 41 | CalloutAi | 36 | StepperField | 61 |
| ProgressRow | 38 | EmptyState | 48 | AppBarSub | 54 |
| MenuRow | 45 | SyncIndicator | 46 | AppBarRoot | 48 |
| ToggleRow | 49 | — | — | FooterBar | 28 |
| LockedRow | 49 | — | — | — | — |
- Self-review akhir: nilai kanan InfoRow/DateGroupHeader/ProgressRow diperbaiki agar rata kanan; golden terkait diperbarui.
- Checkpoint M3 final: check_all SEMUA HIJAU; kedua analyzer bersih, check_arch OK, 81 tes lulus, repo_map 144 berkas. Format 41 berkas Widgetbook juga bersih. Tidak melanjutkan lapisan berikutnya.

## Prompt 10 — Domain inti, 23 Oktober 2026
- Baseline dari commit 58d24d7 sempat merah karena format tool/pen_frame.dart; dirapikan dan disimpan sebagai 1c96d9d, lalu check_all hijau (81 tes).
- Enum, 12 model immutable Equatable dan fungsi murni berada di lib/core/domain/. Antarmuka repository di core/domain/repositories/ baru dikerjakan prompt 11.
- Kolom metadata: id/ownerId/createdAt, updatedAt nullable sampai server mengisi, RecordSyncState pending/synced. SavingsEntry tidak memiliki soft delete.
- Pengguna menyetujui Proposal minimal (status/sourceText/customerId/orderId) dan OrderEvent (orderId/occurredAt/kind/note/fromStatus/toStatus). Ini kontrak domain sementara, bukan skema backend AI.
- lineTotal memakai BigInt untuk perkalian dan pembulatan half-up, hasil int rupiah dibatasi rentang integer eksak lintas platform. Diskon negatif/melebihi subtotal ditolak.
- paidAmount memakai amount, bukan received; payStatus 0 tetap belumBayar sesuai PRD, termasuk total nol. Piutang dihitung per order, tidak negatif, batal/deleted dikecualikan.
- estimateReady menerima WIB wall time (DateTime lokal), menolak UTC, memakai durasi terlama dan jam 17 pada hari kalender. Konversi UTC/WIB tetap tanggung jawab batas data.
- nextStatus/Order.withStatus hanya maju satu langkah atau batal; status selesai/dibatalkan tidak dapat diubah lewat API tersebut.
- applySavings mengembalikan Payment tabungan + SavingsEntry pakai; caller wajib menyimpan keduanya atomik. ID/waktu disediakan caller. Saldo, sisa tagihan, ID duplikat dan order batal divalidasi.
- cancelOrder mengembalikan order baru, koreksi negatif per metode pembayaran, koreksi positif tabungan terpakai dan OrderEvent. Ledger asli tidak dimutasi/dihapus; net tabungan harus cocok dengan ledger pembayaran.
- ReportRange inklusif awal/eksklusif akhir. Pendapatan berdasarkan enteredAt; pengeluaran spentAt; kas paidAt + setoran createdAt. Koreksi kas negatif tetap masuk arus periode walaupun order dibatalkan.
- Baseline historis disetujui pengguna: ReportBaseline memuat rentang dan ReportTotals historis. Input harus delta yang belum tercakup baseline. Rentang berbeda ditolak. Jika mengubah order yang sudah diringkas baseline, baseline wajib dibangun ulang agar tidak menggandakan angka.
- Piutang/tabungan adalah posisi sekarang dari seluruh ledger delta, tidak dibatasi periode. Rekonsiliasi kasFromOrders/tabunganUsed/piutangBaru memakai cohort order periode dan pembayaran terkini; kelebihan bayar hanya masuk cashIn, alokasi ke nota dibatasi total.
- topServices memakai snapshot item dan mengalokasikan diskon proporsional dengan largest remainder (tie ID item), sehingga jumlah pendapatan layanan persis total nota. Urutan pendapatan menurun; tie serviceId/unit. Nama memakai snapshot paling baru. Item snapshot tidak lengkap ditolak.
- Semua koleksi hasil ledger/ranking read-only. Tanpa Flutter, Riverpod, jam sistem, random, persistence, atau paket tambahan di domain.
- Formatters tidak diubah. Temuan: nomorNota masih mengunci kode A; belum menghalangi domain, perlu parameter kode perangkat saat alur nomor nota dikerjakan. Tidak mengubah atoms/molecules, registry, lint, token, atau PRD.
- Teks frame Laporan - Ringkasan dan Transaksi - Detail Order dibaca via pen_frame. Tidak ada widget/layar baru, sehingga perbandingan visual tidak berlaku; angka fixture produksi baru dikerjakan prompt 11.
- Ketidakpastian: skema Proposal/OrderEvent final masih menunggu fase backend/AI; kontrak baseline mengharuskan caller menjaga tidak overlap. Tidak ada pengujian Android/iOS baru pada prompt ini.

### Berkas domain prompt 10 (baris setelah dart format)
| Model | Baris | Model | Baris |
| --- | ---: | --- | ---: |
| BusinessProfile | 33 | Customer | 25 |
| ServiceItem | 38 | Order | 79 |
| OrderItem | 41 | Payment | 37 |
| SavingsEntry | 26 | ExpenseCategory | 19 |
| Expense | 36 | Proposal | 24 |
| ReceiptSettings | 38 | OrderEvent | 37 |

- Logika: money 34, order_rules 26, savings_rules 59, payment_corrections 42, cancellation 69, report 73, revenue_allocation 29, top_services 56 baris.
- Pendukung: domain_enums 16, domain_record 18, report_range 16, report_baseline 13, report_totals 30, service_revenue 15 baris.
- Keputusan implementasi untuk ditinjau: PRD belum menentukan pembagian diskon per layanan; dipilih proporsional dengan largest remainder agar rekonsiliasi tetap tepat.
- Yang perlu ditinjau: kontrak baseline/delta; kontrak sementara Proposal/OrderEvent; distribusi diskon untuk ranking layanan.
- Prompt berikutnya: docs/prompts/11-data-dummy.md. Tidak dikerjakan pada sesi ini.
- Penutup prompt 10: check_all SEMUA HIJAU (format, flutter analyze, dart analyze, check_arch, 112 tes; repo_map 183 berkas). Ada 31 tes baru; semua 26 berkas domain 13–79 baris. INDEX SELESAI 2026-10-23; berhenti sebelum prompt 11.

## Audit dan penyelesaian Prompt 11 — 23 Okt 2026

### Temuan dan perbaikan
- STATE tertinggal pada prompt 10, padahal prompt 11 SEDANG dan 46 berkas baru belum
  di-commit. Checkpoint c985c36 menyimpan pekerjaan lama; baseline 132 tes hijau.
- Empat regresi gagal pada kode lama: provider publik tidak memberi notifikasi, list
  order dapat dimutasi tanpa notifikasi, retry save menggandakan item/ledger, dan
  penghapusan pengeluaran awal tidak mengubah laporan. Keempatnya kini lulus.
- Provider antarmuka meneruskan perubahan Notifier secara eksplisit. Delapan repository
  (Business, Customer, Service, Order, Savings, Expense, Proposal, Report) diuji melalui
  provider publik, termasuk isolasi dua ProviderContainer.
- Provider Riverpod dipindah ke core/services/repository_providers.dart; antarmuka
  core/domain/repositories tetap tanpa Flutter/Riverpod. main/main_dummy memakai override yang sama.
- OrderStore immutable menyimpan order/item/payment/event dalam satu snapshot. Save
  memvalidasi semua perubahan sebelum publish; ledger retry identik idempoten,
  ID sama dengan isi berbeda ditolak, event gagal tidak bocor, status final dijaga.
- Regresi tambahan membuktikan pembatalan order berbayar sebelumnya dapat melewati
  koreksi ledger. Kini cancellation harus melunaskan net setiap metode ke nol dalam
  save yang sama; hasil fungsi domain cancelOrder dapat disimpan bersama event.
- Laporan memakai buildReport(snapshot kini) - buildReport(snapshot awal) + baseline;
  pelunasan nota lama, edit/hapus pengeluaran, order baru dan pembatalan ikut berubah.
  Revenue layanan mingguan juga berubah; Lainnya bukan alias Selimut tebal.
- Soft-delete Customer/Service tidak kembali lewat includeInactive; sortOrder dan
  updatedAt dipertahankan. Batas tanggal pengeluaran [from,to). Nomor nota tetap A-0143.
- Mutasi tabungan terbaru dahulu; ledger immutable, retry tidak menggandakan saldo.
  Telepon aktif pelanggan dicek unik. Saldo tidak dapat dibuat negatif melalui addEntry.
- Tujuh fake layanan tersedia dan mencatat panggilan. Kontak berasal dari fixture,
  FakeAuth memakai owner yang sama, PhotoPicker default null (tidak mengklaim aset
  foto yang tidak ada), Sync stream ditutup ketika provider dibuang.
- Pengguna menyetujui pelengkap DATA MASTER pada sesi ini. Nama generik, saldo,
  14 pengeluaran dan dua usulan ditulis di sana; empat entri pengeluaran utama tetap.
- A-0139 menunggu persetujuan batal, bukan sudah dibatalkan; mengganti pengisi A-0131
  agar antrean tetap 12 (3+5+4), piutang tetap Rp400.500/5 nota. A-0115 kini punya
  order/item/payment tabungan yang berpasangan dengan mutasi Pak Dedi.
- Tidak menambahkan widget/layar, paket, atau mengubah atoms/molecules/token/lint/registry/PRD.

### Batas, selisih visual, dan tinjauan
- Tidak ada perubahan visual; tidak mengklaim perbandingan screenshot .pen baru pada
  pekerjaan data ini. Angka mengacu DATA MASTER; 38/60 widget tetap.
- Baseline laporan hanya Hari ini/Minggu ini/Bulan ini, tanggal dummy 16 Okt 2026.
  Top services hanya Minggu ini; rentang lain ditolak UnsupportedError secara eksplisit.
- Lainnya tidak memiliki kuantitas/satuan yang ditentukan: internal 0/kosong. UI laporan
  berikutnya perlu menyembunyikan kuantitas agregat tersebut.
- Customer history memakai ringkasan historis, bukan rekonstruksi semua order.
  A-0143/A-0144 adalah skenario berikutnya, tidak dimuat di snapshot awal.
- Antarmuka Order.saveOrder atomik untuk order/item/payment/event. Koordinasi transaksi
  lintas Order dan Savings harus memakai hasil fungsi domain berpasangan pada alur kasir
  berikutnya; transaksi database nyata masih di luar mode dummy.
- Fake platform tidak mengakses perangkat/akun/jaringan. Android runtime dan iOS belum
  diuji dalam sesi ini; build APK tidak dilanjutkan.
- Codebase-memory dicoba sesuai skill tetapi Transport closed. Audit memakai REPO_MAP,
  spec terbatas, kode yang berubah, dan regresi; tidak memakai subagen.

### Berkas Dart prompt 11 setelah audit
Semua maksimal 100 baris. Rincian berikut mencakup implementasi lama yang diselesaikan
dan perbaikan audit (termasuk tes); widget/layar baru: tidak ada.

| Berkas | Baris |
| --- | ---: |
| lib/core/domain/order_number_generator.dart | 35 |
| lib/core/domain/repositories/business_repository.dart | 10 |
| lib/core/domain/repositories/customer_repository.dart | 8 |
| lib/core/domain/repositories/expense_repository.dart | 10 |
| lib/core/domain/repositories/order_repository.dart | 33 |
| lib/core/domain/repositories/proposal_repository.dart | 13 |
| lib/core/domain/repositories/report_repository.dart | 10 |
| lib/core/domain/repositories/savings_repository.dart | 9 |
| lib/core/domain/repositories/service_repository.dart | 8 |
| lib/core/services/auth_service.dart | 42 |
| lib/core/services/contact_source.dart | 23 |
| lib/core/services/export_service.dart | 19 |
| lib/core/services/external_launcher.dart | 25 |
| lib/core/services/photo_picker.dart | 16 |
| lib/core/services/print_service.dart | 18 |
| lib/core/services/repository_providers.dart | 41 |
| lib/core/services/service_providers.dart | 38 |
| lib/core/services/sync_service.dart | 42 |
| lib/features/business/data/business_fixtures.dart | 21 |
| lib/features/business/data/in_memory_business_repository.dart | 36 |
| lib/features/customers/data/contact_fixtures.dart | 8 |
| lib/features/customers/data/customer_fixtures.dart | 57 |
| lib/features/customers/data/customer_history_fixtures.dart | 8 |
| lib/features/customers/data/in_memory_customer_repository.dart | 76 |
| lib/features/customers/data/in_memory_savings_repository.dart | 48 |
| lib/features/customers/data/savings_fixtures.dart | 86 |
| lib/features/expenses/data/expense_category_fixtures.dart | 35 |
| lib/features/expenses/data/expense_fixtures.dart | 10 |
| lib/features/expenses/data/in_memory_expense_repository.dart | 64 |
| lib/features/expenses/data/prior_expense_fixtures.dart | 72 |
| lib/features/expenses/data/week_expense_fixtures.dart | 48 |
| lib/features/orders/data/in_memory_order_repository.dart | 91 |
| lib/features/orders/data/order_event_fixtures.dart | 26 |
| lib/features/orders/data/order_fixture_factory.dart | 26 |
| lib/features/orders/data/order_fixtures.dart | 8 |
| lib/features/orders/data/order_history_fixtures.dart | 43 |
| lib/features/orders/data/order_item_fixtures.dart | 43 |
| lib/features/orders/data/order_queue_fixtures.dart | 8 |
| lib/features/orders/data/order_queue_process_fixtures.dart | 81 |
| lib/features/orders/data/order_queue_ready_fixtures.dart | 42 |
| lib/features/orders/data/order_store.dart | 20 |
| lib/features/orders/data/order_store_write.dart | 86 |
| lib/features/orders/data/payment_fixtures.dart | 31 |
| lib/features/proposals/data/in_memory_proposal_repository.dart | 63 |
| lib/features/proposals/data/proposal_fixtures.dart | 31 |
| lib/features/reports/data/in_memory_report_repository.dart | 76 |
| lib/features/reports/data/report_adjustments.dart | 16 |
| lib/features/reports/data/report_fixtures.dart | 83 |
| lib/features/reports/data/report_snapshot.dart | 21 |
| lib/features/reports/data/report_top_services.dart | 35 |
| lib/features/services/data/in_memory_service_repository.dart | 63 |
| lib/features/services/data/service_fixtures.dart | 67 |
| lib/main.dart | 16 |
| lib/main_dummy.dart | 82 |
| test/dummy_cancellation_ledger_test.dart | 35 |
| test/dummy_catalog_integration_test.dart | 56 |
| test/dummy_data_integration_test.dart | 64 |
| test/dummy_fixture_integrity_test.dart | 51 |
| test/dummy_live_creation_test.dart | 59 |
| test/dummy_order_atomicity_test.dart | 77 |
| test/dummy_provider_notifications_test.dart | 71 |
| test/dummy_report_baseline_test.dart | 39 |
| test/dummy_report_mutation_test.dart | 52 |
| test/dummy_repository_regression_test.dart | 52 |
| test/dummy_savings_integration_test.dart | 49 |
| test/order_number_generator_test.dart | 34 |
| test/platform_services_test.dart | 78 |

### Bukti verifikasi akhir
- Baseline agen lama: 132 tes lulus; empat regresi awal sengaja dijalankan dan gagal.
- Regresi cancellation berbayar juga gagal sebelum guard koreksi ledger dipasang.
- Setelah perbaikan: dart run tool/check_all.dart -> check_all: SEMUA HIJAU.
- Format 207 berkas (0 changed); flutter analyze dan dart analyze tanpa isu;
  check_arch OK; 146 tes lulus; REPO_MAP diperbarui 248 berkas.
- Diff whitespace bersih. Tidak ada widget/layar baru; 67 berkas Dart prompt 11,
  maksimum 91 baris. Commit akhir dicatat lewat git log; berikutnya 12-organisms-1.md.

## Prompt 12 — Organisms bagian 1 (24 Okt 2026)
### O1a: BottomNavBar, ServiceRow, CustomerRow
- Baseline check_all 146 tes hijau; git bersih pada c17cd40.
- Referensi Pencil aktif laurum-ready.pen: MurpB, yI3rK, gv4k0, adwTE.
  Screenshot langsung dibanding golden Flutter bottom_nav_bar/service_row/customer_row.
- Semua varian dirender tanpa overflow di 390px. Nominal fixture dari DATA MASTER.
- Selisih: nav dinamis sekitar 61px sebelum SafeArea vs desain 96px; glyph Ionicons;
  ServiceRow jenis tanpa pill dan tanpa ikon jam/titik; nonaktif tanpa opacity 0.75.
  CustomerRow kontak tanpa lingkaran dan status tanpa pill (PRD); DP amber, bukan hijau.
- Atom/token dipertahankan. Tidak membuat widget di luar registry; tanpa provider/navigasi.
- Belum diuji TalkBack/VoiceOver, SafeArea perangkat nyata, Android/iOS.

Checkpoint O1a: check_all SEMUA HIJAU, 152 tes, kedua analyzer bersih, check_arch OK.

### O1b: SavingsRow, ExpenseRow, OrderCard
- Screenshot Pencil i9q8b/vHZ7O/JrA3v/V6p3J dibanding golden Flutter masing-masing.
- SavingsRow: nominal/saldo dipisah baris, wallet mengganti titik, judul tanpa pill,
  detail InfoRow tanpa blok tinted; waktu ringkas disiapkan gallery lewat Formatters.
- ExpenseRow: nominal negatif merah di kanan; kartu per row bukan satu kartu per tanggal;
  tanpa pill kategori/ikon foto. Isi catatan/vendor dari DATA MASTER, bukan tambahan .pen.
- OrderCard: badge status dan rail sesuai token; mono w400 mengganti w600, tanpa titik status,
  waktu/gallery dari enteredAt (A-0142 10.15) vs event proses 10.30 pada frame.
  Caller dapat memberi timeLabel event; kartu tidak memilih event atau menjalankan bisnis.
- Sembilan tes kelompok (kontrak, golden, sempit 320px dengan skala teks 2x) lulus.
- Tidak mengubah atoms/molecules/token/registry. Tidak ada model/provider di organisms.

Checkpoint O1b: check_all SEMUA HIJAU, 161 tes, REPO_MAP 269 berkas.


### O1c: NotaCard, ProposalCard, PiutangCard
- Sembilan tes baru lulus: kontrak render/callback, golden 390px, lebar 320px dan teks 2x.
- Golden ketiganya diperiksa visual: tidak ada overflow; seluruh varian tampil.
- Referensi Sx8tY/i1jkP/C4RpY sudah dilihat lewat screenshot Pencil sebelum interupsi.
  Percobaan verifikasi ulang 24 Okt gagal: transport visual_studio_code tidak terhubung.
  Perbandingan memakai screenshot yang sudah dilihat, bukan klaim capture baru.
- NotaCard: susunan ringkas sesuai referensi; mono w400, teks mengikuti DATA MASTER,
  header membungkus pada ruang sempit dan tinggi dinamis.
- ProposalCard: rail amber dan tombol Tolak/Periksa cocok; tanpa titik pemisah dan kotak
  tinted callout karena API CalloutAi dipertahankan. Isi fixture berbeda dari Bu Rina pada frame.
  Model minimal belum memuat certainty/uncertainPart; galeri menampilkan state teknis ragu,
  mengulang teks sumber di callout. Integrasi AI dan potongan ragu belum ditentukan.
- PiutangCard: usia ink3 dan sisa total-minus-paid, lima piutang Rp400.500; DP amber
  mengikuti PRD dibanding hijau di frame. Nomor nota mono w400 dan header wrap.
- Tidak mengubah atoms/molecules, registry, token, lint, PRD atau dependensi.
- Android/iOS perangkat, TalkBack/VoiceOver dan SafeArea nyata belum diuji pada prompt ini.


### Jumlah baris widget prompt 12 (sesudah dart format)
| Widget | Baris |
| --- | --- |
| BottomNavBar | 73 |
| ServiceRow | 84 |
| CustomerRow | 98 |
| SavingsRow | 74 |
| ExpenseRow | 59 |
| OrderCard | 100 |
| NotaCard | 75 |
| ProposalCard | 63 |
| PiutangCard | 80 |

Yang perlu ditinjau: perbedaan visual yang mengikuti atom/token lama; pola callback
Periksa/Setujui; penanda rail OrderCard tidak menjalankan keputusan usulan batal.

Checkpoint O1c/penutup: dart run tool/check_all.dart -> check_all: SEMUA HIJAU.
Format 226 berkas (0 changed), flutter analyze dan dart analyze tanpa isu,
check_arch OK, 170 tes lulus, REPO_MAP 278 berkas (47/60 widget).
Satu kegagalan directives_ordering pada impor galeri diperbaiki sebelum hasil akhir.
Prompt 12 SELESAI; berikutnya docs/prompts/13-organisms-2.md setelah tinjauan pengguna.

## Prompt 13 — Organisms 2 (24 Okt 2026)

### Checkpoint 1: ReceiptFormatter dan ReceiptPreview
- `receiptLines` murni di core/domain (receipt_formatter.dart + receipt_layout.dart):
  32 kolom, item/berat, baris kondisional, status LUNAS/LUNAS (TABUNGAN)/DP/BELUM BAYAR.
- Formatters.tanggalStruk ditambahkan (d MMM yyyy) karena format tanggal struk belum ada.
- Tes golden-text A-0143 persis 26 baris receipt_template.md; varian tabungan, DP,
  belum bayar, dan flag pengaturan disembunyikan. Semua baris <= 32 kolom.
- ReceiptPreview hanya merender List<String>; mono 11/16, hitam, putih, padding 16,
  tepi bergerigi 8 px lewat ReceiptEdgeClipper di core/theme (bukan path .pen).
- Galeri dua varian (penuh dan tanpa alamat/pelanggan/tabungan/catatan); golden 390x1200,
  uji lebar 320 + skala teks 2x tanpa exception.
- Selisih: alamat DATA MASTER (memuat Bandung) membungkus dua baris seimbang, frame satu
  baris tanpa kota; tangkapan Pencil baru tidak dibuat pada checkpoint ini.
- Checkpoint 1: check_all SEMUA HIJAU, 177 tes, REPO_MAP 289 berkas (48/60 widget).

### Checkpoint 2: ReceiptToggleList dan Numpad
- ReceiptToggleList memakai ToggleRow/LockedRow lama: empat switch (alamat, pelanggan,
  tabungan, catatan) dan dua baris terkunci (nomor/tanggal, rincian item).
- Numpad standar (000) dan desimal (koma) memakai AppNumpadKey; baris NominalChips
  opsional, tanpa Reset (C) dan tanpa logika uang.
- Galeri toggle semua aktif/sebagian mati; galeri numpad dua varian; golden dan uji 320 + teks 2x.
- Selisih: label toggle membungkus dua baris pada 390 px (frame satu baris 48 px);
  chips memakai +Rp (NominalChips lama), bukan chip berat pada frame Input Berat.
- Checkpoint 2: check_all SEMUA HIJAU, 184 tes, REPO_MAP 295 berkas (50/60 widget).
