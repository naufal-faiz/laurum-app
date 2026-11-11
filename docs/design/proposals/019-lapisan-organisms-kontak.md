# 019 � Lapisan organisms: kartu kontak bersama
Status: DISETUJUI pengguna 11 Nov 2026; baru dikerjakan setelah 018 selesai/hijau.
Acuan: kartu pelanggan FigCraft 528 (usulan 512) dan 637 (order 612).

## Alasan dan API
Kedua fitur membutuhkan pola avatar/nama/telepon/kontak yang sama. Aturan 2 dan
UI-25 mewajibkan komponen bersama; CustomerRow yang ada memuat statistik riwayat
sehingga tidak dipaksa menjadi kartu detail dengan data nol palsu.

CustomerContactCard({required String name, required String phone,
 String? initials, String? address, Widget? badge,
 bool showContact = true, VoidCallback? onContact,
 String contactLabel = 'Buka WhatsApp'})

- Stateless, terdaftar sebagai organism. Susun AppCard/AppAvatar/AppText/AppIcon,
  AppButton dan badge registry; Formatters.telepon untuk nomor.
- Avatar + nama + telepon; alamat opsional; badge opsional seperti Belum terdaftar.
- Kontak ringkas di kanan jika muat, membungkus ketika 320 dp/teks 2x.
- Aksi WhatsApp memakai varian tombol biru/outline dan aset merek yang sudah ada,
  mengikuti keputusan primer global; bukan menambah varian tombol hijau baru.
- Callback null tetap menonaktifkan aksi; showContact mempertahankan kondisi lama
  Detail Order (nomor kosong tidak menampilkan aksi). Tidak membaca provider.

## Dampak dan bukti
Komponen baru + registry; CustomerRow lama tidak diubah. Dua Section fitur memakai
kartu yang sama, tanpa impor Section antarfitur. Layout mendekati frame dengan
font/tap target global, bukan mengecilkan teks mengikuti angka contoh frame.
Tes data/semantics/telepon/alamat/badge, kontak/disabled, 320 dp/2x + golden baru.
check_all hijau sebelum lapisan 5. Tidak mengubah data, repository atau dependensi.
