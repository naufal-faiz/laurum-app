# 28 - Hubungkan WhatsApp
Rute: /lainnya/ai/hubungkan | Prompt: 80 (kelompok pengaturan/koneksi)
Frame: Lainnya - Hubungkan WhatsApp. Template: SubScaffold tanpa avatar.
Komposisi: WhatsappLinkSection menyusun BannerMessage nomor usaha, petunjuk,
AppCard/AppIcon QR pratinjau, status dan AppButton, NoticeAi.
Provider: whatsappLinkProvider, whatsappConnectionProvider.
State lokal: menunggu pindai -> kedaluwarsa setelah 1 menit -> Muat ulang kode;
Periksa koneksi mengubah status dummy menjadi Terhubung, memperbarui shell.
Terhubung menampilkan centang dan Kembali ke pengaturan. QR hanya ikon placeholder;
tidak ada kode tautan nyata, permintaan jaringan, pemindaian atau pengiriman pesan.
Timer dibatalkan setelah tersambung atau provider dibuang.
Selisih .pen: ikon QR placeholder sesuai prompt; tombol Periksa koneksi menggerakkan
status lokal dummy, bukan pengecekan perangkat. Durasi 1 menit untuk preview.
Risiko rancangan (PRD B bagian 12): perangkat tertaut lewat QR adalah jalur tidak
resmi yang berisiko ketentuan/pemblokiran nomor; rilis publik perlu keputusan
WhatsApp Business Platform/Cloud API. Prototype ini tidak melakukan penautan.
Verifikasi: menunggu/terhubung/kedaluwarsa/ulang, golden, 320 px/teks 2x.
Integrasi WhatsApp nyata dan perangkat Android/iOS belum diuji.
