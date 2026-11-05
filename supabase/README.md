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

`db reset` menghapus data stack lokal ini dan menjalankan empat migrasi dari nol.
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
hard delete oleh klien. Soft delete tetap ikut pull. Ledger pembayaran/tabungan,
item dan event hanya insert; retry identik diperbolehkan lewat RPC.
Entitlements hanya bisa dibaca, tidak termasuk whitelist push (mencegah self-upgrade).
Payments memiliki deleted_at null untuk kompatibilitas wire; savings tanpa kolom itu.
Trigger menolak mutasi ledger juga oleh service_role biasa. Hanya fungsi cleanup
dengan role NOLOGIN terbatas (tanpa BYPASSRLS) yang boleh menghapus data sendiri.
Owner/id immutable, created_at dipertahankan, updated_at selalu diisi server.
Status final tidak boleh berubah; COD bersisa tidak bisa selesai.
Bucket expense-photos privat, JPEG maksimal200KB, prefix UUID pemilik.
Kebijakan Storage mencakup SELECT/INSERT/UPDATE/DELETE dengan pengecekan tujuan rename.

`sync_push(changes jsonb)` menerima array maksimal50 dan mengembalikan array hasil:

```json
[
  {
    "table": "customers",
    "row_id": "<UUID v4>",
    "op": "upsert",
    "schema_version": 4,
    "payload": {"id": "<UUID v4 yang sama>", "name": "...", "phone": "..."}
  }
]
```

Owner payload diabaikan, updated_at diabaikan; owner berasal dari JWT terverifikasi.
`op=delete` membuat tombstone (payload tidak diperlukan), tidak berlaku bagi ledger.
Hasil tiap perubahan: table, row_id, status `ok`/`konflik`/`ditolak`, updated_at server
(null saat gagal), code generik saat gagal. Versi kurang dari app_config memberi
`schema_too_old`; konflik unik memberi `unique_conflict`. Pesan SQL/PII tidak dikirim.
Sub-transaksi per perubahan mempertahankan hasil lain jika satu baris gagal.
Retry dengan nilai sama tidak mengubah timestamp atau menggandakan ledger.
Nomor telepon harus dikanonisasi oleh adapter B2 sesuai kontrak lokal.

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

- Item lokal B1d dapat diedit/soft-delete, server B0 append-only sesuai PRD.
  Putuskan protokol rekonsiliasi sebelum SyncEngine diaktifkan; jangan diam-diam
  mengirim UPDATE item atau menghapus outbox yang ditolak.
- Kirim dependency berurutan (master → order → ledger → penyelesaian COD).
  Penyelesaian COD yang tiba sebelum pembayaran harus diulang setelah ledger masuk.
- `schema_version` envelope harus ditambahkan adapter B2; tidak ada sync di UI B0.
- pgTAP memeriksa dua owner untuk semua tabel, Storage, retry, konflik, versi,
  FK, final status, service-role ledger guard, dan cleanup akun.
  Tes handler Node memakai HTTP stub. runtime.ps1 menguji Auth/Storage/Edge nyata
  dengan dua akun sintetis yang dibersihkan setelah tes; kunci lokal hanya di env
  proses. Jangan menjalankan pengujian ini pada proyek cloud.

Sumber: [CLI lokal](https://supabase.com/docs/guides/local-development/cli/getting-started),
[konfigurasi](https://supabase.com/docs/guides/local-development/cli/config),
[pgTAP](https://supabase.com/docs/guides/database/testing),
[Edge Auth](https://supabase.com/docs/guides/functions/auth).
