# STATE Laurum
Diperbarui: 2026-10-23 | Cabang dev1

## Posisi
Prompt 10-domain-core.md SELESAI; INDEX diperbarui, berhenti menunggu tinjauan.
UI tetap 17 atoms + 21 molecules (38/60 registry); tidak membuat widget/layar baru.

## Selesai
- Molecules: M1 5de7290, M2 5f981aa, M3 c628f9e.
- Baseline prompt 10: format tool/pen_frame.dart diperbaiki; commit 1c96d9d, check_all 81 tes hijau.
- Tujuh enum bisnis, RecordSyncState, 12 model immutable Equatable di lib/core/domain/.
- lineTotal/orderTotal/paidAmount/payStatus/outstanding, estimateReady/nextStatus.
- savingsBalance/applySavings/cancelOrder dengan ledger koreksi, tanpa mutasi input.
- buildReport baseline/delta, ReportRange/ReportTotals, topServices dan alokasi diskon integer.
- Tes unit: angka kecil buatan, tepi pembulatan/DP/kelebihan bayar/status final/pembatalan/tabungan/laporan.

## Keputusan
- Enum, model, logika lintas fitur: lib/core/domain/. Repository nanti core/domain/repositories/.
- Proposal/OrderEvent memakai kontrak minimal sementara yang disetujui pengguna; skema backend AI tetap ditunda.
- Baseline historis aditif disetujui pengguna; delta tidak boleh overlap. Perubahan order dalam baseline memerlukan baseline baru.
- Rentang laporan [start,end) WIB lokal. Piutang/tabungan adalah posisi saat ini; cashIn arus periode.
- Rekonsiliasi memakai cohort order periode dan pembayaran terkini, dibatasi nilai tagihan untuk kelebihan bayar.
- Diskon per layanan dialokasikan proporsional largest remainder; ranking berdasarkan pendapatan bersih.
- Semua ID/waktu dari caller; simpan hasil applySavings/cancelOrder secara atomik di repository berikutnya.
- Tidak menambah paket atau mengubah UI/token/registry/lint/PRD/Formatters.
- Temuan Formatters.nomorNota masih mengunci A; perlu dibahas saat penomoran multi-perangkat.
- AppChip tetap tanpa icon sesuai keputusan sebelumnya.

## Antrean
- Checkpoint prompt 10: check_all SEMUA HIJAU; 112 tes, kedua analyzer bersih, check_arch OK, repo_map 183 berkas. Commit terakhir: lihat git log -1.
- Prompt berikutnya: docs/prompts/11-data-dummy.md (fixture/repository/provider).
- Detail keputusan, jumlah baris dan ketidakpastian: docs/progress/fase-1.md, bagian Prompt 10.

## Batas
- APK tersedia dan manifest valid; runtime Android belum diuji. Detail android-validation.md.
- iOS/keyboard/IME/aksesibilitas perangkat belum diuji; tidak memulai build Android dalam prompt 10.
- Jangan push/merge atau mengerjakan prompt 11 otomatis.
