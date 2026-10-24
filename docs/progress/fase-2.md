# Fase 2 - Antrean (24 Oktober 2026)
- Baseline commit 2d8dd6f: check_all SEMUA HIJAU, 215 tes, 60/60 widget.
- Prompt 20: StatefulShellRoute lima tab, seluruh rute PRD A 8 berupa placeholder
  bila belum dibuat, dua entry point memakai data dummy dan router yang sama.
- Antrean: snapshot repository publik, chip 12/3/5/4/3, filter persisten antar tab,
  progres status dengan event atomik dan guard klik ganda/status usang.
- Tolak mengubah status usulan tanpa membatalkan order; Periksa membuka placeholder.
- Loading, kosong, filter kosong, retry error dan koneksi WhatsApp palsu dibuat.
- 18 tes terarah lulus termasuk navigasi semua rute, tujuh golden dan teks 2x/320px.
- Font asli wajib dimuat untuk uji visual; Ahem bawaan tes memicu overflow palsu.
- Karakter pemisah tanggal sempat rusak, diperbaiki dan dilindungi assertion teks persis.
- Pencil aktif dan screenshot frame zb8jN, akEX1, zqBHI, MrWTS, P1axJ dibaca.
- Golden normal/proses/kosong/loading/whatsapp diperiksa. Selisih: tiga pesan master
  ditampilkan dibanding dua contoh frame; tanggal bertahun; tombol Hubungkan terpisah;
  header/filter dan FAB tetap muncul saat kosong; skeleton lebih tinggi; nav dinamis.
- Callout/pembatalan AI khusus tidak dibuat karena kontrak minimal; menunggu prompt 80.
- Atom/token/registry/lint tidak diubah. Android/iOS perangkat belum diuji.
- Penggunaan 5 jam mencapai 91%; berhenti atas instruksi pengguna, jangan mulai prompt 30.

## Penutup prompt 20 (24 Oktober 2026)
- AntreanPage dirapikan dari 101 menjadi 100 baris dengan melepas PageStorageKey;
  posisi gulir tetap terjaga karena StatefulShellRoute memakai indexedStack.
- Self-review: guard klik ganda, status usang, error banner, retry, dan filter persisten
  sesuai kontrak. Tolak tidak membatalkan order; Periksa tetap placeholder prompt 80.
- Golden normal/proses/kosong/filter kosong/loading/error/WhatsApp diperiksa; tidak ada
  overflow. FAB memang menutupi kartu terbawah sampai daftar digulir.
- Temuan: placeholder daftar turunan (mis. /lainnya/layanan, /laporan/piutang) masih
  memakai SubScaffold tanpa nav bawah; aturan nav daftar turunan diterapkan saat layar
  tersebut dibangun, bukan di prompt ini.
- Katalog diperbarui: AntreanPage, root shell/router, dan provider shell.
- check_all SEMUA HIJAU: 232 tes, kedua analyzer bersih, check_arch OK, REPO_MAP 342 berkas.
- Prompt 20 SELESAI; berikutnya docs/prompts/30-transaksi-a.md setelah tinjauan.
