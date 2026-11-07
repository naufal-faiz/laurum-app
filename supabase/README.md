# Supabase lokal Laurum (B0)

Hanya pengembangan lokal. Jangan `link`, `db push`, atau memakai `--remote`.
CLI dikunci 3.0.0 di package-lock; Node24 (termasuk tes TypeScript) dan Docker Desktop Linux/WSL2 diperlukan.
Jalankan dari root repo pada PowerShell:

```powershell
npm ci --prefix supabase
& ./supabase/node_modules/.bin/supabase.cmd start --workdir .
& ./supabase/node_modules/.bin/supabase.cmd db reset --workdir .
& ./supabase/node_modules/.bin/supabase.cmd test db --workdir .
npm test --prefix supabase
& ./supabase/node_modules/.bin/supabase.cmd functions serve delete-account --workdir .
```

Biarkan functions serve aktif; dari PowerShell kedua pada root repo:

```powershell
./supabase/tests/runtime.ps1
& ./supabase/node_modules/.bin/supabase.cmd stop --workdir .
```

`db reset` menghapus data stack lokal ini dan menjalankan lima migrasi dari nol.
Jangan menambahkan `--no-backup` saat stop jika ingin mempertahankan data lokal.
Start pertama mengunduh beberapa GB image; sediakan setidaknya 15–20 GB ruang bebas
di drive penyimpanan Docker. Jika C: sempit, pindahkan Disk image location melalui
Docker Desktop → Settings → Resources → Advanced ke drive yang lebih lapang.
Jangan memindah/menghapus VHDX secara manual dan jangan factory reset Docker.

Studio: http://127.0.0.1:54323, API: http://127.0.0.1:54321.
Email konfirmasi/reset hanya ditangkap di http://127.0.0.1:54324.
CLI v3 memakai `[local_smtp]`/Mailpit, pengganti nama Inbucket pada prompt lama.
Email/password aktif, konfirmasi wajib, minimum8, rate limit di config.toml.
`site_url` dan redirect: `laurum://auth-callback`; aplikasi baru tersambung di B3.
Google sengaja disabled sampai kredensial tersedia. Isi lingkungan proses
`SUPABASE_AUTH_EXTERNAL_GOOGLE_CLIENT_ID` dan `SUPABASE_AUTH_EXTERNAL_GOOGLE_SECRET`,
lalu aktifkan `[auth.external.google].enabled` dan restart stack ketika B3 disiapkan.
Google OAuth dan SMTP produksi perlu konfigurasi pemilik proyek sebelum rilis.
Tidak perlu akun cloud, login CLI, URL cloud atau kunci cloud untuk B0.
Output start/status mengandung rahasia lokal: jangan salin ke repo, log atau chat.
Analytics Logflare/Vector lokal dimatikan karena B0 tidak memerlukannya dan jalur
host Docker IPv6:2375 pada mesin uji tidak terjangkau. Health check layanan utama
tetap aktif. Tidak perlu mengekspos Docker daemon tanpa TLS.
Mesin uji sempat kehabisan C: dan memiliki snapshot binary Edge yang terpotong;
cache lokal dipulihkan dari binary lengkap di arsip image resmi versi yang sama.
Rincian/bukti ada di docs/progress/b0.md; instalasi sehat tidak memerlukan langkah itu.

## Kontrak database

13 tabel milik owner: businesses, customers, services, orders, order_items,
payments, savings_entries, order_events, expense_categories, expenses,
receipt_settings, devices, entitlements. `app_config` bersifat global/read-only.
`order_events` mengikuti domain B1d; selisih ringkasan PRD tercatat di progress.
Tidak ada outbox/sync_cursors/local_settings di server.
Semua FK domain menyertakan owner_id sehingga tidak bisa mereferensi akun lain.
Semua tabel owner mempunyai indeks pull `(owner_id,updated_at,id)`.
Tanggal timestamptz; uang bigint rupiah; qty_milli integer (gram untuk kg).

