# 30 - Sinkronisasi (dummy, layar baru)
Rute: /lainnya/sinkronisasi | Prompt: 90
Tidak ada frame .pen. Disusun dari registry sesuai prompt; template SubScaffold.
Komposisi: SyncStatusSection (AppCard status/jumlah tertunda/waktu terakhir,
AppButton Sinkron sekarang, BannerMessage offline/gagal, contoh konflik informasi).
Provider: syncViewProvider/syncActionsProvider/shellSyncProvider, SyncService palsu.

Status: tersimpan, menyimpan, offline, gagal. SyncIndicator di semua AppBarRoot
mengikuti service yang sama. Offline tidak mengunci data lokal; banner persis:
Mode offline. Data tersimpan di HP dan disinkronkan otomatis.
Perubahan repository dummy menaikkan penghitung per mutasi repository; bukan outbox
baris database nyata. Offline/gagal menjaga status dan antrean. Sinkron sekarang
menampilkan busy, berhasil mengosongkan counter dan memperbarui timestamp;
gagal menjaga antrean dan menyediakan retry. Sinkron juga dicoba setelah login/setup.
Timer periodik, foreground hook, backoff dan upload foto belum diimplementasikan.

Fixture: awal tersimpan/0, sinkron terakhir 16 Okt 2026 10.43 WIB.
Contoh konflik nomor Pak Dedi hanya ilustrasi aturan gabung/ganti nomor, bukan
rekaman tambahan atau alat penyelesaian konflik server. Contoh disembunyikan
sesudah hapus akun agar data demo lama tidak muncul pada akun baru.
Format tanggal/jam melalui Formatters. Tidak ada backend atau jaringan nyata.
Verifikasi: empat status/golden, tulis -> pending -> sync, retry, offline/data tetap
bisa diakses, indikator lintas rute root, 320 px/teks 2x. Perangkat belum diuji.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
