# STATE Laurum
Diperbarui: 2026-10-24 | Cabang dev1

## Posisi
Prompt 50: Daftar, Detail Pelanggan, dan sheet Edit profil sudah diimplementasikan.
Validasi akhir BELUM HIJAU: analyzer directives_ordering pada import. Dihentikan karena usage 5%.
Baseline sesi c9b78c1: check_all hijau, 276 tes. Sembilan tes baru sudah lulus terarah.

## Selesai
- Prompt 20-40: Antrean, transaksi, pembayaran/nota, printer palsu, Detail/Edit Order,
  Riwayat Nota. Fase 1: 60/60 widget.
- Daftar Pelanggan: pencarian/filter, jumlah reaktif, tambah cepat, seluruh state.
- Detail: statistik DATA MASTER, tiga mutasi dengan saldo berjalan, tiga nota terakhir,
  WhatsApp palsu, rute Setor/Riwayat mutasi placeholder prompt 51.
- Edit: nama/nomor/alamat/catatan, normalisasi dan duplikat aktif, konfirmasi nonaktif.
  Nonaktif memakai isActive=false, tidak menghapus nota/piutang/tabungan.

## Sedang dikerjakan
- WIP: tinjau hasil dart fix --apply --code=directives_ordering yang diinterupsi; urutkan import Dart (package sebelum relatif, ordinal) pada customer_detail_page.dart dan customer_detail_page_test.dart. Jalankan dart format lalu check_all sampai hijau.

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
3. Setelah perapian import: check_all, ubah INDEX prompt 50 menjadi SELESAI, commit. Baru lanjut prompt 51-pelanggan-b.md jika diminta.
   Fokus satu layar/kelompok; Setor Tabungan, Riwayat Tabungan, Impor Kontak masih placeholder.
4. Pengguna meminta berhenti bila sisa usage mendekati 10%; cek get_usage_limits berkala.
   Cek terakhir sebelum penutupan: sisa 5% jendela 5 jam, 53% mingguan.
5. Android/iOS perangkat, keyboard, TalkBack/VoiceOver, telepon/printer nyata belum diuji.
Tool AI Memory tidak tersedia; handoff disimpan di repo. Tidak push/merge.