RLS: baca milik sendiri; insert/update milik sendiri untuk tabel biasa; tidak ada
hard delete oleh klien. Soft delete tetap ikut pull. Ledger pembayaran/tabungan dan
event hanya insert; retry identik diperbolehkan lewat RPC. `order_items` boleh
di-insert/update/soft-delete selama order milik sendiri belum final; `id`, `owner_id`
dan `order_id` tidak dapat berubah dan role authenticated tidak punya DELETE.
Entitlements hanya bisa dibaca, tidak termasuk whitelist push (mencegah self-upgrade).
Payments memiliki deleted_at null untuk kompatibilitas wire; savings tanpa kolom itu.
Trigger menolak mutasi ledger juga oleh service_role biasa. Hanya fungsi cleanup
dengan role NOLOGIN terbatas (tanpa BYPASSRLS) yang boleh menghapus data sendiri.
Owner/id immutable, created_at dipertahankan, updated_at selalu diisi server.
Status final tidak boleh berubah; COD bersisa tidak bisa selesai.
Bucket expense-photos privat, JPEG maksimal200KB, prefix UUID pemilik.
Kebijakan Storage mencakup SELECT/INSERT/UPDATE/DELETE dengan pengecekan tujuan rename.

## Kontrak sinkronisasi (B2a, wire schema 5)

`app_config.min_schema_version = 5`. Permintaan di bawah versi itu ditolak dengan
`schema_too_old`; `schema_version` ikut di envelope perubahan, bukan parameter RPC.

### Push grup atomik

```
POST /rest/v1/rpc/sync_push
{
  "p_changes": [
    {"table":"orders","row_id":"<uuid>","op":"upsert","schema_version":5,
     "payload":{"id":"<uuid>","order_no":"A-0001", "...":"..."}}
  ],
  "p_group_id": "<uuid v4 grup>",
  "p_group_hash": "<sha256 hex isi grup>",
  "p_fragment_index": 1,
  "p_fragment_count": 1,
  "p_fragment_hash": "<sha256 hex fragmen>"
}
```

- `p_changes` maksimal 50 perubahan. Grup lebih besar dikirim sebagai fragmen
  `1..p_fragment_count`; fragmen ditampung di `private.sync_fragments` dan tidak
  terlihat di tabel bisnis/pull. Setelah fragmen terakhir lengkap dan hashes cocok,
  seluruh grup diterapkan dalam satu transaksi.
- `p_group_hash` = SHA-256 hex dari JSON kanonik seluruh isi grup: kunci objek
  diurutkan, urutan array dipertahankan, angka bilangan bulat, UTF-8 tanpa spasi
  tambahan. `p_fragment_hash` memakai aturan sama atas `p_changes` fragmen itu.
- Setiap perubahan wajib punya `change_id` UUID (untuk dipetakan ke outbox), `row_id`
  UUID yang sama dengan `payload.id`, `op` (`upsert`/`delete`), dan `schema_version`.
- Owner selalu dari JWT terverifikasi; `owner_id` di payload diabaikan, `updated_at`
  diisi server. `op=delete` membuat tombstone dan tidak berlaku bagi ledger.
- Hasil respons:

```json
{
  "group_id": "<uuid grup>",
  "status": "committed",
  "results": [
    {"change_id":"<uuid>","table":"orders","row_id":"<uuid>","status":"ok","updated_at":"2026-11-06T06:29:12.123456Z"}
  ]
}
```

`status` grup: `committed`, `rejected`, atau `staged` (fragmen belum lengkap; berisi
`received`, `expected`, dan `results` kosong). `results[].status`: `ok` atau `ditolak`.
Saat rejected ada `code` grup dan tiap hasil membawa `code` generik yang sama
(`final_locked`, `cod_outstanding`, `broken_reference`, `unique_conflict`, dll);
pesan SQL dan PII tidak dikirim. Permintaan tidak valid (hash salah, fragmen palsu,
tabel di luar whitelist, versi skema terlalu lama) ditolak sebagai error RPC dan
tidak membuat receipt parsial.
- **Atomisitas.** Satu anggota gagal → seluruh grup rollback; tidak ada hasil parsial.
  Grup lain tetap terisolasi.
- **Retry.** Grup identik yang dikirim ulang mengembalikan receipt yang sama
  (`committed`/`rejected`) tanpa menerapkan ulang snapshot lama. `group_id` sama dengan
  hash/count berbeda → error `group_mismatch`.
- **Receipt.** Tanda terima disimpan per owner di `private.sync_groups` sampai akun
  dihapus. Outbox klien hanya boleh menghapus ID yang tercantum `ok` pada receipt
  committed; receipt rejected dipakai untuk menandai konflik.
- Semua penulisan mengambil advisory lock per owner (`laurum_sync:<owner_id>`);
  `private.owner_clock` menjaga `updated_at` monoton, termasuk untuk data lama.

### Pull aman

