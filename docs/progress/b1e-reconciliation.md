# B1e - Audit rekonsiliasi sebelum laporan ledger (4 Nov 2026)

Status dokumen: audit historis sebelum persetujuan. Pengguna telah menyetujui angka
ledger pada 4 Nov 2026; implementasi dilanjutkan (lihat b1e.md). Kolom target di bawah
merekam angka lama untuk menjelaskan selisih, bukan konfigurasi laporan saat ini.
Dasar kode: 70041af, cabang dev2backend.

## Temuan dan keputusan yang diperlukan

Angka laporan historis tidak dapat dihasilkan dari rincian seed DATA MASTER yang
diizinkan saat ini. Seluruh seed hanya mempunyai 16 order, 16 item, 14 pembayaran,
18 pengeluaran dan 7 mutasi tabungan. Dalam minggu 12-18 Oktober ada 14 order.
Target 58 transaksi memerlukan 44 rekaman order tambahan yang tidak dirinci.
Mengganti query, ID atau penyimpanan tidak dapat menambah pendapatan order yang tidak ada.

Prompt [B1e langkah 3](../prompts/B1e-drift-pengeluaran-laporan.md) menyatakan:

> Jika tidak bisa direkonsiliasi, JANGAN membuat baseline atau data fiktif: hentikan, laporkan selisih, minta keputusan pengguna.

DATA MASTER juga menyatakan riwayat tidak dibuat menjadi puluhan nota fiktif dan
preset lama memakai baseline. Karena itu tidak menambah order/pembayaran agar cocok.

Keputusan pengguna: angka dan penjelasan bagian laporan DATA MASTER, grafik,
layanan terlaris serta ekspektasi/golden terkait mengikuti ledger aktual di bawah.
Rincian fixture order/pembayaran/pengeluaran/tabungan/pelanggan tetap.
Pengguna menyetujui perhitungan sesuai ledger: "tentu saja angkanya harus sesuai.
perbaiki semua selisih itu agar hasilnya masuk akal". Rincian historis tambahan tidak dibuat.

## Ringkasan hasil (rupiah)

| Metrik | Hari ini target | Ledger | Minggu ini target | Ledger | Bulan ini target | Ledger |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Pendapatan | 375.000 | 177.000 | 1.800.000 | 589.000 | 4.250.000 | 864.000 |
| Transaksi | 12 | 6 | 58 | 14 | 135 | 16 |
| Pengeluaran | 145.000 | 145.000 | 850.000 | 850.000 | 1.850.000 | 1.850.000 |
| Laba | 230.000 | 32.000 | 950.000 | -261.000 | 2.400.000 | -986.000 |
| Kas masuk | 343.500 | 130.500 | 1.699.500 | 500.000 | 4.050.000 | 868.500 |
| Kas cohort nota | 328.500 | 130.500 | 1.574.500 | 388.500 | 3.750.000 | 438.500 |
| Tabungan dipakai cohort | 0 | 0 | 25.000 | 0 | 99.500 | 25.000 |
| Piutang baru | 46.500 | 46.500 | 200.500 | 200.500 | 400.500 | 400.500 |
| Piutang aktif | 400.500 | 400.500 | 400.500 | 400.500 | 400.500 | 400.500 |
| Saldo tabungan | 430.000 | 430.000 | 430.000 | 430.000 | 430.000 | 430.000 |

Selisih pendapatan minggu: Rp1.211.000; kas masuk: Rp1.199.500.
Pengeluaran, piutang dan saldo tabungan cocok; ini bukan kegagalan semua fixture.
Laba negatif merupakan akibat pendapatan seed lebih kecil dari pengeluaran yang
sudah dirinci; tidak mengganti nilai tersebut dengan baseline tambahan.

Identitas ledger mingguan tetap tepat: 388.500 kas cohort + 0 tabungan dipakai +
200.500 piutang baru = 589.000 pendapatan. Kas masuk 500.000 = 388.500 pembayaran
non-tabungan dalam minggu + 111.500 setoran tabungan. A-0115/pemakaian tabungan
25.000 ada pada 2 Oktober, sehingga masuk bulan tetapi tidak masuk minggu 12-18.

## Grafik dan layanan

| Hari | Target pendapatan | Ledger |
| --- | ---: | ---: |
| Sen 12 Okt | 340.000 | 0 |
| Sel 13 Okt | 385.000 | 0 |
| Rab 14 Okt | 290.000 | 248.000 |
| Kam 15 Okt | 410.000 | 164.000 |
| Jum 16 Okt | 375.000 | 177.000 |

Sabtu/Minggu belum terjadi pada business clock fixture; tidak menganggap nol sebagai
aktivitas masa depan. Total lima hari ledger 589.000; rerata 117.800, puncak Rabu.

| Layanan ledger minggu | Kuantitas | Pendapatan |
| --- | ---: | ---: |
| Cuci setrika | 33,5 kg | 301.500 |
| Cuci kering lipat | 18 kg | 108.000 |
| Bed cover | 4 pcs | 100.000 |
| Cuci kiloan | 8,5 kg | 59.500 |
| Selimut tebal | 1 pcs | 20.000 |

Jumlah alokasi layanan 589.000, sama dengan omzet. Target lama antara lain Cuci
setrika 98 kg/882.000 dan Cuci kiloan 70 kg/490.000 tidak punya snapshot pendukung.

## Metode dan bukti

- Membaca seluruh fixture yang dirangkai orderFixtures/orderItemFixtures/
  paymentFixtures/expenseFixtures/savingsFixtures, termasuk pengisi dan riwayat.
- reportSnapshot memakai buildReport dengan baseline nol; tidak menambahkan target
  historis. topServices/allocateRevenue memakai snapshot item yang sama.
- Range: Hari 16-17 Okt, Minggu 12-19 Okt, Bulan 1 Okt-1 Nov; akhir eksklusif.
  Posisi piutang/tabungan memakai seluruh ledger sesuai semantik domain yang ada.
- Audit dijalankan dengan Dart CLI memakai package_config repo, skrip di
  %TEMP%/laurum-b1e-reconcile.dart. Output mentah tersimpan dalam
  [b1e-reconciliation.json](b1e-reconciliation.json), termasuk delta dan nomor nota.
- Audit memverifikasi jumlah top services = omzet dan kas cohort + tabungan dipakai
  + piutang baru = omzet; keluar 0. Tidak memakai InMemoryReportRepository yang
  mengembalikan baseline + snapshot kini - snapshot awal.
- check_all pada kode aplikasi yang tidak berubah: kedua analyzer tanpa isu,
  check_arch OK, 848 tes lolos, REPO_MAP 840, exit 0.
  Bukti %TEMP%/laurum-b1e-baseline.log:

```text
No issues found!
check_arch: OK
04:50 +848: All tests passed!
REPO_MAP diperbarui: 840 berkas
check_all: SEMUA HIJAU
```

Pada commit audit 2fb58eb, perubahan hanya dokumentasi; aplikasi belum berubah.
Implementasi sesudah persetujuan dicatat di docs/progress/b1e.md. Cloud/key belum perlu;
B1f tetap sesudah B1e selesai.
