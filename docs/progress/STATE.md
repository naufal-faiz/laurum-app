# STATE Laurum
Diperbarui: 2026-11-14 | Cabang ui/pelanggan

## Sesi aktif
Redesign Tambah layanan031, dasar0e81c8d.
Frame pilihan4294968237 LAURUM · Tambah Layanan dibaca sekali lewat FigCraft aktif.
Snapshot/pemetaan/paritas di spec21; proposal031 siap ditinjau.

## Status irisan
- Rancangan: pratinjau biru, kartu informasi, kartu durasi/status, footer sejajar.
- FormScaffold detail, toggle, chip durasi dan layout responsif sudah tersedia.
- Dibutuhkan4varian bersama opt-in agar sesuai frame; belum mengubah kode/tes.
- Proposal031: AppCard.gradient=false, AppBadge inverse, AppTextField.prefixText=null,
  SelectionTile.compact=false. Semua default lama tetap dan memakai token yang ada.
- Nama usaha di subtitle memerlukan pembacaan profil usaha read-only di Page.
- Form Edit mempertahankan komposisi/binding lama; state/data/rute tidak diubah.
- Draft/validasi/save/cancel/not-found/loading/error sudah dipetakan di tabel paritas.
- Tidak mengambil screenshot FigCraft/emulator; struktur node mencukupi.

## Keputusan pengguna terbaru
- Redesign Tambah layanan sesuai frame aktif; pengguna meminta pembaruan.
- Nama usaha/contoh harga Figma bukan data; gunakan sumber nyata/draft yang ada.
- Tetap dukung font HP besar dan keyboard300dp.
- Merge ke backend-newdesign harus melalui persetujuan eksplisit pengguna.
- Jangan uninstall atau menghapus DB/outbox perangkat.

## Belum di-commit
Dokumen persiapan031 dicakup commit WIP sesi ini; kode belum diubah.
android/build/ tetap artefak tak terlacak; tidak disertakan Git.

## Langkah berikutnya
1. Persetujuan proposal031 untuk4varian bersama dan pembacaan profil usaha di Page.
2. Setelah izin: atom/tema→SelectionTile→Page/Section khusus Tambah; Edit tetap.
3. Pertahankan provider/callback/validasi; tambahkan tes Section/varian/keyboard/font.
4. Golden terarah, check_arch, check_all sekali di akhir, paritas penuh dan commit final.
5. Pengguna meninjau HP; tidak push/merge tanpa izin.

## Blocker
AGENTS UI-13/UI-21: perubahan komponen bersama perlu proposal dan persetujuan.
UI-8: subjudul nama usaha perlu persetujuan pembacaan sumber profil yang sudah ada.

## Bukti terakhir
- Branch ui/pelanggan, HEAD0e81c8d, FigCraft aktif dengan pilihan4294968237.
- Graph/snippet menemukan ServiceEditPage dan ServiceEditFieldsSection;
  trace tidak merekam callee; API diverifikasi langsung dan coverage10berkas bersih.
- Proposal/spec/peta frame siap; belum menjalankan tes karena belum ada perubahan kode.
- Bukti1291lulus/2skip/check_all hijau adalah irisan laporan sebelumnya.
- Visual belum diverifikasi manual pada HP; iOS belum diuji.
