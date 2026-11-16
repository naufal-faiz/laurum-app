# 06 - Printer dan Struk
Rute: /lainnya/printer   Fase: 4   Frame .pen: "Lainnya - Printer dan Struk"
Template: FormScaffold (AppBarSub + body gulir + FooterBar sticky)

Komposisi:
- AppBarSub varian detail: back bulat, judul 'Printer dan struk', subjudul
  'Koneksi & format nota kasir', badge status di kanan.
- PrinterConnectionSection: BannerMessage warning 'Printer belum terhubung.' + AppButton
  'Cari printer'; atau AppCard berisi nama printer + 'Terhubung dan siap mencetak' + Ganti.
- PrinterSettingsSection: SegmentedControl '58 mm'/'80 mm' (mengetuk '80 mm' hanya
  menampilkan BannerMessage 'Printer 80 mm masih coming soon...' dan ukuran tetap
  58 mm), SegmentedControl 'Normal'/'Besar',
  ReceiptToggleList (alamat, pelanggan, tabungan, catatan; dua baris terkunci),
  LabeledField + AppTextField 'Teks penutup struk' dan 'Catatan khusus nota'.
- PrinterPreviewSection: ReceiptPreview (lebar 320 untuk 58 mm, 384 untuk 80 mm) memakai
  receiptLines dari ReceiptFormatter; teks 'belum diuji' ke printer asli.
- Footer: AppButton('Simpan pengaturan') + AppButton('Cetak uji').

Data dan provider:
- printerSettingsProvider (AsyncNotifier) memuat ReceiptSettings lewat
  ReceiptSettingsRepository dan BusinessProfile lewat BusinessRepository.
  Edit langsung mengubah state; save menulis keduanya lewat TransactionRunner.
- Printer yang dipilih disimpan di LocalSettingsRepository (printer_id/printer_name),
  hanya lokal di perangkat dan tidak masuk outbox sinkron. Saat halaman Printer dibuka,
  `printerRestoreProvider` mencoba menyambung ulang printer tersimpan secara diam
  (tanpa banner error bila printer mati).
- printerConnectionProvider (Notifier) memegang status, devices, connected, notice.
- printServiceProvider: build backend memakai EscPosPrintService + BlePrinterTransport
  (BLE nyata); build dummy/tes memakai FakePrintService yang dapat disetel gagal/tidak
  terhubung.
- demoReceiptLines memakai A-0143 DATA MASTER.

Interaksi:
- Cari/Ganti langsung membuka modal pencarian dengan loader selama discover/connect.
  Modal menampilkan printer terakhir tersimpan di perangkat dan hasil pindai tanpa duplikasi.
  Cari lagi dan pemilihan printer nonaktif selama proses; callback juga menolak duplikasi.
  Bluetooth mati menampilkan peringatan untuk mengaktifkannya terlebih dahulu, tanpa
  modal/tombol aktivasi. Build dummy memakai daftar palsu; backend memakai hasil BLE.
  Printer tersimpan memakai preferensi perangkat yang sudah ada, tidak disinkronkan ke cloud.
- Mengubah kertas/huruf/toggle/teks langsung memperbarui pratinjau; Simpan menulis
  ReceiptSettings dan BusinessProfile (footer/note) secara atomik; memakai profil
  terbaru agar perubahan nama/status order setelah form dibuka tetap dipertahankan.
- Cetak uji mengirim List<String> 32 kolom + paperMm/fontSize ke PrintService;
  sukses menampilkan notice, gagal menampilkan BannerMessage error.
- Ganti membuka daftar printer lagi.
- Alert memakai info biru, berhasil hijau, peringatan jingga dan gagal merah, dengan
  ikon dan pesan yang menjelaskan hasil. Simpan/koneksi/cetak berhasil memakai success.

State: memuat skeleton, gagal memuat + Coba lagi, belum terhubung, Bluetooth mati,
daftar printer kosong, cetak gagal, cetak sukses.

Skeleton hanya untuk pemuatan awal; pembaruan pengaturan di latar belakang tetap
menampilkan kontrol yang sudah terpasang. Penulisan preferensi printer dan metadata
sinkronisasi tidak memuat ulang query bisnis (DriftChangeMonitor).

Format: ReceiptFormatter 32 kolom; ReceiptPreview mono 11/16; Formatters untuk tanggal.

Selisih terhadap .pen: tanpa tab Printer/Tampilan struk (satu halaman gulir), tanpa
pengaturan perataan header, pilihan ukuran huruf hanya Normal/Besar (11/13),
pratinjau 80 mm tetap 32 kolom, dan status koneksi hanya berasal dari BLE nyata pada
build backend (dummy memakai printer palsu).
iOS: printer thermal banyak memakai Bluetooth Classic (SPP) yang tidak tersedia untuk
aksesori non-MFi; adapter hanya memakai BLE (`flutter_blue_plus`) sehingga Classic
tidak didukung. Fitur ini **belum diuji di iOS**.


