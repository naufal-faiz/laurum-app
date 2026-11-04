# BP0 - Persiapan backend (kontrak, ID, aturan; tanpa Drift dan Supabase)
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: prompt 100 SELESAI dan pengguna sudah menguji HP. Baca: AGENTS.md aturan 17-22, docs/backend/ROADMAP.md, PRD B bagian 3.1-3.3, 5, 7, kode: core/domain/repositories/*, features/*/data/*, checkout_save.dart, order_payment_save.dart, proposal approval, OrderNumberGenerator.

Tujuan: membuat InMemory dan Drift nanti bisa diganti tanpa membongkar layar. Tidak ada perubahan perilaku yang terlihat pengguna; tes lama tidak boleh diubah ekspektasinya.

## IZIN TERTULIS (4 Nov 2026)
- pubspec: tambah HANYA `uuid`. Tanpa drift, supabase, atau paket lain.
- tool/check_arch.dart: tambah aturan 19 (impor persistensi), 20 (dilarang shared_preferences di pubspec/lib), 21 (ID tidak dari rangkaian teks, lihat langkah 2). Dengan tes alat.
- Antarmuka di core/domain/repositories: tambah metode rentang, LocalSettingsRepository baru, dan IdGenerator di core/domain. Semua dengan implementasi InMemory. Tanpa perubahan atoms/molecules/organisms/tema/registry.
- docs/prd: sinkronkan bila ada selisih nyata; jangan menulis ulang bagian lain.

## Langkah (tes lebih dulu)
1. **IdGenerator** (core/domain/id_generator.dart): `newId()` UUID v4 dan `derived(parentId, label)` UUID v5 deterministik; provider dengan fake deterministik untuk tes.
2. **Audit ID**: cari semua pembuatan ID baris (grep: `'ord-`, `-pay-`, `-payment-`, `-savings`, `-event-`, `-status-`, `cust-`, `'$`). Ganti ID baris baru dengan newId(). Gunakan derived() hanya bila kode bergantung pada percobaan ulang yang idempoten (contoh: order dari usulan AI harus derived dari proposalId). ID hitungan (`-payment-N`) dilarang. Fixture boleh tetap teks (dipetakan saat seed di B1f). Buat tabel hasil audit di docs/progress/bp0-id.md (lokasi, keputusan v4/v5).
3. **Metode rentang**: OrderRepository.getOrdersInRange(range, {status}), getPaymentsInRange(range); ExpenseRepository.getExpensesInRange(range); SavingsRepository tetap (saldo sudah per pelanggan). Implementasi InMemory + tes. Pemakai laporan/antrean boleh tetap memakai metode lama sampai B1d/B1e.
4. **LocalSettingsRepository** (get/set String dan Int dengan kunci): InMemory + tes. Dipakai untuk kode perangkat (default `A`), counter nota, printer terpasang. OrderNumberGenerator menerima kode perangkat dan counter dari repository ini; nomor nota fixture tidak berubah (urut tetap melanjutkan nomor tertinggi yang ada).
5. **Tes kontrak**: test/contracts/<repo>_contract.dart berisi fungsi `runXxxRepositoryContract(Factory)` untuk Customer, Service, Business, Order, Savings, Expense, LocalSettings. Pindahkan/ekstrak tes repository yang ada ke suite ini (perilaku sama), InMemory menjalankannya. Tambahkan konstruktor `.empty()` pada InMemory yang perlu (kontrak membutuhkan repository kosong) tanpa mengubah konstruktor berfixture yang dipakai tes lama.
6. **TransactionRunner**: tambahkan tes kontrak runner (atomik, bersarang, lempar ulang) yang nanti dijalankan juga terhadap Drift.
7. **check_arch**: terapkan aturan baru; seluruh kode saat ini harus lolos tanpa daftar pengecualian baru.
8. Perbarui STATE; check_all hijau. Laporkan: jumlah ID yang diganti, daftar yang memakai derived(), jumlah suite kontrak, temuan.

Prompt berikutnya: B1a-drift-fondasi.md (atau B0-supabase.md bila pengguna ingin server dulu; keduanya hanya bergantung pada BP0).
