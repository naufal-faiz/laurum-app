# 70 - Lainnya bagian 1
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: prompt 60 SELESAI. Baca: frame "Pengaturan & Akun", "Daftar Layanan", "Tambah Layanan", "Edit Layanan", "Info Usaha" dan varian State.

- Pengaturan dan Akun (tab Lainnya): MenuRow berkelompok (Layanan dan tarif, Pengeluaran, Printer dan struk, Otomatisasi AI, Info usaha, Sinkronisasi), NoticeAi, versi "Laurum v1.0.0", "Keluar" lewat ConfirmModal "Keluar dari akun?". Baris Sinkronisasi dan bagian Akun dilengkapi di prompt 90 (placeholder dulu). Tanpa "Cadangan Data".
- Daftar Layanan: 6 layanan persis data_master.md ("Jas & gaun" nonaktif 4 hari), header "Total 6 layanan (5 aktif)", ketuk baris untuk Edit.
- Tambah dan Edit Layanan (satu form yang sama): Kiloan atau Satuan, nama, harga (suffix /kg atau /pcs), estimasi sebagai ChipBar 1 sampai 5 hari, ToggleRow aktif, "Simpan layanan" dan "Batal". Catatan harga hanya di form Edit: "Perubahan harga tidak memengaruhi nota yang sudah tercetak." Tanpa Paket dan tanpa dropdown satuan.
- Info Usaha: nama usaha, alamat, nomor telepon, catatan kaki struk; memperbarui nama di AppBarRoot dan struk.
- Perubahan layanan langsung memengaruhi katalog di Pilih Layanan.
