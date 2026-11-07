# B2c — adapter Supabase dan pull seluruh tabel

SELESAI (7 Nov 2026). Bukti: docs/progress/b2c.md.
Prasyarat: B2a dan B2b SELESAI; kontrak di supabase/README.md.

## Hasil yang diminta
1. `SupabaseSyncTransport` mengimplementasikan `SyncTransport` dan `SyncPullTransport`
   di atas RPC `sync_push`/`sync_pull`; galat dipetakan ke kode aman.
2. Pull per tabel dengan kursor `(updated_at,id)` tersimpan di `sync_cursors`, diulang
   sampai `has_more=false`, urutan dependensi tetap.
3. Pull memetakan seluruh 13 tabel owner: upsert, tombstone, normalisasi timestamp,
   kunci turunan pelanggan/tabungan, `sync_state=synced`, tanpa menimpa baris yang
   masih punya entri outbox.
4. Ack/konflik memperbarui outbox dan `sync_state` secara konsisten.
5. `SyncCoordinator` menjalankan push sebelum pull; pull dilewati bila push terblokir.
6. Tes unit dan tes integrasi dua akun lokal yang digerbangi env; check_all hijau,
   STATE/INDEX dan commit.

## Batas
- Tanpa UI, Auth nyata, upload foto, cloud, push, atau merge. B2d/B2e/B3 terpisah.
- Tes integrasi lokal sudah dijalankan pada 7 Nov 2026 (pgTAP219 PASS, dua akun lulus).
  Foto belum diunggah; path perangkat tidak dikirim dan pull null tidak menghapus
  lampiran lokal sampai B2e.
