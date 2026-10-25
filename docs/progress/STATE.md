# STATE Laurum
Diperbarui: 2026-10-25 | Cabang dev1rev

## Posisi
R0 dan R1 SELESAI. check_all hijau: 354 tes, REPO_MAP 505 berkas.
Prompt berikutnya: R2-navigasi-beranda.md. Rincian R1: docs/progress/r1-input-keyboard.md.

## Selesai
- Fase 1-8: 60 widget registry dan alur dummy sampai prompt 70; rincian fase-0..8.md.
- R0: 38 Page non-rute menjadi Section, 50 berkas state, dua flow; check_arch
  menegakkan kategori/lapisan baru. Tujuh tes alat, baseline 317 tes.
- R0 dokumen: PRD A 5.1 dan 7, spec 06/07/08/10/19, component_catalog diperbarui.
- R1 fondasi: AppBottomSheet memakai useSafeArea, batas 90%, padding keyboard;
  FormScaffold menaikkan footer berdasarkan viewInsets; AppTextField.selectAllOnFocus.
- R1 diskon: kosong untuk nol (hint '0'), hanya digit tanpa nol depan, select-all
  untuk nilai bukan nol, kosong = 0 saat simpan, error rentang tetap.
- R1 berat/jumlah: fresh (angka pertama mengganti), koma pertama '0,', Backspace
  mengosongkan, tanpa nol depan, tanpa klamp; tampil nilai apa adanya, pesan
  'Minimal 0,5 kg'/'Minimal 1 pcs', simpan nonaktif; chip menambah; minus stepper
  nonaktif di minimum. Simpan membaca nilai terkini (bukan build lama).
- R1 nominal: Uang tunai dan Setor tabungan tanpa nol depan; harga layanan membuang
  nol depan dan kosong saat '0', selectAllOnFocus saat harga awal bukan nol.
- R1 audit keyboard: 14 layar/sheet lulus helper 300 dp (keyboard_audit_test),
  diskon terpisah; Catat pembayaran dan Uang tunai T/A karena numpad tanpa field
  teks. Helper mendukung layar pencarian tanpa tombol simpan.
- R1 migrasi: ServiceEditFieldsSection menjadi StatelessWidget (data + callback),
  keluar dari tool/section_riverpod_debt.txt (26 -> 25).
- pumpAntrean memakai MediaQuery.fromView: ukuran/insets dinamis, textScaler tetap.

## Antrean
- R2-navigasi-beranda.md, lalu R3, R4, R5, R6, R7 berurutan; setelah R7:
  71-lainnya-b, 80-ai, 90-auth-sinkron, 100-penyelesaian.
- Catat bayar dan Ingatkan di Daftar Piutang masih placeholder.

## Keputusan dan batas
- Section debt 25 berkas, hanya boleh menyusut; migrasikan saat disentuh.
- OrderEditBodySection menerima slot details dari OrderEditPage untuk
  TransactionDetailsSection lintas fitur; keputusan R0 tetap.
- PRD A 5.2 RootScaffold/FAB dan 8 navigasi masih lama; diperbarui di R2.
- R5: ringkasan rentang hanya nota + pembayaran; pengeluaran ditunda ke 71.
- Prompt 70: tanpa Urutkan layanan; switch simpan langsung; Info Usaha hanya
  receiptFooter; Keluar via AuthService.signOut placeholder 90; top services
  Minggu ini; CSV BOM titik koma; piutang dari ledger; nonaktif tidak menghapus data.
- Pembatalan order dan penyesuaian tabungan belum punya rollback lintas repository.
- Widget bersama hanya diubah sesuai izin R1; registry/tema/lint/dependensi tetap.
- Golden lama dipertahankan; Column contoh AppBottomSheet mainAxisSize.min.

## Handoff untuk agen penerus
1. Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status/log.
2. Lanjut R2; satu kelompok widget/layar per sesi, berhenti menunggu tinjauan.
3. Pengguna meminta berhenti bila sisa usage mendekati 10%; simpan STATE + commit.
4. Launcher sandbox gagal karena G: BitLocker; repo E:, eksekusi tereskalasi berhasil.
5. Android/iOS perangkat, keyboard nyata, TalkBack/VoiceOver, ekspor/telepon/printer
   nyata belum diuji. Tidak push/merge.
