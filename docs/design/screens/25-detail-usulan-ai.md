# 25 - Detail Usulan AI
Rute: /antrean/usulan/:id | Prompt: 80
Frame: Antrean - Detail Usulan AI dan varian Pelanggan Baru.
Template: FormScaffold, AppBarSub tanpa avatar; footer Tolak/Setujui jadi order.

Komposisi: ProposalMessageSection (SectionHeader, AppCard, badge Belum terdaftar,
pesan sumber, nomor/jam melalui Formatters, Buka WhatsApp tanpa teks kirim),
ProposalFieldsSection (hasil baca, nama/telepon pelanggan baru, ChipBar layanan,
harga, alamat, CalloutAi), NoticeAi. State loading/gagal-retry/tidak ditemukan.
Provider: proposalReviewProvider, proposalDraftProvider, proposalActionsProvider.
Section Stateless, menerima data/callback; draf tidak di-reset saat repository berubah.

Fixture tersinkron: Rudi minta batal A-0139, Bu Rina cuci setrika/alamat perlu
pemeriksaan, Agus Pratama baru/Bed cover 1 pcs. Layanan terpilih tampil pertama.
Nama/telepon/alamat memakai selectAllOnFocus. Nama dan telepon pelanggan baru
wajib valid; layanan harus aktif. Pelanggan terdaftar dibaca dari repository.

Interaksi:
- Bu Rina: konfirmasi Alamat belum dipastikan sebelum membuat order.
- Agus: pelanggan baru dibuat saat setuju; nomor yang sudah masuk lewat impor
  dipakai ulang. Tolak atau kembali tidak membuat pelanggan.
- Setuju membuat order source whatsappAi; status memakai initialOrderStatus
  profil R4. Layanan kg qtyMilli 0/total 0 sampai berat diisi; layanan pcs 1 pcs.
- Detail Order memperlihatkan pesan berat belum diisi dan tombol ke Edit Order.
- Rudi: ConfirmModal Batalkan order A-0139?; konfirmasi memakai koreksi pembayaran
  dan ledger pembatalan yang ada. Batal dialog tidak mengubah order.
- Tolak lewat ConfirmModal Tolak usulan ini?, memindahkan usulan ke riwayat.
- Order ID tetap per proposal. Retry setelah simpan order berhasil tetapi status
  usulan gagal memperbarui status saja; tidak membuat order/pelanggan ganda.
- Gagal simpan order baru menghapus pelanggan yang baru dibuat sebagai kompensasi.
  Atomicity lintas repository untuk pembatalan/tabungan tetap utang yang sudah ada.
- Detail status final readonly, membuka order terkait bila tersedia.

Selisih .pen: pilihan layanan lewat ChipBar registry; tidak menetapkan berat dari
perkiraan pesan. Penyesuaian DATA MASTER disetujui pengguna 31 Okt.
Verifikasi: dua mode R4, idempotensi/retry, batal/tolak, pembuatan pelanggan,
keyboard 300 dp (nama/telepon/alamat), golden dua varian dan 320 px/teks 2x.
Android/iOS/TalkBack/VoiceOver belum diuji untuk layar ini. Tidak ada AI/pesan nyata.


## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
