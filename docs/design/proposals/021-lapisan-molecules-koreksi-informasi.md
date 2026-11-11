# 021 - Koreksi molecules informasi dan header
Status: DIOTORISASI instruksi pengguna 11 Nov 2026: koreksi header/banner/callout;
banner ringkas dan tegas diminta berlaku global, bukan hanya layar usulan.

- AppBarSub.detail: judul/subtitle tanpa gap tambahan; badge di tengah tinggi
  kelompok judul, bukan sejajar puncak judul. Standard tidak berubah.
- BannerMessage: seluruh varian memakai caption global 13 sp; ikon center;
  info memakai primaryInk agar tetap tegas. API, pesan, varian/warna semantik tetap.
- CalloutAi tambah compact=false; true memakai caption + AppBadge untuk label,
  ikon center. Pemanggil lama termasuk ProposalCard tetap default lama.
- Tidak mengubah atom/token/registry/dependensi. Berkas bersama ini merevisi
  lapisan molecules; seluruh default selain banner global tetap.
- Page usulan: sumber/akurasi satu Row spaceBetween; caption dan ikon kecil,
  kartu layanan memiliki nama terpilih/berat belum diketahui/tarif dan pemisah;
  pilihan layanan tetap inline di bawah kartu sesuai persetujuan 020. Tidak
  menambah aksi baru. Tarif adalah harga layanan asli, bukan total order rekaan.
- Alamat tanpa label berulang dalam kartu, padding ringkas, field dense yang ada,
  maxLines/selectAll/validasi/callback tetap. Perisai center.

## Bukti dan dampak
Tes header/keyboard, baris akurasi/ikon/info/callout, semua paritas usulan.
Golden usulan, detail_molecules/detail_form dan banner_message diperbarui.
Golden layar lain yang berubah karena banner global dicatat sebelum update.
check_all wajib hijau; Android dibandingkan ulang sebelum berhenti.

Golden yang berubah (16, untuk persetujuan UI-28):
- Lingkup layar 25: banner_message, detail_molecules, detail_form, proposal_rina,
  proposal_new_customer, proposal_history.
- Dampak banner global di layar lain (caption 13, ikon center, info primaryInk;
  tidak ada perubahan tata letak lain): add_customer_sheet, ai_settings_disconnected,
  antrean_whatsapp, auth_signin_error, printer_page, r10_signin_error,
  r10_signin_error_320_2x, sync_offline, whatsapp_connected, whatsapp_waiting.
Galeri standard header/form tidak berubah.
Tes posisi/perilaku terakhir 17 lulus; 6 tes golden/layout usulan lulus.
Android SM-N975F dibandingkan ulang frame 512: header, pesan/akurasi, info,
layanan, alamat, badge peringatan, perisai; alamat/selectAll dan footer tetap
terlihat di atas keyboard. Bukti gambar lokal TEMP/laurum-ai-corrected-*.png.
check_all akhir: SEMUA HIJAU, 1063 lulus/1 skip, REPO_MAP 1072.
