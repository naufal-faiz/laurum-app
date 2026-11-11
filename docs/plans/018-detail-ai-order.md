# Detail AI dan Detail Order — rencana sesi 018
Dasar: 49dd172. Cabang newdesign; FigCraft 512/612 terbaca, read-only.
Codebase-memory transport closed; sumber langsung dan REPO_MAP dipakai.

1. Persetujuan proposal lapisan 018, 019 dan 020 (komponen bersama/API template).
2. Lapisan molecules: header detail, label kanan dan PaymentBadge; tes + check_all.
3. Lapisan organisms: CustomerContactCard; tes/golden + check_all.
4. Lapisan templates: FormScaffold varian detail; keyboard + check_all.
5. Periksa Usulan AI: kartu pelanggan, pesan AI + peringatan, data layanan/alamat,
   proteksi AI, footer lama. Semua provider/callback/draf tetap; tanpa fitur berat
   atau jadwal jemput baru. Skor contoh hanya scope dummy yang sudah ada.
6. Detail Order: header/nota/status, kontak, rincian/total, pembayaran, timeline,
   footer sesuai mode/final/COD. Pertahankan menu, cetak, pembayaran dan guards.
7. Setiap Section baru/diubah punya tes; finder visual boleh disesuaikan tanpa
   menghapus assertion perilaku. Catat semua golden terdampak sebelum update.
8. check_all akhir, diff zona beku, Android termasuk keyboard usulan.
9. STATE + commit, tanpa FigCraft pengguna; berhenti untuk tinjauan.

State/data/core/domain/repository/Formatters/rute/dependensi/PRD/lint tidak diubah.
Tidak ada token/font baru; warna, ukuran dan ikon registry yang tersedia dipakai.
