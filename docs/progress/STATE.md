# STATE Laurum
Diperbarui: 2026-11-02 | Cabang dev1rev

## Posisi
Fase 1-8 sampai prompt 90 dan R0-R10 selesai otomatis.
check_all SEMUA HIJAU: 639 tes, kedua analyzer bersih, check_arch OK, REPO_MAP 705 berkas.
Bukti: docs/progress/r10-akun.md; pembayaran R9 dan fondasi rollback R8 tetap hijau.

## Selesai
- R0: Section/state; utang Section kini 14 setelah migrasi R9 (hanya boleh menyusut).
- R1: input/keyboard/nominal/berat fresh dan minimum; r1-input-keyboard.md.
- R2/R3: empat tab, Transaksi tengah, Antrean aktif, katalog/FAB dan pelanggan baru.
- R4: mode sederhana/detail/cetak/selesai; non-COD tidak wajib lunas.
- R5/R6: laporan range, kalender/grafik/top services/CSV, daftar nota/filter;
  pengeluaran tersimpan termasuk custom range; Riwayat Nota terpisah dihapus.
- R7/Nav: aksi pelanggan di atas; Keluar destruktif di luar kartu Akun;
  cincin transaksi dan ruang scroll disetujui. R2 Android dikonfirmasi 30 Okt.
- Prompt 71: daftar/catat/detail/hapus pengeluaran, kategori baru, foto palsu;
  Laporan reaktif. Spec 23/24 dan progress/71-pengeluaran.md.
- Prompt 80: WhatsApp dummy, detail usulan/pelanggan baru, approve/tolak/batal,
  riwayat/filter, status R4, retry tanpa data ganda. Spec 25..28.
- Prompt 90: Google palsu/guard/onboarding, sync pending/retry/offline, logout,
  hapus dua konfirmasi dengan cleanup repo/draf/histori lokal.
- R8: TransactionRunner checkout/batal/persetujuan/cleanup; rollback seluruh store,
  kategori/sync/sesi dummy; nested dan transaksi antre teruji.
- R9: PayTerm sekarang/COD, nominal positif, kembalian/setoran uang lebih atomik;
  COD tertahan state/repository, pelunasan sesuai mode; dua tujuan tombol kasir.
  Catat pembayaran Detail/Struk/Piutang termasuk order selesai; label sisa/COD.
  36 tes tambahan, keyboard 300 dp dan visual 320 px/2x; fixture tidak berubah.
- R10: email/password + Google dummy, daftar/cek email/onboarding, reset 60 detik;
  Kelola akun dan sheet nama/telepon/password, Hapus hanya di Kelola (dua konfirmasi).
  59 tes tambahan, 12 field keyboard/320 px/2x; profil/kredensial ikut rollback R8.

## Sedang dikerjakan / langkah tepat berikutnya
1. Berhenti untuk tinjauan R10: masuk/daftar/reset, edit profil/password, keluar/hapus
   dua konfirmasi; Android perangkat, iOS dan SMTP nyata belum diuji.
2. Tinjau Android R9: COD kedua mode, uang lebih, Catat bayar order selesai,
   tujuan tombol, keyboard dan layar; printer nyata belum diuji.
3. Setelah tinjauan: docs/prompts/100-penyelesaian.md; belum dimulai.

## Keputusan dan batas
- Terminal/Git/Flutter/test rutin langsung; tanya hanya keputusan di luar izin/desain.
  Jangan push/merge. Repo E:/Latihan Pemrograman/laurum-projects/laurum, dev1rev.
- PayStatus turunan, tidak dipilih/disimpan. COD bersisa tidak boleh selesai.
  Nol dengan tabungan sebagian harus COD; tagihan tertutup tabungan boleh disimpan.
  Non-tunai melebihi sisa ditolak. Kelebihan tunai bukan omzet.
- Catat pembayaran biasa mode aktif hanya melepas tahanan COD; aksi Terima pembayaran
  di langkah siap sekaligus selesai. Mode sederhana otomatis selesai saat COD lunas.
- Semua penulisan lintas repository lewat TransactionRunner; backend nanti satu
  transaksi SQLite termasuk outbox. Counter dummy tetap per mutasi, belum outbox nyata.
- Nota non-COD lama yang belum dibayar tetap didukung, filter Sebagian berdasarkan
  payTerm sekarang dan sisa. CSV tetap PayStatus turunan; Ingatkan piutang disembunyikan.
- Fixture Rudi/Rina/Agus mengikuti izin sebelumnya: cust-010 = Pelanggan 10/nomor pengisi,
  A-0137 tetap mengacu ID itu; awal 48 pelanggan/12 antrean. Riwayat AI 142/8/3 agregat.
- AI/QR/foto/auth/sync masih dummy in-memory; tanpa Google/server/WhatsApp nyata.
  Hapus akun dua konfirmasi membersihkan data demo; keluar menjaga data HP.
- R10 password hanya field privat sementara (bukan state UI/log/error), dibuang saat
  sukses/dispose; reset generik dan cooldown bertahan lintas rute. Telepon tanpa OTP.
  Demo satu owner/perangkat; profil akun terpisah dari Info Usaha dan struk.
- OrderEditBodySection slot lintas fitur tetap keputusan R0; statusLabel proposal 001
  mengikuti R4. Omzet = nota non-batal, ekspor CSV BOM titik koma.
- R9 memakai izin perubahan tiga organism dan paragraf PRD; registry/tema/token/lint/
  dependensi/DATA MASTER tidak berubah. R10 izin AuthService/rute dan paragraf PRD B.
- SDK E:/App Data/flutter/flutter; graph E-Latihan-Pemrograman-laurum-projects-laurum
  menunjuk checkout aktif E: dan diperbarui otomatis. Baca REPO_MAP untuk navigasi ringkas.
