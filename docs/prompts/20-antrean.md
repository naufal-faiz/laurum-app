# 20 - Kerangka navigasi dan Antrean - Beranda
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: prompt 14 SELESAI. Baca: PRD A bagian 8 dan 9, frame "Antrean - Beranda" dan varian State terkait.

TUGAS
1. go_router dengan StatefulShellRoute untuk 5 tab (Antrean, Pelanggan, Transaksi, Laporan, Lainnya). Tab yang belum dibangun memakai PlaceholderPage (EmptyState) di features/shell/pages. Rute lain dari tabel PRD A bagian 8 didaftarkan sebagai placeholder bila belum ada.
2. Antrean - Beranda: ChipBar (Semua 12, Jemput 3, Proses 5, Siap 4, Perlu dicek 3), OrderCard dengan aksi (Tandai dijemput, Tandai siap, Serahkan sesuai status), ProposalCard di bagian Perlu dicek, FAB "+ Transaksi baru" ke /transaksi/baru.
3. State: kosong, filter tanpa hasil, loading (skeleton), banner WhatsApp terputus (hanya tampil bila status koneksi palsu = terputus).
4. Aksi mengubah state: "Tandai siap" memindahkan order dari Proses ke Siap dan menghitung ulang chip.
5. main_dummy.dart dan main.dart memakai router dan override data dummy.
Spec: docs/design/screens/01-antrean-beranda.md.
