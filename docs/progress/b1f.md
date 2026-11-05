# B1f — penyambungan Drift

Tanggal 5 November 2026, cabang dev2backend. Status: SELESAI.
Dasar docs/prompts/B1f-drift-penyambungan.md; B1e b2a2d91.

## Implementasi

- Main default Drift; LAURUM_STORE=memory dan entry dummy tersedia untuk tes/demo.
- AccountStorage menserialkan buka/tutup/pergantian akun; data bisnis per berkas.
  Gate root menahan rute saat loading/error dan menyediakan retry tanpa error mentah.
- Identitas akun terpisah dari AuthSession agar provider repository tidak membentuk
  siklus AuthSession -> localData -> database -> AuthSession.
- Semua repository bisnis, tabungan, pengeluaran, laporan, struk dan local_settings
  memakai Drift dalam main. Notifikasi commit SQL memperbarui data layar.
- DemoSeeder memetakan ID dan FK ke UUID v5 per owner, menulis data+outbox+marker
  dalam satu transaksi. Hanya akun demo yang kosong; retry tidak menggandakan data.
  Release tanpa DEMO_SEED=true kosong dan menjalani onboarding; tidak ada baseline laporan.
- Pending = COUNT outbox. DriftSyncService tidak menghapus antrean atau mencatat
  timestamp sukses palsu; pengiriman/ack/server menunggu B2.
- Hapus akun: auth+baris/outbox/settings atomik; file/foto baru dihapus setelah commit.
  Finalisasi menolak bila rollback mengembalikan data. Keluar mempertahankan berkas.
- Antrean memakai getActiveOrders/getActiveItems/getActivePayments; filter status,
  owner dan soft delete di SQL, child join owner+order. Menghilangkan N+1 dan baca
  seluruh riwayat. Kontrak bersama menguji hasil aktif hilang sesudah selesai.
  Kontrak Memory/Drift tetap mempertahankan urutan snapshot dan hasil immutable.
- Monitor perubahan SQL dimiliki akun dan dibatalkan sebelum DB ditutup; UI hanya
  mendengar stream salinan. Logout dengan listener paused semula timeout (tes red),
  sekarang lolos; stream UI yang dijeda tidak menahan close DB.
- Root hanya satu MaterialApp.router; builder menahan Router saat loading/error.
  Tes native widget memakai pump frame di antara tindakan agar scheduler Riverpod
  dapat menyelesaikan invalidasi future (runAsync bukan pengganti frame perangkat).
- Draf checkout/tabungan/impor/akun/usulan dibersihkan ketika identitas berganti.
- Generator nomor nota memakai watch local_settings agar pergantian akun tidak
  mempertahankan referensi database yang sudah ditutup. Release memakai identitas
  stub terpisah dari demo, sehingga database demo tidak tampil pada onboarding release.
- Ringkasan pelanggan produksi tidak mengimpor fixture historis. Offset ringkasan
  lama hanya diinjeksi oleh entry memory; Drift menghitung order/total dari ledger.
  Tes red membuktikan akun baru dengan ID legacy sebelumnya mendapat 14 order fiktif;
  sesudah pemisahan mendapat nol dan 7 tes pelanggan (termasuk memory) lolos.

## Verifikasi

- Tes seed ledger: 48 pelanggan, 16 nota, minggu 589.000/14, biaya 850.000;
  UUID/FK/outbox, retry dan rollback seed diuji.
- Tes provider dengan database berkas: keluar, akun B kosong, kembali akun A tetap,
  hapus A mempertahankan B. Regresi auth lama tetap diuji.
- Tes widget Drift in-memory: antrean/nota, COD tertahan, bayar sebagian, kelebihan
  ke tabungan, batal, pengeluaran/laporan; loading/error/retry tanpa teks mentah.
- Baseline check_all awal terkontaminasi tes red yang baru dibuat saat analyzer
  masih berjalan; bukan bukti baseline hijau. HEAD B1e memiliki 869 tes hijau.
- Pemeriksaan penuh pertama: kedua analyzer tanpa isu dan check_arch OK;
  877 tes lolos, satu tes kosong gagal karena override ganda pada harness (diperbaiki).
  Sesudah perbaikan: 46 tes terarah lolos termasuk kosong, auth, akun dan kontrak dua backend.
