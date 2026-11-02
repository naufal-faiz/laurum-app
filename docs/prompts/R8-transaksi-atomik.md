# R8 - Pembungkus transaksi lintas repository (fondasi, tanpa fitur baru)
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: prompt 90 SELESAI. Baca: AGENTS.md aturan 17, docs/revisi/REVISI-02.md (bagian Fondasi), STATE.md bagian "Keputusan dan batas" (catatan rollback), core/services/repository_providers.dart, order_detail_controller.dart (cancel), checkout_save.dart, proposal approval (features/proposals/state).

Masalah: simpan nota + setoran tabungan, batal order + koreksi tabungan, dan persetujuan usulan AI menulis ke beberapa repository secara berurutan. Gagal di tengah meninggalkan data setengah jadi (sekarang ditambal dengan kompensasi soft-delete). R9 menambah satu lagi (pembayaran + kelebihan ke tabungan). Di backend nanti ini harus menjadi SATU transaksi SQLite.

## IZIN TERTULIS (2 Nov 2026)
- Menambah core/services/transaction_runner.dart (antarmuka) dan implementasi in-memory di features/*/data atau core/services (pilih yang paling sedikit memindah berkas), plus provider di repository_providers.dart.
- Menambah kemampuan snapshot/restore internal pada repository in-memory (tanpa mengubah antarmuka repository abstrak di core/domain/repositories).
- Memperbarui docs/prd/prd-b-backend.md satu paragraf: TransactionRunner dipetakan ke satu transaksi database lokal; tanpa perubahan atoms/molecules/organisms/tema/registry/dependensi.

## Perilaku
- Antarmuka: `Future<T> run<T>(Future<T> Function() body)`. Semua penulisan di dalam body sukses bersama atau dibatalkan bersama. Pemanggilan bersarang bergabung ke transaksi terluar. Pengecualian dilempar ulang setelah rollback.
- Implementasi in-memory: ambil snapshot semua repository yang punya data tulis (order, item, pembayaran, event, tabungan, pelanggan, usulan, pengeluaran, profil) sebelum body; pulihkan semuanya bila body melempar. Counter pending sinkron (sync) ikut dipulihkan.
- Pakai di: saveCheckout, cancel order (order + koreksi pembayaran + tabungan), persetujuan usulan AI (ganti kompensasi soft-delete pelanggan baru dengan rollback sungguhan; pertahankan perilaku retry tidak membuat ganda), dan pembersihan data akun bila melibatkan beberapa repository.

## Langkah (tes lebih dulu)
1. Tes runner: sukses menyimpan semua; kegagalan di tulis ke-2 membatalkan tulis ke-1; bersarang; pengecualian dilempar ulang; counter pending pulih.
2. Tes alur: untuk tiap pemakai di atas, sisipkan repository palsu yang gagal di tengah dan pastikan tidak ada perubahan di repository lain (nota, tabungan, pelanggan).
3. Terapkan runner di pemakai; hapus kode kompensasi yang tidak diperlukan; semua tes lama hijau tanpa mengubah ekspektasi perilaku sukses.
4. Perbarui STATE (hapus catatan "pembatalan order/tabungan belum rollback lintas repository").

Prompt berikutnya: R9-pembayaran-cod.md.
