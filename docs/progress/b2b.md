# B2b — mesin sinkronisasi lokal (selesai 7 Nov 2026)

Lanjutan B2 yang disetujui. Lingkup: Drift v5, metadata grup outbox, ack/konflik,
SyncEngine dengan transport palsu, dan suite kontrak store. Tanpa UI, Auth, Supabase,
pull-apply, upload foto, atau cloud.

## Hasil

- Drift v5 menambah kolom `outbox`: `group_id`, `group_seq`, `requires_recovery`,
  `conflict_code`. Snapshot v1–v4 tetap beku; `drift_schema_v5.json` dan helper v5
  ditambahkan. Migrasi v1→v5 dan v4→v5 diuji.
- Baris outbox baru otomatis satu grup per transaksi bisnis. `DriftTransactionRunner`
  membuat UUID v4 per transaksi tingkat atas; pemanggilan bersarang memakai grup yang
  sama. `OutboxWriter` mengisi `group_seq` 1..n. Rollback menghapus data + outbox.
- Migrasi v4 tidak menebak grup: semua baris lama menjadi `requires_recovery = 1`
  dengan kolom grup null. Mesin berhenti dengan status `legacy` sampai pemulihan
  eksplisit `recoverLegacyGroup(groupId, changeIds)`; tidak ada pemetaan dari waktu.
- Antarmuka baru `SyncOutboxStore` dengan implementasi `DriftSyncOutboxStore` dan
  `InMemoryOutboxStore`:
  - ambil grup tertua berurutan;
  - ack hanya `change_id` yang benar-benar dikirim;
  - catat percobaan gagal (`attempts`, `last_error`);
  - tandai konflik (`conflict_code`) dan blokir grup berikutnya;
  - daftar baris legacy dan pemulihan eksplisit.
- `SyncEngine`:
  - hash kanonik SHA-256 sama dengan server; vektor hash diuji silang dengan
    implementasi Node;
  - grup >50 dipecah fragmen 1..n dengan hash grup dan hash fragmen;
  - receipt `committed` menghapus hanya ID `ok`; `rejected` menandai seluruh grup
    konflik dan berhenti; `staged` berlanjut ke fragmen berikutnya;
  - respons hilang setelah commit: run berikutnya mengirim ulang grup yang sama dan
    memakai receipt lama (tidak menggandakan atau memundurkan data);
  - konflik/legacy memblokir pengiriman berikutnya.
- Dependensi `crypto` dideklarasikan atas persetujuan pengguna (7 Nov 2026); versi
  3.0.8 sudah ada di lockfile sebagai transitive. Tidak ada paket B2 lain yang dipasang.

## Bukti

```powershell
powershell -NoProfile -Command ". ./tool/windows_native_sdk.ps1; ...; dart run tool/check_all.dart"
# format/analyze/Riverpod lint/check_arch hijau
# 906 tes Flutter lulus (sebelumnya 882; +24 tes B2b)
# REPO_MAP 917 berkas
# check_all: SEMUA HIJAU
```

Tes baru mencakup: vektor canonical JSON/hash, grouping satu transaksi vs transaksi
terpisah, rollback, operasi checkout (order+item+payment+event/savings) dalam satu grup,
kontrak store pada Drift dan InMemory, ack selektif, konflik, legacy dan pemulihan,
fragmen >50, retry setelah respons hilang, serta pemblokiran legacy/konflik.

## Batas dan langkah berikutnya

- `SyncTransport` masih palsu; adapter Supabase dan pemetaan pull ke seluruh tabel
  adalah B2c. Belum ada jaringan atau kredensial.
- UI indikator/aksi, debounce/retry/backoff, foreground, konektivitas, dan workmanager
  tetap B2d. Pemulihan legacy perlu aksi eksplisit sebelum antrean lama dikirim.
- Antrean foto tetap B2e.
