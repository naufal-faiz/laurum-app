# STATE Laurum
Diperbarui: 2026-11-04 | Cabang dev2backend

## Posisi
UI dummy prompt 100/R0-R10 dan koreksi struk selesai; bukti docs/progress/fase-ui.md.
BP0 SELESAI: IdGenerator, local_settings, rentang, kontrak dan checker aturan 19-21.
check_all SEMUA HIJAU: 719 tes, kedua analyzer bersih, check_arch OK; REPO_MAP 738.
Bukti akhir: %TEMP%/laurum-bp0-check.log (exit 0); ringkasan docs/progress/bp0-id.md.
Baseline BP0: 688 tes hijau; log %TEMP%/laurum-bp0-baseline.log.
ROADMAP tersedia dan disimpan pada a5d612a; integrasi dokumen sebelumnya 5d830e1.

## Selesai BP0
- Prompt docs/prompts/BP0-persiapan-backend.md; rencana docs/plans/BP0-persiapan-backend.md.
- 28 titik ID baru diganti: 21 v4/7 v5; audit rinci docs/progress/bp0-id.md.
  Fixture teks tetap sampai seed B1f; nomor nota A-0143 tetap, terpisah dari ID UUID.
- LocalSettingsRepository InMemory: kode perangkat default A, counter per perangkat,
  printer_id/name. Counter ikut rollback transaksi; hapus akun membersihkan pengaturan.
- Order/Expense mendapat metode rentang [start,end), pembayaran berdasarkan paidAt.
- 7 suite kontrak repository + 1 TransactionRunner untuk dipakai ulang oleh Drift.
  Fake generator di test menjaga ekspektasi lama; tes default memakai UUID asli.
- Checker aturan 19-21 dan tes negatif ditambah, tanpa daftar pengecualian baru.
- Self-review: tidak ada widget/layar atau perubahan .pen; fixture/registry/tema tetap.
  Semua Dart baru <=100 baris, runtime tersentuh <=110; utang tool lama dicatat di audit.
- LANGKAH BERIKUTNYA: B1a-drift-fondasi.md. Berhenti setelah commit BP0; belum Drift/Supabase.

## Antrean
1. Prompt berikutnya: docs/prompts/B1a-drift-fondasi.md, lalu B1b-B1f, kemudian B0.
   B0 hanya Supabase lokal (Docker/CLI); agen dilarang mengubah proyek cloud.
2. B2/B3/B5-B8 MENUNGGU; minta penyusunan setelah B1f. PRD B 16 berisi default.
3. Tinjau APK UI: Android 12 sudah dipasang/diluncurkan, semua alur/keyboard/TalkBack/
   printer nyata belum seluruhnya diuji manual. iOS belum diuji.
4. Utang lama: runtime 101-110, test/tool >110, padding LockedRow dan PRD A Google-only;
   lihat fase-ui.md. Registry 60/60, utang Section 14 tidak bertambah. Jangan push/merge.

## Keputusan dan batas
- AGENTS 19-22: impor persistensi hanya data/core persistence/sync; tanpa shared_preferences.
  Preferensi perangkat local_settings, bisnis/struk tersinkron, sesi secure storage.
- UUID lewat IdGenerator/provider; v5 hanya retry idempoten. Namespace/label di audit
  merupakan identitas stabil; jangan menggantinya saat implementasi Drift.
- PayStatus turunan, tidak dipilih/disimpan. COD bersisa tidak boleh selesai.
  Nol dengan tabungan sebagian wajib COD; tertutup tabungan boleh disimpan.
  Non-tunai melebihi sisa ditolak; kelebihan tunai bukan omzet.
- Catat bayar mode aktif hanya melepas tahanan; Terima bayar di siap sekaligus selesai.
  Mode sederhana otomatis selesai saat COD lunas; non-COD lama belum lunas didukung.
- Lintas repository wajib TransactionRunner; nanti satu transaksi SQLite + outbox.
  Saat ini counter sync dummy per mutasi; belum ada outbox/sinkron nyata.
- Semua data/account/sync masih in-memory; restart kembali fixture. Password bukan
  state UI/log/error, dibuang saat dispose; telepon tanpa OTP. Keluar menjaga data HP.
- CSV BOM/titik koma, PayStatus turunan; Ingatkan piutang tersembunyi; omzet nota non-batal.
- Fixture 48 pelanggan/12 antrean; cust-010 nomor pengisi, A-0137 mengacu ID itu;
  AI 142/8/3 agregat. Rincian UI/R1-R10 ada di dokumen progress masing-masing.
- Slot OrderEditBodySection lintas fitur tetap izin R0; statusLabel mengikuti R4.
- SDK E:/App Data/flutter/flutter. APK build/app/outputs/flutter-apk/app-debug.apk.
- Graph E-Latihan-Pemrograman-laurum-projects-laurum menunjuk checkout E: aktif,
  auto-index. Repo/STATE adalah acuan handoff; baca REPO_MAP untuk navigasi.
