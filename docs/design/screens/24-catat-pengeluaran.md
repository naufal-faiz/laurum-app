# 24 - Catat Pengeluaran
Rute: /lainnya/pengeluaran/baru | Prompt: 71
Frame .pen: Lainnya - Catat Pengeluaran. Template: FormScaffold, tanpa avatar.

Komposisi: ExpenseAmountSection (LabeledField nominal Rp, AppTextField, Numpad
standar tanpa Reset); ExpenseDetailsSection (ChipBar kategori, Kategori baru,
tanggal melalui kalender, LabeledField vendor dan catatan, status foto/Lampirkan).
Footer: Simpan pengeluaran. Provider: expenseFormProvider, expenseDirectoryProvider,
expenseCategoryProvider, photoPickerProvider, expenseRepositoryProvider.

Nominal kosong hint '0', tanpa nol depan, maksimum 12 digit. Numpad pertama
mengganti nilai awal; Backspace pada nilai awal mengosongkan seluruhnya.
Pesan 'Nominal harus lebih dari Rp0'; simpan nonaktif jika nominal <= 0,
kategori belum dipilih/termuat atau sedang menyimpan. Gagal simpan menjaga draf.
Tanggal default clock usaha; pilihan 1 Jan 2026 sampai hari ini, jam draf tetap.
Vendor dan catatan opsional, uang int rupiah.
Kategori baru: ExpenseCategorySheet via AppBottomSheet.show; nama wajib unik
(tanpa membedakan kapital); simpan ke repository dan pilih kategori baru.
Lampirkan memakai PhotoPicker palsu: hasil photoPath disimpan; batal menjaga foto.
Simpan kembali ke daftar, total/Laporan reaktif. Kembali meninggalkan form.

Selisih .pen: nominal awal kosong mengganti contoh Rp110.000 sesuai aturan 16;
numpad dekat nominal, rincian di bawah dapat digulir; vendor terpisah sesuai prompt.
Tes: nominal/numpad, kategori, tanggal/foto, simpan, keyboard 300 dp untuk
nominal/vendor/catatan dan sheet kategori, golden, 320 px/teks 2x.
Perangkat Android/iOS, kamera dan foto nyata belum diuji.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
