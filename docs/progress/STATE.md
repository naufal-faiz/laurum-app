# STATE Laurum
Diperbarui: 2026-11-05 | Cabang dev2backend

## Posisi
UI 100/R0-R10, BP0 dan B1a-f SELESAI. B1e b2a2d91; B1f wiring Drift selesai.
check_all akhir: 882 tes, dua analyzer tanpa isu, check_arch OK, REPO_MAP895, exit0.
Bukti: docs/progress/b1f.md, b1f-benchmark.json; Temp/laurum-b1f-final-check.log.
Rencana: docs/plans/B1f-penyambungan.md. Tidak push/merge.

## Hasil B1f
- Main default Drift; LAURUM_STORE=memory/entry dummy tetap untuk tes/demo.
  Satu MaterialApp.router, gate loading/error/retry; root49 baris, widget baru0.
- AccountStorage serial per akun; keluar menutup tanpa menghapus. Repository bisnis,
  tabungan, pengeluaran, struk, laporan dan local_settings semuanya Drift.
- AccountIdentity memutus siklus AuthSession -> localData -> DB -> AuthSession.
  Draf dibersihkan saat ganti identitas; generator nota watch local_settings.
- Monitor SQL milik akun dibatalkan sebelum close; UI memakai stream salinan.
  Listener paused tidak menahan close. Jangan mengekspos tableUpdates mentah ke UI.
- Antrean getActiveOrders/Items/Payments: SQL owner/status/soft-delete, tanpa N+1
  atau membaca seluruh riwayat. Kontrak dua backend dan alur widget lulus.
- Seed DATA MASTER atomik+outbox+marker; ID/FK UUID v5 idempoten per akun.
  Debug/profile atau DEMO_SEED=true hanya akun demo kosong; release normal kosong.
  Identitas stub release terpisah dari demo; onboarding membaca profil tersimpan.
- Pending = COUNT outbox; syncNow hanya refresh, tidak menghapus/mengaku terkirim.
- Hapus akun: auth+SQL atomik; finishDelete setelah commit menghapus DB/sidecar/foto.
  Finalisasi menolak data yang dipulihkan rollback; file akun lain tetap.
- Statistik pelanggan Drift murni ledger; offset historis hanya override memory.
- Samsung SM-N975F Android12, profile, 5.000 nota (12 aktif/4.988 arsip):
  cold process Activity->frame728/614/622ms; p95 30 baca25,960/20,360/36,511ms.
  Cache OS tidak dikosongkan; seed awal/run layar terkunci dikecualikan.
- APK utama debug terpasang; force-stop/reopen mempertahankan checksum DB.
  Pengaturan layar kembali0; berkas tangkapan yang tidak relevan dihapus.
- Tes native widget harus pump frame di antara I/O agar future Riverpod diperbarui.
- LANGKAH BERIKUTNYA: docs/prompts/B0-supabase.md; perlu Docker Desktop/Supabase CLI.
  Berhenti menunggu tinjauan B1f. B2/B3 belum ditulis; susun dari temuan b1f.md.

## Keputusan dan batas
- B1e ledger disetujui: omzet hari177.000/6, minggu589.000/14, bulan864.000/16;
  biaya145.000/850.000/1.850.000; laba32.000/-261.000/-986.000.
  Kas130.500/500.000/868.500; piutang400.500 dan tabungan430.000 tetap.
  Audit b1e-reconciliation historis; .pen kalah dari spec18/DATA MASTER.
- Skema v4/16 tabel, snapshot v1-v4 beku. created_key=sqlTimestamp(created_at);
  entered_at/paid_at/spent_at UTC enam digit. Perubahan skema wajib migrasi+tes.
- Foto lama dipertahankan untuk outbox sampai lifecycle/account deletion; upload B2.
- Sebelum SEMUA Dart/Flutter pada PowerShell baru: . ./tool/windows_native_sdk.ps1.
  SDK berspasi; alias Flutter+salinan Dart di Temp, hanya lingkungan proses (~588MB).
  Gradle menyiapkan SDK Platform35/CMake3.22.1; paket Flutter tidak berubah.
- Cloud/key belum perlu. Jangan mengubah proyek cloud. B2/B3/B5-B8 MENUNGGU.
- Auth/sandi/sesi palsu di memori sampai B3; akun baru tidak pulih sesudah proses
  berakhir, data bisnis tetap di DB. AI/usulan/WhatsApp memory sampai B7;
  printer/picker/ekspor native belum disambung. iOS belum diuji.
- Preferensi perangkat local_settings; bisnis/struk sinkron; tanpa shared_preferences.
- Namespace retry BP0 tetap; payload snake_case/UTC ISO tanpa sync_state/pay_status/key lokal.
- B1c profil/struk satu baris per owner dijaga repo, belum UNIQUE(owner_id) SQL.
- PRD B5 belum memuat order_events; tabel tersedia sesuai domain/B1d.
- PayStatus turunan; COD bersisa ditahan; tabungan sebagian+bayar nol wajib COD;
  kelebihan tunai bukan omzet; mode sederhana selesai saat COD lunas.
- Registry60/60, Section debt14; utang runtime101-110/tool: fase-ui/bp0-id.
  Registry/tema/lint/dependensi/skema/golden/fixture transaksi tidak diubah B1f.
