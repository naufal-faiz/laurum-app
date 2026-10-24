# STATE Laurum
Diperbarui: 2026-10-24 | Cabang dev1

## Posisi
Prompt 40 selesai: Detail Order, Edit Order, dan Riwayat Nota menjadi layar nyata.
check_all: SEMUA HIJAU; 269 tes; kedua analyzer bersih; check_arch OK; REPO_MAP 422 berkas.
Berhenti menunggu tinjauan sebelum prompt 50-pelanggan-a.md.

## Selesai
- Fase 1: 60/60 widget, domain inti, data dummy, Widgetbook.
- Fase 2-4: Antrean - Beranda, alur transaksi (pilih layanan, berat, pelanggan,
  pembayaran, nota tersimpan), Printer dan Struk dengan PrintService palsu.
- Prompt 40: /order/:id (status berurutan, ubah status, catat pembayaran, jejak
  aktivitas, cetak struk, batal via cancelOrder) dan /order/:id/edit (draf dari order,
  pelanggan terkunci, banner WhatsApp, simpan item/estimasi/event).
- Tab /transaksi: pencarian, lima filter, grup tanggal, NotaCard, CTA Transaksi baru.
- 11 tes baru; total 269. Placeholder Detail order/Edit order/Riwayat nota dihapus.

## Sedang dikerjakan
- Tidak ada. Tunggu tinjauan pengguna sebelum prompt berikutnya.

## Antrean
1. Tinjau di HP/emulator: buka nota dari Antrean dan Riwayat, ubah status, catat
   pembayaran, edit berat, batalkan A-0142, lalu periksa Antrean/Laporan/tabungan.
2. Berikutnya: docs/prompts/50-pelanggan-a.md (Daftar, Detail, Edit Pelanggan).
3. APK/NDK, iOS, TalkBack/VoiceOver, printer dan keyboard nyata masih ditunda.

## Keputusan dan batas
- Detail order memakai FormScaffold (footer dua tombol sejajar: Cetak struk + CTA).
- Menu: MenuRow untuk Edit order/Ubah status; Batalkan order memakai AppButton
  destructiveOutline karena MenuRow belum punya warna destruktif.
- Status hanya maju berurutan lewat nextStatus; akhir status tidak bisa diedit/diubah.
- Catat pembayaran (Tunai/QRIS/Transfer) memvalidasi sisa piutang terbaru dari
  repository, menyimpan Payment + OrderEvent; tabungan tetap lewat alur pembayaran.
- Batal: cancelOrder menulis koreksi pembayaran + event pada saveOrder, lalu
  SavingsEntry penyesuaian ditambahkan setelahnya (rollback belum tersedia).
- Edit: estimasi = enteredAt + durasi terlama; item lama mempertahankan ID; simpan
  ditolak bila total < pembayaran tercatat; event "edited".
- Riwayat: Semua/Hari ini/Belum lunas/Selesai/Dibatalkan; pencarian nomor atau nama.
  CTA memakai push; kartu membuka Detail order.
- GoRouter push dari dalam shell tidak memperbarui URI di routeInformationProvider
  (halaman tetap terbuka); tes memakai isi layar dan canPop.
- Selisih .pen: tanpa "Oleh Pemilik", baris layanan edit tetap MenuRow + sheet,
  ringkasan A-0140 tanpa "Sisa Rp15.000" di NotaCard.
- Atom/token/registry/lint/PRD tidak diubah. Tanpa dependensi baru.

## Pemeriksaan dan batas
- Android/iOS perangkat, TalkBack/VoiceOver, keyboard/printer nyata belum diuji.
- Screenshot .pen Detail Order, Edit Order, Riwayat Nota, dan state batal dibaca.
- Tidak push/merge. Jangan mulai prompt 50 tanpa instruksi pengguna.
