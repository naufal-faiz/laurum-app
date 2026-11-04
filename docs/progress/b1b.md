# B1b — Pelanggan dan tabungan Drift (4 Nov 2026)

Status: SELESAI; check_all akhir hijau (exit 0).
Baseline: 740 tes hijau, commit B1a c22ec5b. Tanpa dependensi baru atau wiring aplikasi.

## Implementasi

- DriftCustomerRepository dan DriftSavingsRepository di features/customers/data memakai
  AppDatabase, owner scope dan OutboxWriter/TransactionRunner yang sama.
- Pelanggan: insert/upsert, filter aktif/soft delete, nomor aktif unik, prefiks nama/telepon.
  Teks nama/nomor asli dipertahankan. Key telepon menganggap 0/62/+62/8 setara.
- getCustomers mendapat parameter query opsional (default kosong tetap seperti sebelumnya).
  Pencarian prefiks memakai LIKE terikat parameter dan escape wildcard literal.
  Key nama lowercase Dart mendukung huruf Unicode; teks berangka bukan otomatis nomor.
- Urutan pelanggan mempertahankan urutan insert melalui rowid SQLite internal, bukan
  menjadikan rowid sebagai ID domain. Upsert tidak memindahkan posisi pelanggan.
- Tabungan append-only: retry isi yang sama tidak menambah ledger/outbox. Perubahan
  id/owner/waktu asal/pelanggan/kind/nominal/metode/order/catatan ditolak.
- Saldo dihitung SQL SUM(CASE...) dengan owner/customer filter, COALESCE 0; tes silang
  cocok dengan savingsBalance domain, termasuk penyesuaian negatif dan saldo kosong.
- Riwayat memakai pembanding DateTime Dart + posisi insert sebagai tie-break, sama pada
  InMemory/Drift; presisi subdetik dan UTC/lokal tidak hilang akibat pengurutan teks SQL.
- Parent pelanggan/order pada ledger divalidasi milik owner/pelanggan yang sama.

## Metadata dan kontrak

- Setiap mutasi baru menyimpan updated_at lokal dan pending; setiap mutasi data bersama
  outbox berada dalam transaksi yang sama. Delete pelanggan menghasilkan upsert soft delete.
- Payload snake_case, timestamp UTC ISO-8601; tidak menyertakan sync_state/key pencarian.
- Kontrak bersama memeriksa semua field bisnis secara eksplisit. updatedAt/syncState
  dipisahkan karena metadata penyimpanan/sinkron; metadata Drift diuji khusus dengan clock.
  Ini diperlukan karena InMemory sebelumnya mengembalikan metadata input tanpa stamping.
- Retry ledger mengabaikan dua metadata sinkron tersebut; semua isi bisnis tetap immutable.
  InMemory diselaraskan untuk alias nomor, prefiks dan tie-break riwayat. Fixture tetap.

## Skema v2 dan indeks

16 tabel tetap. Dua kolom lokal turunan customers.name_key/phone_key bukan field bisnis
baru dan tidak dikirim ke Postgres. Skema berubah dari v1 ke v2 dengan migrasi atomik.

| Indeks | Fungsi |
| --- | --- |
| customers_active_phone(owner_id, phone_key), parsial aktif/tidak terhapus/tidak kosong | Unik lintas format 0/62 |
| customers_name_prefix(owner_id, name_key COLLATE NOCASE) | Range prefiks nama |
| customers_phone_prefix(owner_id, phone_key COLLATE NOCASE) | Range prefiks nomor |
| customers_owner_updated(owner_id, updated_at) | Scope owner/metadata mutasi |
| savings_owner_updated(owner_id, updated_at) | Scope owner/metadata ledger |

LIKE name/phone memakai UNION dua cabang supaya masing-masing dapat memakai indeksnya;
EXPLAIN QUERY PLAN membuktikan kedua indeks dengan range key>?. Indeks riwayat pelanggan
tabungan dari v1 tetap ada. Pencarian substring UI belum diganti/wired ke API prefiks ini.

Migrasi menambah dan mengisi key, mengganti indeks unik lalu menambah indeks lainnya.
Jika dua nomor aktif lama menjadi sama setelah normalisasi, seluruh migrasi dibatalkan:
tidak menghapus/menggabungkan pelanggan. Tes membuktikan dua baris dan skema v1 tetap utuh.
Snapshot v1 tidak diubah; v2 disimpan di test/persistence/schema/drift_schema_v2.json.
Snapshot/helper memakai --data-classes --companions; v1->v2 diuji SchemaVerifier dan data lama.

## Verifikasi

- Baseline check_all 740 hijau; tes Drift baru gagal sebelum implementasi.
- 55 tes terarah hijau: kontrak InMemory + Drift, migrasi, query plan, metadata/outbox,
  injeksi SQL trigger di tengah mutasi dan validasi owner/parent.
- Regresi alfanumerik dibuktikan gagal di kedua backend sebelum perbaikannya.
- check_all akhir: 759 tes lolos, flutter analyze dan dart analyze bersih,
  check_arch OK, REPO_MAP 787 berkas; exit 0. Bukti %TEMP%/laurum-b1b-check.log:

```text
04:33 +759: All tests passed!
REPO_MAP diperbarui: 787 berkas
check_all: SEMUA HIJAU
```

- Self-review: semua Dart baru non-generated <=100 baris; snapshot/helper v1 utuh;
  git diff --check bersih. Tidak mengubah lint, dependensi, fixture, tema atau registry.

Windows: aktifkan tool/windows_native_sdk.ps1 sebelum Dart/Flutter (lihat README).
Database Android/iOS belum diuji; aplikasi tetap InMemory sampai B1f.
Prompt berikutnya: B1c-drift-usaha-layanan.md. Supabase cloud/key belum diperlukan.

Dasar teknis: [optimasi LIKE SQLite](https://www.sqlite.org/optoverview.html#the_like_optimization)
dan [migrasi Drift](https://drift.simonbinder.eu/migrations/).
