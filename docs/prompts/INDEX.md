# Antrean prompt (urut)

Seri R (revisi hasil uji HP, 25 Okt 2026) dikerjakan lebih dulu, berurutan R0 sampai R7; daftar revisi lengkap di docs/revisi/REVISI-01.md. Setelah R7, lanjut No 18.

Cara memakai: tempel prompt LANJUT di bawah ke agen setiap kali. Agen mengambil baris pertama berstatus BELUM atau SEDANG, mengerjakannya, mengubah statusnya sendiri, lalu berhenti. Jika ada koreksi, jelaskan ke agen, lalu jalankan LANJUT lagi.

```
LANJUT. Ikuti AGENTS.md dan SKILLS.md. Baca docs/prompts/_COMMON.md, lalu docs/prompts/INDEX.md. Ambil baris pertama berstatus BELUM atau SEDANG, baca berkas promptnya, dan kerjakan persis sesuai itu. Setelah selesai ikuti bagian Penutup di _COMMON.md (ubah status di INDEX.md, perbarui STATE.md, commit), lalu berhenti.
```

| No | Berkas | Isi | Status | Tinjau / tindakanmu |
| --- | --- | --- | --- | --- |
| 1 | (fase-0.md) | Inisiasi | SELESAI kecuali lint Riverpod dan Android SDK | Pasang Android SDK sebelum No 21 |
| 2 | (fase-1.md) | Atoms A, B, C | SELESAI | |
| 3 | (fase-1-molecules.md) | Molecules (21) | SELESAI | Tinjau Widgetbook |
| 4 | 10-domain-core.md | Enum, model, logika murni + tes | SELESAI (2026-10-23) | Tinjau kontrak domain dan baseline laporan |
| 5 | 11-data-dummy.md | Fixture, repository in-memory, provider | SELESAI (2026-10-23) | Audit 146 tes hijau; tinjau pelengkap DATA MASTER dan batas baseline |
| 6 | 12-organisms-1.md | Organisms 1 (9) | SELESAI (2026-10-24) | 9 widget, 170 tes hijau; tinjau selisih visual di fase-1.md |
| 7 | 13-organisms-2.md | Organisms 2 (8) + ReceiptFormatter | SELESAI (2026-10-24) | 8 widget, 200 tes hijau; tinjau ReportSummary dan modal |
| 8 | 14-templates.md | Templates (5), penutup Fase 1 | SELESAI (2026-10-24) | **Tinjau seluruh Widgetbook (60 widget)** |
| 9 | 20-antrean.md | Kerangka navigasi + Antrean - Beranda | SELESAI (2026-10-24) | Coba di HP/emulator; tinjau FAB dan chip gulir |
| 10 | 30-transaksi-a.md | Pilih Layanan, Buat Transaksi, Input Berat, Tambah Pelanggan Cepat | SELESAI (2026-10-24) | Tinjau alur transaksi dan sheet keyboard |
| 11 | 31-printer.md | Printer dan Struk, PrintService palsu | SELESAI (2026-10-24) | Tinjau koneksi palsu, pratinjau, dan simpan pengaturan |
| 12 | 32-transaksi-b.md | Pembayaran, Nota Tersimpan | SELESAI (2026-10-24) | **Coba alur nota lengkap**; tinjau atomicity tabungan |
| 13 | 40-order.md | Detail Order, Edit Order, Riwayat Nota | SELESAI (2026-10-24) | Tinjau alur batal/edit dan sheet Catat pembayaran |
| 14 | 50-pelanggan-a.md | Daftar, Detail, Edit Pelanggan | SELESAI (2026-10-24) | check_all hijau, 285 tes; tinjau Detail/Edit dan keyboard di HP |
| 15 | 51-pelanggan-b.md | Setor Tabungan, Riwayat Tabungan, Impor Kontak | SELESAI (2026-10-24) | check_all hijau, 292 tes; tinjau setoran, riwayat, dan impor kontak di HP |
| 16 | 60-laporan.md | Laporan Ringkasan, Daftar Piutang | SELESAI (2026-10-25) | check_all hijau, 301 tes; tinjau ringkasan periode dan daftar piutang di HP |
| 17 | 70-lainnya-a.md | Pengaturan dan Akun, Layanan, Info Usaha | SELESAI (2026-10-25) | check_all hijau, 310 tes; tinjau Pengaturan, Layanan, dan Info Usaha di HP |
| R0 | R0-struktur-section.md | Revisi: kategori Section, struktur fitur, check_arch (tanpa perubahan perilaku) | SELESAI (2026-10-25) | 38 Page->Section, 50 berkas state, 317 tes hijau; tinjau daftar utang di tool/section_riverpod_debt.txt - 26 berkas |
| R1 | R1-input-keyboard.md | Revisi 1,2,3,10: keyboard, angka awal, berat | SELESAI (2026-10-25) | Fondasi keyboard, diskon, berat/jumlah, nominal, audit 14 layar + numpad T/A; koreksi teks desimal, 355 tes hijau. Catatan: docs/progress/r1-input-keyboard.md |
| R2 | R2-navigasi-beranda.md | Revisi 9,11: tombol Transaksi di tengah nav, Beranda antrean aktif | SELESAI (2026-10-30) | 366 tes hijau di perangkat lama; PRD disinkronkan dengan izin pengguna, pemeriksaan manual Android dikonfirmasi |
| R3 | R3-transaksi.md | Revisi 4,5: FAB Pilih Layanan, tombol tambah pelanggan | BELUM | |
| R4 | R4-status-order.md | Revisi 6: pengaturan Pakai status order | BELUM | **Coba Selesaikan -> cetak di HP** |
| R5 | R5-laporan-rentang.md | Revisi 8,13,14: rentang tanggal, Ekspor di atas | BELUM | Tinjau pemilih tanggal dan angka |
| R6 | R6-laporan-nota.md | Revisi 7,8,13: daftar nota di Laporan, hapus Riwayat Nota | BELUM | Tinjau rekonsiliasi angka dan daftar nota |
| R7 | R7-pelanggan-akun.md | Revisi 12,15: tombol Pelanggan baru di atas, tombol Keluar | BELUM | Tinjau di HP |
| 18 | 71-lainnya-b.md | Daftar dan Catat Pengeluaran | BELUM | |
| 19 | 80-ai.md | Layar AI (dummy) | BELUM | |
| 20 | 90-auth-sinkron.md | Masuk Google (dummy), Sinkronisasi, Akun | BELUM | |
| 21 | 100-penyelesaian.md | Audit, aksesibilitas, alur akhir, APK | BELUM | **Butuh Android SDK. Coba di HP** |

Setelah No 21 selesai, antrean berikutnya adalah backend (PRD B bagian 14). Prompt-nya disusun terpisah setelah keputusan terbuka PRD B dijawab.

