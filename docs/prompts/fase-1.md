Baca AGENTS.md, docs/prd/prd-a-ui.md (bagian 5 dan 6), docs/design/tokens.md, dan docs/design/widget_registry.yaml. Kerjakan HANYA kelompok widget ini:

AppText, AppIcon, AppGap, AppDivider, AppCard, AppSvg

Untuk setiap widget:
1. Satu berkas, maksimal 100 baris (batas keras 110). Semua varian dan parameter sesuai PRD A bagian 5.2.
2. Semua gaya dari core/theme; semua ikon lewat AppIcon. Tidak ada hex, TextStyle, atau Icon() langsung.
3. Satu use-case Widgetbook yang menampilkan SEMUA varian.
4. Satu tes widget yang memeriksa render varian utama.
5. Satu entri di docs/design/component_catalog.md (parameter, varian, contoh).
6. Visual dibandingkan dengan frame .pen terkait; catat setiap selisih.

Aturan khusus:
- Urutan pengerjaan: widget yang dipakai widget lain lebih dulu (AppText, AppIcon).
- AppSvg: buat widget dan konstanta path (boleh kosong). Lewati use-case sampai ada SVG pertama, lalu catat di component_catalog.md.
- Jangan menambah widget di luar registry. Jika kurang, tulis proposal di docs/design/proposals/ dan berhenti.

Selesai bila dart run tool/check_all.dart hijau. Laporkan: daftar widget, jumlah baris tiap berkas, selisih terhadap .pen, dan hal yang tidak pasti. Tulis catatan kemajuan di docs/progress/fase-1.md, bukan di file prompt ini. Lalu BERHENTI dan tunggu tinjauanku sebelum kelompok berikutnya.