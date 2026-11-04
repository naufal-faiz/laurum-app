# 26 - Riwayat Usulan AI
Rute: /lainnya/ai/riwayat | Prompt: 80
Frame: Lainnya - Riwayat Usulan AI. Template: RootScaffold, Lainnya aktif.
Komposisi: ProposalHistorySection (ChipBar, BannerMessage ringkasan historis,
MenuRow usulan terbaru, EmptyState filter kosong). Padding akhir bebas tombol tengah.
Provider: proposalHistoryProvider, proposalHistoryFilterProvider.

Data: tiga usulan aktual, tanggal menurun; status dari ProposalRepository.
Ringkasan historis DATA MASTER: 142 disetujui, 8 ditolak, 3 ditutup otomatis;
status awal aktual Menunggu 3. Setuju/tolak menambah penghitung terkait dan
mengurangi Menunggu. Ringkasan lama tidak dijadikan rekaman pesan fiktif.
Daftar berisi hanya usulan aktual; banner menjelaskan ringkasan historis.
Ketuk MenuRow -> detail, termasuk detail yang sudah diproses (readonly).
Gagal memuat -> Coba lagi; filter tanpa rincian -> EmptyState.

Selisih .pen: urutan terbaru dahulu; banner menjelaskan batas ringkasan historis;
nav empat tab dan tombol Transaksi mengikuti revisi terakhir pengguna.
Verifikasi: hitungan fixture, perubahan status, filter, buka detail, retry,
golden, 320 px/teks 2x. Perangkat Android/iOS belum diuji untuk layar ini.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
