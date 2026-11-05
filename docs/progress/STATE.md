# STATE Laurum
Diperbarui: 2026-11-05 | Cabang dev2backend

## Posisi
UI100/R0-R10, BP0 dan B1a-f SELESAI. HEAD dasar B1f0275f3b.
B1f: check_all882 tes, dua analyzer tanpa isu, archOK, REPO_MAP895, exit0.
Bukti B1f: docs/progress/b1f.md dan b1f-benchmark.json. Tidak push/merge.
B0 SEDANG: docs/prompts/B0-supabase.md; rencana docs/plans/B0-supabase-lokal.md.
Berkas/bukti/selisih rinci: docs/progress/b0.md dan supabase/README.md.

## Sedang dikerjakan — B0
- CLI npm Supabase3.0.0 terkunci di supabase/package-lock.json; Docker29.9.2/WSL2.
- Config/Auth/Mailpit, empat migrasi schema/RLS/triggers/RPC, Edge delete-account,
  pgTAP semua tabel/Storage, enam tes handler Node, tes runtime disiapkan.
- Tidak mengubah lib/pubspec/PRD, tidak mengakses/mengubah cloud, tanpa kunci repo.
- Start gagal saat pull/extract: C: tinggal4,7MB, containerd read-only.
  Pengguna sudah memindahkan Docker ke E: lewat UI dan menyalakannya kembali.
  Server29.9.2 merespons; pengunduhan image diulang. Jangan factory reset/prune/VHDX.
- db reset exit0; pgTAP140/140 PASS. 47 policy public +4 Storage terpasang.
  Cleanup role tanpa akses schema Auth, UID dari verified claims; RLS tetap auth.uid.
- Node handler6 pass/0 fail, parser PowerShell OK; runtime Auth/Storage/Edge belum.
- check_all HIJAU:882 tes, dua analyzer tanpa isu, archOK, map895, exit0.
  BOT=true/FLUTTER_SUPPRESS_ANALYTICS=true hanya proses mencegah crash telemetry.
  Bukti Temp/laurum-b0-check-all-retry.log, laurum-b0-reset.log, laurum-b0-pgtap.log.
- Edge Runtime v1.77.9 SIGSEGV139 juga saat binary kosong --help, bukan handler.
  Docker history COPY binary167MB, file dalam container40MB: cache ekstraksi rusak.
  Image rm/pull biasa masih memakai cache lama. Sedang rm image/restart Docker/pull.
  Analytics dinonaktifkan (Vector gagal host IPv6:2375); start --exclude edge-runtime
  berhasil, health database/Auth/Storage normal. Jangan ignore-health-check.
- Cache SDK sementara kini E:\laurum-b0-native-dart-sdk (tanpa spasi), junction
  Temp/laurum-native-dart-sdk menunjuk ke sana. SDK asli tetap. Path berspasi
  mematahkan native hook; jangan pindah cache ini ke folder repo berspasi.
- LANGKAH BERIKUTNYA: selesaikan perbaikan cache binary Edge tanpa hapus volume;
  functions serve dan
  ./supabase/tests/runtime.ps1 (kunci lokal hanya env proses). check_all wajib.
  Update STATE/INDEX/b0.md, commit final lalu berhenti. B2/B3 MENUNGGU/belum ditulis.

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
- Payload snake_case/UTC ISO tanpa sync_state/pay_status/key lokal. B2 tambah envelope
  schema_version4 dan urutan master/order/ledger/selesaiCOD; server append-only item
  berbeda dengan edit/soft-delete lokal B1d, protokol WAJIB diputuskan sebelum sync.
- order_events domain B1d disertakan server, ringkasan PRD B5 belum mencantumkan.
- PayStatus turunan, COD bersisa ditahan, transaksi multi-repo lewat TransactionRunner.
- Preferensi bisnis/struk sinkron, perangkat local_settings; tanpa shared_preferences.
- Registry60/60, Section debt14. Registry/tema/lint/fixture tidak diubah B0.
