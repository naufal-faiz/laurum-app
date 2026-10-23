# Antrean prompt (urut)

Cara memakai: tempel prompt LANJUT di bawah ke agen setiap kali. Agen mengambil baris pertama berstatus BELUM atau SEDANG, mengerjakannya, mengubah statusnya sendiri, lalu berhenti. Jika ada koreksi, jelaskan ke agen, lalu jalankan LANJUT lagi.

```
LANJUT. Ikuti AGENTS.md dan SKILLS.md. Baca docs/prompts/_COMMON.md, lalu docs/prompts/INDEX.md. Ambil baris pertama berstatus BELUM atau SEDANG, baca berkas promptnya, dan kerjakan persis sesuai itu. Setelah selesai ikuti bagian Penutup di _COMMON.md (ubah status di INDEX.md, perbarui STATE.md, commit), lalu berhenti.
```

| No | Berkas | Isi | Status | Tinjau / tindakanmu |
| --- | --- | --- | --- | --- |
| 1 | (fase-0.md) | Inisiasi | SELESAI kecuali lint Riverpod dan Android SDK | Pasang Android SDK sebelum No 21 |
| 2 | (fase-1.md) | Atoms A, B, C | SELESAI | |
| 3 | (fase-1-molecules.md) | Molecules (21) | SELESAI | Tinjau Widgetbook |
| 4 | 10-domain-core.md | Enum, model, logika murni + tes | BELUM | |
| 5 | 11-data-dummy.md | Fixture, repository in-memory, provider | BELUM | |
| 6 | 12-organisms-1.md | Organisms 1 (9) | BELUM | |
| 7 | 13-organisms-2.md | Organisms 2 (8) + ReceiptFormatter | BELUM | |
| 8 | 14-templates.md | Templates (5), penutup Fase 1 | BELUM | **Tinjau seluruh Widgetbook (60 widget)** |
| 9 | 20-antrean.md | Kerangka navigasi + Antrean - Beranda | BELUM | Coba di HP/emulator |
| 10 | 30-transaksi-a.md | Pilih Layanan, Buat Transaksi, Input Berat, Tambah Pelanggan Cepat | BELUM | |
| 11 | 31-printer.md | Printer dan Struk, PrintService palsu | BELUM | |
| 12 | 32-transaksi-b.md | Pembayaran, Nota Tersimpan | BELUM | **Coba alur nota lengkap** |
| 13 | 40-order.md | Detail Order, Edit Order, Riwayat Nota | BELUM | |
| 14 | 50-pelanggan-a.md | Daftar, Detail, Edit Pelanggan | BELUM | |
| 15 | 51-pelanggan-b.md | Setor Tabungan, Riwayat Tabungan, Impor Kontak | BELUM | |
| 16 | 60-laporan.md | Laporan Ringkasan, Daftar Piutang | BELUM | Cocokkan angka dengan data_master.md |
| 17 | 70-lainnya-a.md | Pengaturan dan Akun, Layanan, Info Usaha | BELUM | |
| 18 | 71-lainnya-b.md | Daftar dan Catat Pengeluaran | BELUM | |
| 19 | 80-ai.md | Layar AI (dummy) | BELUM | |
| 20 | 90-auth-sinkron.md | Masuk Google (dummy), Sinkronisasi, Akun | BELUM | |
| 21 | 100-penyelesaian.md | Audit, aksesibilitas, alur akhir, APK | BELUM | **Butuh Android SDK. Coba di HP** |

Setelah No 21 selesai, antrean berikutnya adalah backend (PRD B bagian 14). Prompt-nya disusun terpisah setelah keputusan terbuka PRD B dijawab.
