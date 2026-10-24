# 13 - Detail Pelanggan & Tabungan
Rute: /pelanggan/:id   Prompt: 50
Frame .pen: "Pelanggan - Detail Pelanggan & Tabungan".
Template: SubScaffold; daftar gulir vertikal.

Komposisi:
- AppCard: AppAvatar + AppText nama, InfoRow telepon/alamat/catatan,
  AppButton Buka WhatsApp dan Edit profil; BannerMessage bila nonaktif.
- StatTile Total belanja, Frekuensi, Piutang aktif, Saldo tabungan laundry.
- AppButton Setor tabungan dan Lihat riwayat mutasi.
- SectionHeader Riwayat mutasi terkini, SavingsRow (maksimal 3).
- SectionHeader Riwayat order terakhir, NotaCard (maksimal 3).
- AppSkeleton saat loading; EmptyState untuk error/retry, pelanggan tidak ditemukan,
  tanpa mutasi, dan tanpa nota.

Data/provider:
- customerDetailProvider(id) memakai customerSummariesProvider (termasuk nonaktif),
  notaHistoryProvider dan SavingsRepository. Daftar tetap memfilter pelanggan aktif.
- Pak Dedi: 0813-7788-1122; total Rp580.000; 16 order; piutang Rp31.500; saldo Rp50.000.
- Saldo mutasi dihitung dari ledger kronologis penuh sebelum mengambil 3 terbaru:
  10 Okt +Rp50.000/saldo Rp50.000; 2 Okt -Rp25.000/saldo Rp0;
  28 Sep +Rp25.000/saldo Rp25.000. Nota awal A-0142 dan A-0115.
- Edit nama/status tidak menghapus histori; tampilan mengikuti perubahan repository.

Interaksi:
- Edit profil membuka CustomerEditSheet (spec 14) di navigator utama.
- Buka WhatsApp memakai ExternalLauncher palsu; disabled jika nomor kosong.
- Setor -> /pelanggan/:id/setor; riwayat mutasi -> /pelanggan/:id/tabungan,
  keduanya placeholder sampai prompt 51. Setor/Edit disabled jika pelanggan nonaktif.
- Nota -> Detail order. Kembali: pop, atau /pelanggan jika dibuka langsung.
- Rute statis /pelanggan/impor harus didaftarkan sebelum /pelanggan/:id.

Format: Formatters untuk nominal, telepon, tanggal, jam. Semua nominal int rupiah.
Selisih .pen: statistik vertikal untuk layar sempit; tanpa rata-rata 2x/bln (tidak ada
data bulanan); tanpa klaim potong tabungan otomatis; Setor tabungan mengikuti prompt.
Riwayat memakai NotaCard, bukan kartu/CTA Struk terpisah; tidak ada Lihat semua karena
prompt hanya meminta order terakhir. Inisial memakai helper yang sudah ada (PB, bukan BD).
Tanggal/jam mengikuti Formatters. Warna/widget/token tidak diubah.
Tes: angka master, saldo ledger, rute, edit/nonaktif, loading/error/retry/kosong,
320 px dengan teks 2x. Perangkat dan WhatsApp nyata belum diuji; belum diuji di iOS.
