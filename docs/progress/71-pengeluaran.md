# Prompt 71 - Daftar dan Catat Pengeluaran
Tanggal: 31 Oktober 2026 | Cabang: dev1rev.
- Placeholder dua rute diganti Pages dan tiga Section Stateless sefitur.
- Daftar bulanan aktual: 18 fixture Rp1.850.000, kategori, grup tanggal,
  detail dan soft-delete terkonfirmasi; total/Laporan reaktif.
- Form kosong, nominal/numpad fresh, kategori baru persisten, tanggal,
  vendor/catatan, PhotoPicker palsu, error/retry dan busy state.
- Tanpa perubahan registry/tema/dependensi/PRD. ExpenseRepository mendapat
  saveCategory untuk kebutuhan Kategori baru; kategori buatan pengguna bukan fixture.
- Selisih .pen pada spec 23/24. Golden dua layar ditinjau visual.
- Tes keyboard 300 dp dan 320 px/teks 2x; perangkat/foto nyata belum diuji.
- Berkas UI: ExpenseDirectoryPage 72, ExpenseFormPage 82, ExpenseDetailSheet 71,
  ExpenseCategorySheet 46; ExpenseListSection 97, ExpenseAmountSection 42,
  ExpenseDetailsSection 85 baris. Seluruh Section Stateless tanpa provider/router.
- Baseline check_all sebelum tugas hijau (454 tes). Validasi akhir:
```text
dart run tool/check_all.dart
Formatted 507 files (0 changed)
flutter analyze: No issues found!
dart analyze: No issues found!
check_arch: OK
+473: All tests passed!
REPO_MAP diperbarui: 575 berkas
check_all: SEMUA HIJAU
```
- Berikutnya docs/prompts/80-ai.md. Tinjau pengeluaran di Android; integrasi
  foto nyata dan iOS belum diuji. Tidak push atau merge pada tugas ini.
