# Prompt 10 — domain inti

- Dasar: PRD B 5/6, data_master, aturan Format tokens; tanpa perubahan UI.
- Enum, model immutable Equatable dan logika murni di lib/core/domain/.
- Antarmuka repository baru dikerjakan prompt 11, di core/domain/repositories/.
- Tes lebih dulu: aritmetika/pembulatan, status final, tanggal, ledger, laporan.
- Ledger append-only; pembatalan mengembalikan entri koreksi, tabungan menghasilkan pasangan entri.
- Semua ID dan waktu diberikan pemanggil; tanpa random, clock, provider, Flutter atau persistence.
- Pengguna menyetujui kontrak minimal Proposal/OrderEvent dan baseline historis aditif.
- Range laporan half-open pada WIB lokal; posisi saldo/piutang tidak dibatasi periode.
- Formatters tidak diubah; keterbatasan nomorNota berkode A dicatat untuk prompt terkait.
- Akhir: check_all hijau, INDEX/STATE/progress diperbarui, commit, berhenti.
