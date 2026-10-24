# STATE Laurum
Diperbarui: 2026-10-24 | Cabang dev1

## Posisi
Fase 1 selesai (60/60 widget, commit 2d8dd6f). Prompt 20-antrean.md SELESAI.
check_all: SEMUA HIJAU; 232 tes; kedua analyzer bersih; check_arch OK.
REPO_MAP 342 berkas. Berhenti menunggu tinjauan sebelum prompt 30-transaksi-a.md.

## Selesai
- Fase 1: atoms/molecules/organisms/templates, domain inti, data dummy, Widgetbook 60 widget.
- Prompt 20: GoRouter StatefulShellRoute lima tab; placeholder seluruh rute PRD A 8.
- Antrean - Beranda: chip 12/3/5/4/3, filter persisten, usulan Perlu dicek, OrderCard
  dengan aksi status, FAB Transaksi baru, banner WhatsApp palsu.
- Loading skeleton, error/retry, kosong, filter kosong; aksi menulis OrderEvent dan
  menghitung ulang chip; guard klik ganda dan status usang.
- 18 tes terarah (17 antrean/router + entry point), 7 golden, uji 320 px dan teks 2x.
- AntreanPage 100 baris; katalog layar/router/provider diperbarui; docs fase-2 ditutup.

## Sedang dikerjakan
- Tidak ada. Tunggu tinjauan pengguna sebelum prompt berikutnya.

## Antrean
1. Tinjau Antrean - Beranda di HP/emulator bila tersedia (FAB, chip gulir, banner).
2. Berikutnya: docs/prompts/30-transaksi-a.md (Pilih Layanan, Buat Transaksi,
   Input Berat, Tambah Pelanggan Cepat).
3. APK/NDK, iOS, TalkBack/VoiceOver, dan SafeArea perangkat masih ditunda.

## Keputusan dan batas
- FAB hanya di cabang Antrean; banner WhatsApp di atas daftar dengan tombol Hubungkan
  terpisah karena BannerMessage belum punya slot aksi.
- Semua usulan diberi Periksa karena Proposal minimal belum memuat certainty.
  Persetujuan/pembatalan order AI menunggu prompt 80.
- FakeWhatsappConnection terpisah dari SyncService; jam dummy 16 Okt 2026 12.00.
- Placeholder daftar turunan (mis. /lainnya/layanan, /laporan/piutang) memakai SubScaffold
  tanpa nav; aturan nav daftar diterapkan saat layar nyata dibangun.
- Antrean memakai indexedStack sehingga filter dan posisi gulir bertahan antar tab.
- main.dart dan main_dummy.dart memakai router serta dummyRepositoryOverrides yang sama.
- Formatters.nomorNota masih kunci A; transaksi Order/Savings atomik ditunda ke alur kasir.
- Atom/token/registry/lint/PRD tidak diubah. Tanpa dependensi baru.
- Selisih visual lama dipertahankan: Ionicons, mono w400, nav 61 px, DP amber, field 48.

## Pemeriksaan dan batas
- Android/iOS perangkat, TalkBack/VoiceOver, SafeArea nyata belum diuji; APK ditunda.
- Screenshot Pencil frame zb8jN, akEX1, zqBHI, MrWTS, P1axJ sudah dibaca.
- Tidak push/merge. Jangan mulai prompt 30 tanpa instruksi pengguna.
