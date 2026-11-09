# B3c — hapus akun dan gerbang sinkron nyata

Ikuti _COMMON.md. Rencana: docs/plans/B3-auth.md. Prasyarat: B3b SELESAI.
Butuh migrasi `supabase/migrations` sudah diterapkan ke proyek cloud oleh pemilik.

## Hasil yang diminta
1. `SupabaseAuthService.deleteAccount` memanggil Edge Function `delete-account`
   (kontrak di supabase/README.md) dengan dua konfirmasi yang sudah ada; galat
   jaringan/batas permintaan aman, tanpa token di log.
2. Setelah hapus akun: bersihkan sesi keystore, database lokal akun, draf reset,
   dan cooldown; aplikasi kembali ke Masuk.
3. Gerbang B2d dibuka: `SyncCoordinator` (transport Supabase + outbox/cursor Drift)
   disuntikkan ke `DriftSyncService` lewat `AccountStore`; tanpa sesi Auth gerbang
   tetap tertutup dan tidak ada panggilan jaringan.
4. Registrasi perangkat (`devices`) saat login pertama di perangkat; tes dengan
   transport palsu.
5. `workmanager` untuk sinkron latar HANYA bila pengguna menyetujui dependensi;
   jika tidak, catat sebagai tunda dan tutup sesi.
6. check_all hijau; docs/progress/b3c.md, INDEX, STATE, commit, berhenti.

## Batas
- Tanpa push/merge, tanpa mengubah proyek cloud dari agen, tanpa upload foto
  (B2e). Jangan mengubah PRD, registry, tema, atau lint.
