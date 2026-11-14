# STATE Laurum
Diperbarui: 2026-11-14 | Cabang ui/printer (worktree terpisah dari ui/pelanggan)

## Sesi aktif
Redesign layar Printer & Struk, dasar 13a1741 (koreksi fix(ui)).
Frame dibaca sekali lewat FigCraft: Printer & Struk (4294969167), Cari Printer
Bluetooth (4294969275), Printer & Struk — Terhubung (4294969351).
Paritas dan selisih di docs/design/screens/06-printer-struk.md.

## Status irisan
- Koreksi putaran 2: header memakai AppBarSub varian detail (back bulat, judul,
  subjudul satu baris, badge status di kanan); jarak antar kartu AppSpacing.cardGap.
- Kontrol lebar kertas dan ukuran huruf memakai molekul baru SegmentedControl
  (track + pil aktif) sesuai Figma; label 58/80 mm dan Normal/Besar tetap.
- Molekul baru: lib/shared/widgets/molecules/segmented_control.dart, terdaftar di
  widget_registry.yaml; proposal singkat 032-segmented-control.md; tanpa token baru.
- Section: printer_format_section kini memakai SegmentedControl; tanpa AppChip.
- Device list memakai MenuRow di dalam AppCard; sheet tetap AppBottomSheet.
- Tidak ada perubahan state, data, rute, atau dependensi.

## Keputusan pengguna terbaru
- Ketiga frame Printer dikerjakan dalam satu irisan.
- Koreksi tata letak langsung (fix(ui)) tanpa proposal baru.
- Branch baru disetujui; merge butuh persetujuan; konflik dilaporkan.
- Jangan commit docs/design/new-design-laurum.figcraft.

## Belum di-commit
(Perubahan koreksi ini belum di-commit; lihat git status --short.)

## Langkah berikutnya
1. Pengguna meninjau golden atau menjalankan flutter run -t lib/main_dummy.dart
   (visual belum diverifikasi manual di perangkat).
2. Koreksi lanjutan dikerjakan sebagai commit fix(ui) berikutnya.
3. Merge ke newdesign/backend-newdesign hanya setelah persetujuan pengguna.

## Blocker
Tidak ada.

## Bukti terakhir
- flutter analyze lib/features/printer lib/shared/widgets/molecules/segmented_control.dart:
  No issues found.
- flutter test printer_page/sections/device list/discovery/refresh/reconnect/restore/
  service + keyboard_audit: 32 tes lulus; golden printer_page.png diperbarui.
- dart format pada 4 berkas berubah; dart run tool/check_arch.dart: OK.
