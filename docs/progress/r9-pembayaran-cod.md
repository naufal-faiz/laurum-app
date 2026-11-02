# R9 - Pembayaran COD dan pembayaran lanjutan (2 Nov 2026)

## Hasil
- Order.payTerm sekarang/cod dipertahankan pada perubahan status/edit; PayStatus tetap turunan.
- Kasir hanya Bayar sekarang / Bayar nanti (COD); nominal awal terutang, nol eksplisit
  tidak diubah ke total. Nol dengan tabungan sebagian wajib COD; tagihan tertutup tabungan boleh disimpan.
- Nominal non-tunai melebihi tagihan ditolak. Tunai menerapkan maksimal sisa;
  kelebihan dikembalikan atau disetor ke tabungan sesuai pilihan, tanpa menambah omzet.
- Cetak struk menyimpan lalu membuka nota; Ke antrean menyimpan dan memberi banner empat detik.
  Kedua tombol terkunci selama simpan dan controller menolak ketukan simpan ganda.
- Catat pembayaran aktif di Detail, Struk dan Piutang selama bersisa dan tidak batal,
  termasuk order selesai. Semua memakai PaymentRecordSheet dan satu controller/save bersama.
- COD ditahan oleh state dan repository. Mode sederhana otomatis selesai saat lunas;
  mode aktif Catat pembayaran biasa melepas tahanan, sementara Terima pembayaran
  pada langkah siap menyimpan pelunasan dan event selesai bersama.
- Seluruh penulisan nota/pembayaran/setoran/status/event memakai TransactionRunner R8.
- Label status nota: Lunas / Sisa Rp X / COD - sisa Rp X. CSV tetap PayStatus turunan.
  Piutang difilter Semua/COD/Sebagian; Ingatkan disembunyikan dan Catat bayar berfungsi.
- Fixture master tidak berubah. Nota non-COD lama yang belum dibayar tetap didukung
  dan masuk filter Sebagian; COD tambahan hanya dibuat di tes.

## Struktur dan tampilan
- Dua Section baru: PaymentRecordInputSection (58 baris), ReceiptActionsSection (53 baris).
- Enam utang Section dihapus (provider/router dipindah ke Page); tersisa 14 entri.
- PaymentSummary/PaymentSavings/PaymentMethod/ReceiptStatus/OutstandingList Stateless;
  CustomerOrdersSection kini menerima callback navigasi.
- Controller pembayaran piutang lama yang tidak lagi dipakai dihapus; seluruh pintu
  masuk memakai alur pembayaran yang sama, termasuk aturan COD dan rollback.
- Tinjauan gambar 320 px/teks 2x menemukan nomor nota terjepit vertikal. Header
  OrderSummarySection kini Wrap; tes mengunci tinggi nomor agar tidak terulang.
- Piutang memakai AppBarSub terdaftar agar judul terbaca; ringkasan kartu Total tagihan.
- Tidak mengubah registry, tema/token, fixture, dependensi atau lint. Izin PRD R9
  dipakai hanya untuk paragraf pembayaran/piutang dan kolom pay_term/aturan backend.

## Verifikasi
Baseline check_all hijau: 544 tes, REPO_MAP 637 berkas.
Tes domain/state dibuat lebih dulu; kegagalan awal membuktikan API R9 belum tersedia.
Tes baru memeriksa COD kedua mode, pembayaran sebagian setelah selesai, tabungan,
uang lebih, rollback setelah setoran, guard repository/antrean, dua rute tombol,
input awal/backspace/nol, Section, keyboard 300 dp, dan visual 320 px/teks 2x.
Delapan golden lama diperbarui setelah kegagalan regresi diidentifikasi sesuai perubahan R9;
empat golden COD ditambahkan dan gambar hasilnya diperiksa langsung.

Verifikasi akhir `dart run tool/check_all.dart` (%TEMP%/laurum-r9-final.log):
```text
Formatted 595 files (0 changed)
No issues found! (flutter analyze)
No issues found! (dart analyze / Riverpod lint)
check_arch: OK
04:12 +580: All tests passed!
REPO_MAP diperbarui: 663 berkas
check_all: SEMUA HIJAU
```
Git diff --check bersih. Berkas Dart baru maksimal 100 baris; berkas lama yang
disentuh tetap di bawah batas keras 110. Gambar pembayaran/struk normal dan empat
golden COD 320 px/2x ditinjau langsung. Semua fixture/tema/registry/dependensi tetap.

## Yang perlu ditinjau
1. Android: COD kedua mode, tetap di antrean sampai pelunasan, Cetak struk vs Ke antrean.
2. Uang lebih: Kembalian vs Simpan ke tabungan; pembayaran order selesai dari tiga pintu masuk.
3. Tampilan/keyboard pada perangkat nyata. iOS dan printer nyata belum diuji.

Berikutnya: docs/prompts/R10-akun.md. R10 dan prompt 100 belum dikerjakan.
