Baca AGENTS.md, docs/prd/prd-a-ui.md (bagian 4, 6, 10) dan docs/prd/prd-b-backend.md (hanya bagian 3). Kerjakan HANYA Fase 0:
1. flutter create (Android saja), nama paket laurum, application ID: <ISI>.
2. Pasang dependensi PRD A bagian 4 dengan flutter pub add (jangan menebak versi). Laporkan versi yang ter-resolve dan apakah custom_lint/riverpod_lint kompatibel.
3. Bundel font Plus Jakarta Sans dan IBM Plex Mono di assets/fonts.
4. Buat lib/core/theme (token PRD A bagian 6), core/formatters, core/icons/app_icons.dart (pemetaan bagian 8), kerangka folder.
5. Salin analysis_options.yaml, tool/check_arch.dart, tool/check_all.sh, widget_registry.yaml dari Kit Agen. Sesuaikan nama paket.
6. Buat main_dummy.dart yang menampilkan satu layar kosong bertema. Siapkan skeleton Widgetbook.
Jangan membuat widget atau layar apa pun. Selesai bila tool/check_all.sh hijau. Laporkan.