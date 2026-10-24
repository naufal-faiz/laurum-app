# Fase 5 - Detail Order, Edit Order, Riwayat Nota (24 Oktober 2026)

- Baseline commit 2391b06 (termasuk gradle.properties sesi lama): check_all SEMUA HIJAU,
  258 tes, 391 berkas REPO_MAP.
- Prompt 40: /order/:id, /order/:id/edit, /order/:id/edit/layanan, dan tab /transaksi
  menjadi layar nyata; placeholder Detail order/Edit order/Riwayat nota dihapus dari
  placeholder_routes.
- Detail order: AppBadge status + AppStatusText bayar, InfoRow masuk/estimasi, kartu
  pelanggan + Buka WhatsApp (ExternalLauncher palsu), rincian layanan, catatan, riwayat
  pembayaran + Catat pembayaran (Numpad + Tunai/QRIS/Transfer), jejak aktivitas dari
  OrderEvent (tanpa "Oleh Pemilik"), footer Cetak struk + CTA status berurutan.
- Menu titik tiga: AppBottomSheet (Edit order, Ubah status) + tombol Batalkan order
  destructiveOutline; Ubah status memakai sheet satu langkah; batal memakai ConfirmModal
  "Batalkan order A-0142?" dan cancelOrder (koreksi pembayaran + tabungan dalam satu simpan).
- Catat pembayaran memvalidasi sisa piutang terbaru dari repository (bukan data layar),
  menyimpan Payment + OrderEvent, lalu menginvalidasi detail, Antrean, dan struk.
- Edit order: orderEditProvider (AsyncNotifier family) mengisi transactionDraftProvider
  dari order tersimpan; pelanggan terkunci (LockedRow), banner WhatsApp, widget Buat
  Transaksi dipakai ulang (MenuRow, TransactionLineSheet, WeightInputSheet, DiscountSheet),
  simpan mempertahankan ID item lama dan menulis event "edited". Ditolak bila total baru
  di bawah pembayaran tercatat.
- Riwayat nota: AppSearchField, ChipBar lima filter, DateGroupHeader per tanggal masuk,
  NotaCard, CTA Transaksi baru di atas BottomNavBar; kartu membuka Detail order.
  Pembatalan dari Detail langsung terlihat di daftar (tes reaktif).
- 11 tes baru: 3 aksi/domain (batal belum bayar, batal dengan tabungan, catat pembayaran),
  3 Detail order, 2 Edit order, 3 Riwayat nota.
- Selisih .pen: MenuRow tidak punya warna destruktif -> Batalkan order memakai AppButton;
  jejak aktivitas tanpa "Oleh Pemilik" dan tanpa pengulangan jam di judul; baris layanan
  Edit order tetap MenuRow + sheet (bukan stepper inline); ringkasan A-0140 tidak menambah
  "Sisa Rp15.000" pada NotaCard; label "Nama pelanggan" menjadi label aksesibilitas
  AppSearchField.
- Temuan lapisan lain: GoRouter `push` dari dalam StatefulShellRoute tidak memperbarui
  routeInformationProvider (halaman tetap terbuka, `canPop` benar), sehingga tes memakai
  isi layar/canPop, bukan URI. MenuRow (registry) tidak mendukung warna teks/ikon khusus.
- Keputusan: estimasi saat edit dihitung dari enteredAt + durasi terlama; pembatalan
  menyimpan koreksi pembayaran dan tabungan terpisah (antarmuka repository terpisah);
  Catat pembayaran hanya Tunai/QRIS/Transfer (tabungan lewat alur pembayaran/nota).
- Atom/token/registry/lint/PRD tidak diubah. Tanpa dependensi baru.
- check_all SEMUA HIJAU; rincian keluarannya ada di STATE.md.
