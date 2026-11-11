# 017 � Loader pembukaan data lokal

Koreksi pengguna 11 Nov 2026; prasyarat FigCraft frame 408 terbaca.
Tujuan: ganti ikon gate Membuka data lokal dengan AppLoader terpusat;
pertahankan judul, deskripsi, error aman dan retry. Hindari loader berlapis.

- lib/app.dart: AppLoader + judul/deskripsi dalam grup Center layar penuh.
- Gate menunggu penyimpanan DAN pembacaan awal provider Beranda yang sudah ada
  (antreanData, customerDirectory, reportView), hanya saat gate lokal aktif dan
  AccountStore tersedia. Ini penggabungan presentasi loading yang diminta pengguna;
  tidak ada provider/state/data/aksi repository baru atau perubahan rute.
- Hanya data yang belum pernah tersedia menahan gate; refresh bernilai lama
  tidak mengganti navigator dengan loading dan tetap mempertahankan state layar.
- Error query diteruskan ke UI error/retry halaman yang sudah ada, bukan ditelan.
- Lepas AppLoader sekunder Beranda/Antrean; kembalikan skeleton lama untuk
  mode tanpa gate serta loading halaman. Startup lokal nyata menunggu data siap
  sebelum halaman ditampilkan, sehingga tidak ada pergantian dua loader.
- Perubahan padding AntreanPage yang sudah ada sebelum sesi dipertahankan.

Paritas: storageGateEnabled/accountStore, retry invalidate(accountStore), pesan
error aman, sumber data/callback halaman, kosong, filter, COD dan Key tetap.
Tes: posisi pusat + deskripsi, opening->data awal bertahap->halaman (satu loader),
refresh tidak melepas navigator, storage error/retry lama, golden loading.
Golden diperkirakan bergeser: antrean_loading dan tujuh antrean lain bila padding
manual pengguna berpengaruh; r4_antrean_sederhana, r9_cod_queue. Daftar akhir dicatat.
Tidak ada komponen/token/dependensi baru. iOS belum diuji.

Hasil pembaruan golden: local_storage_loading.png baru; antrean_loading.png
menampilkan skeleton kembali. antrean_normal/proses/whatsapp bergeser karena
padding pengguna yang dipertahankan. Golden lain tetap sama (total 5 berkas).
Tes lama storage_gate menunggu tiga future data sebelum settle agar I/O Drift
selesai nyata, tanpa mengurangi assertion error aman, retry dan hitungan attempt.
Tes antrean_states mengembalikan finder skeleton; seluruh aksi lama tetap diuji.
Codebase-memory terputus; penelusuran dan bukti memakai pembacaan berkas langsung.

## Paritas koreksi
| Butir | Status | Bukti |
|---|---|---|
| storageGateEnabled/accountStore, mode tanpa gate | Lengkap | storage_gate + antrean_states |
| Judul/deskripsi loading dan posisi Center | Lengkap | storage_loading_presentation + golden + Android |
| Storage error aman, Coba lagi, invalidate yang sama | Lengkap | storage_gate, attempt tetap 2 |
| Data awal bertahap, satu AppLoader/Element | Lengkap | storage_loading_presentation |
| Refresh mempertahankan navigator | Lengkap | storage_loading_presentation |
| Query error tidak tersangkut; retry ke halaman | Lengkap | storage_gate_query_error |
| Sumber data, aksi order/COD, Key halaman | Lengkap | Drift/payment/antrean_states |

Bukti akhir 11 Nov 2026: check_all exit 0, format 979 (0 berubah), analyzer dan
Riverpod bersih, check_arch OK, 1042 tes lulus/1 skip, REPO_MAP 1057 berkas.
Log lokal: TEMP/laurum-local-loader-check-all-complete.log. Tidak ada zona beku
berubah: state/data/domain/repository, persistensi/sync, rute, dependensi, token,
registry, tool, lint, PRD dan supabase tetap. Root hanya mengamati provider yang
sudah ada untuk menyatukan presentasi startup sesuai koreksi pengguna.
Android: loader/judul/deskripsi terpusat dipratinjau melalui entry TEMP yang
menahan store, lalu main.dart normal dijalankan; Beranda tampil dengan data lokal
tersimpan. Entry diagnostik dan screenshot perangkat dibersihkan; bukti di TEMP
dipertahankan. iOS belum diuji.
