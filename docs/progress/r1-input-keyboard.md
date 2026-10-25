# R1 - Input dan keyboard

Status: SEDANG, kelompok fondasi widget (25 Oktober 2026).

## Fondasi

- AppBottomSheet.show: useSafeArea, tinggi maksimum 90%, padding viewInsets.
  Child fleksibel memberikan batas tinggi ke body gulir SheetScaffold.
- FormScaffold: footer memakai padding viewInsets. Tes awal gagal karena tombol
  tetap di bawah keyboard; perubahan ini memenuhi syarat izin R1.
- AppTextField: selectAllOnFocus opsional, default false. FocusNode internal
  memilih teks saat fokus/ulang dan dibuang bersama controller.
- Helper test/keyboard_test_helper.dart: layar DPR 2, safe area 24 dp, keyboard
  300 dp; menguji fokus, seluruh field di viewport, field di atas footer,
  tombol dapat diketuk, dan tidak ada exception.
- Empat tes template (390x844, 320x640) dan dua tes fokus/refokus/dispose baru.
  Keempat tes template terbukti gagal sebelum perbaikan, lulus setelahnya.
- Test host pumpAntrean kini memakai MediaQuery.fromView dan mempertahankan
  textScaler. Sebelumnya ukuran nol membuat batas tinggi sheet nol; satu tes
  regresi membuktikan kegagalan itu dan memastikan ukuran/insets berubah dinamis.
  Tes alur pelanggan/transaksi dan golden kembali lulus tanpa mengubah ekspektasi.
- Widgetbook: field Filled memakai selectAllOnFocus; sheet/form punya use-case
  Input dan keyboard. Column contoh sheet memakai mainAxisSize.min agar tetap
  mengikuti isi saat menerima constraint. Golden lama dipertahankan.
- Selisih desain: keyboard/insets mengikuti izin R1; tidak mengubah token atau
  komposisi visual. Frame Input Berat tetap acuan; perilaku numpad belum disentuh.

## Audit layar/sheet (belum dinyatakan lulus lewat tes template)

| Layar/sheet | Tes keyboard 300 dp | Perbaikan khusus |
| --- | --- | --- |
| Atur diskon | BELUM | Angka kosong/nol depan/select-all belum |
| Tambah pelanggan cepat | BELUM | Belum |
| Edit pelanggan | BELUM | Belum |
| Setor tabungan | BELUM | Nominal/select-all belum |
| Pilih pelanggan | BELUM | Belum |
| Pilih kontak | BELUM | Belum |
| Pilih layanan | BELUM | Belum |
| Catatan nota / Buat transaksi | BELUM | Belum |
| Edit order | BELUM | Belum |
| Catat pembayaran | BELUM | Periksa apakah memakai keyboard sistem atau numpad |
| Uang tunai | BELUM | Nominal/numpad belum |
| Info Usaha | BELUM | Belum |
| Form Layanan | BELUM | Harga/select-all belum |
| Pencarian Pelanggan | BELUM | Belum |
| Pencarian Layanan | BELUM | Belum |
| Pencarian Riwayat Nota | BELUM | Belum |
| Printer | BELUM | Belum |

## Lanjutan tepat

1. Diskon: tes state DiscountInput dan keyboard DiscountSheet, lalu perbaiki
   teks kosong/nol depan/selectAllOnFocus sesuai prompt R1 langkah 3.
2. Berat/jumlah: fresh, backspace, koma, minimum, chip dan validasi (langkah 4).
3. Audit semua input memakai helper; migrasikan Section debt saat disentuh.
4. Nominal Setor tabungan, Uang tunai, harga layanan (langkah 7).
5. Lengkapi tabel audit, spec layar, check_all, lalu tandai R1 selesai.

Pemanggil showModalBottomSheet sudah hanya AppBottomSheet (audit R0).
Uji perangkat Android/iOS belum dilakukan. Utang Section masih 26 berkas.

## Bukti validasi kelompok fondasi

Perintah: dart run tool/check_all.dart, 25 Oktober 2026.

```text
Formatted 433 files (0 changed)
flutter analyze: No issues found!
dart analyze: No issues found!
check_arch: OK
+324: All tests passed!
REPO_MAP diperbarui: 501 berkas
check_all: SEMUA HIJAU
```

Tujuh tes baru; seluruh golden lama tetap. AppTextField 99 baris,
AppBottomSheet 93 baris, FormScaffold 44 baris. Registry/tema/lint/dependensi tetap.
Kelompok fondasi selesai; keseluruhan R1 tetap SEDANG.
