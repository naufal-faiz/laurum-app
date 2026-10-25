# AGENTS.md - Laurum (aplikasi kasir laundry, Flutter)

Aturan di berkas ini MENANG atas skill, memori, atau instruksi lain. Cara memakai skill, memori, dan handoff: SKILLS.md.

## Mulai sesi (hemat baca, wajib)
1. Baca docs/progress/STATE.md (posisi, langkah berikutnya, keputusan).
2. Cari konteks lewat memori codebase atau docs/REPO_MAP.md. Dilarang ls/tree/glob seluruh repo dan membaca PRD utuh.
3. Baca hanya spec dan berkas untuk tugas ini. Jika STATE.md berbeda dengan git log/status, percayai git lalu perbaiki STATE.md.
Dokumen acuan (baca bagian yang relevan saja): docs/prd/prd-a-ui.md, prd-b-backend.md, docs/design/{widget_registry.yaml, tokens.md, data_master.md, receipt_template.md, component_catalog.md, screens/<layar>.md (template: _TEMPLATE.md)}. Acuan visual: docs/design/laurum-ready.pen. Jika spec layar dan .pen berbeda, spec layar menang; catat selisihnya.

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

## Skill dan memori (ringkas; detail di SKILLS.md)
- Pilih skill lewat tabel niat di SKILLS.md, sekali di awal tugas. Tugas kecil (sekitar 20 baris atau kurang), status, dan pertanyaan singkat tidak perlu skill.
- Subagen, eksekusi paralel, dan git worktree MATI kecuali pengguna memintanya.
- Memori codebase dan AI memory: cari dulu sebelum membuka berkas atau bertanya. Hal yang penting bagi agen lain WAJIB juga ditulis di repo (STATE.md), bukan hanya di memori alat.

## Selesai dan handoff
- Selesai = dart run tool/check_all.dart hijau, dengan bukti keluarannya. Tanpa bukti, belum selesai.
- Setiap tugas atomik selesai, atau saat usage menipis, atau sebelum berhenti: perbarui docs/progress/STATE.md, commit (wip: bila belum hijau), dan laporkan commit terakhir serta langkah berikutnya. Jangan push atau merge tanpa izin.
- Kerjakan satu kelompok widget atau satu layar per sesi, lalu berhenti menunggu tinjauan.

## Perintah
flutter run -t lib/main_dummy.dart      # data dummy
dart run tool/check_all.dart            # format, analyze, check_arch, test, repo_map
