# 13 - Detail Pelanggan & Tabungan
## Redesign FigCraft — persiapan14Nov2026
Frame dipilih pengguna: `LAURUM · Detail Pelanggan` (`4294969558`,390×844).
Snapshot dibaca sekali; proposal028 disetujui pengguna14Nov2026 dan diterapkan.

### Snapshot tata letak
- Header: kembali + judul + subtitle nama/jumlah order.
- Konten: horizontal24/atas12, gap12; kartu profil biru/avatar/nama/nomor/alamat,
  aksi WhatsApp dan Edit sejajar; catatan/nonaktif tetap harus disertakan.
- Empat statistik2×2 dengan gap10, kemudian Setor/Riwayat mutasi sejajar.
- Judul riwayat mutasi/order disertai Lihat semua; kartu riwayat ringkas di bawahnya.

### Paritas redesign
Semua butir diverifikasi dengan tes terarah dan check_all akhir.

| Butir | Sumber/aksi/keadaan | Verifikasi |
|---|---|---|
| Data | customerDetailProvider(customerId), summary/history/movements/orders | [x] |
| Profil | nama, inisial, Formatters.telepon, alamat/catatan opsional, status aktif | [x] |
| Statistik | historyTotal/orderCount/debt/savings dari summary, tanpa angka contoh baru | [x] |
| WhatsApp | externalLauncherProvider.launchWhatsApp(phone: customer.phone,message: '') termasuk nomor kosong | [x] |
| Edit | CustomerEditSheet.show(context,ref,customer); disabled nonaktif | [x] |
| Setor | /pelanggan/:id/setor; disabled nonaktif | [x] |
| Mutasi | /pelanggan/:id/tabungan; savingsLabel/tanggal/jam/jenis/nominal/saldo tetap | [x] |
| Order | data.orders awal3; orderNo/summary/total/status/payStatus/paymentLabel/paid/timeLabel | [x] |
| Ekspansi order | Lihat semua jika lebih3; state per pelanggan; semua history cocok, urutan/filter lama tetap | [x] |
| Buka order | context.push('/order/${order.id}') | [x] |
| Kembali | canPop?pop:go('/pelanggan') | [x] |
| Keadaan | loading4skeleton, gagal/retry/invalidate, tidak ditemukan, nonaktif, mutasi/order kosong | [x] |
| Key/fokus | Page/profile/savings/orders tanpa Key eksplisit; host antrean-golden dan fokus sheet tetap | [x] |
| Aksesibilitas | viewport320/teks2x, aksi terjangkau; keyboard edit tetap melalui tes sheet | [x] |

### Selisih desain
- Font7–10px dan tombol36px Figma dipetakan ke minimum font/area sentuh global.
- Profil memakai biru solid+bubble yang tersedia, bukan membuat token gradien baru.
- Tetap menampilkan catatan opsional, pesan nonaktif dan tiga riwayat terakhir.
- Tidak menyalin angka/nama/tanggal contoh; tanpa klaim Sejak Okt2025 atau jumlah
  nota belum lunas sebelum sumber data dan semantiknya dipastikan.
- Lihat semua mutasi punya rute tersedia; Lihat semua order belum ada perilaku lama:
  proposal028 meminta izin ekspansi riwayat di halaman sama menggunakan history tersedia.
- Perubahan callback navigasi Section dan pembacaan provider Page hanya setelah izin.

### Implementasi dan perlindungan ukuran/font
- Profil biru solid+bubble, nomor/alamat/catatan lengkap dan pesan nonaktif tetap.
- StatTile.compact untuk empat statistik2×2; tinggi per baris mengikuti isi melalui
  IntrinsicHeight, bukan angka tetap. Lebar sempit atau teks>1,2× menjadi satu kolom.
- CustomerDetailActionsSection dipakai kedua pasangan aksi; tombol kecil bertumpuk
  pada ruang sempit/teks besar, tinggi mengikuti label, tanpa ellipsis isi pelanggan.
- SavingsRow/NotaCard compact hanya pada detail ini; default lama dan golden tetap.
- SubScaffold detail memakai header intrinsik; judul/subjudul membungkus dan tetap
  di atas area gulir. Provider detail dibaca sekali untuk header/body.
- Hanya inisial dekoratif avatar dibatasi maksimal1× dalam lingkaran40; nama lengkap
  dan seluruh teks isi tetap mengikuti skala pengguna pada tes widget langsung.
- SavingsSection sekarang data/callback murni; satu entri debt dihapus sesuai izin.
- Lihat semua mutasi memakai rute lama; order awal3, ekspansi per pelanggan tanpa
  rute baru, tanpa mengubah repository atau perhitungan uang.
