# 033 — Tarik ke bawah untuk menyegarkan data lintas perangkat
Status: disetujui16Nov2026; fix kedipan c5c6087 terverifikasi sebelum implementasi.
## Masalah dan alur
- UI membaca Drift lokal; login memicu sync, pemicu periodik sekitar15menit.
- Gesture memanggil SyncService.syncNow(): push lokal, pull server, lalu muat query layar.
- Jangan memakai DriftSyncService.refresh() sebagai pengganti sync: itu hanya menghitung outbox.

## Komponen bersama
- AppDataRefresh, organisme lib/shared/widgets/organisms/app_data_refresh.dart.
- API: required Widget child, required Future<void> Function() onRefresh,
  bool hasScrollableChild = true (fallback scroll untuk keadaan kosong/error tanpa daftar).
- Membungkus RefreshIndicator; scroll vertikal tetap dapat ditarik saat konten pendek/kosong.
- Tanpa provider dalam widget, StatefulWidget khusus, token baru atau dependensi baru.
- Registry diperbarui; Root/Sub/FormScaffold yang ada mendapat onRefresh opsional (null).
- Root/Sub.refreshScrollable=true; tanpa template atau opsi navbar baru.

## Integrasi
- DataRefreshActions di features/sync/state/: tunggu sync dan reload query; gabungkan request bersamaan.
- Page membaca provider dan meneruskan callback; Section tetap menerima data/callback saja.
- Layar: Beranda, Antrean, Pelanggan/kontak, Lainnya, Laporan, Pengeluaran,
  Daftar layanan, Piutang, Detail pelanggan/order/nota, dan Riwayat saldo/tabungan.
- Indikator berhenti setelah pembacaan ulang selesai; offline/gagal/belum siap diberi pesan jelas.
- Filter, pencarian, tab dan data lokal dipertahankan; tidak me-reset akun, database atau draft form.
- Form Tambah/Edit dan modal input tidak diberi gesture yang dapat mengganti input pengguna.
- Memakai protokol sinkronisasi dan penjaga outbox yang ada; tanpa skema/RPC/auth baru.

## Verifikasi
- Widget: gesture, konten pendek/kosong/error, font2x, navigasi saat request, posisi scroll/filter.
- Integrasi: perubahan perangkatA masuk perangkatB lewat pull+Drift tanpa login ulang; offline/konkurensi.
- Jalankan tes terarah, check_arch dan check_all; uji dua HP dengan Supabase lokal oleh pengguna.
