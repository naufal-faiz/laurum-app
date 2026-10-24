# STATE Laurum
Diperbarui: 2026-10-24 | Cabang dev1

## Posisi
Prompt 51 SELESAI. check_all SEMUA HIJAU: 292 tes, REPO_MAP 457 berkas, generator
baru untuk setor/riwayat/impor terpasang.
Baseline sebelumnya: bb4196d hijau 285 tes; tujuh tes prompt 51 lulus.

## Selesai
- Prompt 20-40: Antrean, transaksi, pembayaran/nota, printer palsu, Detail/Edit Order,
  Riwayat Nota. Fase 1: 60/60 widget.
- Daftar Pelanggan: pencarian/filter, jumlah reaktif, tambah cepat, seluruh state.
- Detail: statistik DATA MASTER, tiga mutasi dengan saldo berjalan, tiga nota terakhir,
  WhatsApp palsu.
- Edit: nama/nomor/alamat/catatan, normalisasi dan duplikat aktif, konfirmasi nonaktif.
  Nonaktif memakai isActive=false, tidak menghapus nota/piutang/tabungan.
- Setor Tabungan: Numpad + NominalChips aditif, metode ChipBar, catatan, saldo
  sekarang/akhir; menulis SavingsEntry(setor) dengan jam usaha dan ownerId sesi.
- Riwayat Tabungan: header saldo + CTA setor, ChipBar Semua/Setoran/Terpakai, SavingsRow
  lengkap (metode, referensi nota, catatan), saldo berjalan, tanpa BottomNavBar.
- Impor Kontak: ContactSource palsu, pencarian, pilih semua, kontak terdaftar dilewati,
  ringkasan jumlah, state izin ditolak dengan "Buka pengaturan" (app-settings:).

## Antrean
- Berkas prompt berikutnya: docs/prompts/60-laporan.md (Laporan Ringkasan, Daftar
  Piutang). Cocokkan angka dengan docs/design/data_master.md.
- Setelah itu 70-lainnya-a.md.

## Keputusan dan batas
- customerSummariesProvider mencakup pelanggan nonaktif; daftar memfilter isActive.
- Riwayat = baseline + snapshot order kini - fixture awal; nota batal dikecualikan.
- Mutasi: saldo dihitung dari seluruh ledger kronologis sebelum memilih baris;
  savingsMovements dipakai Detail (3 terbaru) dan Riwayat (semua).
- Edit mengambil pelanggan terkini saat simpan, menjaga id/ownerId/createdAt;
  updatedAt dari jam usaha dan sync pending. Nonaktif mengabaikan draf belum disimpan.
- Rute /pelanggan/impor, /:id/setor, /:id/tabungan harus sebelum /pelanggan/:id.
- Setor: nominal awal kosong (Rp0), chip menambah bukan mengganti, maks 9 digit;
  nominal 0 ditolak "Nominal harus lebih dari Rp0."; id sav-new-<micros>.
- Impor memakai normalizePhone sebagai kunci; kontak yang cocok dengan pelanggan
  aktif/nonaktif dilewati. contactImportProvider mematikan retry Riverpod agar izin
  ditolak menjadi state akhir. READ_CONTACTS berisiko (PRD B bagian 10); mitigasi
  pemilih kontak sistem untuk satu pelanggan, layar tetap karena ContactSource di core.
- Fixture kontak DATA MASTER seluruhnya sudah terdaftar (cust-010..013), sehingga dummy
  menampilkan 0 kontak baru; alur simpan diuji lewat override ContactSource. Menambah
  kontak baru perlu keputusan pemilik produk.
- main_dummy.dart memakai dummyOverrides({contactSource}); dummyRepositoryOverrides
  tetap untuk pemanggil lama.
- Statistik vertikal; tanpa rata-rata bulanan/klaim potong otomatis yang tidak didukung.
- Tidak mengubah widget bersama/registry/token/lint/PRD, tanpa dependensi baru.

## Handoff untuk agen penerus
1. Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status dan git log -5.
2. Tinjau di HP: setoran (numpad, chip, metode), riwayat (chip filter, saldo berjalan),
   impor kontak (izin ditolak, pilih semua, nomor duplikat).
3. Lanjut prompt 60-laporan.md bila diminta; satu layar/kelompok widget per sesi,
   berhenti menunggu tinjauan. Tool AI Memory tidak tersedia; handoff disimpan di repo.
4. Pengguna meminta berhenti bila sisa usage mendekati 10%; cek get_usage_limits berkala.
5. Android/iOS perangkat, keyboard, TalkBack/VoiceOver, telepon/printer nyata belum diuji.
Tidak push/merge.
