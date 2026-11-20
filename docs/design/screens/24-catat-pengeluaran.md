# 24 - Catat Pengeluaran
Rute: /lainnya/pengeluaran/baru | Prompt: 71
Frame .pen: Lainnya - Catat Pengeluaran (legacy). Frame desain baru:
`LAURUM · Catat Pengeluaran` (ID 4294969900, x 2620 y 5302).
Template: FormScaffold varian detail, tanpa avatar.

Komposisi: ExpenseAmountSection (SectionHeader Jumlah pengeluaran, AppCard nominal
yang tidak dapat diketuk berisi label, AppBadge Rupiah, nilai, pesan validasi, dan
Numpad); ExpenseDetailsSection (SectionHeader Rincian pengeluaran,
ExpenseCategorySection berisi chip kategori memakai AppChip dan aksi Kategori baru;
AppCard berisi MenuRow tanggal, vendor, catatan, dan ExpenseAttachmentSection).
Footer: AppButton Batal dan Simpan pengeluaran berdampingan; menumpuk vertikal
pada lebar < 288 dp atau skala teks > 1,2.
Provider: expenseFormProvider, expenseDirectoryProvider, expenseCategoryProvider,
photoPickerProvider, expenseRepositoryProvider.

Nominal TIDAK dapat diketuk dan tidak pernah membuka keyboard sistem; satu-satunya
input adalah Numpad. Nominal kosong tampil '0' (warna placeholder), tanpa nol depan,
maksimum 12 digit. Numpad pertama mengganti nilai awal; Backspace pada nilai awal
mengosongkan seluruhnya. Pesan 'Nominal harus lebih dari Rp0'; simpan nonaktif jika
nominal <= 0, kategori belum dipilih/termuat atau sedang menyimpan. Gagal simpan
menjaga draf.
Tanggal default clock usaha; pilihan 1 Jan 2026 sampai hari ini, jam draf tetap.
Vendor dan catatan opsional, uang int rupiah.
Kategori baru: ExpenseCategorySheet via AppBottomSheet.show; nama wajib unik
(tanpa membedakan kapital); simpan ke repository dan pilih kategori baru.
Lampirkan memakai PhotoPicker palsu: hasil photoPath disimpan; batal menjaga foto.
Simpan kembali ke daftar, total/Laporan reaktif. Batal dan tombol kembali
meninggalkan form tanpa menyimpan.

## Redesign 16 Nov 2026 (frame LAURUM · Catat Pengeluaran)

### Paritas redesign

| Butir | Sumber lama | Ada di UI baru |
|---|---|---|
| expenseFormProvider (nominal, kategori, tanggal, vendor, catatan, foto, busy, error) | Page/Amount/Details | ya |
| Input nominal hanya lewat Numpad (12 digit, ganti/backspace) | AppTextField + Numpad | ya, tampilan nominal AppText |
| Pesan 'Nominal harus lebih dari Rp0' + simpan nonaktif | Amount/Footer | ya |
| Pilih kategori + Kategori baru (ExpenseCategorySheet) | ChipBar + tombol | ya, chip AppChip |
| Tanggal lewat kalender (1 Jan 2026..hari ini, jam draf tetap) | tombol tanggal | MenuRow tanggal |
| Vendor dan catatan (AppTextField, selectAllOnFocus) | Details | ya |
| Lampirkan + status foto (photoPickerProvider) | tombol Lampirkan | ya |
| Simpan pengeluaran: validasi, simpan, invalidate, pop | Footer | ya (+ ikon centang) |
| Batal/kembali meninggalkan form | tombol kembali | Batal + tombol kembali |
| Banner gagal simpan / kategori gagal dimuat + Coba lagi | Page | ya |
| Key `expense-nominal` untuk tes | tes | ya |
| Keyboard 300 dp: vendor/catatan dan tombol simpan terlihat | tes template | tes expense_keyboard |

### Selisih desain

- Nominal tampil sebagai teks di dalam AppCard (bukan field), sesuai permintaan
  pengguna: tidak dapat diketuk dan tidak membuka keyboard Android.
- Numpad memakai organisme bersama (tinggi tombol standar 56 dp) sehingga lebih
  tinggi dari frame (36 px); mengecilkannya butuh proposal widget bersama.
- Pesan validasi tampil segera saat nominal kosong (perilaku lama dipertahankan;
  tes perilaku menguncinya).
- Kategori memakai AppChip yang membungkus (semua kategori terlihat), bukan tiga
  chip + tombol "+ Kategori baru" selebar layar.
- Kategori baru berupa chip di baris sendiri, bukan tombol lebar.
- Header memakai varian detail dengan subjudul 'Pengeluaran baru · 16 Okt 2026'
  yang disembunyikan saat keyboard terbuka (FormScaffold).
- Footer dua tombol mengikuti frame (3:5); pada 320 px/teks 2x tombol menumpuk.
- Numpad dekat nominal, rincian di bawah dapat digulir; vendor dan catatan tetap
  terpisah sesuai prompt.

Tes: nominal/numpad, kategori, tanggal/foto, simpan, keyboard 300 dp untuk
vendor, sheet kategori, golden, 320 px/teks 2x.
Perangkat Android/iOS, kamera dan foto nyata belum diuji.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
