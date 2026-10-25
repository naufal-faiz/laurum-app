# STATE Laurum
Diperbarui: 2026-10-25 | Cabang dev1rev

## Posisi
R0 SELESAI. check_all SEMUA HIJAU: 317 tes, REPO_MAP 496 berkas.
38 kelas *Page non-rute sudah menjadi Section, logika non-UI di features/*/state/.
Prompt berikutnya: R1-input-keyboard.md.
Audit ulang 25 Okt 2026: check_all hijau (317 tes), ekspektasi tes lama tetap;
rincian migrasi dan bukti: docs/progress/r0-verification.md.

## Selesai
- Fase 1-8: 60 widget registry, alur antrean, transaksi, pembayaran/nota, printer,
  detail/edit order, pelanggan, tabungan, impor kontak, laporan/piutang,
  pengaturan/akun, layanan, info usaha. Prompt 70 berakhir 310 tes hijau;
  rincian di docs/progress/fase-0..8.md.
- R0 Struktur Section (25 Okt 2026): check_arch menegakkan *Page hanya untuk rute,
  *Section hanya di features/*/widgets/*_section.dart (StatelessWidget, tanpa
  Riverpod/go_router/widgets fitur lain), pages/ hanya *_page/_sheet/_flow/_routes
  + app_router.dart, state/ tanpa kelas Widget dan tanpa material/go_router,
  showModalBottomSheet hanya di AppBottomSheet. Ditambah test/tool/check_arch_test.dart
  (7 tes).
- R0 migrasi: 38 Page non-rute menjadi Section (orders 12, transactions 7, customers 9,
  reports 2, services 3, settings 2, printer 3); 50 berkas di state/; notifier yang
  menempel di sheet (diskon, uang tunai) dipisah ke state/; order_cancel dan
  leaveTransaction menjadi *_flow.dart. Tes lama tidak diubah ekspektasinya:
  310 + 7 = 317 hijau.
- R0 dokumen: PRD A 5.1 (paragraf Section) dan 7 (struktur fitur) diperbarui;
  spec 06, 07, 08, 10, 19 dan component_catalog memakai nama Section baru.

## Antrean
- R1-input-keyboard.md: perbaiki AppBottomSheet, selectAllOnFocus, diskon, berat,
  audit keyboard semua sheet. Lalu R2, R3, R4, R5, R6, R7 berurutan.
- Setelah R7: prompt 71-lainnya-b.md, 80-ai.md, 90-auth-sinkron.md, 100-penyelesaian.md.
- Catat bayar dan Ingatkan di Daftar Piutang masih placeholder.

## Keputusan dan batas
- Section debt: 26 berkas (22 ConsumerWidget) di tool/section_riverpod_debt.txt;
  hanya boleh menyusut, dimigrasikan saat berkas disentuh R1-R7.
- OrderEditBodySection menerima slot `details` (Widget) dari OrderEditPage karena
  Section dilarang mengimpor widgets/ fitur lain: TransactionDetailsSection dipakai
  fitur transactions dan orders (draf transaksi dipakai bersama).
- PRD A 5.2 (RootScaffold + FAB) dan 8 (5 tab, /transaksi) masih deskripsi lama;
  diperbarui di R2 sesuai izin pengguna 25 Okt 2026.
- R5 (keputusan pengguna 25 Okt 2026): ringkasan rentang hanya nota + pembayaran;
  pengeluaran ditunda ke prompt 71.
- Keputusan prompt 70 tetap: direktori layanan tanpa kontrol Urutkan; switch aktif
  simpan langsung; Info Usaha hanya receiptFooter; Keluar lewat AuthService.signOut
  (placeholder prompt 90); top services hanya Minggu ini; CSV UTF-8 BOM titik koma;
  total piutang dari ledger; nonaktif tidak menghapus nota/piutang/tabungan.
- Pembatalan order lalu penyesuaian tabungan belum punya rollback lintas repository.
- Tidak mengubah widget bersama/registry/tema/lint/PRD lain/dependensi. Tes layar
  320 px dan teks 2x lulus.

## Handoff untuk agen penerus
1. Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status/log sebelum lanjut.
2. Lanjut R1-input-keyboard.md; satu layar/kelompok widget per sesi, berhenti menunggu
   tinjauan.
3. Pengguna meminta berhenti bila sisa usage mendekati 10%; simpan STATE + commit.
4. Launcher sandbox kadang gagal karena drive G: terkunci; repo ada di E:. 
5. Android/iOS perangkat, keyboard, TalkBack/VoiceOver, ekspor/telepon/printer nyata
   belum diuji.
Tidak push/merge.
