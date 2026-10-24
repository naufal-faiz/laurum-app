# Fase 6 - Pelanggan (24 Oktober 2026)

## Prompt 50: Daftar Pelanggan
- Sesi dibatasi satu layar sesuai AGENTS.md; Detail/Edit belum dikerjakan.
- Tab /pelanggan memakai CustomerRow, AppSearchField, ChipBar, SectionHeader,
  FooterBar, EmptyState, dan AppSkeleton dari registry.
- Jumlah chip dan saldo/piutang reaktif terhadap repository; riwayat dummy memakai
  baseline + selisih snapshot order agar nota fixture tidak dihitung dua kali.
- Tambah cepat memakai sheet yang sama, banner konteks daftar, dan navigator utama.
  Temuan: membuka sheet dari navigator tab memotong tinggi 500 px (overflow 97 px
  pada viewport tes); memilih navigator utama di page menyelesaikannya tanpa mengubah
  AppBottomSheet. Integrasi keyboard/perangkat nyata masih perlu ditinjau.
- Selisih desain: urutan repository; chip Semua/Punya tabungan diberi jumlah sesuai
  prompt; DP memakai teks CustomerRow tanpa nomor nota; CTA tambah tetap di footer.
- Tes: angka DATA MASTER dan normalisasi/filter, pembatalan reaktif, pencarian/rute,
  tambah pelanggan, loading/kosong, error/retry, lebar 320 px dengan teks 2x.
- Atom/registry/token/lint/PRD tidak berubah; tidak ada dependensi baru.
- Detail pelanggan dan Impor kontak masih placeholder; telepon memakai launcher palsu.
- Hasil check_all akhir dicatat di STATE.md; tinjau Daftar sebelum melanjutkan prompt 50.

## Prompt 50: Detail Pelanggan dan sheet Edit profil
- /pelanggan/:id mengganti placeholder; statistik, tiga mutasi, tiga nota terbaru.
- customerSummariesProvider memuat aktif/nonaktif; daftar memfilter aktif sehingga
  detail/histori tetap tersedia setelah nonaktif. Saldo dihitung sebelum membatasi mutasi.
- Edit memakai Notifier dan konfirmasi nonaktif, mempertahankan identitas/metadata awal,
  menolak nomor duplikat aktif, serta tidak menghapus nota/piutang/tabungan.
- Rute statis impor didahulukan dari parameter id. Setor/riwayat mutasi masih placeholder.
- Selisih: statistik vertikal, tanpa rata-rata bulanan yang tidak tersedia di data master,
  tanpa klaim tabungan otomatis, NotaCard tanpa CTA Struk/Lihat semua; inisial helper.
- Spec 13/14 mencatat detail dan teks baru ConfirmModal. Tidak ada widget bersama baru.
- Sembilan tes baru: tiga data/edit/nonaktif, tiga alur UI, tiga state/layar sempit.
- Penutup: directive import dirapikan (dart fix directives_ordering) pada
  customer_detail_page.dart dan customer_detail_page_test.dart; check_all SEMUA HIJAU,
  285 tes, REPO_MAP 441 berkas. Berikutnya prompt 51 setelah tinjauan.

## Prompt 51: Setor Tabungan, Riwayat Tabungan, Impor Kontak HP
- Tiga rute placeholder diganti: /pelanggan/:id/setor, /pelanggan/:id/tabungan,
  dan /pelanggan/impor (statis harus sebelum /pelanggan/:id).
- Setor: FormScaffold + Numpad, NominalChips aditif (+Rp20.000/+Rp50.000/+Rp100.000),
  ChipBar metode (Tunai/QRIS/Transfer), catatan opsional, ringkasan saldo sekarang dan
  saldo akhir. Simpan menulis SavingsEntry(setor) dengan jam usaha, ownerId sesi, dan
  id sav-new-<micros>; nominal 0 ditolak "Nominal harus lebih dari Rp0.".
  Pak Dedi Rp50.000 + Rp50.000 = Rp100.000 (diuji).
- Riwayat: tanpa BottomNavBar; header saldo + CTA setor, ChipBar Semua/Setoran/Terpakai
  dengan hitungan, SavingsRow (metode, referensi nota, catatan), dan catatan
  "Riwayat mutasi tidak dapat diubah atau dihapus.". customerSavingsProvider membaca
  ledger kronologis untuk saldo berjalan lalu membalik urutan; savingsMovements dipakai
  bersama Detail (3 terbaru) dan Riwayat (semua).
- Impor: ContactSource palsu + ToggleRow, pencarian nama/nomor, pilih semua, kontak
  terdaftar dilewati, ringkasan "n kontak baru dipilih (n dilewati)". Izin ditolak
  memakai EmptyState "Izin kontak belum diberikan" + "Buka pengaturan" (app-settings:).
  contactImportProvider mematikan retry otomatis Riverpod agar izin ditolak final.
- Fixture: empat kontak DATA MASTER (Agus, Danang, Maya, Siti) sudah terdaftar sebagai
  cust-010..013, jadi dummy menampilkan 0 kontak baru. Alur simpan diuji lewat
  dummyOverrides(contactSource:) dengan kontak tambahan; menambah kontak baru butuh
  keputusan pemilik produk karena data_master tidak menyediakannya.
- main_dummy.dart: dummyOverrides({contactSource}) menggantikan daftar override tetap;
  dummyRepositoryOverrides tetap tersedia untuk pemanggil lama.
- Risiko izin READ_CONTACTS (PRD B bagian 10) dicatat di spec 17 beserta mitigasi pemilih
  kontak sistem untuk satu pelanggan; layar tidak berubah karena ContactSource di core.
- Selisih .pen dicatat di spec 15-17: nominal mulai Rp0 (bukan contoh Rp50.000), metode
  memakai ChipBar (belum ada segmented control), tanpa BottomNavBar di Riwayat, dan tanpa
  header huruf/avatar inisial pada Impor.
- Tanpa widget bersama baru; registry, tema, lint, PRD, dan dependensi tidak berubah.
- Tes baru: setor (2), riwayat (2), impor (3). check_all SEMUA HIJAU: 292 tes,
  REPO_MAP 457 berkas. Berikutnya 60-laporan.md setelah tinjauan.
