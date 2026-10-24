# STATE Laurum
Diperbarui: 2026-10-24 | Cabang dev1

## Posisi
Prompt 50 SELESAI. check_all SEMUA HIJAU: 285 tes, REPO_MAP 441 berkas.
Import dirapikan dengan dart fix (directives_ordering); tidak ada info analyzer tersisa.
Baseline sebelumnya: c9b78c1 hijau 276 tes; sembilan tes prompt 50 lulus.

## Selesai
- Prompt 20-40: Antrean, transaksi, pembayaran/nota, printer palsu, Detail/Edit Order,
  Riwayat Nota. Fase 1: 60/60 widget.
- Daftar Pelanggan: pencarian/filter, jumlah reaktif, tambah cepat, seluruh state.
- Detail: statistik DATA MASTER, tiga mutasi dengan saldo berjalan, tiga nota terakhir,
  WhatsApp palsu, rute Setor/Riwayat mutasi placeholder prompt 51.
- Edit: nama/nomor/alamat/catatan, normalisasi dan duplikat aktif, konfirmasi nonaktif.
  Nonaktif memakai isActive=false, tidak menghapus nota/piutang/tabungan.

## Antrean
- Berkas prompt berikutnya: docs/prompts/51-pelanggan-b.md (Setor Tabungan,
  Riwayat Tabungan, Impor Kontak HP). Placeholder rute /pelanggan/:id/setor,
  /pelanggan/:id/tabungan, dan /pelanggan/impor sudah ada.
- Setelah itu 60-laporan.md.

## Keputusan dan batas
- customerSummariesProvider mencakup pelanggan nonaktif; daftar memfilter isActive.
- Riwayat = baseline + snapshot order kini - fixture awal; nota batal dikecualikan.
- Mutasi: saldo dihitung dari seluruh ledger kronologis sebelum mengambil tiga terbaru.
- Edit mengambil pelanggan terkini saat simpan, menjaga id/ownerId/createdAt;
  updatedAt dari jam usaha dan sync pending. Nonaktif mengabaikan draf belum disimpan.
- Rute /pelanggan/impor harus sebelum /pelanggan/:id. Sheet memakai navigator utama.
- Spec 13-detail-pelanggan.md dan 14-edit-pelanggan.md mencatat selisih .pen dan teks modal.
- Statistik vertikal; tanpa rata-rata bulanan/claim potong otomatis yang tidak didukung.
- Order: status berurutan, total edit tidak boleh di bawah pembayaran; pembatalan
  order lalu koreksi tabungan belum memiliki rollback lintas repository.
- Tidak mengubah widget bersama/registry/token/lint/PRD, tanpa dependensi baru.

## Handoff untuk agen penerus
1. Baca AGENTS.md, SKILLS.md, STATE.md; verifikasi git status dan git log -5.
2. Tinjau Detail/Edit di HP: simpan profil, nonaktif, keyboard; data keuangan harus tetap ada.
3. Lanjut prompt 51-pelanggan-b.md bila diminta; fokus satu layar/kelompok widget,
   berhenti menunggu tinjauan. Tool AI Memory tidak tersedia; handoff disimpan di repo.
4. Pengguna meminta berhenti bila sisa usage mendekati 10%; cek get_usage_limits berkala.
   Cek terakhir sebelum penutupan: sisa 5% jendela 5 jam, 53% mingguan.
5. Android/iOS perangkat, keyboard, TalkBack/VoiceOver, telepon/printer nyata belum diuji.
Tidak push/merge.
