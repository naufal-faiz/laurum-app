# 40 - Detail Order, Edit Order, Riwayat Nota
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: prompt 32 SELESAI. Baca: frame "Transaksi - Detail Order", "Edit Order", "Riwayat Nota" dan varian State (batalkan order).

Aturan:
- Detail Order (/order/:id): footer CTA "Tandai siap" (berubah sesuai nextStatus, mis. "Serahkan") dan Secondary "Cetak struk". Menu titik tiga di AppBarSub membuka AppBottomSheet berisi MenuRow: Edit order, Ubah status, Batalkan order (merah). Kartu pembayaran punya "Catat pembayaran" (sheet Numpad). Jejak aktivitas dari OrderEvent; tanpa "Oleh Pemilik".
- Batalkan order: ConfirmModal "Batalkan order A-0142?" memakai cancelOrder; order keluar dari laporan.
- Edit Order (/order/:id/edit): komposisi yang sama dengan Buat Transaksi (pakai widget yang sama), pelanggan terkunci, banner info untuk order dari WhatsApp ("isi berat setelah cucian ditimbang"), sheet Input Berat.
- Riwayat Nota (tab Transaksi): AppSearchField, ChipBar (Semua, Hari ini, Belum lunas, Selesai, Dibatalkan), DateGroupHeader, NotaCard, tombol CTA "Transaksi baru" di atas BottomNavBar. Sambungkan tombol "Lihat order" dari Nota Tersimpan.
- Semua perubahan memperbarui Antrean, Laporan, dan saldo secara nyata.