- Pemeriksaan akhir `dart run tool/check_all.dart`: exit 0, 828 berkas diformat
  (0 berubah), dua analyzer tanpa isu, check_arch OK, 882 tes lolos,
  REPO_MAP 895 berkas. Log: %TEMP%/laurum-b1f-final-check.log.

```text
No issues found!
check_arch: OK
04:37 +882: All tests passed!
REPO_MAP diperbarui: 895 berkas
check_all: SEMUA HIJAU
```

- Self-review: widget baru 0; root app 49 baris, seluruh Dart baru/tersentuh <=100.
  Registry/tema/lint/dependensi/skema/golden/fixture transaksi tidak berubah.
  `git diff --check` bersih dengan normalisasi Git bawaan (core.autocrlf=true).
- Frame Antrean dan State dibaca lewat pen_frame. .pen masih memakai header tanggal
  lama; spec 01/R2 tetap menang. Gate DB loading/error adalah state B1f dari registry
  yang belum ada di .pen; statistik pelanggan Drift mengikuti ledger sesuai spec 12/13.

## Benchmark dan peninjauan

tool/benchmark_device.dart menggunakan folder sementara terpisah dari usaha.
Dataset 5.000 order/5.000 item/8.000 pembayaran; 12 aktif dan 4.988 arsip.
Run pertama menyiapkan dataset; cold start berikutnya dipakai untuk pengukuran.
Waktu main sampai frame antrean dan p95 30 pembacaan dilaporkan terpisah.
Waktu ini harus dibedakan dari startup proses/engine Android.

Awal Samsung SM-N975F/Android12: main->frame1905,14ms; Activity->frame2904ms;
30 baca median911,217/p951564,198ms. Timestamp remote sebelum adb menghasilkan
3173ms karena mencakup latensi perintah, tidak dipakai sebagai startup native.
Sesudah query aktif: main1300,91ms/Activity2200ms, baca median22,774/p9545,471ms.
Hasil akhir sesudah gate satu MaterialApp (profile, cold process, cache OS tidak
dikosongkan; persiapan seed dan run layar terkunci dikecualikan):

| Run | Activity -> frame ms | Main -> frame ms | Median baca ms | p95 baca ms |
| --- | ---: | ---: | ---: | ---: |
| 1 | 728 | 207,858 | 17,186 | 25,960 |
| 2 | 614 | 203,768 | 16,421 | 20,360 |
| 3 | 622 | 211,182 | 16,565 | 36,511 |

Ketiga run memenuhi target <2000ms. Setiap p95 dari 30 pembacaan. Awal dihitung
dari timestamp ActivityTaskManager START, akhir setelah Flutter endOfFrame;
ini bukan pengukuran presentasi GPU. Angka dan metode: b1f-benchmark.json.

APK utama debug `lib/main.dart` dibangun dan terpasang kembali di HP. Force-stop
dan buka ulang berhasil; satu DB usaha tetap ada dengan checksum sama, aplikasi
Laurum kembali menjadi fokus. Ini bukti persistensi berkas, bukan audit manual
semua alur. Pengaturan layar sementara dipulihkan ke nilai awal 0. Foto sementara
di HP dibersihkan; tangkapan dari aplikasi lain diabaikan dan salinan temp dihapus.
Log build: %TEMP%/laurum-b1f-main-build.log; QA: laurum-b1f-main-qa.json.
Debug memakai JIT dan tidak disamakan dengan benchmark profile di atas.

Lingkungan: SDK Platform 35 dan CMake 3.22.1 dipersiapkan oleh Gradle sesuai
konfigurasi/dependensi yang sudah ada; tidak menambah paket Flutter.

Yang perlu ditinjau di HP: tutup-buka (data bertahan), mode pesawat, ganti akun.
Auth, AI/usulan/WhatsApp masih in-memory; printer/picker/ekspor tetap palsu.
Belum diuji di iOS. Cloud/key belum perlu. Sesudah B1f: B0 lokal; B2/B3 perlu
disusun berdasarkan temuan ini, jangan memulai prompt MENUNGGU.

Temuan untuk prompt B2/B3: jaga created_key/UTC enam digit dan atomic outbox;
ack baru boleh menghapus antrean, monitor harus dilepas sebelum tutup akun,
auth nyata harus mengganti stub tanpa menyimpan sandi/token ke DB bisnis.
