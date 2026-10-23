# 12 - Organisms bagian 1 (9 widget)
Ikuti _COMMON.md bagian A, B, D, E, F. Prasyarat: prompt 11 SELESAI. Baca: PRD A bagian 5, tokens.md, component_catalog.md, frame .pen terkait.

Widget (urutan kerja): BottomNavBar, ServiceRow, CustomerRow, SavingsRow, ExpenseRow, OrderCard, NotaCard, ProposalCard, PiutangCard.
Organisms boleh mengimpor atoms, molecules, dan enum core/domain; pemetaan status ke badge dilakukan di dalam widget.

Catatan per widget:
- BottomNavBar: 5 tab, aktif #00653B semibold, ikon terisi saat aktif; parameter tab aktif dan callback.
- OrderCard: varian dengan aksi dan ringkas; rail kiri amber (perlu dicek) atau merah (usulan batal); nomor nota mono; badge status dan teks status bayar.
- ProposalCard: tombol utama "Periksa" bila ada bagian ragu, "Setujui" bila tidak; selalu ada "Tolak".
- PiutangCard: usia netral ("4 hari lalu"), tombol "Catat bayar" dan "Ingatkan". TIDAK ada konsep jatuh tempo.
- SavingsRow: setor (+) atau pakai (-), saldo setelah mutasi. ExpenseRow: kategori, catatan, nominal negatif.
- NotaCard: baris ringkas untuk Riwayat Nota.

Titik simpan setelah tiap tiga widget.
