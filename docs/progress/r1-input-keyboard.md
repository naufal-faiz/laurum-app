# R1 - Input dan keyboard

Status: SELESAI (25 Oktober 2026), menunggu tinjauan pengguna.

## Fondasi

- AppBottomSheet.show: useSafeArea, tinggi maksimum 90%, padding viewInsets.
  Child fleksibel memberikan batas tinggi ke body gulir SheetScaffold.
- FormScaffold: footer memakai padding viewInsets. Tes awal gagal karena tombol
  tetap di bawah keyboard; perubahan ini memenuhi syarat izin R1.
- AppTextField: selectAllOnFocus opsional, default false. FocusNode internal
  memilih teks saat fokus/ulang dan dibuang bersama controller.
- Helper test/keyboard_test_helper.dart: layar DPR 2, safe area 24 dp, keyboard
  300 dp; menguji fokus, field di atas keyboard, field di viewport, dan tombol
  dapat diketuk. Parameter `save` opsional untuk layar pencarian; viewport dicek
  lewat Scrollable mana pun (ListView atau SingleChildScrollView).
- Empat tes template (390x844, 320x640) dan dua tes fokus/refokus/dispose baru.
- Test host pumpAntrean memakai MediaQuery.fromView dan mempertahankan textScaler.

## Diskon dan berat

- DiscountInput.start menulis kosong bila nilai 0; set() hanya digit, membuang nol
  depan, nol tunggal menjadi kosong; simpan membaca kosong sebagai 0. Field memakai
  selectAllOnFocus saat nilai awal bukan nol; pesan error rentang tetap.
- WeightEdit memakai penanda fresh: angka pertama mengganti nilai awal, koma pertama
  menjadi '0,', Backspace pada nilai fresh mengosongkan, nol depan tidak ditampilkan,
  dan nilai tidak diklam. Chip menambah ke nilai berjalan dan mematikan fresh;
  pcs mengabaikan koma.
- WeightInputSheet menampilkan nilai apa adanya (Formatters), pesan 'Minimal 0,5 kg'
  / 'Minimal 1 pcs' di bawah minimum, dan tombol simpan nonaktif. Simpan membaca
  nilai terkini dari provider (bukan nilai build lama) agar ketukan cepat tidak
  menyimpan angka basi.
- StepperField minus di TransactionLineSheet nonaktif saat qty di minimum.
- Audit prasyarat R2 menemukan angka utama masih diformat dari gram, sehingga
  '0,' dan '0,50' kehilangan koma/nol desimal saat mengetik. Sudah dikoreksi:
  Formatters.beratInput mempertahankan teks draf; ringkasan dan simpan tetap gram.
  weight_input_display_test membuktikan kegagalan sebelum perbaikan dan memastikan
  '0,50' tersimpan sebagai 500 gram setelah perbaikan.

## Nominal

- Uang tunai: nol tunggal tidak pernah menempel di depan; set(0) mengosongkan.
- Setor tabungan: angka pertama mengganti nol; 000 tidak menambah nol.
- Harga layanan: nol depan dibuang, '0' menjadi kosong (hint), selectAllOnFocus saat
  harga awal bukan nol. Field telepon tetap dikecualikan (nol depan sah).
- ServiceEditFieldsSection dimigrasikan dari ConsumerWidget ke StatelessWidget
  (data + callback) dan keluar dari tool/section_riverpod_debt.txt.

## Audit layar/sheet (tes keyboard 300 dp)

| Layar/sheet | Lulus tes | Perbaikan |
| --- | --- | --- |
| Atur diskon | Ya (discount_input_test) | kosong=0, tanpa nol depan, select-all |
| Tambah pelanggan cepat | Ya (keyboard_audit_test) | tidak perlu |
| Edit pelanggan | Ya (keyboard_audit_test) | tidak perlu |
| Setor tabungan | Ya (keyboard_audit_test) | tidak perlu (numpad + field catatan) |
| Pilih pelanggan | Ya (keyboard_audit_test) | tidak perlu |
| Pilih kontak (impor) | Ya (keyboard_audit_test) | tidak perlu |
| Pilih layanan | Ya (keyboard_audit_test) | tidak perlu |
| Catatan nota / Buat transaksi | Ya (keyboard_audit_test) | tidak perlu |
| Edit order | Ya (keyboard_audit_test) | tidak perlu |
| Catat pembayaran | T/A - numpad, tanpa field teks | tidak berubah |
| Uang tunai | T/A - numpad, tanpa field teks | tanpa nol depan, set(0) kosong |
| Info Usaha | Ya (keyboard_audit_test) | tidak perlu |
| Form Layanan | Ya (keyboard_audit_test, nominal_input_test) | nol depan, select-all |
| Pencarian Pelanggan | Ya (keyboard_audit_test) | tidak perlu |
| Pencarian Layanan | Ya (keyboard_audit_test) | tidak perlu |
| Pencarian Riwayat Nota | Ya (keyboard_audit_test) | tidak perlu |
| Printer | Ya (keyboard_audit_test) | tidak perlu |

Catatan audit: pencarian memakai parameter `save` kosong karena tidak punya tombol
simpan; field tetap diverifikasi fokus, terlihat, dan dapat diketuk. Sheet numpad
(Catat pembayaran, Uang tunai) tidak memunculkan keyboard sistem sehingga tidak
memakai helper 300 dp; perilakunya ditutup tes state dan tes alur lama.

## Bukti validasi

Perintah: dart run tool/check_all.dart, 25 Oktober 2026.

```text
== format      Formatted 438 files (0 changed)
== analyze     No issues found!
== Riverpod lint No issues found!
== check_arch  check_arch: OK
== test        +355: All tests passed!
== repo_map    REPO_MAP diperbarui: 506 berkas
check_all: SEMUA HIJAU
```

Tambahan tes: discount_input_test (4), weight_edit_test (8), nominal_input_test (3),
keyboard_audit_test (14), satu tes stepper di transaction_page_test. Tes lama tidak
diubah ekspektasinya kecuali satu alur berat yang tetap 3 kg (perilaku baru identik).
Audit prasyarat R2 menambahkan satu tes weight_input_display_test; seluruh 354 tes
sebelumnya tetap lulus. R2 belum dimulai karena sesi ini menutup koreksi layar R1.

Pemanggil showModalBottomSheet sudah hanya AppBottomSheet (audit R0).
Uji perangkat Android/iOS belum dilakukan. Utang Section menyusut 26 -> 25 berkas.
