# B2a — kontrak server sinkronisasi (selesai 6 Nov 2026)

Usulan induk `docs/plans/B2-kontrak-sinkronisasi.md` disetujui pengguna pada 6 Nov 2026.
Lingkup B2a hanya server: migrasi baru, RLS/penjaga, RPC, pgTAP, tes runtime, PRD dan
README. Tidak ada paket Flutter, SyncEngine, UI, Auth nyata, cloud, push, atau merge.

## Hasil

- Migrasi baru `supabase/migrations/20261106062912_b2a_sync_groups.sql`; empat migrasi
  B0 tidak diubah. `app_config.min_schema_version` naik ke **5** (wire schema).
- `order_items`: insert/update/soft-delete hanya untuk order milik sendiri yang belum
  final. `id`, `owner_id`, `order_id` immutable; role authenticated tidak punya DELETE.
  Trigger menolak perubahan setelah final dan menolak pemindahan item.
- Order final: status final tidak bisa dimundurkan, nilai bisnis terkunci (hanya
  `updated_at` boleh berubah), COD bersisa ditolak lewat constraint deferred dan
  pemeriksaan keadaan akhir `sync_push`.
- `sync_push` baru:
  `sync_push(p_changes,p_group_id,p_group_hash,p_fragment_index,p_fragment_count,p_fragment_hash)`.
  - Owner dari JWT; whitelist tabel; `change_id` UUID untuk pemetaan outbox.
  - Grup > 50 dipecah fragmen; fragmen diparkir di `private.sync_fragments` dan tidak
    terlihat di tabel bisnis/pull sampai lengkap.
  - Commit seluruh grup satu transaksi; satu anggota gagal = rollback semua.
  - Receipt identik dikembalikan pada retry; `group_id` sama dengan hash/count berbeda
    ditolak (`group_mismatch`).
  - Receipt disimpan di `private.sync_groups` per owner sampai akun dihapus.
  - Hash = SHA-256 JSON kanonik (kunci terurut, array berurutan, angka bulat).
  - Batas: 50 perubahan/request, maks 100 fragmen, maks 5000 perubahan/grup.
- `sync_pull(p_table,p_cursor_updated_at,p_cursor_id,p_limit)`: urutan tuple
  `(updated_at,id)`, UTC enam digit, tombstone ikut, limit dijepit 1..500,
  `has_more` dan `next_cursor` dikembalikan.
- Semua penulisan dan pull mengambil advisory lock per owner
  (`laurum_sync:<owner_id>`); `private.owner_clock` menjaga `updated_at` monoton dan
  di-seed dari timestamp data lama.
- `delete_my_account()` ikut menghapus `private.sync_groups` dan
  `private.sync_fragments`; kepemilikan fungsi cleanup tetap role NOLOGIN sempit.
- PRD B §6–8 diperbarui terbatas pada item mutable/final lock, atomisitas grup,
  metadata protokol, pull aman, dan daftar fungsi/RLS. `supabase/README.md` memuat
  bentuk request/response/receipt/cursor/error dan protokol pemulihan antrean v4
  (tanpa menebak grup dari `created_at`, tanpa membuang antrean, tanpa mengganti UUID).

## Bukti

Perintah dijalankan dari root repo pada PowerShell, 6 Nov 2026:

```powershell
& ./supabase/node_modules/.bin/supabase.cmd db reset --workdir .
# exit 0; kelima migrasi diterapkan

& ./supabase/node_modules/.bin/supabase.cmd test db --workdir .
# Files=2, Tests=219, Result: PASS
# backend_test.sql 153 tes (B0 disesuaikan dengan kontrak baru)
# b2a_test.sql     66 tes

& ./supabase/node_modules/.bin/supabase.cmd functions serve delete-account --workdir .
./supabase/tests/runtime.ps1
# tests 1, pass 1, fail 0 (Auth/Storage/Edge + sync_push retry + sync_pull nyata)

powershell -NoProfile -Command ". ./tool/windows_native_sdk.ps1; ...; dart run tool/check_all.dart"
# check_arch OK; 882 tes Flutter lulus; REPO_MAP 895; check_all: SEMUA HIJAU
```

Cakupan pgTAP B2a: isolasi dua owner, item milik B ditolak, pindah item ditolak,
edit/soft-delete sebelum final berhasil dan sesudah final ditolak, ledger tetap
immutable, rollback utuh nota+item dan pembayaran+tabungan, COD final bersama
pembayaran dalam satu grup, retry tidak memundurkan edit baru, grup >50 lintas
fragmen (termasuk urutan terbalik), fragmen/hash/ukuran palsu ditolak tanpa kebocoran,
pull >500 baris bertimestamp sama terambil sekali, tombstone dan commit terlambat
tidak hilang, skema terlalu lama, akses anonim, dan cleanup staging/receipt dua owner.

Catatan penggantian tes B0: `backend_test.sql` diubah karena tanda tangan
`sync_push(jsonb)` dan semantik append-only item sudah digantikan kontrak grup.
Tidak ada penurunan cakupan isolasi/ledger; tes lama dipetakan ke RPC baru.

## Batas dan langkah berikutnya

- Klien belum memakai kontrak ini: B2b (Drift v5, metadata grup outbox, penyimpanan
  receipt/konflik, SyncEngine dengan transport palsu) belum ditulis.
- Adapter transport Supabase, dua akun nyata, UI indikator, dan antrean foto tetap
  B2c–B2e.
- Antrean v4 lama harus direkonsiliasi eksplisit sebelum dikirim; lihat README.
