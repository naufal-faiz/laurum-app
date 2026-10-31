# 27 - Pengaturan AI & WhatsApp
Rute: /lainnya/ai | Prompt: 80 (kelompok pengaturan/koneksi)
Frame: Lainnya - Pengaturan AI & WhatsApp. Template: RootScaffold, Lainnya aktif.
Komposisi: SectionHeader, NoticeAi, AiConnectionSection, AiPreferencesSection,
MenuRow Riwayat usulan AI. Padding akhir scroll bebas dari tombol Transaksi.
AiConnectionSection: AppCard status/nomor usaha, Uji koneksi, Putuskan koneksi
(destructiveOutline) atau Hubungkan WhatsApp bila terputus.
AiPreferencesSection: ToggleRow Baca pesan WhatsApp, Abaikan pesan grup,
Deteksi permintaan batal (bawaan aktif); AppCard privasi dan retensi 30 hari.
Provider: aiSettingsProvider, whatsappConnectionProvider, businessProfileProvider.
Nomor usaha memakai Formatters.telepon, bukan hardcode salinan fixture.
Putus koneksi melalui ConfirmModal; batal menjaga koneksi, konfirmasi mengubah
state shell sehingga banner Antrean/menu Lainnya mengikuti status yang sama.
Uji koneksi membuka status koneksi lokal di /lainnya/ai/hubungkan.
Toggle menyimpan preferensi lokal dummy, belum mengendalikan worker AI nyata.
Retensi adalah keterangan rancangan, belum menjalankan penghapusan pesan sungguhan.
Selisih .pen: empat tab/nav revisi terbaru; status relatif pembaruan tidak dikarang;
angka ringkasan riwayat kini mengikuti fixture yang disetujui pengguna pada 31 Okt.
Verifikasi: toggle, batal/putus/sambung, golden terhubung/terputus, 320 px/teks 2x.
Perangkat Android/iOS dan TalkBack/VoiceOver belum diuji untuk layar ini.
