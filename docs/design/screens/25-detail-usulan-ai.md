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

## Redesign 018–020 — Paritas sebelum implementasi (11 Nov 2026)
Frame FigCraft 512 dibaca; pengguna menyetujui ketiga proposal komponen bersama.
| Butir | Sumber / aksi lama | Status implementasi |
|---|---|---|
| Proposal lengkap, pelanggan, layanan aktif/harga | proposalReviewProvider(id) | Selesai |
| Nama/telepon/alamat/serviceId draf, validasi, draf tidak di-reset | proposalDraftProvider(id) | Selesai |
| Loading, error/retry, tidak ditemukan, final readonly | cabang snapshot/draft/status lama | Selesai |
| Pending/gagal aksi, cegah klik ganda | proposalActionsProvider(id) | Selesai |
| Field nama, telepon, alamat; pilih layanan | actions.name/phone/address/service, argumen sama | Selesai |
| WhatsApp (validasi nomor, tanpa pesan kirim otomatis) | openProposalWhatsApp(ref, draft.phone) | Selesai |
| Tolak + konfirmasi | rejectReviewedProposal(context, ref, id) | Selesai |
| Setujui/pembatalan + alamat belum pasti | approveReviewedProposal(context, ref, review, draft) | Selesai |
| Final/status dan Buka order | proposalStatusLabel; push orderId lama | Selesai |
| NoticeAi dan CalloutAi alamat | pesan lama, tidak menghapus peringatan | Selesai |
| Back, route id, label field / fokus dan keyboard 300 dp | canPop/pop atau go antrean; tidak ada Key eksplisit pada Page/Section lama | Selesai |

Selisih desain yang disetujui bersama proposal 020: berat tetap diisi lewat Edit
order setelah persetujuan; jadwal jemput tidak tersedia dan tidak ditambahkan.
Pilihan layanan dan field alamat/nama/telepon tetap inline agar alur/draf/callback
lama tidak berubah. Data waktu/nominal memakai Formatters, bukan contoh frame.
Skor AI hanya contoh berlabel dari scope dummy yang sudah ada; data nyata tanpa
skor buatan. Buka WhatsApp tetap pada kartu pelanggan. Semua transaksi/validasi,
pembatalan, koreksi ledger dan idempotensi berada di alur lama yang tidak diubah.

### Tata letak dan golden penerapan 018-020
Header detail intrinsik dengan waktu pesan dan status; kartu kontak; judul primer
Hasil bacaan AI dan pesan lengkap di bubble muted; peringatan pemeriksaan;
layanan/field pelanggan baru serta alamat inline dalam kartu; privasi; footer lama.
Golden yang diperbarui: proposal_rina dan proposal_new_customer, karena susunan
header/kartu/footer. proposal_history dan proposal_card dipertahankan.
### Verifikasi penerapan layar 25 (11 Nov 2026)
Semua baris paritas selesai: provider/aksi/argumen lama tetap, hanya membaca skor
contoh dari proposalDemoAccuracyProvider yang sudah ada. Final readonly dan Buka
order tetap. NoticeAi.message dipertahankan dalam ProposalPrivacySection.
Tes lama tanpa perubahan assertion/finder: proposal_pages, sections, keyboard,
retry; enam tes baru untuk lima Section baru. Golden rina/new_customer diperbarui;
320 dp/2x tanpa overflow. Android SM-N975F dibandingkan dengan frame 512:
header/kartu/pesan/layanan/alamat/privasi dan footer diperiksa; field alamat
select-all serta tombol Tolak/Setujui tetap terlihat di atas keyboard.
Ukuran teks/tap global lebih besar daripada frame. iOS belum diuji.