# REVISI-01 - Hasil uji HP dan audit kode (25 Okt 2026)
Sumber: uji dummy app di Android (Naufal) + audit statis cabang dev1 (prompt 70). Dikerjakan lewat seri prompt R0-R7 (docs/prompts/INDEX.md).

## Daftar revisi
| No | Permintaan | Akar masalah di kode | Prompt | Status |
| --- | --- | --- | --- | --- |
| 1, 10 | Input tertutup keyboard (diskon, dan semua input) | AppBottomSheet.show tanpa padding viewInsets; berlaku untuk semua sheet berinput | R1 | SEDANG: fondasi widget, audit layar belum |
| 2 | Angka 0 di diskon harus tergantikan | DiscountInput.start menulis "0" ke field; tidak ada select-all dan pembersih nol di depan | R1 | BELUM |
| 3 | Berat default 1 kg, tidak bisa 0, edit tanpa hapus angka | WeightEdit menambah digit ke nilai awal; layar menampilkan 0,5 saat nilai 0 (klamp diam-diam) | R1 | BELUM |
| 4 | FAB tambah di Pilih Layanan | SubScaffold belum mendukung FAB | R3 | BELUM |
| 5 | Tombol tambah pelanggan di samping Pilih pelanggan | TransactionCustomerSection hanya satu tombol | R3 | BELUM |
| 6 | Pengaturan pakai status order atau tidak | Status order selalu dipakai; belum ada pengaturan | R4 | BELUM |
| 7 | Hapus Riwayat Nota | Nota dilihat lewat Laporan | R6 | BELUM |
| 8, 13 | Laporan: tanggal kustom + daftar order pada tanggal terpilih (dari halaman transaksi) | PeriodTabs hanya 3 periode; daftar nota ada di Riwayat Nota | R5 (ringkasan), R6 (daftar nota) | BELUM |
| 9 | Nav: tombol Transaksi di tengah, FAB Beranda dihapus (ikon lama) | FAB ada di RootScaffold; Transaksi masih tab Riwayat Nota | R2 | BELUM |
| 11 | Beranda hanya antrean aktif | Judul "Antrean hari ini" menyesatkan; data sudah aktif-saja | R2 | BELUM |
| 12 | Tombol Pelanggan baru pindah ke atas, di sebelah Impor kontak | Berada di FooterBar | R7 | BELUM |
| 14 | Ekspor Excel di atas | Berada di FooterBar Laporan | R5 | BELUM |
| 15 | Tombol logout cacat | MenuRow biasa berikon panah kembali di kartu yang sama dengan baris terkunci | R7 | BELUM |
| S1-S3 | Sub-widget (rekomendasi di bawah) | ~39 kelas *Page non-rute menyiasati Aturan 1; logika non-UI bercampur di pages/ | R0 | SELESAI (2026-10-25) |

Temuan tambahan yang masuk prompt: Daftar Piutang memakai BottomNavBar tanpa onSelected (nav tidak berfungsi) -> R2.

## S. Rekomendasi sub-widget (diputuskan: kategori Section)
Masalah: aturan 1 mengecualikan akhiran Page/Sheet, sehingga potongan layar (OrderSummaryPage, ReportBodyPage, dll.) diberi akhiran Page agar lolos check_arch dan batas 100 baris. Katalog 60 widget tidak lagi satu-satunya sumber UI, dan pages/ berisi controller dan data.

Keputusan (alternatif yang ditolak: menambah puluhan widget ke registry = registry membengkak dengan potongan sekali pakai; mempertahankan celah = aturan tidak bermakna):
1. *Page = hanya kelas rute. *Sheet = modal. Dicek otomatis.
2. *Section = potongan layar satu fitur di features/<f>/widgets/. Boleh dibuat tanpa proposal, StatelessWidget murni (data via konstruktor, aksi via callback, tanpa Riverpod dan go_router). Dipakai dua fitur atau lebih = naik ke registry lewat proposal.
3. Logika non-UI ke features/<f>/state/. pages/ hanya *_page, *_sheet, *_flow, *_routes.
4. Utang: Section lama yang masih ConsumerWidget dicatat di tool/section_riverpod_debt.txt; hanya boleh menyusut, dimigrasikan saat berkas disentuh seri R.
5. Mengapa Section murni: mudah dites dan diuji di Widgetbook, dan alur data terlihat di satu tempat (Page/Sheet), penting sebelum backend dan sinkronisasi masuk.

## Keputusan dan asumsi (ubah sebelum menjalankan prompt terkait bila salah)
- R4 (diputuskan pengguna): mode status order NONAKTIF punya tiga aksi Edit, Hapus, Selesaikan. Selesaikan membuka cetak struk; saat cetak berhasil status menjadi selesai dan order keluar dari antrean. Asumsi tambahan: bila cetak gagal atau dibatalkan, order tetap di antrean dengan opsi "Selesaikan tanpa cetak"; Selesaikan tidak mensyaratkan lunas.
- R4: "Hapus" pada mode ini memakai alur batal yang ada (status dibatalkan, riwayat tetap, tidak dihitung di laporan), bukan penghapusan permanen. Jadi tetap pertahankan nama "Batal"
- R2: bagian "Perlu dicek" (usulan AI menunggu) tetap di Beranda karena bagian dari antrean aktif.
- R3: tombol tambah pelanggan hanya tampil saat belum ada pelanggan terpilih.
- R5: rentang tanggal memakai showDateRangePicker bawaan Flutter (lokal id_ID lewat flutter_localizations, paket SDK). Data dummy hanya berisi minggu 12-18 Okt 2026, jadi rentang di luar itu menampilkan keadaan kosong; DATA MASTER tidak diubah.
- R7: bila setelah perbaikan Keluar masih terlihat cacat di HP, kirim tangkapan layar sebelum perubahan berikutnya.
