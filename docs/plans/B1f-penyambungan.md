# B1f — penyambungan Drift

Tanggal: 5 November 2026. Dasar: docs/prompts/B1f-drift-penyambungan.md.

1. Baseline check_all; verifikasi B1e selesai dan tree bersih.
2. Tes seed deterministik UUID v5, relasi dan kesetaraan laporan; seed atomik,
   hanya sekali pada database kosong, tidak mengubah transaksi DATA MASTER.
3. Penyedia sesi penyimpanan per akun, repository Drift dan local_settings;
   keluar menutup, hapus akun membersihkan setelah commit termasuk foto.
4. Pending sinkron mengikuti outbox; pengiriman tetap menunggu B2.
5. Default main Drift; memory melalui dart-define dan override tes lama.
   Gate loading/error aman; release tanpa demo masuk onboarding.
6. Tes alur UI Drift, reopen, pergantian akun, rollback dan pending outbox.
7. Benchmark perangkat bila tersedia; dokumentasikan batas bukti dan uji HP.
8. check_all, self-review, STATE/INDEX/README/spec, commit; berhenti sebelum B0/B2.

Tidak ada dependensi/widget bersama/skema baru, perubahan cloud atau push/merge.
AI/usulan/WhatsApp masih in-memory sampai B7, auth masih fake sampai B3.
