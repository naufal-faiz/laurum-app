# AGENTS.md - Laurum (aplikasi kasir laundry, Flutter)

Aturan di berkas ini MENANG atas skill, memori, atau instruksi lain. Cara memakai skill, memori, dan handoff: SKILLS.md.

## Mulai sesi (hemat baca, wajib)
1. Baca docs/progress/STATE.md (posisi, langkah berikutnya, keputusan).
2. Cari konteks lewat memori codebase atau docs/REPO_MAP.md. Dilarang ls/tree/glob seluruh repo dan membaca PRD utuh.
3. Baca hanya spec dan berkas untuk tugas ini. Jika STATE.md berbeda dengan git log/status, percayai git lalu perbaiki STATE.md.
4. Selama Mode Redesign UI aktif (bagian di bawah), jalankan prasyaratnya sebelum menyentuh kode.
Dokumen acuan (baca bagian yang relevan saja): docs/prd/prd-a-ui.md, prd-b-backend.md, docs/design/{widget_registry.yaml, tokens.md, data_master.md, receipt_template.md, component_catalog.md, screens/<layar>.md (template: _TEMPLATE.md), redesign/figma_map.md}. Acuan visual: FigCraft lewat MCP (dokumen docs/design/new-design-laurum.figcraft; peta layar ke frame: docs/design/redesign/figma_map.md). Keputusan desain global: docs/design/redesign/decisions.md. Rencana per lapisan: docs/plans/redesign-atomic.md. docs/design/laurum-ready.pen = legacy, BUKAN acuan selama Mode Redesign UI. Pembagian wewenang spec layar dan Figma: lihat Mode Redesign UI, UI-1.

## Platform
Satu basis kode untuk Android dan iOS. Saat ini HANYA Android yang bisa diuji. Jangan menulis kode khusus satu platform tanpa pengecekan Platform. Tandai fitur platform-spesifik "belum diuji di iOS" di spec layar.