- Matriks16kombinasi: lebar280/320/390/600dp × skala0,85/1/1,3/2; pengujian langsung
  tanpa pembatas font aplikasi. Ditambah teks/nama/alamat/catatan panjang dan nominal besar.
- Tes baru memeriksa posisi header saat scroll, grid/aksi bertumpuk, tinggi statistik,
  avatar tidak terpotong, ekspansi3ke4, isolasi pelanggan dan buka order setelah ekspansi.
- Tes lama tidak diubah/dilemahkan. Tes terarah40lulus; dua golden detail baru normal
  dan actual2× diperiksa. Tidak ada golden default atau layar lain yang bergeser.
- dart run tool/check_all.dart: SEMUA HIJAU,1244lulus/2skip Supabase lokal,exit0;
  format1113berkas tanpa perubahan, analyzer/lint bersih,check_arch OK,REPO_MAP1191.
- Visual belum diverifikasi manual pada HP; tidak mengambil screenshot emulator.

Rute: /pelanggan/:id   Prompt: 50
Frame aktif FigCraft: "LAURUM · Detail Pelanggan"4294969558; .pen adalah acuan lama.
Template: SubScaffold detail; header tetap dan daftar gulir vertikal.

Komposisi:
- AppCard primary: AppAvatar, nama/telepon/alamat/catatan dan aksi WhatsApp/Edit;
  BannerMessage bila nonaktif; CustomerStatisticsSection untuk empat StatTile compact.
- Aksi Setor tabungan/Lihat riwayat mutasi responsif melalui Section sefitur.
- SectionHeader Riwayat mutasi terkini + Lihat semua; SavingsRow compact (maksimal3).
- SectionHeader Riwayat order terakhir; NotaCard compact awal3, Lihat semua bila lebih3.
- AppSkeleton saat loading; EmptyState untuk error/retry, pelanggan tidak ditemukan,
  tanpa mutasi, dan tanpa nota.

Data/provider:
- B1f main/Drift memakai statistik ledger aktual seperti spec 12; tidak menambah
  ringkasan historis fixture. Angka Pak Dedi di bawah khusus entry demo memory.
- customerDetailProvider(id) memakai customerSummariesProvider (termasuk nonaktif),
  reportOrdersProvider dan SavingsRepository. Daftar tetap memfilter pelanggan aktif.
- Pak Dedi: 0813-7788-1122; total Rp580.000; 16 order; piutang Rp31.500; saldo Rp50.000.
- Saldo mutasi dihitung dari ledger kronologis penuh sebelum mengambil 3 terbaru:
  10 Okt +Rp50.000/saldo Rp50.000; 2 Okt -Rp25.000/saldo Rp0;
  28 Sep +Rp25.000/saldo Rp25.000. Nota awal A-0142 dan A-0115.
- Edit nama/status tidak menghapus histori; tampilan mengikuti perubahan repository.

Interaksi:
- Edit profil membuka CustomerEditSheet (spec 14) di navigator utama.
- Buka WhatsApp memakai DeviceExternalLauncher pada build Drift; nomor terisi membuka
  percakapan, nomor kosong membuka pilihan WhatsApp tanpa penerima tertentu.
  Dummy/tes tetap memakai FakeExternalLauncher. Belum diuji di iOS.
- Setor -> /pelanggan/:id/setor; riwayat mutasi -> /pelanggan/:id/tabungan,
  tujuan tetap. Setor/Edit disabled jika pelanggan nonaktif.
- Nota -> Detail order. Kembali: pop, atau /pelanggan jika dibuka langsung.
- Rute statis /pelanggan/impor harus didaftarkan sebelum /pelanggan/:id.

Format: Formatters untuk nominal, telepon, tanggal, jam. Semua nominal int rupiah.
Selisih .pen: statistik vertikal untuk layar sempit; tanpa rata-rata 2x/bln (tidak ada
data bulanan); tanpa klaim potong tabungan otomatis; Setor tabungan mengikuti prompt.
Riwayat memakai NotaCard; Lihat semua order disetujui pada proposal028 dan membuka
seluruh riwayat pada halaman sama. Inisial tetap memakai helper lama (PB, bukan BD).
Tanggal/jam mengikuti Formatters. Warna/widget/token tidak diubah.
Tes: angka master, saldo ledger, rute, edit/nonaktif, loading/error/retry/kosong,
320 px dengan teks 2x. Perangkat dan WhatsApp nyata belum diuji; belum diuji di iOS.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