```
POST /rest/v1/rpc/sync_pull
{"p_table":"orders","p_cursor_updated_at":"2026-11-06T06:00:00.000000Z",
 "p_cursor_id":"<uuid>","p_limit":500}
```

Mengembalikan `{"table":"orders","rows":[...],"next_cursor":{"updated_at":"...","id":"..."},"has_more":true}`.
Urutan `(updated_at, id)` dengan perbandingan tuple; `p_limit` 1..500. Timestamp UTC
enam digit; tombstone (`deleted_at`) ikut. Kursor disimpan klien di `sync_cursors` dan
diulang sampai `has_more=false`. Pull juga mengambil lock owner yang sama sehingga tidak
kehilangan commit yang selesai setelah halaman sebelumnya.

### Pemulihan antrean v4

Antrean lama belum punya `group_id`. Jangan menebak grup dari `created_at`, jangan
menghapus antrean lama, dan jangan mengganti UUID ledger agar retry tampak berhasil.
Klien v5 menandai baris lama `requires_recovery=1` dan menolak mengirimnya; baris itu
baru masuk grup setelah pemulihan eksplisit `recoverLegacyGroup(groupId, changeIds)`.
Sebelum B2c mengirim: kelompokkan outbox berdasarkan operasi bisnis yang diketahui,
beri `group_id` baru secara eksplisit, lalu kirim sebagai satu grup. Baris yang sudah
terkirim tanpa receipt dibiarkan sampai bisa direkonsiliasi lewat pull; ID baris tetap.

`delete_my_account()` hanya menghapus baris domain milik sesi; tidak menghapus Auth
atau byte Storage. Edge `delete-account` harus dipanggil untuk alur lengkap:
POST dengan Bearer user JWT → verifikasi `/auth/v1/user` → RPC memakai JWT pengguna
→ list/paginasi/hapus Storage prefix owner → admin hapus Auth owner yang diverifikasi.
ID dari body tidak dipercaya. verify_jwt gateway false karena pemeriksaan Auth langsung
di handler mendukung kunci asimetris dan memeriksa pengguna masih ada.
SUPABASE_URL/ANON_KEY/SERVICE_ROLE_KEY disuntikkan runtime, jangan ditulis di berkas.
Kegagalan memberi kode umum dan mempertahankan Auth agar bisa mencoba ulang;
operasi database/Storage/Auth bukan transaksi terdistribusi. UI dua konfirmasi dan
penutupan sesi/sinkronisasi lintas perangkat disambungkan di B3.

## Tindak lanjut B2

- Kontrak server B2a selesai (wire schema 5). B2b harus memakai `group_id`/hash dan
  receipt di atas; kirim dependency berurutan (master → order → ledger → penyelesaian
  COD) di dalam grup yang sama, bukan menunggu percobaan terpisah.
- Antrean v4 lama mengikuti protokol pemulihan di atas; jangan menebak grup dari waktu.
- Klien B2c sudah menyambungkan `sync_push`/`sync_pull` di `SupabaseSyncTransport`,
  menyimpan kursor di `sync_cursors`, dan memetakan 13 tabel lewat
  `DriftSyncRemoteApplier`. Baris yang masih punya entri outbox tidak ditimpa pull.
  Retry, indikator, koneksi, dan periode tetap B2d; upload foto tetap B2e.
- Tes integrasi dua akun `test/sync/supabase_sync_local_test.dart` hanya berjalan bila
  `LAURUM_LOCAL_SUPABASE_URL=http://127.0.0.1:54321` dan kedua kunci lokal ada di env
  proses. Tes ini belum dijalankan saat B2c ditutup karena Docker tidak aktif.
- pgTAP memeriksa dua owner untuk semua tabel, Storage, retry, konflik, versi, FK,
  final status, item mutable/lock, grup atomik, fragmen, receipt, pull tuple,
  service-role ledger guard, dan cleanup akun.
  Tes handler Node memakai HTTP stub. runtime.ps1 menguji Auth/Storage/Edge nyata dan
  kontrak push/pull lewat REST dengan dua akun sintetis yang dibersihkan setelah tes;
  kunci lokal hanya di env proses. Jangan menjalankan pengujian ini pada proyek cloud.

Sumber: [CLI lokal](https://supabase.com/docs/guides/local-development/cli/getting-started),
[konfigurasi](https://supabase.com/docs/guides/local-development/cli/config),
[pgTAP](https://supabase.com/docs/guides/database/testing),
[Edge Auth](https://supabase.com/docs/guides/functions/auth).
