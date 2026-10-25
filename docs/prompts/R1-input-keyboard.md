# R1 - Input, keyboard, dan angka awal (revisi 1, 2, 3, 10)
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: R0 SELESAI. Baca: AGENTS.md aturan 16, docs/revisi/REVISI-01.md (item 1, 2, 3, 10), spec layar 02, 04, 05.

Akar masalah (dari kode): (1) AppBottomSheet.show memakai isScrollControlled tanpa padding viewInsets sehingga SEMUA sheet berinput tertutup keyboard; (2) DiscountInput.start menulis '0' ke field sehingga mengetik 5000 menjadi 05000; (3) WeightEdit.key menambah digit ke nilai awal dan WeightInputSheet menampilkan 0,5 saat nilai 0 (pembulatan diam-diam).

## IZIN TERTULIS (25 Okt 2026)
- AppBottomSheet.show: padding bawah = MediaQuery.viewInsetsOf, tinggi maksimum 90% layar, useSafeArea. Footer SheetScaffold tetap terlihat di atas keyboard.
- AppTextField: tambah parameter opsional selectAllOnFocus (default false, perilaku lama tidak berubah); implementasi dengan FocusNode di State yang sudah ada.
- FormScaffold: footer ikut naik di atas keyboard (padding viewInsets pada footer) bila terbukti diperlukan oleh tes.
- Entri component_catalog.md dan use-case Widgetbook untuk perubahan di atas. Tanpa dependensi baru, tanpa mengubah tema.

## Langkah (tes lebih dulu)
1. Buat helper tes keyboard di test/ (FakeViewPadding atau tester.view.viewInsets 300 dp) yang memastikan: field yang fokus dan tombol simpan berada di atas keyboard.
2. Perbaiki AppBottomSheet dan (bila perlu) FormScaffold sesuai izin.
3. Diskon: DiscountInput.start menulis kosong bila nilai 0 (hint "0"); set() hanya digit, tanpa nol di depan; kosong = 0 saat simpan; selectAllOnFocus bila nilai awal bukan nol. Pesan error rentang tetap.
4. Berat/jumlah: WeightEdit memakai penanda fresh. Setelah start(), ketukan angka pertama MENGGANTI nilai; koma pertama menjadi "0,"; Backspace pada nilai fresh mengosongkan. Layar menampilkan nilai yang diketik apa adanya (tanpa klamp ke 0,5). Nilai di bawah minimum (kiloan 0,5 kg, satuan 1 pcs) menampilkan "Minimal 0,5 kg" (teks error) dan tombol simpan nonaktif. Nilai awal baris baru tetap 1 kg / 1 pcs. Chip +0,5/+1/+5 menambah ke nilai saat ini dan mematikan fresh. Stepper minus tetap nonaktif di minimum.
5. Audit SEMUA input: jalankan grep -rl "AppTextField\|AppSearchField" lib/features. Untuk setiap layar/sheet (minimal: Atur diskon, Tambah pelanggan cepat, Edit pelanggan, Setor tabungan, Pilih pelanggan, Pilih kontak, Pilih layanan, Catatan nota, Edit order, Catat pembayaran, Uang tunai, Info Usaha, Form Layanan, pencarian Pelanggan/Layanan/Riwayat Nota, Printer) tulis tes keyboard. Perbaiki yang gagal di tingkat template/organism sesuai izin; bila butuh perubahan lain, berhenti dan tulis proposal.
6. Cari pemanggil showModalBottomSheet selain AppBottomSheet dan pindahkan ke AppBottomSheet.show.
7. Aturan angka (AGENTS 16a/b) diterapkan pada semua field nominal: Setor tabungan, Uang tunai, Form Layanan (harga), pengeluaran nanti. Field telepon dikecualikan (nol di depan sah).

## Laporan tambahan
Tabel audit: layar/sheet | lulus tes keyboard | perbaikan. Prompt berikutnya: R2-navigasi-beranda.md.
