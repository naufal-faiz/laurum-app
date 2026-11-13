# STATE Laurum
Diperbarui: 2026-11-13 | Cabang ui/pelanggan

## Sesi aktif
Mode Redesign UI aktif kembali atas permintaan pengguna; dasar 4f14852.
Branch ui/pelanggan dibuat dari backend-newdesign dengan izin pengguna.
Frame pilihan: Pelanggan4294969460 dan Detail Pelanggan4294969558.
Dokumen aktif: docs/design/new-design-laurum.figcraft; MCP terhubung.

## Status irisan
- Irisan pertama daftar pelanggan; snapshot/paritas dicatat di spec12.
- Proposal027 CustomerRow menunggu persetujuan sebelum implementasi.
- Belum ada perubahan kode/tes/golden/provider/data.
- Detail pelanggan menjadi irisan berikutnya.
- Visual belum diverifikasi manual; tidak mengambil screenshot emulator.
- Batch sebelumnya sudah di commit97b3980 dan4f14852 (git mengoreksi STATE lama).

## Keputusan pengguna terbaru
- Lanjutkan redesign pelanggan dengan frame FigCraft terpilih.
- Buat ui/pelanggan dari backend-newdesign; disetujui sesi ini.
- Merge kembali ke backend-newdesign HARUS melalui persetujuan eksplisit pengguna.
- Hanya Nama pelanggan wajib; kebijakan detail/struk tanpa nomor tetap berlaku.
- Pertahankan data kedua HP; jangan uninstall/hapus DB/outbox.
- Data safety Play Store mencantumkan Contacts; iOS belum diuji.

## Belum di-commit
Persiapan proposal027, spec12, figma_map dan STATE dicakup commit wip persiapan.
android/build/ tetap artefak tak terlacak sesi sebelumnya; tidak dimasukkan Git.

## Langkah berikutnya
1. Persetujuan proposal027 untuk komponen bersama CustomerRow.
2. Setelah izin: komponen bersama dahulu, lalu Section, tanpa perubahan perilaku.
3. Tes terarah/golden dan check_all sekali; lengkapi paritas.
4. Commit feat(ui) irisan selesai; tunggu tinjauan pengguna.
5. Detail pelanggan setelah daftar ditinjau; merge hanya dengan izin pengguna.

## Blocker
UI-13: perubahan CustomerRow memerlukan persetujuan proposal027.
Header jumlah piutang Figma memerlukan pembacaan data shell; belum diizinkan.

## Bukti terakhir
- Branch ui/pelanggan berhasil dibuat dari4f14852; MCP membaca frame pilihan.
- Coverage9berkas: no_recorded_issue/metadata_match; sumber dibaca langsung.
- Tes belum dijalankan: persiapan dokumen, belum implementasi.
- Bukti lama dari STATE sebelumnya: check_all1215lulus/2skip (Supabase lokal).
  Bukti lama tersebut bukan verifikasi redesign pelanggan.
