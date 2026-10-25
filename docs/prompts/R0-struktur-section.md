# R0 - Struktur fitur dan kategori Section (tanpa perubahan perilaku)
Ikuti _COMMON.md bagian A, D, E, F. Prasyarat: prompt 70 SELESAI. Baca: AGENTS.md aturan 1, 5, 14, 15 (sudah diperbarui), docs/revisi/REVISI-01.md bagian S.

Tujuan: menutup celah akhiran Page. Potongan layar diberi nama dan tempat resmi (Section), logika non-UI keluar dari pages/. TIDAK ada perubahan visual atau perilaku; 310 tes harus tetap hijau tanpa mengubah ekspektasi (hanya impor dan nama kelas).

## IZIN TERTULIS (25 Okt 2026)
- Mengubah tool/check_arch.dart dan tool/check_all.dart (aturan baru di bawah) dengan tes.
- Memindah dan mengganti nama berkas di lib/features dan test/. Tanpa mengubah atoms/molecules/organisms/templates, registry, tema, lint, dependensi.
- Memperbarui docs/prd/prd-a-ui.md bagian 5.1 (tambah paragraf kategori Section, satu paragraf) dan docs/design/screens/*.md yang menyebut nama kelas lama.

## Langkah
1. check_arch (tes lebih dulu; tambah test/tool/check_arch_test.dart bila belum ada pola tes alat):
   - Kelas *Page di lib/features harus menjadi builder rute (disebut di app_router.dart atau berkas *_routes.dart). Selain itu: error "pakai Section di widgets/".
   - Kelas *Section hanya sah di features/*/widgets/*_section.dart, extends StatelessWidget, tanpa impor flutter_riverpod/go_router (kecuali tercatat di tool/section_riverpod_debt.txt), tanpa impor widgets/ fitur lain.
   - Isi features/*/pages/ hanya *_page.dart, *_sheet.dart, *_flow.dart, *_routes.dart, app_router.dart. Berkas lain: error "pindah ke state/".
   - features/*/state/ tanpa kelas Widget dan tanpa impor package:flutter/material.dart atau go_router.
   - showModalBottomSheet hanya di shared/widgets/organisms/app_bottom_sheet.dart (bila ada pemanggil lain, daftarkan sebagai temuan untuk R1; jangan diubah di R0).
2. Migrasi mekanis, satu fitur per commit (orders, transactions, customers, reports, settings+services+business+printer+shell):
   - git mv berkas non-UI (controller, data, draft, state, providers, quote, save) dari pages/ ke state/.
   - Fungsi pembuka dialog/sheet yang memakai BuildContext (contoh order_cancel.dart, leaveTransaction) menjadi *_flow.dart di pages/.
   - Setiap kelas *Page non-rute menjadi *Section (nama kelas dan berkas), pindah ke widgets/. Contoh: OrderSummaryPage -> OrderSummarySection (order_summary_section.dart).
   - Perbarui impor, tes, spec layar. Tes dipindah mengikuti berkas.
3. Section yang masih ConsumerWidget atau mengimpor go_router: jangan ubah perilaku; daftarkan path-nya di tool/section_riverpod_debt.txt (satu baris per berkas, urut abjad). Buat daftar ini otomatis dari hasil migrasi.
4. Berkas yang dibelah hanya karena batas 100 baris dan sebenarnya satu kesatuan: JANGAN digabung di R0. Catat sebagai temuan.
5. Jalankan check_all (REPO_MAP otomatis). Tidak ada golden yang berubah.

## Hasil yang diharapkan di laporan
Jumlah berkas dipindah per fitur, daftar kelas yang diganti nama, isi tool/section_riverpod_debt.txt (jumlah baris), temuan (maks 5). Prompt berikutnya: R1-input-keyboard.md.
