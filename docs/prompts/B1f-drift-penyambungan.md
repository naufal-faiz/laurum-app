# B1f - Drift: penyambungan ke aplikasi dan penutup fase
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: B1e SELESAI. Baca: AGENTS 19-22, lib/main.dart, core/services/repository_providers.dart, local_data_service.dart, sync_service.dart, features/auth/data/*, docs/backend/ROADMAP.md.

## IZIN TERTULIS (4 Nov 2026)
- main.dart dan repository_providers.dart: mode penyimpanan lewat `--dart-define=LAURUM_STORE=drift|memory`; default setelah fase ini = drift. Tes widget lama tetap memakai InMemory lewat override.
- Menambah DemoSeeder (hanya build debug/profile atau --dart-define=DEMO_SEED=true) yang memuat DATA MASTER ke database; ID fixture dipetakan ke UUID v5 (pemetaan deterministik, ada tes). Release pertama kali kosong dan masuk onboarding.
- SyncService.pendingChanges untuk implementasi nyata = jumlah baris outbox (FakeSyncService tetap untuk tes). Mesin kirim BUKAN bagian fase ini.

## Isi
1. Penyedia database per akun: DB dibuka dari ownerId sesi (dummy auth R10 sudah punya currentUserId); keluar menutup database dan mempertahankan berkas; masuk dengan akun lain membuka berkas lain; Hapus akun memanggil penghapusan berkas lewat LocalDataService.
2. Semua layar berjalan di Drift: tes alur nyata (buat nota, COD, bayar sebagian, kelebihan ke tabungan, batal, laporan, pengeluaran) lewat widget test dengan Drift in-memory, ditambah tes persistensi: tulis, tutup database, buka ulang, data tetap ada, outbox terisi.
3. Keadaan kosong, loading, dan error database di layar utama (gagal membuka database: pesan jelas, tanpa teks pengecualian mentah).
4. Pengaturan AI/usulan/WhatsApp tetap in-memory (B7): tampilkan keterangan di dokumen dan catat di STATE; jangan menyembunyikan di UI tanpa keputusan pengguna.
5. Benchmark akhir: buka aplikasi dengan seed 5.000 order, waktu ke Beranda (target < 2 detik di perangkat uji, laporkan di emulator/HP); baca lokal p95.
6. Bersihkan: hapus kode InMemory yang tidak dipakai produksi dari jalur release (tetap ada untuk tes/demo), perbarui README, spec yang terdampak, STATE, REPO_MAP; check_all hijau.
7. Laporkan "Yang perlu ditinjau" di HP: tutup-buka aplikasi (data bertahan), mode pesawat, ganti akun. Sarankan penyusunan prompt B2 dan B3 berdasarkan temuan.

Prompt berikutnya: B2 (belum ditulis; minta penyusunan setelah B1f SELESAI) atau B0 bila server belum dikerjakan.
