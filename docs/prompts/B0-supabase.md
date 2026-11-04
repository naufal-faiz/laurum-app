# B0 - Supabase lokal: skema, RLS, RPC, Auth, tes RLS
Ikuti _COMMON.md bagian A, D, E, F (tanpa Flutter bila tidak ada perubahan lib/). Prasyarat: BP0 SELESAI; pengguna sudah memasang Docker Desktop dan Supabase CLI. Baca: PRD B bagian 4, 5, 6, 7, 8, 9, AGENTS aturan 19-22.

## IZIN TERTULIS (4 Nov 2026)
- Membuat folder supabase/ (config.toml, migrations/, functions/, tests/, README.md). Tanpa perubahan lib/, pubspec, atau PRD kecuali selisih nyata.
- DILARANG: `supabase link`, `supabase db push`, atau perintah ke proyek cloud; menyimpan kunci/token/.env; kunci service_role di berkas mana pun selain secrets lokal yang diabaikan git (.gitignore).

## Isi
1. `supabase init`; config.toml: Auth email+password aktif dengan konfirmasi email, password minimal 8, Google provider dari variabel lingkungan, site_url dan redirect (`laurum://auth-callback`), pembatasan laju; email lokal lewat Inbucket.
2. migrations/0001_schema: tabel PRD bagian 5 (businesses termasuk use_order_status, customers, services, orders termasuk pay_term, order_items, payments, savings_entries, expense_categories, expenses, receipt_settings, devices, entitlements, app_config), kolom umum (id uuid, owner_id default auth.uid(), created_at, updated_at, deleted_at), unik `(owner_id, phone)` aktif dan `(owner_id, order_no)`, indeks PRD bagian 8, bucket Storage `expense-photos`.
3. 0002_rls: RLS di semua tabel (`owner_id = (select auth.uid())`); tabel append-only (payments, savings_entries, order_items) tanpa kebijakan update/delete; Storage berdasar awalan `owner_id/`.
4. 0003_triggers: updated_at diisi server; owner_id tidak bisa diubah; orders: status final (selesai/dibatalkan) tidak bisa dimundurkan; payments/savings tidak bisa diubah/dihapus walau lewat service role biasa (kecuali fungsi hapus akun).
5. 0004_rpc: `sync_push(changes jsonb)` (tabel dalam daftar putih, owner_id SELALU dari auth.uid() bukan payload, upsert idempoten, tiap perubahan dalam sub-transaksi sehingga satu pelanggaran unik tidak menggagalkan batch dan hasilnya dikembalikan per perubahan: ok/konflik/ditolak beserta updated_at server); `app_config` (min_schema_version); `delete_my_account()` menghapus semua baris pemilik.
6. functions/delete-account (Edge Function): verifikasi JWT, panggil delete_my_account, hapus objek Storage, lalu hapus pengguna Auth dengan service role dari secrets Supabase (tidak pernah di aplikasi).
7. tests/*.sql (pgTAP, `supabase test db`): pengguna A tidak bisa select/insert/update/delete data B di SEMUA tabel dan bucket; append-only menolak update; sync_push idempoten (dua kali payload sama), konflik phone dilaporkan tanpa menggagalkan batch, owner_id payload diabaikan; status final tidak mundur; delete_my_account hanya menghapus milik sendiri.
8. README: perintah Windows (start/stop/reset/test), cara melihat email konfirmasi di Inbucket, cara menjalankan tes.

Laporkan: hasil `supabase db reset` dan `supabase test db`, daftar tabel/kebijakan, keputusan yang menunggu. Prompt berikutnya: B1a (bila belum), atau B2 setelah B1f.
