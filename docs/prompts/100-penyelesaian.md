# 100 - Penyelesaian UI dummy
Ikuti _COMMON.md bagian A, D, E, F. Prasyarat: prompt 90 SELESAI. Baca: PRD A bagian 10 (Definition of Done) dan 12 (penerimaan global).

TUGAS
1. Audit: jalankan check_all, periksa REPO_MAP (60/60 widget), cari file di atas 100 baris, widget di luar registry, angka yang tertulis langsung, dan teks terlarang (jatuh tempo, Paket, Reset (C), TB-07, Terverifikasi, Berkah Cloud).
2. Kelengkapan state: setiap layar punya state kosong, loading, dan error yang relevan; banner offline dan gagal sinkron berfungsi di layar utama.
3. Aksesibilitas: label Semantics pada ikon dan tombol ikon, area sentuh minimal 44, tidak overflow pada skala teks 1,3.
4. Tes alur akhir PRD A bagian 12: buat nota (pelanggan baru, layanan, berat, bayar tabungan + tunai) -> nota tersimpan -> Antrean -> tandai siap -> serahkan -> Laporan berubah.
5. Bandingkan semua layar dengan .pen; tulis tabel selisih akhir di docs/progress/fase-ui.md.
6. Perbarui README, component_catalog.md, dan semua spec layar. Buat tag git ui-dummy-v1 hanya jika pengguna meminta.
7. Coba `flutter build apk --debug`. Jika Android SDK belum tersedia, catat sebagai BLOKIR di STATE.md dan laporkan; jangan menandai selesai tanpa APK berjalan.

Laporkan: hasil audit, daftar selisih terakhir, keputusan yang menunggu, dan saran urutan backend (PRD B bagian 14).


Tambahan (25 Okt 2026): audit akhir mencakup tes keyboard seluruh layar berinput (AGENTS 16e) dan pemeriksaan bahwa tool/section_riverpod_debt.txt tidak bertambah.
