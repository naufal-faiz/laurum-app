# STATE Laurum
Diperbarui: 2026-11-12 | Cabang backend-newdesign

## Sesi aktif
B5 printer nyata, irisan 1 selesai: encoder ESC/POS murni + kontrak `PrinterTransport`
+ `EscPosPrintService`, semuanya teruji tanpa hardware. Irisan 2 (adapter Bluetooth)
menunggu tipe printer dan izin dependensi. B3b sudah selesai sebelumnya. Jangan
push/merge.

## Status irisan
- B3b: deep link menyegarkan sesi, Cek email memakai sesi server, layar `/password-baru`
  (sementara, tanpa Figma) dengan guard recovery. Tes 21 lulus.
- B5.1: `esc_pos_encoder.dart` (baris 32 kolom → ESC/POS, besar = tinggi ganda, ASCII,
  tanpa cut), `printer_transport.dart`, `esc_pos_print_service.dart` (status nyata).
  Mode dummy tetap `FakePrintService`; belum ada penyambungan provider.
- Rencana/arahan uji B5: `docs/plans/B5-printer.md`; bukti: `docs/progress/b5.md`.
- PARITY.md: baris "Buat password baru" (B3b) sudah terverifikasi.

## Keputusan pengguna terbaru
Mode Backend BE-1..BE-9 aktif; Mode Redesign UI dijeda. Satu tugas backend per sesi,
tanpa push/merge. Tampilan sementara diizinkan bila layar belum ada. B5 dikerjakan
sekarang; B3 perangkat dan B2e ditunda atas keputusan pengguna.

## Belum di-commit
AGENTS.md dan docs/design/new-design-laurum.figcraft milik pengguna, dikecualikan.

## Langkah berikutnya
1. Pengguna memilih printer: BLE, Classic SPP, atau Wi-Fi/LAN; lalu menyetujui paket.
2. Irisan 2 B5: adapter `PrinterTransport` + sambungkan `printServiceProvider`.
3. Uji cetak 58 mm di perangkat dan bandingkan dengan preview.
4. B2e unggah foto pengeluaran: butuh keputusan antrean/migrasi dan kompresi (BE-7).
5. Verifikasi perangkat B3 (tautan pemulihan, Cek email) dengan akun uji + SMTP.

## Blocker
B5 irisan 2: tipe koneksi printer belum diketahui dan dependensi belum disetujui;
tanpa printer fisik, "cetak 58 mm identik preview" belum bisa dibuktikan.

## Bukti terakhir
- flutter test test/printer: 7 lulus; analyze lib/features/printer test/printer bersih.
- dart run tool/check_all.dart: SEMUA HIJAU, 1151 lulus/1 skip, format/analyze/
  check_arch bersih, REPO_MAP 1130 berkas, exit 0.
