# STATE Laurum
Diperbarui: 2026-11-21 | Cabang ai-whatsapp. Mode Integrasi AI WhatsApp.

## Sesi aktif
B7e backend penautan WhatsApp: Edge Function `wa-connect` (QR + kode pasangan sekaligus)
dan `wa-status` (status nyata ke wa_connections). UI belum disentuh; itu B7f.
Basis 0ff9950; worker infra 26c497d.

## Status irisan
- wa-connect: JWT pemilik -> /auth/v1/user; instance_id dari baris pemilik atau
  `laurum-<8 hex owner>`; instance baru dibuat dengan qrcode:false. Tanpa nomor -> QR.
  Dengan nomor (0 depan -> 62) -> sesi QR lama ditutup, sesi baru diminta, jawaban
  memuat QR **dan** pairingCode. Jawaban lain: already_connected, invalid_number,
  not_ready, unavailable.
- wa-status: open/connecting/close -> terhubung/menunggu/terputus; RPC
  set_wa_connection_status hanya saat status berubah, jadi connected_at tidak bergeser
  (filter "pesan sebelum penautan" di worker tetap benar).
- owner_id tidak pernah dari body; galat upstream tidak diteruskan (kode saja).
- config.toml mendaftarkan dua fungsi (verify_jwt=false, handler verifikasi sendiri).
- docs/progress/b7e.md memuat langkah deploy cloud dan cara membatalkan.

## Keputusan pengguna terbaru
- Kode pasangan di aplikasi DAN QR berjalan bersamaan seperti WhatsApp Web.
- Urutan: B7e backend dulu (selesai), UI penautan di B7f.

## Belum di-commit
Tidak ada.

## Langkah berikutnya
1. GATE B7e: pemilik menjalankan docs/progress/b7e.md (secret hanya nama, nilai di UI).
2. B7f: layar Hubungkan WhatsApp memakai wa-connect/wa-status (SegmentedControl QR |
   Nomor telepon, AppTextField, tes keyboard 300 dp), ganti FakeWhatsappConnection.
3. Smoke infra enam kasus menunggu SUPABASE_SERVICE_ROLE_KEY di terminal pemilik.
4. Tinjau usulan uji 081300000102 yang masih Menunggu.

## Blocker
Tidak ada blocker kode. Uji cloud (fungsi + tunnel) belum dijalankan; itu tindakan pemilik.
Sebelum reset PC (21 Nov 2026): branch ai-whatsapp, backend-newdesign, ui/*, dan dua backup
stash sudah didorong ke origin; repo laurum-infra belum punya remote sehingga disimpan
sebagai bundle + dump n8n/evolution di E:/Latihan Pemrograman/laurum-projects/_backup-20261121.

## Bukti terakhir
- npm test --prefix supabase: 17/17 lulus (delete-account 6, wa-connect 6, wa-status 5).
- Bukti langsung ke Evolution v2.3.7 lokal (Supabase stub): QR 13.334 byte; pairing
  keluar bersama QR 13.282 byte; status menunggu tersimpan; connected_at tidak bergeser;
  instance uji dihapus. Tidak ada Dart/Flutter yang berubah pada tugas ini.
