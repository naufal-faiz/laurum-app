# Peta Layar ke Frame Figma (Redesign UI Laurum)

Dokumen ini memetakan spec layar di `docs/design/screens/` ke frame Figma/FigCraft.
Sesuai aturan UI-4 di `AGENTS.md`: frame diisi oleh pengguna per sesi (dilarang menebak frame).

| Layar | Frame Figma | Status | Selisih |
|---|---|---|---|
| `01-beranda.md` (01 — Beranda) | `LAURUM · Beranda` (ID: 281) | Koreksi 013 selesai; check_all hijau; Android diperiksa | Header tetap di AppBar, padding 16, layanan teratas, font lebih besar, banner lebih renggang; lihat spec |
| `01-antrean-beranda.md` (01 — Antrean) | `LAURUM · Antrean` (ID: 408) | 015/016 selesai; check_all hijau; Android diperiksa | Ringkasan dirapatkan, subjudul primary, modal di atas nav; loader pada gate lokal (014/017); dua preview AI dan seluruh aksi lama tetap |
| Gate Membuka data lokal (lib/app.dart) | Tanpa frame khusus; aset loader dan instruksi eksplisit pengguna 11 Nov, proposal 017 | 017 selesai; check_all hijau; Android diperiksa | Loader terpusat + judul/deskripsi; satu tahap sampai data awal siap |
| Nav bawah global (semua tab) | `LAURUM · Beranda` Nav Bawah (ID: 388) dan `LAURUM · Antrean` Nav Bawah (ID: 494) | Selesai (kode) | Laporan diganti Beranda; ikon lama dipertahankan |
| `02-buat-transaksi.md` (02 - Buat Transaksi) | | Menunggu | |
| `03-pilih-layanan.md` (03 - Pilih Layanan) | | Menunggu | |
| `04-input-berat.md` (04 - Input Berat) | | Menunggu | |
| `05-tambah-pelanggan-cepat.md` (05 - Tambah Pelanggan Cepat) | | Menunggu | |
| `06-printer-struk.md` (06 - Printer dan Struk) | | Menunggu | |
| `07-pembayaran.md` (07 - Pembayaran) | | Menunggu | |
| `08-nota-tersimpan.md` (08 - Nota Tersimpan) | | Menunggu | |
| `09-detail-order.md` (09 - Detail Order) | `LAURUM · Detail Order` (ID: 612) | Persiapan 018–020 disetujui | Komponen bersama dahulu; seluruh mode/status/COD/aksi lama tetap |
| `10-edit-order.md` (10 - Edit Order) | | Menunggu | |
| `12-daftar-pelanggan.md` (12 - Pelanggan - Daftar Pelanggan) | | Menunggu | |
| `13-detail-pelanggan.md` (13 - Detail Pelanggan & Tabungan) | | Menunggu | |
| `14-edit-pelanggan.md` (14 - Edit Pelanggan) | | Menunggu | |
| `15-setor-tabungan.md` (15 - Setor Tabungan) | | Menunggu | |
| `16-riwayat-tabungan.md` (16 - Riwayat Tabungan) | | Menunggu | |
| `17-impor-kontak.md` (17 - Impor Kontak HP) | | Menunggu | |
| `18-daftar-piutang.md` (18 - Daftar Piutang) | | Menunggu | |
| `18-laporan-ringkasan.md` (18 - Laporan - Ringkasan) | | Menunggu | |
| `19-pengaturan-akun.md` (19 - Pengaturan dan Akun) | | Menunggu | |
| `20-daftar-layanan.md` (20 - Daftar Layanan) | | Menunggu | |
| `21-form-layanan.md` (21 - Tambah dan Edit Layanan) | | Menunggu | |
| `22-info-usaha.md` (22 - Info Usaha) | | Menunggu | |
| `23-daftar-pengeluaran.md` (23 - Daftar Pengeluaran) | | Menunggu | |
| `24-catat-pengeluaran.md` (24 - Catat Pengeluaran) | | Menunggu | |
| `25-detail-usulan-ai.md` (25 - Detail Usulan AI) | `LAURUM · Detail Usulan AI` (ID: 512) | Selesai 018-020 | Android + keyboard diperiksa; 1060 tes lulus; tanpa fitur berat/jadwal baru |
| `26-riwayat-usulan-ai.md` (26 - Riwayat Usulan AI) | | Menunggu | |
| `27-pengaturan-ai.md` (27 - Pengaturan AI & WhatsApp) | | Menunggu | |
| `28-hubungkan-whatsapp.md` (28 - Hubungkan WhatsApp) | | Menunggu | |
| `29-masuk-google.md` (29 - Masuk email/password dan Google) | `LAURUM · Masuk` (ID: 4294968692) | Selesai (kode) | Hero + kartu + fitur bar statis; back button dihapus; T&C ditunda |
| `30-sinkronisasi.md` (30 - Sinkronisasi) | | Menunggu | |
| `31-daftar.md` (31 - Daftar dan Cek email) | `LAURUM · Daftar` (ID: 4294968748) | Selesai (kode) | Hero 230 + kartu; Google ditambahkan; T&C ditunda |
| `32-lupa-password.md` (32 - Lupa password) | | Menunggu | |
| `33-kelola-akun.md` (33 - Kelola akun) | | Menunggu | |

---

### Referensi Frame Terdeteksi di FigCraft (`docs/design/new-design-laurum.figcraft`)
Daftar frame level teratas yang terbaca dari dokumen aktif FigCraft:
- `LAURUM · Beranda` (ID: 281)
- `LAURUM · Antrean` (ID: 408)
- `LAURUM · Detail Usulan AI` (ID: 512)
- `LAURUM · Detail Order` (ID: 612)
- `LAURUM · Buat Transaksi` (ID: 691)
- `LAURUM · Buat Transaksi · Layanan Dipilih` (ID: 752)
- `LAURUM · Pilih Pelanggan` (ID: 821)
- `LAURUM · Pilih Layanan` (ID: 895)
- `LAURUM · Pelanggan Baru` (ID: 1075)
- `LAURUM · Pembayaran` (ID: 1146)
- `LAURUM · Buat Transaksi` (ID: 1247)
- `LAURUM · Buat Transaksi` (ID: 1309)
- `LAURUM · Struk Pembayaran` (ID: 4294967599)
- `LAURUM · Struk COD` (ID: 4294967729)
- `LAURUM · Detail Order COD` (ID: 4294967861)
- `LAURUM · Detail Order COD · Catat Pembayaran` (ID: 4294967961)
- `LAURUM · Lainnya` (ID: 4294968100)
- `LAURUM · Tambah Layanan` (ID: 4294968237)
- `LAURUM · Laporan` (ID: 4294968337)
- `LAURUM · Laporan · Pilih Tanggal` (ID: 4294968452)
- `LAURUM · Masuk` (ID: 4294968692)
- `LAURUM · Daftar` (ID: 4294968748)
- `LAURUM · Kelola Akun` (ID: 4294968821)
- `LAURUM · Info Usaha` (ID: 4294968909)
- `LAURUM · Lupa Password` (ID: 4294968977)
- `LAURUM · Verifikasi OTP` (ID: 4294969044)
- `LAURUM · Password Baru` (ID: 4294969106)
- `LAURUM · Printer & Struk` (ID: 4294969167)
- `LAURUM · Cari Printer Bluetooth` (ID: 4294969275)
- `LAURUM · Printer & Struk — Terhubung` (ID: 4294969351)
