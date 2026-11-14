# STATE Laurum
Diperbarui: 2026-11-14 | Cabang ui/pelanggan

## Sesi aktif
Persiapan redesign Detail Pelanggan, dasar36fdffe; daftar pelanggan selesai sebelumnya.
Frame aktif pilihan pengguna4294969558 dibaca14Nov melalui MCP FigCraft.
Dokumen docs/design/new-design-laurum.figcraft; snapshot/paritas disimpan di spec13.

## Status irisan
- Proposal028 disiapkan: varian ringkas StatTile/SavingsRow/NotaCard dan header SubScaffold.
- Rencana profil biru, statistik2×2, aksi sejajar, riwayat rapat; token yang ada.
- Belum ada perubahan kode/tes/golden/state pada irisan detail ini.
- Lihat semua mutasi memakai rute tersedia; usulan Lihat semua order butuh izin perilaku.
- Perlu izin migrasi navigasi SavingsSection ke callback Page dan penghapusan satu entri debt.
- Visual belum diverifikasi manual; tidak mengambil screenshot emulator.

## Keputusan pengguna terbaru
- Lanjutkan UI detail pelanggan dengan frame yang dipilih; branch tetap ui/pelanggan.
- Merge kembali ke backend-newdesign HARUS melalui persetujuan eksplisit pengguna.
- Izin revisi sebelumnya: batas10/Lihat semua daftar, ikon impor dan teks tombol kecil;
  izin tersebut dipakai pada36fdffe, bukan dianggap izin fitur baru riwayat order.
- Pertahankan data kedua HP; jangan uninstall/hapus DB/outbox.
- Hanya Nama wajib; kebijakan WhatsApp tanpa nomor tetap; Contacts Data safety wajib.

## Belum di-commit
Persiapan proposal028, spec13, figma_map dan STATE dicakup commit wip sesi ini.
android/build/ tetap artefak tak terlacak sesi sebelumnya; tidak dimasukkan Git.

## Langkah berikutnya
1. Minta satu persetujuan proposal028, termasuk ekspansi order dan izin migrasi callback.
2. Setelah izin: komponen bersama dari bawah ke atas, lalu Page/Section dan tes.
3. Pertahankan nama/nomor/alamat/catatan/nonaktif/uang dan seluruh aksi/paritas spec13.
4. Golden terarah, check_all akhir, satu commit feat(ui) dan tinjauan pengguna.
5. Merge hanya setelah pengguna memberi izin eksplisit.

## Blocker
UI-13: perubahan komponen bersama menunggu proposal028.
UI-9/UI-20: Lihat semua order memerlukan keputusan perilaku dan state ekspansi.

## Bukti terakhir
- Branch ui/pelanggan, dasar36fdffe; FigCraft pilihan4294969558 terbaca.
- Coverage11berkas: no_recorded_issue/metadata_match; sumber dibaca langsung.
- Tes belum dijalankan karena sesi ini baru persiapan dokumen.
- Bukti revisi daftar sebelumnya: check_all1222lulus/2skip,exit0; bukan bukti detail baru.
