# 028 — Irisan detail pelanggan
Status: MENUNGGU PERSETUJUAN; branch ui/pelanggan, dasar36fdffe.
Acuan pengguna: LAURUM · Detail Pelanggan4294969558 (390×844), dibaca14Nov2026.

## Komponen bersama (UI-13; satu persetujuan seluruh irisan)
- StatTile: parameter opsional compact=false untuk padding12/gap4/nilai lebih kecil;
  pilihan warna nilai opsional dengan default lama; dipakai statistik2×2 responsif.
- SavingsRow dan NotaCard: compact=false; varian ringkas untuk riwayat detail saja,
  nominal/status/waktu/saldo tetap lengkap; default dan semua API lama tetap.
- SubScaffold: subtitle=null dan appBarVariant=standard; detail memakai AppBarSub
  detail yang sudah ada, tinggi intrinsik untuk teks besar, default lama tetap.
- Tidak menambah token, registry, dependensi atau widget bersama baru.

## Page/Section
- Profil AppCard primary+bubble (biru solid token yang ada, pengganti gradien frame),
  nama/nomor/alamat/catatan tetap; WhatsApp/Edit sejajar, tumpuk saat ruang sempit.
- Statistik Total belanja/Frekuensi/Piutang aktif/Saldo tabungan menjadi2×2;
  gunakan data ledger yang sama, font minimum global dan tanpa tinggi tetap.
- Setor/Lihat riwayat mutasi sejajar; label lama, guard nonaktif dan tujuan sama.
- Lihat semua mutasi menuju rute tabungan yang sudah ada.
- Usulan Lihat semua order: membuka seluruh riwayat pelanggan di halaman sama,
  awal tetap3; memerlukan izin perilaku/state ekspansi baru, tanpa rute baru.
- Migrasikan navigasi CustomerSavingsSection ke callback Page dengan tujuan/argumen
  sama; izin hapus HANYA entri section ini dari tool/section_riverpod_debt.txt.
- Header subtitle nama/jumlah order memakai provider yang sama; izin merapikan
  pembacaan provider Page menjadi sekali agar header/body konsisten.

## Selesai
- Paritas/tes perilaku tetap, tes320px/teks besar, golden hanya varian/layar terdampak.
- check_all di akhir; satu commit feat(ui), tanpa merge/push; tinjauan HP pengguna.
