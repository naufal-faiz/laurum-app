# Keputusan Desain Global (Redesign UI Laurum)

Diisi oleh PENGGUNA. Agent dilarang mengisi kolom "Keputusan pengguna" dan dilarang
memperlakukan kolom "Usulan" sebagai keputusan (AGENTS.md UI-22). Selama kolom keputusan
kosong, lapisan token (UI-21 lapisan 1) belum boleh dimulai.

Fakta diambil dari analisis snapshot branch newdesign (9 Nov 2026):
dokumen `docs/design/new-design-laurum.figcraft` dan `lib/core/theme/`.

Keputusan pengguna dicatat dari persetujuan lisan sesi 10 Nov 2026 ("ya semua") atas
kelima usulan, oleh agen, sebagai transkripsi — bukan pilihan agen (UI-22).

| # | Keputusan | Fakta | Usulan | Keputusan pengguna |
|---|---|---|---|---|
| 1 | Warna primer dan peran hijau lama | Figma: #2675C9 (212x), #174B83 (191x), ink #26364A (416x), label #7C8DA3 (340x) dominan di SEMUA frame, termasuk Beranda dan Antrean. Kode global: `AppColors.primary` = #00653B (hijau). Hijau #2F7D4F (25x) dan #E9F5EE (16x) tetap ada di Figma, kemungkinan status sukses. | Primer biru #2675C9, aksen gelap #174B83, ink #26364A, label #7C8DA3. Hijau lama menjadi token status sukses (bukan primer). | DISETUJUI 10 Nov 2026 ("ya semua"): primer biru #2675C9, aksen #174B83, ink #26364A, label #7C8DA3; hijau menjadi status sukses. |
| 2 | Font global | Figma: Inter di 1.081 dari 1.081 teks. Kode global: Plus Jakarta Sans; auth sudah Inter. | Inter menjadi font global. Berkas PlusJakartaSans dihapus dari assets setelah migrasi (perubahan pubspec perlu izin terpisah). | DISETUJUI 10 Nov 2026 ("ya semua"): Inter menjadi font global; Plus Jakarta Sans dihapus setelah migrasi. Perubahan `pubspec.yaml` tetap dimintakan izin berkas pada proposal lapisan token. |
| 3 | Skala tipografi dan ukuran minimum | Figma: 775 dari 1.081 teks (72%) berukuran 10,5 px atau kurang pada kanvas 390 lebar. Auth sudah dinaikkan: label 12, input 14, tombol 15, body 12, meta 11, chip 10,5. | Skala auth menjadi dasar skala global; ukuran minimum 11 (chip 10,5 menjadi 11). Perlu diverifikasi di perangkat. | DISETUJUI 10 Nov 2026 ("ya semua"): skala auth menjadi dasar global, ukuran minimum 11 (chip 10,5 → 11), verifikasi di perangkat Android. |
| 4 | Varian ukuran tombol | Figma memuat 6 kombinasi tinggi/radius tombol biru: 44/12 (9x), 50/14 (6x), 46/13 (4x), 40/12 (3x), 48/13 (2x), 54/14 (2x). | Tiga ukuran: besar 50/r14 (aksi utama form), sedang 44/r12 (bawaan), kecil 40/r12. | DISETUJUI 10 Nov 2026 ("ya semua"): tiga ukuran — besar 50/r14, sedang 44/r12, kecil 40/r12. |
| 5 | Variabel dan komponen di FigCraft | Dokumen FigCraft: 0 komponen/instance, 0 variabel, 0 style (format dokumen memiliki bidang `styles` dan `variables`). | Buat variabel (warna, radius, spacing, tipografi) dan komponen untuk pola berulang sebelum lapisan atoms, dengan nama sejajar `widget_registry.yaml`. | DISETUJUI 10 Nov 2026 ("ya semua"): buat variabel & komponen FigCraft sebelum lapisan atoms. Catatan sesi: FigCraft MCP tidak tersambung (port 9876 tidak listen); verifikasi file lewat `figcraft-cli info` (headless). |