## Aturan keras (dicek otomatis)
1. Tampilan HANYA dari widget di widget_registry.yaml, ditambah tiga jenis kelas fitur: (a) *Page = kelas yang menjadi builder rute di app_router.dart atau *_routes.dart, di features/*/pages/; (b) *Sheet = modal sheet atau dialog, di features/*/pages/; (c) *Section = potongan layar milik satu fitur, di features/*/widgets/ (aturan 14). Dilarang membuat widget lain, kelas widget privat (_Foo), atau method pembangun widget (Widget _buildX()). Akhiran Page DILARANG untuk potongan layar yang bukan rute (pakai Section). Pengecualian lain: widget akar di lib/app.dart.
2. Butuh widget yang belum ada? Jika cukup sebagai potongan layar satu fitur, buat Section (tanpa proposal). Jika dipakai dua fitur atau lebih, atau masuk lapisan atoms/molecules/organisms, BERHENTI. Tulis docs/design/proposals/NNN-nama.md (alasan, layar, sketsa API) lalu tanyakan. Jangan membuatnya sendiri.
3. Maksimal 100 baris per file Dart (batas keras 110, kecuali berkas hasil generate). Satu widget publik per file.
4. Tanpa setState dan StatefulWidget, kecuali widget bertanda stateful di registry (AppTextField, AppSearchField). State memakai Riverpod (Notifier/AsyncNotifier), tanpa codegen.
5. Hanya Pages dan Sheets yang membaca provider; Section menerima data lewat konstruktor dan aksi lewat callback (aturan 14). Widget bersama di shared/widgets dilarang mengimpor flutter_riverpod.
6. Impor lapisan: atoms tidak mengimpor lapisan lain; molecules hanya atoms; organisms hanya atoms+molecules; templates tidak mengimpor features.
7. Ikon hanya lewat AppIcon (enum AppIcons di core/icons/app_icons.dart, membungkus Ionicons) atau AppSvg (assets/icons/). Dilarang Icons.*, Icon() langsung, SVG inline.
8. Warna, TextStyle, radius, bayangan hanya di lib/core/theme/. Dilarang Color(0x..), Colors.*, TextStyle() di luar tema.
9. Format uang/berat/tanggal/jam/telepon hanya lewat Formatters. Uang int rupiah, berat int gram. Dilarang double untuk uang.
10. Dilarang print, ignore lint tanpa alasan tertulis, dan menambah dependensi tanpa persetujuan.
11. Data dummy hanya dari fixture di features/*/data/ yang isinya persis docs/design/data_master.md.
12. Jangan menebak versi paket: gunakan flutter pub add dan versi yang di-resolve.
13. Jangan mengubah registry, tema/token, aturan lint, struktur folder, atau PRD tanpa izin pengguna. Jangan menambah fitur di luar PRD (kurir, stok, jatuh tempo, paket layanan, dsb). Catatan: custom_lint sudah dilepas (izin 22 Okt 2026); lint Riverpod terbukti berjalan lewat dart analyze (dua probe negatif; lihat PRD A bagian 13). flutter analyze tetap dijalankan.
14. Section (features/<f>/widgets/<nama>_section.dart): satu Section publik per file, maksimal 100 baris, StatelessWidget, data lewat konstruktor (tipe primitif, domain, atau view-data), aksi lewat callback. Dilarang mengimpor flutter_riverpod dan go_router, dan dilarang mengimpor widgets/ fitur lain. Hanya menyusun widget registry dan Section sefitur. Satu tes widget per Section. Section lama yang masih ConsumerWidget tercatat di tool/section_riverpod_debt.txt; daftar itu hanya boleh menyusut (migrasikan saat berkas disentuh), dilarang menambah.
15. Struktur fitur features/<f>/: pages/ (hanya *_page.dart, *_sheet.dart, *_flow.dart berupa fungsi pembuka dialog/sheet tanpa kelas widget, dan *_routes.dart), widgets/ (*_section.dart), state/ (Notifier, draf, view-data, pemetaan; tanpa impor package:flutter/material.dart dan go_router), data/ (fixture dan repository in-memory).
16. Input dan keyboard (dicek lewat tes): (a) field nominal/jumlah tidak pernah diisi teks "0": kosong dengan hint "0", kosong dihitung 0 saat simpan, tanpa nol di depan (05000); (b) field yang berisi nilai awal bukan nol memakai selectAllOnFocus; (c) Numpad dan stepper: ketukan angka pertama MENGGANTI nilai awal, Backspace pada nilai awal menghapus semuanya; (d) batas minimum tampil sebagai pesan error dan tombol simpan nonaktif, dilarang membulatkan diam-diam (0 menjadi 0,5); (e) setiap layar atau sheet berisi AppTextField atau AppSearchField wajib punya tes keyboard (viewInsets.bottom 300 dp: field yang fokus dan tombol simpan tetap terlihat); (f) sheet hanya lewat AppBottomSheet.show, dilarang showModalBottomSheet langsung.
17. Data pembayaran dan transaksi: (a) PayStatus (belumBayar/dp/lunas) adalah nilai TURUNAN dari total dan pembayaran masuk; dilarang disimpan atau dipilih pengguna; pilihan pengguna hanya Bayar sekarang atau COD (Order.payTerm); (b) order COD dengan sisa tagihan > 0 tidak boleh selesai lewat jalur apa pun (isCompletionHeld); (c) penulisan yang menyentuh lebih dari satu repository (nota+tabungan, batal+tabungan, pembayaran+tabungan, persetujuan usulan) wajib lewat TransactionRunner (R8); (d) kelebihan uang tunai dipilih Kembalian atau Simpan ke tabungan, bukan omzet.
18. Rahasia dan akun: password dan token tidak disimpan di state UI, tidak masuk log, dan tidak muncul di pesan error; field password tersembunyi secara default; pesan reset password dan pendaftaran tidak membocorkan keberadaan akun; Hapus akun hanya dari halaman Kelola akun dengan dua konfirmasi.
19. Persistensi: hanya core/persistence, core/sync, dan features/*/data boleh mengimpor drift, supabase_flutter, flutter_secure_storage, connectivity_plus, workmanager, path_provider; state/, widgets/, pages/, shared/ hanya lewat repository. Skema Drift berubah = migrasi + tes migrasi; skema Postgres berubah hanya lewat supabase/migrations (dilarang mengubah proyek cloud dari agen).
20. Preferensi: dilarang shared_preferences. Preferensi bisnis ke businesses/receipt_settings (sinkron), preferensi perangkat ke local_settings, sesi ke flutter_secure_storage, keadaan layar tidak disimpan.
21. Kontrak repository: setiap antarmuka repository punya satu suite tes kontrak yang dijalankan terhadap InMemory* dan Drift*; implementasi baru tidak boleh lolos tanpa suite itu. ID baris memakai IdGenerator (UUID v4; UUID v5 hanya untuk percobaan ulang idempoten); dilarang membuat ID dari rangkaian teks atau hitungan.
22. Rahasia: kunci service_role, token, dan berkas .env tidak masuk repo; aplikasi hanya memakai URL dan kunci publik lewat --dart-define; Edge Function memakai secrets Supabase.

## Mode Redesign UI (AKTIF di branch UI; hapus bagian ini sebelum merge ke main)
Tujuan: menerapkan desain baru dari Figma ke UI yang sudah ada. Murni tampilan (tata letak, posisi, gaya). Perilaku, data, dan alur DILARANG berubah. Aturan keras 1-22 tetap berlaku penuh; tidak ada pengecualian selain yang tertulis di bagian ini. Redesign dikerjakan BERURUTAN per lapisan atomic (UI-21 sampai UI-29), BUKAN per halaman.

Prasyarat setiap sesi (gagal = berhenti dan lapor, jangan menebak):
- git branch --show-current menunjukkan branch UI, bukan main/master.
- MCP FigCraft terhubung (aplikasi FigCraft terbuka dan MCP aktif sesuai opencode.json; uji dengan membaca satu frame yang diminta). Dilarang menebak desain dari ingatan, .pen lama, atau tangkapan layar lama.

Sumber kebenaran:
UI-1. Figma menang untuk tata letak, urutan, spacing, dan hierarki visual. Spec layar dan PRD menang untuk perilaku, data, aksi, validasi, dan teks pesan. Selisih dicatat di bagian "Selisih desain" pada spec layar; bagian tata letak spec layar diperbarui mengikuti Figma.
UI-2. Kode keluaran alat Figma (React, Tailwind, HTML, CSS) hanya referensi struktur dan nilai. Dilarang disalin atau ditiru kelas demi kelas; terjemahkan ke Flutter lewat widget_registry.yaml dan token.
UI-3. Figma hanya DIBACA. Dilarang membuat, mengubah, memindah, atau menghapus node, dan dilarang memakai tool tulis, auto-fix, atau lint-fix FigCraft, kecuali pengguna memintanya eksplisit pada sesi itu.
UI-4. Peta layar ke frame ada di docs/design/redesign/figma_map.md (layar, frame/URL, status, selisih). Pengguna memberi frame per sesi; catat di sana. Dilarang menebak frame.

Zona:
UI-5. BOLEH diubah: susunan widget di features/*/pages/ (pembacaan provider dan pemanggilan notifier tidak disentuh, lihat UI-8) dan features/*/widgets/, lib/shared/widgets/ (atoms sampai templates; hanya lewat UI-13 dan UI-21), tes widget (UI-18), lib/core/theme/ dan docs/design/tokens.md (hanya lewat UI-12), assets/ yang dipakai desain, bagian tata letak spec layar, figma_map.md, STATE.md. decisions.md hanya diisi pengguna (UI-22).
UI-6. BEKU (dilarang diubah tanpa izin eksplisit pengguna): features/*/state/, features/*/data/, core/persistence, core/sync, supabase/, tool/, app_router.dart dan *_routes.dart (path, nama rute, parameter), Formatters, TransactionRunner, IdGenerator, aturan lint, docs/prd, API widget_registry.yaml (nama dan parameter yang ada; parameter opsional baru berdefault hanya lewat UI-13), dependensi di pubspec.yaml, dan semua tes non-widget (state, data, kontrak repository, migrasi). Struktur navigasi (jumlah tab, tujuan rute) tetap; hanya tata letak bar navigasi yang boleh berubah.

Paritas fungsi (inti mode ini):
UI-7. Sebelum menulis kode sebuah layar, tulis tabel "Paritas redesign" di spec layarnya: semua data yang dibaca layar, semua aksi/callback, semua keadaan tampil (kosong, memuat, error, tertahan COD, dsb), dan semua Key yang dipakai tes. Setelah implementasi, centang satu per satu; tiap butir harus ada di UI baru.
UI-8. Sumber data dan aksi sama persis: provider yang sama, method yang sama, argumen yang sama, urutan pemanggilan yang sama. Section boleh dipecah atau digabung, tetapi data dan callback-nya tetap. Butuh data atau aksi baru dari state = berhenti dan tanya (state beku).
UI-9. Elemen di Figma tanpa dukungan PRD/state (tombol, filter, kartu, data baru): JANGAN dibuat, termasuk tombol mati atau data palsu. Catat di "Selisih desain" lalu tanya.
UI-10. Fungsi yang ada di aplikasi tetapi tidak tampak di Figma: JANGAN dihapus. Pertahankan di UI, catat selisih, tanya letaknya.
UI-11. Key, urutan fokus form, aturan input (aturan 16), dan validasi tidak berubah. Setiap layar dengan field tetap lolos tes keyboard (16e) pada tata letak baru.

Token, widget bersama, aset:
UI-12. Nilai Figma dipetakan ke token yang ada. Selisih kecil: pakai token terdekat dan catat. Tidak ada yang cocok: jangan hardcode (aturan 8) dan jangan ubah tema sendiri; tulis docs/design/proposals/NNN-token-<nama>.md (tabel token lama ke baru, layar terdampak) lalu tunggu persetujuan. Setelah disetujui, ubah hanya lib/core/theme/ dan tokens.md sesuai proposal. Token desain bersifat GLOBAL: dilarang membuat namespace token per layar atau per fitur (contoh terlarang: AppAuth*, AppColors.auth*). Perubahan token dikerjakan di lapisan token (UI-21), bukan saat mengerjakan halaman.
UI-13. Perubahan tampilan widget di widget_registry.yaml (gaya, ukuran, padding, varian baru) berdampak ke banyak layar: satu proposal PER LAPISAN (UI-21), bukan per widget atau per halaman; isinya daftar widget terdampak, varian baru, dan layar yang visualnya bergeser. API publik: nama dan parameter yang ada tidak berubah; parameter opsional baru berdefault boleh. Widget baru: aturan 2.
UI-14. Ikon Figma dipetakan ke AppIcons. Ada padanan Ionicons = tambah entri dan catat; tidak ada = SVG di assets/icons lewat AppSvg, catat sumbernya. Font baru atau paket baru = proposal (aturan 10).
UI-15. Teks dan angka contoh di Figma BUKAN data: dilarang disalin ke fixture (aturan 11) atau di-hardcode di widget. Label UI mengikuti spec; label diubah hanya bila tertulis di Figma dan dicatat di spec layar.
UI-16. Utang Section ConsumerWidget (tool/section_riverpod_debt.txt): selama mode ini JANGAN dimigrasikan kecuali pengguna meminta, karena migrasi menyentuh pembacaan state. Tetap dilarang menambah.
UI-17. Token akses Figma dan kredensial MCP lain hanya lewat environment variable di mesin pengguna. Dilarang ada di opencode.json, AGENTS.md, atau berkas lain yang masuk repo (aturan 22).

Tes dan selesai:
UI-18. Tes perilaku tidak boleh diubah. Tes widget Section/Page boleh disesuaikan hanya pada finder dan struktur visual; dilarang menghapus, melemahkan, atau men-skip assertion perilaku. Laporkan setiap tes yang diubah beserta alasannya.
UI-19. Satu layar selesai = (a) dart run tool/check_all.dart hijau dengan bukti keluaran; (b) git diff --name-only terhadap commit awal sesi tidak memuat zona beku (tampilkan keluarannya); (c) tabel paritas penuh tanpa butir kosong; (d) hasil dibandingkan dengan frame Figma di emulator Android, termasuk keyboard terbuka bila ada field. Jika lingkungan tidak bisa menjalankan emulator, tulis "visual belum diverifikasi" di STATE.md dan minta pengguna memeriksa.
UI-20. Berhenti dan tanya bila: perlu mengubah zona beku, perlu state/data baru, desain menuntut perilaku baru, paritas tidak terpenuhi, keputusan UI-22 belum terisi, urutan lapisan UI-21 akan dilanggar, atau check_arch gagal karena desain. Dilarang mengakali pemeriksaan (melonggarkan check, memindah logika ke Section, dan sejenisnya).

Urutan atomic (gerbang):
UI-21. Redesign dikerjakan BERURUTAN per lapisan: (0) keputusan desain global (UI-22), (1) token, (2) atoms, (3) molecules, (4) organisms, (5) templates, (6) Page/Section. Setiap lapisan 1-5 = satu proposal docs/design/proposals/NNN-lapisan-<nama>.md (komponen/token yang berubah, padanan komponen Figma, varian baru, layar terdampak). Lapisan berikutnya dimulai setelah proposal lapisan sebelumnya disetujui DAN selesai (check_all hijau). Page/Section sebuah layar baru dikerjakan setelah semua lapisan di bawah yang dipakai layar itu selesai. Persetujuan proposal lapisan = izin aturan 13 hanya untuk lingkup proposal itu.
UI-22. Keputusan desain global (warna primer dan peran hijau, font, skala tipografi minimum, varian ukuran tombol) dicatat PENGGUNA di docs/design/redesign/decisions.md. Kolom "Usulan" bukan keputusan. Selama kolom "Keputusan pengguna" kosong, lapisan 1 dilarang dimulai: berhenti dan lapor. Dilarang memilih sendiri.
UI-23. Utang token auth: app_auth_text_styles.dart, app_field_styles.dart, AppColors.auth*, AppRadius.auth*, AppShadows.auth*. Dimigrasikan ke token global pada lapisan 1; sebelum itu hanya boleh menyusut (dilarang menambah entri baru), sesudahnya dilarang ada lagi.
UI-24. Section dilarang membuat kontrol atau dekorasi sendiri: Material, InkWell, GestureDetector, ColorFiltered, BoxDecoration/DecoratedBox/Container berdekorasi, Stack+Positioned dekoratif. Tombol = AppButton/AppIconButton, kartu = AppCard atau organisme, pemisah = AppDivider atau molekul, dan seterusnya. Tidak ada padanan = aturan 2 (proposal), bukan membuat sendiri. Tata letak murni (Padding, Align, Column, Row, Expanded, Flexible, SizedBox) tetap boleh.
UI-25. Pola visual atau struktur yang sama di dua Section atau lebih, termasuk dalam satu fitur, wajib diangkat menjadi molekul/organisme lewat proposal lapisan. Dua Section yang hanya beda teks adalah satu komponen dengan parameter.
UI-26. Angka spacing/ukuran literal di Section dilarang (SizedBox(height: 12), EdgeInsets literal): pakai AppSpacing, AppGap, atau AppDimensions. Nilai yang belum ada diusulkan di proposal lapisan token.
UI-27. Page memakai template di shared/widgets/templates. Scaffold, Stack, atau SingleChildScrollView langsung di Page dilarang; butuh slot baru (mis. hero) = ubah template lewat proposal lapisan 5.
UI-28. Bukti lapisan 1-5: tes widget/golden komponen yang berubah diperbarui, check_all hijau, dan SEMUA golden layar lama yang berubah dilaporkan (daftar + alasan) agar pengguna menyetujui pergeseran visual. Dilarang memperbarui golden layar lama tanpa daftar itu.
UI-29. Setelah lapisan 1-5 selesai, Page/Section auth (layar 29 dan 31) dikerjakan ulang menjadi komposisi murni: tanpa primitif terlarang (UI-24), tanpa duplikasi (UI-25), tanpa literal (UI-26), memakai AuthScaffold (UI-27). Perilaku, Key, dan tes perilaku tidak berubah (UI-8, UI-11, UI-18).

## Skill dan memori (ringkas; detail di SKILLS.md)
- Pilih skill lewat tabel niat di SKILLS.md, sekali di awal tugas. Tugas kecil (sekitar 20 baris atau kurang), status, dan pertanyaan singkat tidak perlu skill.
- Subagen, eksekusi paralel, dan git worktree MATI kecuali pengguna memintanya.
- Memori codebase dan AI memory: cari dulu sebelum membuka berkas atau bertanya. Hal yang penting bagi agen lain WAJIB juga ditulis di repo (STATE.md), bukan hanya di memori alat.

## Selesai dan handoff
- Selesai = dart run tool/check_all.dart hijau, dengan bukti keluarannya. Tanpa bukti, belum selesai.
- Setiap tugas atomik selesai, atau saat usage menipis, atau sebelum berhenti: perbarui docs/progress/STATE.md, commit (wip: bila belum hijau), dan laporkan commit terakhir serta langkah berikutnya. Jangan push atau merge tanpa izin.
- Kerjakan satu kelompok widget atau satu layar per sesi, lalu berhenti menunggu tinjauan.
- Mode Redesign UI: STATE.md juga memuat lapisan aktif (UI-21), layar selesai/ditunda, proposal yang menunggu, selisih desain, tes yang diubah, dan status verifikasi visual.

## Perintah
flutter run -t lib/main_dummy.dart      # data dummy
dart run tool/check_all.dart            # format, analyze, check_arch, test, repo_map