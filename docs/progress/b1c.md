# B1c - Usaha, struk, layanan dan pengaturan lokal (4 Nov 2026)

Status: SELESAI; check_all akhir hijau, exit 0.
Baseline bersih: commit 8821b17, check_all 759 tes hijau, exit 0.
Bukti baseline: %TEMP%/laurum-b1c-baseline-clean.log.
Percobaan baseline pertama tercampur tes baru; tidak dipakai sebagai bukti baseline.

## Implementasi

- DriftBusinessRepository: satu profil per owner, default useOrderStatus true,
  semua field profil termasuk footer/note, timestamp lokal/pending, outbox atomik.
- DriftServiceRepository: kiloan/satuan, harga int, durasi, status aktif, sortOrder,
  soft delete dan outbox. Katalog diurutkan sortOrder lalu posisi insert (rowid lokal).
  Upsert tidak memindahkan urutan ketika sortOrder sama; InMemory memakai aturan sama.
- ReceiptSettingsRepository baru dengan InMemoryReceiptSettingsRepository dan
  DriftReceiptSettingsRepository; opsi kertas/font/empat toggle mengikuti akun.
  BusinessRepository mewarisi antarmuka struk sebagai jembatan kompatibilitas.
- Adapter InMemory berbagi state bisnis lama: notifikasi, rollback dan cleanup akun
  tetap melalui satu sumber. Dummy overrides menyediakan provider struk baru.
- PrinterSettingsController dan receiptViewProvider memakai repository struk baru.
  Penyimpanan struk + footer/note memakai TransactionRunner. Profil terbaru dibaca
  dalam transaksi agar nama/status order yang berubah setelah form dibuka tidak tertimpa.
- copySettings/copyProfile mempertahankan syncState/deletedAt; metadata Drift saat
  mutasi tetap diisi repository. Payload outbox snake_case, timestamp UTC ISO,
  tanpa sync_state. Validasi owner mencegah penimpaan ID milik akun lain.
- Pilihan printer tetap printer_id/printer_name di LocalSettingsRepository.
  Tes integrasi membuktikan pilihan printer tidak menghasilkan baris outbox/struk.

## Skema dan identitas

Skema tetap v2/16 tabel. Semua kolom B1c sudah tersedia; snapshot v1/v2 tidak diubah.
Transaksi repository menolak ID profil/struk baru jika owner sudah punya baris.
Tidak mengganti ID atau menghapus baris lama diam-diam. Batas satu baris ini berlaku
pada penulisan repository lokal; penulisan langsung SQL/sinkron harus menjaga invariant
yang sama pada tahap berikutnya. Belum ada constraint UNIQUE(owner_id) pada dua tabel.

Pembacaan akun kosong mengembalikan default tanpa menulis database/outbox. ID default
memakai IdGenerator UUID v4, stabil sepanjang instance repository. UUID baru yang belum
disimpan bisa berbeda pada instance lain; setelah tersimpan seluruh instance membaca ID
baris yang sama. Tidak membuat ID domain dari teks atau hitungan.

## Verifikasi

- Tes kontrak usaha/layanan yang sama berjalan pada InMemory dan Drift.
- Suite baru struk berjalan pada InMemory dan Drift: default dan seluruh opsi bolak-balik.
- Kontrak membandingkan seluruh field bisnis; updatedAt/syncState diuji terpisah seperti B1b.
- Tes sebelum implementasi gagal: repository belum ada dan katalog InMemory belum berurutan.
- 84 tes terarah lolos: kontrak, owner/ID, singleton, metadata, injeksi trigger outbox,
  rollback profil+struk beserta retry, database file ditutup/dibuka ulang, pengaturan
  status order setelah form dibuka, LocalSettings printer, regresi halaman/golden printer.
- Log: %TEMP%/laurum-b1c-red.log dan %TEMP%/laurum-b1c-targeted.log.
- check_all akhir: 781 tes lolos, flutter analyze dan dart analyze bersih,
  check_arch OK, REPO_MAP 804 berkas, exit 0. Bukti %TEMP%/laurum-b1c-check.log:

```text
04:07 +781: All tests passed!
REPO_MAP diperbarui: 804 berkas
check_all: SEMUA HIJAU
```

- Self-review: seluruh Dart baru/tersentuh <=100 baris (maksimal main_dummy.dart 98);
  tidak ada lint ignore. Pemeriksaan whitespace bersih. Skema, snapshot, dependensi,
  registry dan token tidak berubah. Analyzer akhir dan check_arch sudah bersih.
- Repository Drift usaha/struk/layanan masing-masing 68/54/63 baris;
  PrinterSettingsController beserta state tetap dalam berkas 91 baris. Widget/layar baru: 0.

## Batas dan tinjauan

- Tidak ada widget/layar baru atau perubahan tampilan. Spec 06 diperbarui untuk aliran data.
  Golden printer lama tetap cocok; acuan frame diperiksa lewat tool/pen_frame.dart.
  Selisih visual yang sudah dicatat di spec tetap berlaku.
- AiPreferences TETAP in-memory sampai B7; belum ikut persistensi/sinkron.
- Aplikasi tetap InMemory sampai B1f; repository Drift diuji SQLite native Windows.
  Database Android/iOS belum diuji. Printer asli tetap ditunda.
- Tidak menambah dependensi atau mengubah registry, tema, lint, fixture maupun PRD.
- Supabase cloud/key belum dibutuhkan. Berikutnya B1d-drift-order-pembayaran.md.
