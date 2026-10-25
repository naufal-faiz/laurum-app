# STATE Laurum
Diperbarui: 2026-10-25 | Cabang dev1rev

## Posisi
R0 SELESAI (audit ulang 317 tes hijau): docs/progress/r0-verification.md.
R1 SEDANG: fondasi keyboard selesai, check_all hijau (324 tes, REPO_MAP 501 berkas).
Lanjutan: R1-input-keyboard.md langkah 3 (diskon), bukan R2.

## Selesai
- Fase 1-8: 60 widget registry dan alur dummy sampai prompt 70; rincian fase-0..8.md.
- R0: 38 Page non-rute menjadi Section, 50 berkas state, dua flow; check_arch
  menegakkan kategori/lapisan baru. Tujuh tes alat, total baseline 317 tes.
- R0 dokumen: PRD A 5.1 dan 7, spec 06/07/08/10/19, component_catalog diperbarui.
- R1 fondasi: AppBottomSheet memakai useSafeArea, batas 90%, padding keyboard;
  child fleksibel. FormScaffold menaikkan footer berdasarkan viewInsets.
- AppTextField.selectAllOnFocus (default false), FocusNode internal + dispose.
- Helper keyboard 300 dp, DPR 2, safe area; empat tes template pada dua ukuran,
  dua tes seleksi/refokus, satu tes host. Use-case Widgetbook + katalog diperbarui.
- pumpAntrean memakai MediaQuery.fromView: ukuran layar sebelumnya nol;
  ukuran/insets sekarang dinamis dan textScaler tetap. Tes alur/golden tetap.

## Sedang dikerjakan / langkah berikutnya
- Rincian dan tabel audit: docs/progress/r1-input-keyboard.md.
- Kelompok fondasi sudah diverifikasi; berhenti untuk tinjauan sesuai AGENTS.md.
- Berikutnya DiscountInput + DiscountSheet: kosong untuk nol, digit tanpa nol
  depan, selectAllOnFocus untuk nilai awal bukan nol; tes state dan keyboard.
- Setelah itu WeightEdit fresh/backspace/koma/minimum, lalu audit semua input
  dan field nominal sesuai R1. Audit per layar BELUM; tes template bukan pengganti.

## Antrean
- R1 lalu R2-R7 berurutan; setelah R7: 71-lainnya-b, 80-ai, 90-auth-sinkron,
  100-penyelesaian. Catat bayar dan Ingatkan di Daftar Piutang masih placeholder.

## Keputusan dan batas
- Section debt tetap 26 berkas (22 ConsumerWidget), hanya boleh menyusut;
  migrasikan saat disentuh. Daftar: tool/section_riverpod_debt.txt.
- OrderEditBodySection menerima slot details dari OrderEditPage untuk
  TransactionDetailsSection lintas fitur; keputusan R0 tetap.
- PRD A 5.2 RootScaffold/FAB dan 8 navigasi masih lama; diperbarui di R2.
- R5: ringkasan rentang hanya nota + pembayaran; pengeluaran ditunda ke 71.
- Prompt 70: tanpa Urutkan layanan; switch simpan langsung; Info Usaha hanya
  receiptFooter; Keluar via AuthService.signOut placeholder 90; top services
  Minggu ini; CSV BOM titik koma; piutang dari ledger; nonaktif tidak menghapus data.
- Pembatalan order dan penyesuaian tabungan belum punya rollback lintas repository.
- Perubahan widget bersama hanya izin R1; registry/tema/lint/dependensi tetap.
- Golden lama dipertahankan; Column contoh AppBottomSheet kini mainAxisSize.min
  agar tetap mengikuti isi saat menerima constraint.

## Handoff untuk agen penerus
1. Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status/log.
2. Lanjut R1 dari bagian Sedang dikerjakan; satu kelompok widget/layar per sesi.
3. Pengguna meminta berhenti bila sisa usage mendekati 10%; simpan STATE + commit.
4. Launcher sandbox gagal karena G: BitLocker; repo E:, eksekusi tereskalasi berhasil.
5. Android/iOS perangkat, keyboard nyata, TalkBack/VoiceOver, ekspor/telepon/printer
   nyata belum diuji. Tidak push/merge.
