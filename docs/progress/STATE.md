# STATE Laurum
Diperbarui: 2026-11-06 | Cabang dev2backend

## Posisi
UI100/R0-R10, BP0, B1a-f, B0 dan **B2a SELESAI**; B2b belum ditulis. B2 disetujui
pengguna 6 Nov 2026. Bukti B2a: docs/progress/b2a.md.
Bukti B1f: docs/progress/b1f.md dan b1f-benchmark.json; tanpa push/merge.
B0 SELESAI: docs/prompts/B0-supabase.md; rencana docs/plans/B0-supabase-lokal.md.
Berkas/bukti/selisih rinci: docs/progress/b0.md, b2a.md dan supabase/README.md.

## Hasil B2a (6 Nov 2026)
- Migrasi baru `20261106062912_b2a_sync_groups.sql`; empat migrasi B0 utuh.
  Wire schema5 (`app_config.min_schema_version=5`).
- Item nota mutable/soft-delete selama order belum final, immutable setelah final;
  id/owner/order_id tetap; tanpa DELETE klien.
- `sync_push` grup atomik: fragmen >50, hash kanonik SHA-256, receipt idempoten per
  owner, retry tidak memundurkan edit baru, rollback utuh bila satu anggota gagal.
- `sync_pull` tuple `(updated_at,id)` UTC6, maks500, tombstone, lock per owner;
  `private.owner_clock` menjaga updated_at monoton.
- `delete_my_account` membersihkan grup/fragmen/receipt; isolasi dua owner diuji.
- PRD B §6–8 direvisi terbatas; README memuat kontrak dan pemulihan antrean v4.
- db reset exit0; pgTAP219/219 PASS; runtime1 PASS; check_all HIJAU 882 tes,
  archOK, REPO_MAP895, exit0. Tidak ada paket Flutter/UI/cloud yang diubah.
- LANGKAH BERIKUTNYA: tinjauan pengguna, lalu tulis prompt B2b dari kontrak teruji
  (Drift v5, metadata grup outbox, receipt/konflik, SyncEngine transport palsu).
  Jangan mulai B2c/B3 sebelum B2b selesai.


## Hasil B0
- CLI npm Supabase3.0.0 terkunci di supabase/package-lock.json; Docker29.9.2/WSL2.
- Config/Auth/Mailpit, empat migrasi schema/RLS/triggers/RPC, Edge delete-account,
  pgTAP semua tabel/Storage, enam tes handler Node dan tes runtime nyata lulus.
- Tidak mengubah lib/pubspec/PRD, tidak mengakses/mengubah cloud, tanpa kunci repo.
- Docker dipindahkan pengguna ke E: setelah C: tinggal4,7MB dan extract gagal.
- db reset exit0; pgTAP140/140 PASS. 47 policy public +4 Storage terpasang.
  Cleanup role tanpa akses schema Auth, UID dari verified claims; RLS tetap auth.uid.
- Node handler6 PASS; runtime1 PASS: Auth min8/konfirmasi, Storage privat,
  purge A tanpa menyentuh B. Cleanup akhir auth_users/storage_objects/customers=0.
- check_all HIJAU:882 tes, dua analyzer tanpa isu, archOK, map895, exit0.
  BOT=true/FLUTTER_SUPPRESS_ANALYTICS=true hanya proses mencegah crash telemetry.
  Check terbaru persiapan B2: Temp/laurum-b2-preparation-check.log (882 tes, exit0).
- Snapshot Edge rusak: binary40MB, arsip resmi166.846.080byte. Dipulihkan dari
  arsip resmi ke image cache laurum-edge-runtime-recovered:v1.77.9, tag CLI lokal
  menunjuk recovered; digest berubah karena layer pemulihan, versi tetap1.77.9.
  Tidak publish image/ubah volume. Binary/runtime/HTTP lulus setelah pemulihan.
- Analytics opsional off (Vector host IPv6:2375 gagal); startup normal tanpa exclude
  exit0. Stack lokal aktif, tanpa ignore-health-check. Bukti Temp/laurum-b0-runtime.log.
- Cache SDK sementara kini E:\laurum-b0-native-dart-sdk (tanpa spasi), junction
  Temp/laurum-native-dart-sdk menunjuk ke sana. SDK asli tetap. Path berspasi
  mematahkan native hook; jangan pindah cache ini ke folder repo berspasi.
- B2a: migrasi/tes server selesai; PRD B5/7/8 dan README sudah sesuai kontrak grup.
  B2b belum ditulis; antrean v4 mengikuti protokol pemulihan eksplisit di README.

## Hasil B1f dan batas yang tetap berlaku
- Main default Drift; memory/dummy untuk tes. Satu MaterialApp.router, root49baris.
  AccountStorage serial per akun, keluar menutup tanpa menghapus; draf dibersihkan.
- Monitor SQL owner dibatalkan sebelum close; stream salinan, paused tidak menahan.
- Antrean hanya order aktif dengan items/payments SQL, tanpa N+1/seluruh riwayat.
- Seed DATA MASTER atomik/outbox/marker UUIDv5 per akun; release normal kosong.
- Pending = COUNT outbox; syncNow hanya refresh, tidak mengaku terkirim.
- Account delete auth+SQL atomik, finishDelete menghapus DB/sidecar/foto setelah commit.
- Android SM-N975F profile5.000nota: cold728/614/622ms; p95 25,960/20,360/36,511ms.
  APK utama terpasang, restart mempertahankan checksum DB; iOS belum diuji.
- B1e ledger disetujui: omzet177.000/589.000/864.000; biaya145.000/850.000/1.850.000;
  laba32.000/-261.000/-986.000, kas130.500/500.000/868.500; piutang400.500/tabungan430.000.
- Drift v4/16tabel, snapshotv1-v4 beku. created_key lokal; UTC6digit untuk tanggal.
- Sebelum SEMUA Dart/Flutter: . ./tool/windows_native_sdk.ps1.
- Cloud/key belum diperlukan B0; Google OAuth+SMTP produksi perlu konfigurasi B3.
  Auth/sesi/AI/usulan/WhatsApp masih dummy sampai B3/B7. Printer/picker/ekspor belum.
- Foto lama dipertahankan untuk outbox sampai lifecycle/delete; upload B2.
- Payload snake_case/UTC ISO tanpa sync_state/pay_status/key lokal. Wire schema5 dan
  metadata grup (group_id/hash/fragmen/change_id) tersedia di server; adapter klien baru
  di B2b. Urutan master/order/ledger/selesaiCOD tetap wajib.
- order_events domain B1d disertakan server, ringkasan PRD B5 belum mencantumkan.
- PayStatus turunan, COD bersisa ditahan, transaksi multi-repo lewat TransactionRunner.
- Preferensi bisnis/struk sinkron, perangkat local_settings; tanpa shared_preferences.
- Registry60/60, Section debt14. Registry/tema/lint/fixture tidak diubah B0.
