# REVISI-02 - Pembayaran COD dan akun (2 Nov 2026)
Sumber: usulan pengguna setelah audit dev1rev (R0-R7, prompt 71/80/90 selesai). Dikerjakan lewat R8-R10, SEBELUM prompt 100.

## Daftar revisi
| No | Permintaan | Keputusan | Prompt | Status |
| --- | --- | --- | --- | --- |
| 1 | Payment COD; hapus status DP/belum bayar/lunas; COD menahan selesai; belum bayar masuk piutang | Pilihan UI hanya Bayar sekarang / COD. PayStatus tetap sebagai nilai turunan (Piutang, Laporan, fixture). DP = Bayar sekarang kurang dari total. Order.payTerm baru | R9 | SELESAI (2026-11-02) |
| 2 | Toggle kembalian/tabungan bila bayar lebih | Tunai saja; default Kembalian; Simpan ke tabungan = setoran, bukan omzet; juga di Catat pembayaran | R9 (+R8) | SELESAI (2026-11-02) |
| 3 | Sembunyikan hapus akun atau buat Kelola akun | Halaman Kelola akun (nama, no. telp, email, ganti password, Google, Keluar); Hapus akun di Zona berbahaya, tidak disembunyikan | R10 | SELESAI (2026-11-02) |
| 4 | Login email atau no. telp + password | Email+password dan Google; no. telp hanya profil (tanpa OTP) | R10 | SELESAI (2026-11-02) |
| 5 | Halaman Daftar | Daftar + Cek email + Lupa password | R10 | SELESAI (2026-11-02) |
| 6 | Tombol halaman Pembayaran | "Cetak struk" (simpan lalu buka struk) dan "Ke antrean" (simpan lalu Beranda). Keduanya sebelumnya memanggil fungsi yang sama (bug) | R9 | SELESAI (2026-11-02) |
| 7 | Catat pembayaran tidak hilang untuk COD | Tampil selama sisa > 0 dan tidak dibatalkan, termasuk order selesai; juga di Struk dan Piutang | R9 | SELESAI (2026-11-02) |
| 8 | COD belum diinput tetap di Antrean | Otomatis, karena selesai tertahan; kartu diberi penanda COD | R9 | SELESAI (2026-11-02) |
| F | (fondasi) pembayaran + tabungan harus atomik | TransactionRunner lintas repository; menutup celah rollback yang tercatat di STATE | R8 | SELESAI (2026-11-02) |

Catatan penomoran: usulan awal menyebut R8 = Pembayaran dan R9 = Akun; fondasi atomik dipisah menjadi R8 sehingga menjadi R8-R10.

## Konsekuensi yang disetujui
- Tidak ada lagi "belum bayar" tanpa COD: Bayar sekarang wajib jumlah > 0; 0 berarti pilih COD. Bon langganan tanpa penahanan selesai tidak lagi bisa dibuat dari kasir.
- Aturan R4 "tepat tiga aksi" punya satu pengecualian: order COD tertahan di mode status nonaktif menampilkan Edit, Hapus, Cetak struk, dan aksi utama "Terima pembayaran".
- Mode status aktif: langkah "Serahkan" untuk COD berubah menjadi "Terima pembayaran" (pembayaran + selesai satu transaksi).
- Label "DP" dan "Belum bayar" hilang dari UI: lunas -> "Lunas"; COD -> "COD - sisa Rp X"; sebagian -> "Sisa Rp X". Enum tetap dipakai internal.
- Tombol Ingatkan di Daftar Piutang disembunyikan (fitur tidak dibuat).
- Fixture DATA MASTER tidak diubah; order COD dibuat di tes kecuali pengguna menyetujui penambahan fixture.

## Catatan biaya dan produksi (belum berlaku di dummy)
- Konfirmasi email dan reset password produksi memerlukan SMTP kustom; layanan email bawaan Supabase dibatasi 2 email per jam dan hanya untuk uji coba. Periksa paket gratis penyedia email transaksional saat tahap backend.
- Login/konfirmasi no. telp butuh penyedia SMS berbayar per pesan dan perlu pembatasan laju serta CAPTCHA; sengaja ditunda.
- Hapus akun dalam aplikasi: verifikasi kebijakan Google Play terbaru sebelum rilis (termasuk tautan hapus akun di web pada formulir keamanan data).

## Risiko
- R9 besar (domain, checkout, empat layar). Jika sesi terputus, pecah di langkah 3 (UI) dan lanjutkan dengan status SEDANG di INDEX.
- Penahanan selesai harus ditegakkan di state (StateError), bukan hanya menyembunyikan tombol, agar usulan AI dan menu Ubah status tidak menembusnya.
