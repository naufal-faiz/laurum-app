# STATE Laurum
Diperbarui: 2026-11-04 | Cabang dev2backend

## Posisi
UI dummy sampai prompt 100, R0-R10 dan koreksi struk selesai.
check_all SEMUA HIJAU: 688 tes, kedua analyzer bersih, check_arch OK, REPO_MAP 714 berkas.
Bukti UI: docs/progress/fase-ui.md; APK final dibangun, dipasang dan diluncurkan Android 12.
Integrasi dokumen dev2backend: check_all diulang 4 Nov, exit 0; 688 tes/714 berkas.
Bukti pemeriksaan: %TEMP%/laurum-backend-docs-check.log (check_all: SEMUA HIJAU).

## Selesai
- Registry 60/60; semua feature memakai Page/Sheet/Section. Utang Section tetap 14.
- R1: input awal/minimum, keyboard 300 dp, numpad/stepper; tidak membulatkan diam-diam.
- R2/R3/R7: empat tab + Transaksi tengah, Antrean aktif, FAB katalog dan aksi pelanggan
  di atas; Keluar destruktif di luar kartu. R2 Android dikonfirmasi 30 Okt.
- R4: mode status/sederhana, non-COD boleh selesai belum lunas; COD tetap tertahan.
- R5/R6: range/kalender/grafik/CSV dan daftar nota di Laporan; Riwayat Nota dihapus.
- Prompt 71/80/90: pengeluaran reaktif, usulan AI atomik, auth/sync dan cleanup dummy;
  spec 23-30 dan progres per fase menyimpan rincian/keputusan.
- R8: TransactionRunner checkout/batal/persetujuan/cleanup; rollback seluruh store.
- R9: Bayar sekarang/COD, uang lebih kembalian/setoran, pelunasan sesuai mode;
  Catat pembayaran Detail/Struk/Piutang termasuk nota selesai. Progress R9.
- R10: email/password + Google dummy, daftar/cek email/onboarding, reset 60 detik,
  Kelola akun/profil/password dan hapus dua konfirmasi. Progress R10.
- Koreksi 4 Nov: semua Cetak Detail menuju receipt; Selesaikan selesai setelah cetak
  berhasil. Tanpa cetak dihapus. Tombol receipt seragam/berborder, preview center;
  saldo/switch sejajar dan footer Cetak/Tandai siap sama ukuran/font.
- Prompt 100: banner gagal sinkron empat tab, bridge Laporan aman dari notifikasi
  saat build, hint harga layanan 0. Alur penerimaan baru dari pelanggan hingga Laporan.
  34 rute 320px/1,3x + guideline empat tab; 32 frame .pen/34 rute/3 sheet diperiksa.
  README, katalog dan 33 spec diperbarui; utang lama dicatat tanpa mengubah checker.

## Langkah berikutnya
1. Integrasi dokumen backend 4 Nov: INDEX2/STATE2 digabung ke berkas utama;
   progres UI prompt 100 tetap selesai (HEAD UI 94c5fc9), backend belum dimulai.
2. Lengkapi docs/backend/ROADMAP.md: dirujuk BP0/INDEX tetapi belum ada di checkout.
   Setelah prasyarat terpenuhi, urutan BP0 -> B1a-B1f -> B0; B2/B3/B5-B8 MENUNGGU.
   B0 hanya Supabase lokal, memerlukan Docker Desktop dan CLI; jangan mengubah cloud.
3. PRD B 16 kini berisi keputusan default; AGENTS aturan 19-22 dan delapan prompt
   backend sudah dibaca. Tidak perlu menyusun ulang prompt atau menjalankan BP0 saat integrasi.
4. Tinjau APK/catatan fase-ui.md; alur/keyboard/TalkBack/printer nyata belum seluruhnya
   diuji manual, iOS belum diuji. Utang: 15 runtime 101-110 baris, test/tool lama >110,
   padding LockedRow dan PRD A Google-only; rincian fase-ui.md. Jangan tag/push/merge.

## Keputusan dan batas
- Backend: UUID lewat IdGenerator, kontrak InMemory/Drift bersama; preferensi lokal
  di SQLite local_settings, sesi di secure storage, tanpa shared_preferences/rahasia repo.
- Terminal/Git/Flutter/test rutin langsung; tanya hanya keputusan di luar izin/desain.
- PayStatus turunan, tidak dipilih/disimpan. COD bersisa tidak boleh selesai.
  Nol dengan tabungan sebagian wajib COD; tagihan tertutup tabungan boleh disimpan.
  Non-tunai melebihi sisa ditolak. Kelebihan tunai bukan omzet.
- Catat pembayaran mode aktif hanya melepas tahanan; Terima pembayaran di langkah
  siap sekaligus selesai. Mode sederhana otomatis selesai saat COD lunas.
- Semua penulisan lintas repository lewat TransactionRunner; backend nanti satu
  transaksi SQLite termasuk outbox. Counter dummy per mutasi, belum outbox nyata.
- Nota lama non-COD belum lunas didukung; CSV PayStatus turunan, BOM/titik koma;
  Ingatkan piutang disembunyikan. Omzet = nota non-batal. Ekspor Excel masih CSV.
- Fixture cust-010 = Pelanggan 10/nomor pengisi, A-0137 mengacu ID itu; awal 48
  pelanggan/12 antrean. Histori AI 142/8/3 adalah agregat; fixture tidak diubah audit.
- Semua layanan/account/sync masih in-memory/palsu; restart kembali ke fixture.
  Password bukan state UI/log/error, dihapus saat form dispose; telepon tanpa OTP.
  Profil akun terpisah Info Usaha; hapus membersihkan demo, keluar menjaga data HP.
- Slot OrderEditBodySection lintas fitur tetap izin R0; statusLabel mengikuti R4.
  Audit tidak mengubah PRD, registry, tema/token, dependensi atau aturan lint/checker.
- SDK E:/App Data/flutter/flutter. Android SDK/JDK tersedia, Samsung wireless teruji;
  APK build/app/outputs/flutter-apk/app-debug.apk, hash/bukti di fase-ui.md.
- Graph E-Latihan-Pemrograman-laurum-projects-laurum menunjuk checkout E: aktif
  dan diperbarui otomatis. Repo adalah acuan handoff; baca REPO_MAP untuk navigasi.
