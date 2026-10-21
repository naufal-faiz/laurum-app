# PRD B — Sistem, Data, dan Backend Laurum

Versi 1.0 · 20 Oktober 2026 · Pasangan PRD A (Tampilan). Keputusan dasar: offline-first dengan SQLite lokal, sinkron otomatis ke Supabase Postgres, login Google lewat Supabase Auth, rencana rilis Play Store, fitur Pro dan AI menyusul.

## 1. Tujuan dan lingkup

**Tujuan:** data kasir **selalu tersimpan di HP lebih dulu** dan aman di server begitu ada internet. Pengguna tidak pernah menunggu jaringan untuk membuat nota.

| Fase | Dalam lingkup | Ditunda |
| --- | --- | --- |
| Sekarang | SQLite (Drift), Supabase (Postgres, Auth, Storage), sinkronisasi, login Google, hapus akun, kesiapan Play Store | — |
| Hook saja | `FeatureGate` (selalu terbuka), tabel `entitlements`, antarmuka `ProposalRepository` dan `PrintService` | Play Billing, AI nyata, printer nyata |
| Nanti | AI pembaca WhatsApp, fitur Pro berbayar | — |

**Di luar lingkup:** multi-outlet, role karyawan, kurir, stok, jatuh tempo piutang, dan semua yang sudah dicoret di PRD A.

## 2. Prinsip

1. **SQLite adalah sumber kebenaran untuk UI.** UI hanya membaca dan menulis lokal. Server mengikuti.
2. **Setiap penulisan lokal bersifat atomik** dan sekaligus mencatat antrean sinkron (outbox) dalam satu transaksi.
3. **ID dibuat di klien** (UUID), sehingga membuat data offline tidak pernah bentrok.
4. **Uang `int` rupiah, berat `int` gram** (jumlah satuan disimpan ribuan: 1 pcs = 1000). Tidak ada float.
5. **Data keuangan tidak diubah, hanya ditambah** (pembayaran, mutasi tabungan). Koreksi berupa entri baru.
6. **Logika bisnis ditulis sekali** di `core/domain/` (Dart murni) dan dipakai UI, repository, dan tes.
7. Waktu disimpan UTC, ditampilkan WIB (Asia/Jakarta).

## 3. Arsitektur

```
UI (Pages, provider Riverpod)
   |  hanya lewat antarmuka
Repository (CustomerRepository, OrderRepository, ...)
   |-- Drift/SQLite  <-- sumber kebenaran lokal (data + outbox + cursor)
   `-- SyncEngine    <-- membaca outbox, bicara dengan Supabase
          |
          v
