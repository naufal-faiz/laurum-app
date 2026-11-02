# R8 - Transaksi lintas repository (2 Nov 2026)

## Hasil
- TransactionRunner.run mengembalikan hasil body atau melempar ulang error asli setelah rollback.
- Snapshot immutable mencakup order/item/payment/event, pelanggan, tabungan,
  usulan, pengeluaran/kategori, layanan, profil/pengaturan, histori demo, sesi dummy, sync.
- Nested ikut transaksi terluar; error nested yang ditangkap body tetap membatalkan induk.
- Transaksi independen diantrikan; rollback memulihkan sync terakhir setelah notifikasi store.
- Checkout, pembatalan, persetujuan AI dan pembersihan akun memakai runner yang sama.
- Kompensasi soft-delete pelanggan AI dihapus; retry setelah gagal membuat data tepat sekali.
- PRD B ditambah satu paragraf pemetaan ke transaksi SQLite + outbox sesuai izin R8.

## Verifikasi
Baseline: check_all SEMUA HIJAU, 535 tes, REPO_MAP 629 berkas.
Tes runner dibuat sebelum implementasi dan gagal karena runner belum tersedia.
Sembilan tes baru memeriksa commit/hasil, rollback/error asli, nested,
antrean transaksi, kegagalan setelah tulis tabungan/nota AI dan cleanup akun.
Tes retry lama kini memastikan kegagalan persetujuan tidak menyisakan pelanggan/order.

Keluaran akhir `dart run tool/check_all.dart` (`%TEMP%/laurum-r8-clean.log`):
```text
Formatted 569 files (0 changed)
No issues found! (flutter analyze)
No issues found! (dart analyze / Riverpod lint)
check_arch: OK
03:23 +544: All tests passed!
REPO_MAP diperbarui: 637 berkas
check_all: SEMUA HIJAU
```
Temuan lint pada helper tes (properti notifier publik dan boolean posisi)
dirapikan menjadi field privat dan parameter bernama tanpa menekan aturan lint.

## Self-review dan batas
Tidak membuat widget/layar, tidak ada selisih visual .pen atau tes keyboard baru.
Registry, tema/token, fixture, aturan lint dan dependensi tidak berubah.
Repository abstrak tidak berubah; checkpoint hanya kemampuan internal implementasi dummy.
Backend wajib menyediakan runner database sendiri; checkpoint auth hanya untuk sesi dummy,
bukan mekanisme membatalkan penghapusan akun pada layanan autentikasi nyata.
Android/iOS tidak diuji manual pada R8; seluruh perubahan diverifikasi otomatis.

Tinjau: rollback checkout/batal, retry persetujuan, cleanup akun saat gagal.
Berikutnya: docs/prompts/R9-pembayaran-cod.md, lalu R10; berhenti untuk tinjauan R8.
