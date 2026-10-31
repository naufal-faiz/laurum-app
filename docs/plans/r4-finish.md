# Menuntaskan R4

- Pengguna meminta R4 sampai selesai: lanjutkan lintas kelompok tersisa pada sesi ini.
- Checkout membaca profil terbaru, memakai initialOrderStatus dan meneruskan policy.
- Audit AI: rute usulan masih placeholder 80; jangan membangun fitur 80 dalam R4.
- Toggle Pakai status order di Lainnya/PENGATURAN, simpan langsung, busy/error/retry.
- Migrasikan navigasi SettingsMenuSection ke callback, pisahkan kelompok operasional.
- Guard callback Detail mode lama agar nonaktif tidak bisa maju tanpa alur cetak.
- Tes logika dahulu, tes toggle/checkout/cetak gagal/sukses/Hapus/piutang dan regresi.
- Spec 19/PRD B satu kolom sinkron sesuai izin R4; golden ditinjau bila berubah.
- check_all hijau, INDEX R4 selesai, STATE dan commit; tidak memulai R5 atau push.