Supabase: Auth (Google) | Postgres + RLS | Storage (foto struk)
```

- **Dua implementasi repository** di balik antarmuka yang sama: `InMemory*` (PRD A, data dummy) dan `Drift*` (nyata). Pergantian dilakukan lewat override provider di `main.dart`. Pages tidak berubah.
- `SyncEngine` berjalan di latar dan hanya mengekspos `Stream<SyncStatus>` untuk `SyncIndicator`.
- Dependensi (pasang versi terbaru lewat `flutter pub add`): `drift`, `drift_flutter` (atau `sqlite3_flutter_libs`), `supabase_flutter`, `google_sign_in`, `connectivity_plus`, `workmanager`, `flutter_secure_storage`, `uuid`, `path_provider`.

## 4. Autentikasi

- **Satu-satunya metode: Google.** Login native dengan `google_sign_in`, lalu `supabase.auth.signInWithIdToken(provider: google, idToken, accessToken)`. Perlu *Web client ID* di Google Cloud dan provider Google aktif di Supabase (panduan resmi Supabase untuk Flutter).
- Sesi disimpan dengan `flutter_secure_storage` (bukan SharedPreferences biasa).
- **Alur pertama kali:** Masuk → (akun baru) layar Info Usaha untuk nama usaha → pull awal → Beranda. **Akun lama di HP baru:** Masuk → layar "Memulihkan data..." dengan progres → Beranda.
- **Keluar:** jika outbox belum kosong, tampilkan peringatan jumlah perubahan yang belum tersinkron. Opsi "Keluar dan hapus data di HP" hanya aktif setelah sinkron tuntas.
- **Hapus akun (wajib untuk Play Store):** di Pengaturan dan Akun (dalam aplikasi) **plus** tautan web publik untuk permintaan hapus akun. Menghapus akun menghapus semua baris milik pengguna di server, file di Storage, dan akun Auth, lalu data lokal. Alur memerlukan konfirmasi dua langkah.
- Perangkat: tabel `devices` mencatat tiap HP yang login (kode `A`, `B`, ...).

## 5. Model data

Tabel yang sama di SQLite dan Postgres. Kolom umum di semua tabel kecuali dicatat lain: `id uuid pk`, `owner_id uuid` (default `auth.uid()`), `created_at`, `updated_at` (diisi **server** saat push), `deleted_at` (soft delete). Di SQLite ditambah `sync_state` (`synced`/`pending`).

| Tabel | Kolom penting |
| --- | --- |
| `businesses` | name, address, phone, receipt\_footer, receipt\_note |
| `devices` | code (A, B, ...), name, last\_seen\_at |
| `customers` | name, phone, address, notes, is\_active. Unik `(owner_id, phone)` untuk baris aktif |
| `services` | name, kind (`kiloan`/`satuan`), price, duration\_days, is\_active, sort\_order |
| `orders` | order\_no (unik per owner), customer\_id, status, source (`kasir`/`whatsapp_ai`), proposal\_id, discount, note, entered\_at, estimated\_at, subtotal, total |
| `order_items` | order\_id, service\_id, service\_name (snapshot), unit, qty\_milli, unit\_price, line\_total |
| `payments` | order\_id, method (`tunai`/`qris`/`transfer`/`tabungan`), amount, received, paid\_at, note. **Tidak diubah** |
| `savings_entries` | customer\_id, kind (`setor`/`pakai`/`penyesuaian`), amount, method, order\_id, note. **Tidak diubah, tanpa soft delete** |
| `expense_categories` | name, is\_default |
| `expenses` | category\_id, amount, vendor, note, spent\_at, photo\_path |
| `receipt_settings` | paper\_mm (58/80), font\_size, show\_address, show\_customer, show\_savings, show\_note |
| `entitlements` | plan (`free`/`pro`), valid\_until, source. **Hook Pro** |
| `ai_proposals`, `wa_connections` | **Ditunda.** Skema didefinisikan saat fase AI |

**Hanya lokal (tidak disinkronkan):** `outbox`, `sync_cursors`, `local_settings` (printer yang dipasangkan di HP ini, kode perangkat, counter nota).

**Enum status order:** `menunggu_jemput`, `diproses`, `siap`, `selesai`, `dibatalkan`. `selesai` dan `dibatalkan` bersifat final.

**Nomor nota:** `<kode perangkat>-<urut 4 digit>`, misalnya `A-0143`. Counter ada di perangkat, sehingga HP kedua (`B-0001`) tidak pernah bentrok dan tidak butuh koordinasi server. Setelah pemulihan data, counter dilanjutkan dari nomor tertinggi perangkat itu.

## 6. Aturan bisnis

- **Estimasi selesai** = tanggal masuk + durasi layanan terlama (hari kalender), jam 17.00 WIB.
- **Total** = jumlah `line_total` − diskon. `line_total = round(qty_milli x unit_price / 1000)`.
- **Status bayar (turunan, tidak disimpan):** `dibayar = jumlah payments`. `0` → belum bayar; `0 < dibayar < total` → DP; `dibayar >= total` → lunas.
- **Piutang** = jumlah `total − dibayar` untuk order tidak dibatalkan dengan sisa > 0. Tidak ada jatuh tempo. Usia ditampilkan netral ("4 hari lalu").
- **Saldo tabungan** = setor − pakai ± penyesuaian. Tidak disimpan, selalu dihitung dari mutasi.
- **Bayar dengan tabungan** membuat satu `payments` (method `tabungan`) **dan** satu `savings_entries` (`pakai`, terhubung ke order) dalam **satu transaksi lokal**. Sisa dibayar tunai/QRIS/transfer. Jika kelebihan bayar dan pengguna memilih menyimpannya, dibuat `savings_entries` `setor`.
- **Pembatalan order** mengubah status menjadi `dibatalkan` dan mengeluarkan order dari laporan. Pembayaran yang sudah masuk dibalik dengan entri koreksi (nominal negatif), bukan dihapus.
- **Laporan periode** (zona WIB): Pendapatan = total order tidak dibatalkan yang masuk pada periode. Pengeluaran = jumlah `expenses`. Laba = Pendapatan − Pengeluaran. Kas masuk = payments non-tabungan + setoran tabungan. Piutang aktif dan saldo tabungan adalah posisi saat ini, bukan arus periode. Rekonsiliasi: `Pendapatan = kas dari nota + tabungan terpakai + piutang baru`.
- **Layanan terlaris** diurutkan berdasarkan pendapatan, bukan volume.

## 7. Sinkronisasi

**Outbox.** Setiap penulisan lokal menambahkan baris `outbox(id, table, row_id, op, payload, created_at, attempts, last_error)` pada transaksi yang sama dengan datanya.

**Push.** Kirim batch (maks 50) ke RPC `sync_push(changes jsonb)` yang melakukan upsert per tabel dalam satu transaksi server. Server mengisi `updated_at = now()` lewat trigger dan mengembalikannya. Baris outbox dihapus bila berhasil. Idempotent karena ID dari klien.

**Pull.** Per tabel: `select * where updated_at > :cursor order by updated_at, id limit 500`, ulangi sampai habis. Kursor disimpan di `sync_cursors`. Soft delete ikut tersinkron.

**Konflik.**

- Tabel biasa (customers, services, expenses, settings): **terakhir menulis menang** berdasarkan `updated_at` server. Baris yang masih punya perubahan di outbox tidak ditimpa pull sampai push selesai.
- `orders`: LWW per baris, dengan penjaga: status final tidak bisa dimundurkan.
- `payments`, `savings_entries`, `order_items`: **hanya tambah** (tidak ada konflik).
- Pelanggaran unik (`phone`, `order_no`): server menolak, klien menandai `sync_state` konflik dan menampilkan penyelesaian di layar Sinkronisasi (gabung pelanggan atau ganti nomor).

**Pemicu sinkron.** Setelah login; aplikasi kembali ke foreground; koneksi pulih (`connectivity_plus`); 2 detik setelah penulisan (debounce); periodik tiap \~15 menit lewat `workmanager`; tombol "Sinkron sekarang". Gagal → percobaan ulang dengan backoff eksponensial (maks 15 menit).

**Status ke UI (`SyncIndicator`):** `tersimpan`, `menyimpan` (ada outbox aktif), `offline`, `gagal` (butuh perhatian), plus jumlah perubahan tertunda dan waktu sinkron terakhir.

**Foto struk pengeluaran:** dikompres (≤ 200 KB), disimpan lokal, diunggah lewat antrean terpisah ke bucket privat `expense-photos/{owner_id}/{uuid}.jpg`.

**Versi skema.** Migrasi Drift (lokal) dan Supabase CLI `supabase/migrations/*.sql` (server) dikelola di repo. RPC menolak klien yang terlalu lama dengan kode khusus; UI menampilkan "Perbarui aplikasi" (tabel `app_config.min_schema_version`).

**Alternatif yang dipertimbangkan:** PowerSync atau pustaka sinkron siap pakai. Ditolak untuk v1 karena menambah layanan dan batas gratis lain, sedangkan data kecil dan pengguna tunggal per akun. Dapat dievaluasi ulang bila perlu.

## 8. Supabase

- **RLS di semua tabel:** `owner_id = (select auth.uid())` untuk select, insert (`with check`), update; tabel append-only tanpa kebijakan update/delete. Kunci `service_role` tidak pernah ada di aplikasi.
- **Storage:** bucket privat, kebijakan berdasar awalan folder `owner_id`.
- **Provider:** hanya Google yang aktif; pendaftaran email dimatikan.
- **Indeks:** `(owner_id, updated_at)` di tiap tabel (untuk pull), `orders(owner_id, status)`, `orders(owner_id, entered_at)`, `payments(order_id)`.
- **Fungsi server:** `sync_push`, `delete_my_account` (menghapus semua data pemilik), `app_config`.
- **Batas paket gratis (diperiksa Juli–Agustus 2026):** 500 MB database per proyek, 1 GB storage, 50.000 MAU, **proyek dijeda setelah 7 hari tidak aktif**, tanpa backup harian. Semua pengguna berbagi satu proyek.
  - Estimasi kasar: ≈ 2,5 KB per order termasuk indeks → laundry 15 order/hari ≈ 14 MB per tahun → 500 MB cukup untuk ±30 pengguna aktif selama setahun. **Rencanakan Pro (≈ US$25/bulan) sebelum rilis publik luas.**
  - Mitigasi masa pengembangan: ping harian terjadwal agar proyek tidak dijeda, dan `pg_dump` mingguan ke tempat penyimpanan pribadi. Aplikasi tetap berjalan saat server dijeda karena offline-first.
  - Angka ini bisa berubah; cek halaman harga Supabase sebelum keputusan.

## 9. Keamanan dan privasi

- Data pelanggan (nama, telepon, alamat) adalah **data pribadi pihak ketiga**. Perlu kebijakan privasi publik (daftar data, tujuan, retensi, cara hapus) sejalan UU PDP.
- Token di secure storage. HTTPS saja. Tidak ada kunci rahasia di aplikasi. Anon key bersifat publik dan aman karena dilindungi RLS.
- Basis data lokal tidak dienkripsi tambahan di v1 (mengandalkan sandbox Android dan enkripsi disk). SQLCipher dicatat sebagai opsi.
- Log tidak boleh memuat nama atau nomor telepon pelanggan.
- Pengguna dapat mengekspor datanya (CSV) dan menghapus akun.

## 10. Kesiapan Play Store

| Hal | Keputusan/kebutuhan |
| --- | --- |
| Target SDK | Aplikasi baru harus menargetkan **Android 16 (API 36)** sejak 31 Agustus 2026 |
| Akun developer | Akun **pribadi** baru wajib uji tertutup: **12 penguji, 14 hari berturut-turut** sebelum bisa produksi. Akun **organisasi** terbebas. Rencanakan ±3 minggu untuk rilis pertama |
| Data safety | Deklarasikan: info pribadi (nama, email, telepon, alamat pelanggan), info keuangan pengguna (catatan transaksi), kontak (bila impor), identitas akun Google |
| Hapus akun | Dalam aplikasi dan tautan web (bagian 4) |
| Kebijakan privasi | URL publik dan tautan di aplikasi |
| Izin sensitif | `READ_CONTACTS` untuk Impor Kontak massal berisiko ditinjau ketat. Mitigasi: "Ambil dari kontak HP" pada satu pelanggan memakai **pemilih kontak sistem** (tanpa izin). Impor massal tetap opsional dengan penjelasan izin |
| Bluetooth | Android 12+: `BLUETOOTH_CONNECT` dan `BLUETOOTH_SCAN` (dengan `neverForLocation`). Tidak perlu izin lokasi |
| Kamera | Hanya untuk foto struk pengeluaran, opsional |
| Rilis | AAB bertanda tangan, Play App Signing, jalur Internal → Closed → Production |

## 11. Hook Pro (belum ditagih)

- Model `Entitlement` dan provider `entitlementProvider` (saat ini selalu `free`, tetapi **semua fitur terbuka**).
- Pembungkus `FeatureGate(feature: ..., child: ...)` yang sekarang selalu menampilkan `child`. Dipasang di titik yang kelak dibatasi sehingga tidak perlu membongkar layar.
- Kandidat fitur Pro (belum diputuskan): multi-perangkat, ekspor lanjutan dan periode kustom, riwayat panjang, AI WhatsApp.
- Nanti: Google Play Billing (`in_app_purchase`) dan validasi pembelian di server (Edge Function) yang menulis `entitlements`.

## 12. AI (dikembangkan belakangan)

- Preview berjalan dengan `InMemoryProposalRepository` (data dummy dari PRD A). Tidak ada perubahan UI saat AI nyata dipasang.
- Rancangan: worker terpisah membaca pesan WhatsApp dan menulis `ai_proposals` lewat Edge Function (service role). Aplikasi **hanya membaca** usulan lewat sinkronisasi. Pemilik menyetujui → aplikasi membuat order lokal dan menandai usulan `approved`. **AI tidak pernah mengirim pesan.**
- **Peringatan keputusan:** menautkan WhatsApp lewat QR (perangkat tertaut) adalah jalur tidak resmi dengan risiko pelanggaran ketentuan dan pemblokiran nomor. Untuk rilis publik, evaluasi WhatsApp Business Platform (Cloud API) yang resmi, termasuk verifikasi bisnis dan biayanya. Layar Hubungkan WhatsApp saat ini hanya placeholder.

## 13. Printer thermal

- Antarmuka `PrintService` (`discover`, `connect`, `print(ReceiptData)`, `status`). Sekarang `FakePrintService`.
- `ReceiptFormatter` (fungsi murni) menghasilkan **baris 32 kolom** yang sama dipakai `ReceiptPreview` dan ESC/POS, sehingga preview dan cetakan selalu identik. Diuji dengan golden text.
- Pemilihan paket Bluetooth ESC/POS dilakukan saat fase printer; agen wajib memeriksa dukungan Android 12+ sebelum memilih.

## 14. Fase backend

| Fase | Hasil | Selesai bila |
| --- | --- | --- |
| B0 | Proyek Supabase, migrasi awal, RLS, provider Google, `delete_my_account`, CI migrasi | Tes RLS: pengguna A tidak bisa membaca data B |
| B1 | Skema Drift + repository `Drift*` menggantikan `InMemory*` layar demi layar | Semua layar PRD A berjalan di data lokal nyata, data bertahan setelah restart |
| B2 | Outbox, `SyncEngine`, status sinkron, layar Sinkronisasi | Nota dibuat offline muncul di HP kedua setelah online |
| B3 | Integrasi Auth Google, onboarding, pemulihan data, keluar dan hapus akun | Instal ulang memulihkan semua data |
| B4 | Logika ledger, piutang, laporan, tes unit | Angka laporan cocok dengan DATA MASTER |
| B5 | Printer nyata | Cetak 58 mm identik dengan preview |
| B6 | Persiapan Play Store | Closed test berjalan, Data safety dan kebijakan privasi siap |
| B7 | AI | Usulan dari worker muncul dan bisa disetujui |
| B8 | Pro | Pembelian membuka `entitlements` |

## 15. Pengujian

- Unit: semua fungsi `core/domain/` (estimasi, total, status bayar, saldo, laporan) dengan data DATA MASTER.
- Sinkron: tes simulasi dua perangkat; offline → online; konflik LWW; pelanggaran unik; putus di tengah push (idempotensi); outbox besar.
- RLS: tes otomatis lintas pengguna.
- Migrasi: dari skema versi N ke N+1 tanpa kehilangan data.
- Manual: mode pesawat saat membuat nota, instal ulang, ganti HP.

**Target kualitas:** buka aplikasi offline < 2 detik; baca lokal p95 < 100 ms; sinkron 100 perubahan < 5 detik di 4G; tidak ada kehilangan data pada skenario di atas.

## 16. Keputusan terbuka

1. Akun Play: pribadi (12 penguji x 14 hari) atau organisasi?
2. Perlu multi-perangkat sejak awal (HP kedua), atau satu HP per akun dulu? (Desain sudah mendukung keduanya.)
3. Jalur WhatsApp untuk rilis publik: resmi (Cloud API) atau tetap tidak resmi?
4. Kapan pindah ke Supabase Pro? Disarankan sebelum rilis publik luas.
5. Crash reporting (Sentry/Crashlytics) atau cukup log lokal?

## 17. Catatan iOS

Aplikasi dibangun untuk Android dan iOS dari satu basis kode, tetapi **belum ada lingkungan uji iOS**. Hal yang berbeda dan harus diputuskan sebelum iOS dirilis:

- **Printer thermal:** iOS tidak mengizinkan Bluetooth Classic (SPP) untuk aksesori non-MFi, hanya Bluetooth LE. Banyak printer thermal 58 mm murah memakai Classic. `PrintService` harus mendukung BLE (atau printer Wi-Fi/LAN) agar iOS berjalan; periksa tipe printer yang dipakai pengguna.
- **Login:** App Store umumnya mewajibkan opsi login setara bila memakai login pihak ketiga (Guideline 4.8), misalnya Sign in with Apple. Supabase mendukungnya. Perlu keputusan sebelum rilis iOS.
- **Sinkron latar:** `workmanager` di iOS dibatasi sistem dan tidak bisa dijadwalkan tiap 15 menit. Andalkan sinkron saat aplikasi aktif dan saat koneksi pulih.
- **Izin:** string izin di `Info.plist` untuk kontak, Bluetooth, dan kamera; label privasi App Store.
- **Biaya dan alat:** Apple Developer Program (berbayar tahunan) dan Mac untuk build rilis.
- **Aturan kerja:** fitur platform-spesifik diuji di Android dulu dan ditandai "belum diuji di iOS" di spec layar.
