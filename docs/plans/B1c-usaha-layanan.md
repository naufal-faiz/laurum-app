# B1c - Usaha, layanan dan pengaturan struk

Scope: prompt B1c; tanpa perubahan tampilan, dependensi atau wiring Drift B1f.

1. Baseline check_all dan verifikasi B1b/git; telusuri repository serta printer.
2. Tambah kontrak ReceiptSettingsRepository; jalankan suite yang sama di memory/Drift.
3. Perluas kontrak usaha/layanan: semua field bisnis, default status order,
   sort_order stabil, filter aktif/soft delete; metadata diuji terpisah seperti B1b.
4. Implementasi mapping dan repository Drift dengan owner scope, timestamp lokal,
   pending dan outbox atomik. Satu profil/struk per akun; ID tetap setelah disimpan.
   Pembacaan kosong memakai default dengan UUID tanpa menulis database/outbox.
5. Pertahankan API struk BusinessRepository sebagai jembatan kompatibilitas;
   adapter InMemory berbagi sumber state yang sama untuk notifikasi/cleanup.
6. PrinterSettingsController memakai repository struk; simpan profil+struk melalui
   TransactionRunner. Pilihan printer tetap LocalSettingsRepository tanpa outbox.
7. Uji injeksi gagal outbox, rollback gabungan, metadata/payload, owner, singleton,
   baca ulang koneksi database dan integrasi controller printer/status order.
8. check_all hijau, self-review <=100 baris, STATE/INDEX/laporan, commit lalu berhenti.

AI preferences tetap InMemory sampai B7. Skema v2 sudah memuat seluruh kolom B1c;
tidak perlu mengubah skema/snapshot bila query repository cukup untuk invariant lokal.
Supabase cloud/key tidak diperlukan.
