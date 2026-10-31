# R4: kelompok Antrean

- Pertahankan kontrak filter internal 0..4 agar pilihan Perlu dicek tetap stabil.
- Mode sederhana memetakan chip ke Semua (0) dan Perlu dicek (4).
- Filter status lama diperlakukan sebagai Semua selama mode sederhana.
- Kartu aktif tetap terbuka, tombol maju disembunyikan dengan showAction.
- Tambahan statusLabel OrderCard disetujui pengguna (proposal 001).
- Guard controller agar mode sederhana tidak memajukan status melalui callback lama.
- Tes logika sebelum implementasi; tes kedua mode dan perpindahan mode/filter.
- Spec/katalog, golden bila perlu, check_all, STATE dan commit; tanpa push.
