# STATE Laurum
Diperbarui: 2026-11-14 | Cabang ui/printer (worktree terpisah dari ui/pelanggan)

## Sesi aktif
Redesign layar Printer & Struk, dasar 7e85870.
Frame dibaca sekali lewat FigCraft: Printer & Struk (4294969167), Cari Printer
Bluetooth (4294969275), Printer & Struk — Terhubung (4294969351).
Paritas dan selisih di docs/design/screens/06-printer-struk.md.

## Status irisan
- Page 06 sudah memakai tata letak frame: header + badge status, kartu koneksi,
  kartu format, kartu elemen, kartu pesan, kartu pratinjau, footer dua tombol.
- Section baru: printer_format_section, printer_elements_section,
  printer_message_section, printer_footer_section.
- Device list memakai MenuRow di dalam AppCard; sheet tetap memakai
  AppBottomSheet (judul/subjudul spec).
- Tidak ada perubahan state, data, rute, token, shared/widgets, atau dependensi.
- Selisih: tanpa tombol Putus, tanpa banner cetak otomatis, tanpa baterai/sinyal,
  badge hijau memakai varian `siap`, kontrol 58/80 memakai AppChip.

## Keputusan pengguna terbaru
- Ketiga frame Printer dikerjakan dalam satu irisan.
- Branch baru disetujui; merge butuh persetujuan; konflik dilaporkan.
- Commit terpisah dari agen lain; jangan commit docs/design/new-design-laurum.figcraft.

## Belum di-commit
(Irisan ini sudah di-commit berbarengan dengan STATE.md.)

## Langkah berikutnya
1. Pengguna meninjau layar di perangkat/emulator (visual belum diverifikasi manual).
2. Koreksi tata letak dikerjakan sebagai commit fix(ui).
3. Merge ke newdesign/backend-newdesign hanya setelah persetujuan pengguna;
   docs/progress/STATE.md dan docs/design/redesign/figma_map.md berpotensi konflik
   dengan perubahan agen lain di pohon utama.

## Blocker
Tidak ada.

## Bukti terakhir
- flutter analyze lib/features/printer: No issues found.
- flutter test printer_page/sections/device list/discovery/refresh/reconnect/restore:
  semua lulus; golden printer_page.png diperbarui.
- flutter test test/keyboard_audit_test.dart: 14 tes lulus.
- dart run tool/check_arch.dart: OK.
