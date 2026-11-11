# STATE Laurum
Diperbarui: 2026-11-11 | Cabang newdesign

## Sesi aktif
Layar 25 Periksa Usulan AI putaran 2 + layar 09 Detail Order.
Frame FigCraft 512/612; dasar irisan a8d627e. Pekerjaan penerus SELESAI.

## Status irisan
- Usulan: Ubah layanan lewat AppBottomSheet; Isi berat opsional dalam kartu;
  alamat dan CalloutAi satu kartu, badge Periksa bagian ini oranye.
- Berat masuk qty/total order; kosong tetap opsional, terisi minimal 0,5 kg.
  Simpan/Setujui nonaktif saat invalid; nol/leading zero/titik-koma dinormalisasi.
  Ganti layanan mengosongkan berat. Draf dipisah ke proposal_draft.dart (<110 baris).
- Detail Order: header status/waktu, nota, kontak, rincian, pembayaran, aktivitas,
  footer sesuai mode/COD/final. Seluruh aksi dan 12 baris paritas tetap lengkap.
- InfoRow.compact opt-in hanya pada Detail Order; default layar lain tetap.
- Golden 9: app_badge, callout_ai, proposal_card, proposal_rina, proposal_new_customer, r4_order_detail, r9_cod_detail, order_detail_actions_1x/2x.
- Visual belum diverifikasi manual putaran ini (UI-19); golden diperiksa.
  Keyboard 300 dp dan 320 dp/teks 2x lulus. iOS belum diuji.

## Keputusan pengguna terbaru
- Izin spesifik: "Izinkan, berat masuk draf"; mencakup state draf dan order.
  Berkas state berubah hanya proposal_review, proposal_order, dan proposal_draft.
- Pemilih layanan dalam kartu, alamat satu kartu, badge oranye; tanpa jadwal baru.
- AGENTS.md terbaru dari pengguna ikut disimpan; tanpa push/merge.

## Belum di-commit
Kode/tes/spec/STATE disimpan dalam commit akhir. FigCraft pengguna dikecualikan.
Stash f7a9e49 sudah diterapkan oleh agen sebelumnya dan tetap sebagai cadangan;
jangan apply ulang otomatis.

## Langkah berikutnya
1. Tinjauan pengguna untuk layar 25 dan 09.
2. Tunggu arahan layar berikutnya; jangan mulai pekerjaan lain otomatis.

## Blocker
Tidak ada. Graph sempat transport closed; tidak diulang, sumber langsung dipakai.

## Bukti terakhir
- dart run tool/check_all.dart: SEMUA HIJAU, exit 0; 1072 lulus/1 skip.
  TEMP/laurum-resume-complete-check.log; REPO_MAP 1080 berkas.
- Tes terarah 28 lulus; golden/alur Order 6 + COD 1 lulus; check_arch OK.
- Finder visual diubah: proposal_pages/sections/detail_sections/alignment
  (subtitle/modal/Text.rich), r4_detail_completion/r4_finish_flow (tooltip ikon).
  Assertion aksi/transaksi lama tetap; proposal_keyboard menambah tes sheet berat.
- Tes baru: order_detail_sections, proposal_weight, proposal_weight_validation.
  app_badge menambah perhatian. Tidak mengubah tes non-widget.