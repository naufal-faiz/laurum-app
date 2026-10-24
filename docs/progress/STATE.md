# STATE Laurum
Diperbarui: 2026-10-24 | Cabang dev1

## Posisi
Prompt 20, 30, 31, dan 32 selesai. Fase 1-4 tertutup untuk alur yang dibangun.
check_all: SEMUA HIJAU; 258 tes; kedua analyzer bersih; check_arch OK.
REPO_MAP 391 berkas. Berhenti menunggu tinjauan sebelum prompt 40-order.md.

## Selesai
- Fase 1: 60/60 widget, domain inti, data dummy, Widgetbook.
- Antrean - Beranda, Printer dan Struk, dan alur transaksi bagian 1.
- Prompt 32: Pembayaran (Lunas/DP/Belum bayar, tabungan, Tunai/QRIS/Transfer, uang
  diterima + kembalian) dan Nota Tersimpan (struk, cetak, WhatsApp, lihat order).
- Checkout membuat order A-0143, item, payment, event, dan SavingsEntry; draf dibersihkan;
  Antrean/Laporan/saldo tabungan berubah.
- Skenario A-0143 diuji end-to-end dan struk dari data tersimpan identik receipt_template.md.
- 5 tes baru (checkout, pembayaran, nota, 2 golden); 258 tes, 72 berkas golden.

## Sedang dikerjakan
- Tidak ada. Tunggu tinjauan pengguna sebelum prompt berikutnya.

## Antrean
1. Tinjau alur nota lengkap di HP/emulator: pelanggan baru, dua layanan, berat,
   tabungan + tunai, nota tersimpan, Antrean/Laporan/saldo berubah.
2. Berikutnya: docs/prompts/40-order.md (Detail Order, Edit Order, Riwayat Nota).
3. APK/NDK, iOS, TalkBack/VoiceOver, printer dan keyboard nyata masih ditunda.

## Keputusan dan batas
- Jam bisnis dummy 16 Okt 2026 10.45 agar A-0143 sama dengan DATA MASTER dan struk.
- Order baru: status diproses, sumber kasir, nomor dari OrderNumberGenerator (A-0143),
  estimasi estimateReady, diskon dari draf, total memakai lineTotal.
- saveOrder atomik untuk order/item/payment/event. SavingsEntry ditulis setelahnya karena
  antarmuka repository terpisah; saldo divalidasi lebih dulu, rollback belum tersedia.
- Pembayaran: tabungan memakai applySavings; Lunas membayar sisa, DP memakai uang diterima,
  Belum bayar tanpa pembayaran; QRIS/Transfer tepat sisa; kembalian hanya tunai.
- Nota: cetak manual via PrintService; gagal menampilkan banner + Coba lagi/Pengaturan
  printer; WhatsApp memakai ExternalLauncher palsu; Lihat order masih placeholder.
- Kedua tombol footer pembayaran menyimpan tanpa cetak otomatis (selisih dari .pen).
- Draf global dibersihkan setelah simpan; filter Antrean tetap seperti sebelumnya.
- Formatters.nomorNota masih kunci A; nomor memakai OrderNumberGenerator(A).
- Atom/token/registry/lint/PRD tidak diubah. Tanpa dependensi baru.
- Selisih visual lama: Ionicons, mono w400, nav 61 px, DP amber, field 48.

## Pemeriksaan dan batas
- Android/iOS perangkat, TalkBack/VoiceOver, keyboard/printer nyata belum diuji.
- Screenshot Pencil frame Pembayaran/Nota dan state terkait sudah dibaca.
- Tidak push/merge. Jangan mulai prompt 40 tanpa instruksi pengguna.
