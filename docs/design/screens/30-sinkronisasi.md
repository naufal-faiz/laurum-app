# 30 - Sinkronisasi
Rute: /lainnya/sinkronisasi | Prompt: 90
Perilaku backend nyata (perbaikan 13 Nov 2026, PRD B §4/§7):
- Saat akun dibuka, jalankan siklus Supabase push/pull sebelum menentukan setup.
  Akun lama di HP baru memakai profil/pelanggan/antrean yang dipulihkan.
- Sinkron manual menunggu siklus aktif lalu menjalankan siklus berikutnya;
  push tertahan tetap memberi kesempatan pull, tanpa membuang outbox lokal.
- Pull berkomit memberi notifikasi ke query halaman, sehingga daftar yang semula
  nol diperbarui tanpa perlu login ulang. Foreground/koneksi pulih tetap memicu sinkron.
- Status lokal conflict tetap bisa dibaca; kegagalan sinkron tidak mengunci data.
- Data profil/pengaturan struk ganda dari perangkat lama dibaca dengan urutan stabil
  created_at/id (yang tertua aktif); baris lain tetap disimpan, tidak dihapus.
- Error pembukaan lokal: Coba lagi menutup/membuka ulang koneksi dengan menunggu
  pekerjaan sync selesai; Keluar akun mempertahankan file/outbox sebagai jalan keluar.
- Request jaringan dibatasi 15 detik, bootstrap menunggu maksimal 20 detik lalu
  tetap menyediakan data lokal. Retry berhasil juga menuntaskan metadata setup.
- Teruji dua sesi/satu akun pada Supabase lokal: fetch awal, perubahan dua arah,
  dua transaksi, profil legacy ganda; isolasi dua akun tetap diuji terpisah.

Catatan historis B1f/dummy berikut bukan perilaku build backend saat ini:
Pembaruan B1f: main memakai DriftSyncService. Pending berasal dari COUNT outbox,
termasuk sesudah restart. Nol = tersimpan lokal; ada antrean = menyimpan.
Sinkron sekarang membaca ulang jumlah, tidak mengirim atau menghapus outbox;
lastSyncedAt tetap kosong sampai mesin kirim B2 tersedia. Belum ada klaim sinkron server.
Bagian perilaku palsu di bawah hanya berlaku untuk mode memory/tes dummy.
Database native belum diuji di iOS; hasil Android dicatat di docs/progress/b1f.md.

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
