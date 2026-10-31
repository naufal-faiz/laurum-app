# STATE Laurum
Diperbarui: 2026-10-31 | Cabang dev1rev

## Posisi
R0-R3 SELESAI otomatis. check_all hijau: 387 tes, REPO_MAP 517 berkas.
Fondasi R4 tervalidasi; R4 MASIH PARSIAL (belum ada toggle/integrasi cetak).
Perangkat sudah kembali memiliki SDK; izin menunda validasi tanpa SDK sudah berakhir.

## Selesai
- Fase 1-8 sampai prompt 70; rincian fase-0..8.md. R0: 38 Section, 50 state.
- R1: keyboard/insets, diskon, berat fresh/minimum, nominal, audit input;
  koma/nol desimal tetap di layar. Rincian r1-input-keyboard.md.
- R2: empat tab, aksi Transaksi tengah, tanpa FAB Beranda, Antrean aktif,
  navigasi Piutang. PRD disinkronkan dan Android manual dikonfirmasi 30 Okt.
- R3: FAB Layanan baru di dua rute pemilih; sembunyi saat keyboard; katalog
  reaktif; Baru langsung tambah/pilih pelanggan. Section pelanggan Stateless.
  Sembilan skenario baru lulus; dua golden ditinjau, registry/tema/dependensi tetap.
- Validasi ulang 31 Okt: format draf dirapikan, empat lint diperbaiki tanpa ignore,
  seluruh 387 tes lulus. Rincian docs/progress/r3-transaksi.md.
- Fondasi R4: useOrderStatus default true, salinan profil/preservasi mode di Info
  Usaha dan printer, status awal/label/transisi. Dua belas tes kontrak lulus.
  withOrderStatus memakai argumen bernama enabled; fixture memakai default true.

## Sedang dikerjakan / langkah tepat berikutnya
1. Lanjut guard repository order R4 secara konsisten pada saveOrder/updateOrderStatus
   dan writeOrderStore, default mode aktif tetap menolak diproses->selesai langsung.
2. Setelah itu toggle/settings, checkout/AI, Antrean/Detail dan alur selesai/cetak
   sesuai R4. Jangan aktifkan toggle sebelum semua perilaku tersambung.
3. Spec 01/09/19 dan kolom sinkron PRD B masih perlu disesuaikan saat integrasi.
   Catatan: docs/progress/r4-status-order.md. Jangan mulai R5 sebelum R4 selesai.
4. Setiap kelompok: check_all hijau, STATE, commit. Tidak push/merge tanpa izin.

## Keputusan dan batas
- R5 ringkasan hanya nota + pembayaran; pengeluaran ke 71. R4 selesai tidak wajib lunas.
- Utang Section 24, hanya menyusut; migrasikan saat disentuh.
- OrderEditBodySection slot details lintas fitur tetap keputusan R0.
- Prompt 70: tanpa Urutkan, switch langsung, receiptFooter, signOut placeholder90,
  top services Minggu ini, CSV BOM titik koma, piutang ledger, nonaktif tidak hapus data.
- Pembatalan order/tabungan belum rollback lintas repository.
- Sesudah R4: R5-R7 lalu 71,80,90,100. Catat bayar/Ingatkan piutang masih placeholder.
- Repo C:/Users/Naufal/Downloads/laurum-app. Branch dev1rev melacak origin/dev1rev.
- SDK: E:/App Data/flutter/flutter; cache/lock di luar workspace perlu akses eskalasi.
- Graph lokal kini laurum-app (root C:/Users/Naufal/Downloads/laurum-app);
  indeks lama E-Latihan-Pemrograman-laurum-projects-laurum menunjuk checkout lama.
- R3/R4: Android/iOS perangkat, TalkBack/VoiceOver dan printer nyata belum diuji.

## Untuk agen penerus
Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status/log. Lanjut bagian di atas.
Berhenti mendekati sisa usage 10%; simpan perubahan dengan bukti validasi dan commit.
