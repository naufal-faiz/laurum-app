# STATE Laurum
Diperbarui: 2026-10-31 | Cabang dev1rev

## Posisi
Fase 1-8 sampai prompt 80 dan R0-R7 selesai otomatis.
check_all: SEMUA HIJAU, 510 tes, kedua analyzer bersih, check_arch OK,
REPO_MAP 605 berkas. Bukti prompt 80 di docs/progress/80-ai.md.

## Selesai
- R0: Section/state; utang Riverpod Section 21 (tidak bertambah).
- R1: input/keyboard/nominal/berat fresh dan minimum; r1-input-keyboard.md.
- R2: empat tab, Transaksi tengah, Antrean aktif; Android dikonfirmasi 30 Okt.
- R3: katalog/FAB Layanan baru dan tambah pelanggan; r3-transaksi.md.
- R4: useOrderStatus default aktif, mode sederhana/detail/cetak/selesai;
  r4-status-order.md. Selesai tidak wajib lunas; toggle tidak mengubah order lama.
- R5/R6: laporan range aktual, kalender/grafik/top services/CSV, daftar nota/filter;
  pengeluaran tersimpan termasuk custom range. Riwayat Nota terpisah dihapus.
- R7: aksi pelanggan di atas; Keluar destruktif di luar kartu Akun.
- Nav: tombol menonjol 28 dp/cincin putih 4 dp; sisi atas milik halaman dan
  menerima tap/scroll; ripple/fade/lift tetap. Padding akhir scroll +28 dp,
  aksi pelanggan 48 dp, AppIconButton transparan; animasi-transaksi.md.
- Prompt 71: daftar/catat/detail/hapus pengeluaran, kategori baru, foto palsu;
  Laporan reaktif. Spec 23/24 dan progress/71-pengeluaran.md.
- Prompt 80: pengaturan/koneksi WhatsApp dummy, detail usulan/pelanggan baru,
  persetujuan/tolak/batal terkonfirmasi, riwayat/filter; spec 25..28.
  Status awal kedua mode dari initialOrderStatus. Order kg tanpa berat memiliki
  jalan langsung ke Edit. Retry tidak membuat pelanggan/order ganda.

## Sedang dikerjakan / langkah tepat berikutnya
1. Tinjau kelompok AI dan keyboard di Android (juga nav/pengeluaran).
   iOS, pembaca layar, printer/ekspor, foto dan WhatsApp nyata belum diuji.
2. Berikutnya docs/prompts/90-auth-sinkron.md, kemudian 100-penyelesaian.md.
   Jangan memulai prompt berikutnya tanpa sesi/tinjauan kelompok ini.

## Keputusan dan batas
- Terminal/Git/Flutter/test rutin langsung dijalankan; tanya hanya keputusan
  penting yang melewati aturan/desain. Batas persetujuan sistem tetap berlaku.
- Izin pengguna: sinkronkan DATA MASTER/fixture usulan ke Rudi/Rina/Agus baru.
  cust-010 lama menjadi Pelanggan 10/nomor pengisi, A-0137 tetap mengacu ID itu;
  jumlah awal 48 pelanggan/12 antrean terjaga. Impor Agus kini tersedia.
- Riwayat AI 142/8/3 historis berupa ringkasan, bukan ratusan pesan fiktif.
  Tiga usulan aktual dapat dibuka; perubahan status menambah agregat terkait.
- AI/QR/foto hanya dummy lokal: tidak menautkan atau mengirim pesan.
  Risiko jalur QR PRD B 12 di spec 28; jalur rilis publik belum dipilih.
- Pembatalan order/tabungan belum rollback lintas repository. Persetujuan baru
  mengompensasi kegagalan simpan order dengan soft-delete pelanggan baru.
- Catat bayar/Ingatkan piutang dan signOut masih placeholder.
- OrderEditBodySection slot lintas fitur tetap keputusan R0; OrderCard statusLabel
  opsional proposal 001 mengikuti R4. Custom omzet = nota non-batal, CSV BOM titik koma.
- Tidak mengubah registry/tema/token/lint/PRD/dependensi pada prompt 71/80.
- Repo E:/Latihan Pemrograman/laurum-projects/laurum, dev1rev. Jangan push/merge.
- SDK E:/App Data/flutter/flutter; graph laurum-app menunjuk checkout C:/Users/
  Naufal/Downloads/laurum-app, indeks E lama; pakai REPO_MAP untuk checkout aktif.

## Untuk agen penerus
Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status/log, lanjut bagian di atas.