## Redesign 14 Nov 2026 (frame LAURUM · Printer & Struk)

Frame: `LAURUM · Printer & Struk` (4294969167), `LAURUM · Cari Printer Bluetooth`
(4294969275), `LAURUM · Printer & Struk — Terhubung` (4294969351). Tampilan saja.

### Paritas redesign

| Butir | Sumber lama | Ada di UI baru |
|---|---|---|
| Data printerSettingsProvider (settings, profile, notice) | Page | ya |
| Data printerConnectionProvider (status, connected, busy, notice) | Page | ya |
| printerRestoreProvider saat halaman dibuka | Page | ya |
| demoReceiptLines + ReceiptPreview | Preview | ya |
| Memuat skeleton / gagal + Coba lagi | Page | ya |
| Belum terhubung (kartu status) | Banner + tombol | ya (status di kartu) |
| Terhubung + nama printer + id perangkat | Kartu | ya |
| Busy koneksi ("Memproses koneksi printer...") | Kartu | ya |
| Bluetooth mati (banner warning) | Banner | ya |
| Tombol Cari printer / Ganti | Section | ya |
| Chip 58/80 mm + notice coming soon | Settings | ya |
| Chip Normal/Besar | Settings | ya |
| Toggle alamat, pelanggan, tabungan, catatan | ReceiptToggleList | ya |
| Info "nomor nota & rincian selalu tampil" | 2 LockedRow | ya (keterangan bawah judul kartu) |
| Field teks penutup + catatan khusus | Settings | ya |
| Pratinjau struk + lebar 320/384 + catatan belum diuji | Preview | ya |
| Simpan pengaturan | Footer | ya |
| Cetak uji + banner sukses/gagal | Footer | ya |
| Sheet: printer tersimpan, hasil pindai, dedup, busy | DeviceSheet | ya |
| Sheet: Bluetooth mati tanpa modal aktivasi | DeviceSheet | ya |
| Sheet: Cari lagi | DeviceSheet | ya |
| Key/golden host (`antrean-golden`) | tes | ya |

### Selisih desain

- Tombol header "Putus" tidak dibuat: state tidak punya aksi putuskan; aksi yang ada
  (Ganti) dipertahankan (UI-9/UI-10).
- Banner "Cetak otomatis aktif setelah pembayaran" tidak dirender: cetak otomatis
  belum ada di PRD/state (UI-9).
- Indikator baterai/sinyal tidak ditampilkan: PrinterDevice hanya punya id dan nama.
- Badge hijau "Terhubung" memakai AppBadge varian `siap` (biru); varian sukses belum
  ada di registry (tanpa token/varian baru).
- Kartu terhubung memakai AppCardStyle.success (#E9F5EE, tanpa garis hijau); Figma
  #F0FDF4 bergaris #86EFAC.
- Kontrol 58/80 dan Normal/Besar memakai SegmentedControl (molekul baru, proposal 032)
  mengikuti track+pil Figma; ukuran teks segmen memakai token label 13 (Figma 10),
  lebar track mengikuti sisa baris kartu (Figma 198). Label tetap "58 mm", "80 mm",
  "Normal", "Besar" agar perilaku/tes tidak berubah.
- Subjudul header memakai teks ringkas 'Koneksi & format nota kasir' agar muat satu
  baris dengan badge di header detail bersama.
- Device list memakai MenuRow di dalam AppCard (bukan kartu + tombol per baris), tanpa
  badge "Memindai..." karena loader + teks busy sudah ada.
- Label Figma Title Case tidak diadopsi; teks pesan mengikuti spec.

### Tes yang disesuaikan (finder/visual)

- Review integrasi 16 Nov 2026: baris format sebelumnya overflow 111 px pada
  lebar 320 dp/font 2x. Label dan kontrol kini bertumpuk pada ruang sempit/font besar;
  segmen tumbuh mengikuti teks dengan area sentuh minimum 44 dp, tanpa ellipsis.
- `printer_format_accessibility_test.dart`: regresi font 2x, ukuran sentuh,
  keterbacaan label, callback font 13/58 mm, dan 80 mm tetap pemberitahuan.
- Golden `printer_page.png` diperbarui karena tinggi kontrol berubah; ditinjau sebagai
  gambar. Review Android dan cetak perangkat keras belum dilakukan pada integrasi ini.

- `printer_page_test.dart`: finder status awal `Printer belum terhubung.` menjadi
  `Belum terhubung`; finder judul pratinjau menjadi teks judul baru. Assertion perilaku
  lain tidak berubah. Golden `printer_page.png` diperbarui.
- `printer_sections_feedback_test.dart`: finder ketuk `AppChip` 'Besar'/'80 mm' menjadi
  `find.text(...)` karena kontrol kini SegmentedControl; assertion (font 13, notice
  coming soon) tidak berubah.

## Audit penyelesaian UI - prompt 100
Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
