# R9 - COD dan pencatatan pembayaran

1. Verifikasi baseline R8; baca spec, batas izin, registry dan frame pembayaran.
2. Tes domain untuk PayTerm, isCompletionHeld, label sisa, dan salinan Order.
3. Checkout: pilihan sekarang/COD, jumlah awal terutang, validasi nol, kelebihan tunai.
4. Simpan nota/setoran kelebihan dalam TransactionRunner; pisahkan rute dua tombol.
5. Catat pembayaran: terapkan min(diterima,sisa), pilihan kelebihan, auto-selesai COD.
6. Tegakkan tahanan COD di semua jalur selesai dan repository; tes rollback pembayaran.
7. Migrasikan Section pembayaran/struk/piutang yang disentuh ke data dan callback.
8. Hubungkan pembayaran di Detail/Struk/Piutang dan CTA COD Antrean/Detail.
9. Ganti label pembayaran seluruh layar; kartu menerima paymentLabel opsional.
10. Tes alur COD kedua mode, sisa non-COD selesai, kelebihan, rute, keyboard, Section.
11. Perbarui spec 01/07/08/09/18, katalog, PRD sesuai izin, INDEX dan STATE.
12. check_all, self-review, commit; berhenti sebelum R10.

Fixture DATA MASTER tidak diubah; order COD hanya dibuat pada tes.
Tidak menambah widget bersama, tema, registry, dependensi atau fitur di luar R9.
