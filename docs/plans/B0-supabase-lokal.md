# B0 - Supabase lokal

Dasar: docs/prompts/B0-supabase.md, PRD B bagian 4-9, wire payload B1.
1. Periksa Docker/WSL, pasang CLI npm dengan versi terkunci; tanpa akses cloud.
2. Init config lokal; Auth email terkonfirmasi/min8, Google lewat env opsional,
   callback Laurum, SMTP lokal dan pembatasan laju.
3. Migrasi skema, ownership/FK/index, RLS dan bucket expense-photos privat.
4. Trigger server time, owner immutable, final order dan append-only ledger.
5. RPC push maksimal50, idempoten/perubahan terisolasi, owner dari sesi,
   hasil konflik/ditolak tanpa membocorkan data; versi skema minimum.
6. Penghapusan akun melalui RPC dan Edge Function, tanpa kunci di repo.
7. pgTAP dua pemilik untuk setiap tabel/Storage, trigger, retry, konflik dan delete.
8. Reset dan test DB lokal; README Windows, bukti, STATE/INDEX, commit.

CLI v3 mengganti [inbucket] dengan [local_smtp]; ikuti CLI/docs terpasang.
Tidak mengubah lib/, pubspec, PRD, proyek cloud atau menjalankan db push/link.
Jika Docker membutuhkan BIOS/fitur Windows/reboot, laporkan dan lanjutkan
pekerjaan berkas yang independen; jangan mengklaim tes SQL sudah lolos.
