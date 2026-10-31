# R4 - Fondasi mode status order (draf tanpa SDK)
1. Tambahkan BusinessProfile.useOrderStatus default true dan props.
2. Siapkan salinan profil yang mempertahankan metadata serta nilai pengaturan.
3. Pastikan simpan Info Usaha dan pengaturan struk tidak mereset mode.
4. Tambah aturan awal status, label, dan nextStatus dengan flag eksplisit.
5. Pertahankan seluruh perilaku default dan proteksi status final.
6. Tulis tes domain, persamaan model, dan persistensi profil (belum dijalankan).
7. Jangan tampilkan toggle sebelum seluruh alur mode nonaktif tersambung.
8. Lanjutan: repository order, settings/toggle, checkout/AI, Antrean, Detail, cetak.
9. Setelah integrasi: satu kolom sinkron PRD B sesuai izin R4, spec dan tes layar.
10. Di perangkat SDK: format/analyze, tes R3/R4, golden dan check_all.

31 Oktober 2026: fondasi dan guard repository selesai otomatis; 396 tes hijau.
Berikutnya provider/toggle dan integrasi layar/cetak. R4 tetap parsial.
