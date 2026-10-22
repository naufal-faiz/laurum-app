# Kemajuan Fase 1

## 22 Oktober 2026 — kelompok atom pertama

Lingkup: AppText, AppIcon, AppGap, AppDivider, AppCard, AppSvg.
Tidak mengerjakan kelompok berikutnya sampai tinjauan pengguna.

### Implementasi

| Widget | Baris Dart |
| --- | ---: |
| AppText | 64 |
| AppIcon | 27 |
| AppGap | 19 |
| AppDivider | 16 |
| AppCard | 47 |
| AppSvg | 29 |

- Seluruh atom memakai token core/theme dan enum ikon yang sudah tersedia.
- Tambahan AppDimensions (ukuran ikon 16/20/24, garis/border 1) diizinkan pengguna;
  nilai token lama tidak diubah.
- Lima use-case Widgetbook mencakup seluruh varian. AppSvg ditunda sesuai instruksi
  sampai aset produksi pertama; daftar AppSvgs kosong.
- Enam tes widget dan lima golden galeri memakai font lokal.
- Katalog parameter, varian, contoh, dan batas pemakaian ada di
  docs/design/component_catalog.md.
- AGENTS.md diperbarui agar semua catatan kemajuan berada di docs/progress,
  bukan docs/prompts. File prompt tidak diubah oleh tugas ini.
- Tidak ada provider, fixture bisnis, rute, widget di luar registry, atau paket baru.
- dart format dipakai karena Prettier tidak mendukung Dart.

### Visual dan hal yang belum pasti

- Kelima galeri Flutter telah dirender dengan font lokal; semua varian terlihat,
  tidak ada overflow. PNG ada di test/goldens/.
- Perbandingan .pen berhasil melalui server MCP visual_studio_code yang diberikan
  pengguna. Konektor sesi salah mengarah ke desktop; berkas desain tidak diubah.
- Referensi Antrean - Beranda: i1jkP, Xa0qs, JrA3v (kartu); VHueK, D6n7xs,
  XjlWD (teks); gxvLY/gKNjY (gap); plTzD (separator); qN76G (ikon navigasi).
  Screenshot referensi disimpan di docs/progress/fase-1-visuals/.
- Cocok: radius/padding kartu 16, rail 4, border 1, gap 12, judul 24/32 w700
  ls -0.6, body 14/20, section 16/22 w600; tanpa bayangan kartu.
- Selisih: glyph Ionicons menggantikan Lucide/Material sesuai PRD; divider generik
  memakai border, sementara plTzD memakai chipIdle; monoLabel memakai token w400,
  sementara nomor nota NAfLI di .pen w600. Token lama tidak diubah.
- SVG produksi belum ada; hanya fixture pengujian. Use-case AppSvg ditunda.
- Belum diuji di iOS atau perangkat Android pada tugas ini; golden dibuat di Windows.
- Perubahan lokal yang sudah ada saat mulai (.metadata, web/, konfigurasi lint,
  PRD dan catatan Fase 0) dipertahankan.

### Pemeriksaan

SELESAI untuk kelompok ini; menunggu tinjauan pengguna sebelum kelompok berikutnya.

- dart run tool/check_all.dart: SEMUA HIJAU (format, flutter analyze, dart analyze, check_arch, 16 tes).
- dart format --set-exit-if-changed widgetbook: lulus.
- flutter build bundle -t widgetbook/main.dart: lulus.
- 6 tes atom + 5 golden galeri baru; 5 tes fondasi tetap lulus.
- Seluruh berkas Dart baru maksimal 100 baris. Registry dan aturan lint tidak diubah.

Tinjau melalui flutter run -d chrome -t widgetbook/main.dart (target web sudah tersedia di workspace), atau lihat galeri PNG di test/goldens/.

## 22 Oktober 2026 — kelompok atom kontrol

Lingkup: AppButton, AppIconButton, AppChip, AppBadge, AppStatusText, AppAvatar, AppSwitch.
Pengguna meminta melanjutkan pengembangan setelah pembacaan prompt terbaru.

| Widget | Baris Dart |
| --- | ---: |
| AppButton | 54 |
| AppIconButton | 40 |
| AppChip | 40 |
| AppBadge | 31 |
| AppStatusText | 22 |
| AppAvatar | 36 |
| AppSwitch | 50 |

- Tujuh use-case, tujuh tes widget dan tujuh golden baru; total 30 tes lulus.
- check_all SEMUA HIJAU: format, flutter analyze, dart analyze, check_arch, test, repo_map.
- Tidak mengubah registry/aturan lint atau menambah paket/provider/layar/fixture bisnis.
- Token kontrol tambahan berdasarkan desain; nilai token lama tetap.
- Semantik chip digabung untuk status selected dan aksi; switch menerima value/callback eksternal.
- Screenshot Pencil dibandingkan dengan galeri Flutter; tidak ada overflow.
- Referensi: B4bt3y/Ax5fO/h8n1Hk/azFlV/xpKx9/e32I1Q (tombol), jo0oP (ikon),
  VFXLp/EciH5 (chip), s9ip1 (badge), G8xEZi (bayar), SlEQS (avatar), ZOUFH/qcTo3 (switch).
- Selisih: CTA/secondary w700 token vs w600 desain; Ionicons mengganti glyph;
  status bayar tanpa titik dekoratif, sesuai PRD berupa teks.
- Disabled memakai token yang tersedia; opacity switch 0.5 belum punya frame acuan terverifikasi.
- Referensi PNG: docs/progress/fase-1-controls-visuals/; detail API di component_catalog.md.
- Android SDK 36.0.0/JDK 25 terdeteksi dan lisensi lengkap. Belum ada perangkat tersambung.
- Build awal gagal karena NDK 28.2.13676358 belum terpasang dan SDK Manager baru memecah
  identifier paket lama. Pemasangan langsung ndk/28.2.13676358 berhasil mulai mengunduh; dihentikan sekitar 14% atas permintaan pengguna. APK ditunda.
- iOS belum diuji (Windows tanpa Xcode).
- flutter build bundle -t widgetbook/main.dart: lulus.
- Pengguna memilih menunda APK dan menutup kelompok widget; unduhan NDK dihentikan.
- Kelompok kontrol selesai dan menunggu tinjauan. Tidak memulai kelompok selanjutnya.

## 23 Oktober 2026 — kelompok atom input

Lingkup: AppTextField, AppSearchField, AppSkeleton, AppNumpadKey.

| Widget | Baris Dart |
| --- | ---: |
| AppTextField | 88 |
| AppSearchField | 88 |
| AppSkeleton | 25 |
| AppNumpadKey | 54 |

- Empat use-case dan empat berkas tes baru (lima kasus), empat golden baru.
- AppText diperluas dengan varian numpad 18/24 w700 dari desain; golden teks diperbarui.
- Controller hanya pada field yang diizinkan registry; tanpa setState atau provider.
- Tes mencakup entry/filter/submit, value eksternal, selection, clear, disposal, varian field,
  skeleton statis dan seluruh key numpad. Pemeriksaan sebelumnya lulus 39 tes.
- Bundle Widgetbook berhasil dikompilasi; pemeriksaan akhir check_all dijalankan kembali.
- Semua galeri diperiksa tanpa overflow. Tombol clear diperbaiki agar tidak menutupi border.
- Screenshot Pencil disimpan di docs/progress/fase-1-inputs-visuals/.
- Acuan T24HQe/kmkgP/LRZzT (field), Q1YznQ/e48H25/dStCL/E2wCq (skeleton),
  f0G1R/TU6VH/ONyEv (numpad). Warna/radius/tipografi sesuai token.
- Selisih: field baku 48 vs beberapa frame 44; placeholder search satu baris vs frame
  panjang membungkus; multiline rata atas vs contoh satu baris rata tengah; glyph Ionicons.
- Toggle mata pada field password belum disediakan; obscureText dikontrol pemanggil.
- Fokus/error/disabled menggunakan token, tetapi frame state khusus belum terverifikasi.
- Tidak ada dependensi/registry/aturan lint baru; APK tetap ditunda sesuai keputusan pengguna.
- Keyboard/IME dan aksesibilitas perangkat Android/iOS belum diuji.
- Dokumentasi sempat tertunda karena batas penggunaan peninjau persetujuan otomatis;
  dilanjutkan 23 Oktober setelah pengguna meminta continue.
- Pemeriksaan akhir 23 Oktober: check_all SEMUA HIJAU (format, flutter analyze,
  dart analyze, check_arch, 39 tes, repo_map 75 berkas); format Widgetbook juga lulus.
- Kelompok selesai. Semua 17 atom registry tersedia; berhenti menunggu tinjauan pengguna.

## Molecules M1 — 23 Oktober 2026
- Delapan widget, delapan use-case semua varian, delapan tes perilaku dan delapan golden.
- Acuan Pencil tersimpan di docs/progress/fase-1-m1-visuals/.
- SectionHeader (ogqS8): judul sesuai section; garis bawah dan teks kanan statis pada frame belum menjadi opsi khusus (aksi opsional tersedia).
- InfoRow (pA7A7): frame berupa ikon/alamat inline; API menyediakan pasangan label/nilai fleksibel untuk pemakaian umum.
- StatTile (C2MvH3): padding 16 vs 14, nilai figure 24 vs frame sekitar 18, ikon tanpa kotak latar. Menggunakan token/atom yang tersedia.
- DateGroupHeader (DaGCC): latar, dot 8, padding 10/16 sesuai; teks berasal dari pemanggil.
- ProgressRow (ZFy5T): track pill 8 dan warna sesuai; label/nilai di atas track.
- MenuRow (MkVX5): ikon langsung tanpa kotak latar frame; glyph Ionicons menggantikan Lucide.
- ToggleRow (SW1pv): target switch 48 plus padding vertikal 6 menghasilkan baris minimum 60 vs frame 48; tidak memperkecil target sentuh.
- LockedRow (aSIwH): label dan ikon lock sesuai; tinggi mengikuti isi/padding, bukan dikunci 48.
- Tidak mengubah atoms. Opsi ikon pendamping tersedia pada ToggleRow/LockedRow. Data galeri teknis, bukan fixture bisnis.
- AppBarRoot nanti memakai slot syncIndicator dari pemanggil agar tidak mengimpor molecule lain.
- APK tetap ditunda; runtime iOS dan pembaca layar perangkat belum diuji.
- Checkpoint M1: check_all SEMUA HIJAU, 55 tes, repo_map 102 berkas (23 Oktober).

## Molecules M2 — 23 Oktober 2026
- LabeledField, BannerMessage, NoticeAi, CalloutAi, EmptyState, SyncIndicator selesai diimplementasikan.
- Enam galeri Flutter diperiksa tanpa overflow; referensi di docs/progress/fase-1-m2-visuals/.
- LabeledField jbLdH: label 14/20 dan gap 6 cocok; atom field tetap 48 vs frame 44. Error wrapper tidak mengubah border child; pilih satu lokasi error agar tidak duplikat.
- BannerMessage XFgML: info radius 12/padding 12/gap 8 sesuai. Warning/error memakai palet tema; frame khusus belum ditemukan.
- NoticeAi K1Xa3y/FnvUf: kalimat persis, radius 12/padding 12 dan body 14/20 sesuai.
- CalloutAi s45lh: isi dan label sesuai; ikon Ionicons 16 vs Lucide 12x15; jarak antarbaris mengikuti line height tanpa tambahan 2 px frame.
- EmptyState nKUPl: lingkaran 64/ikon 28, heading dan gap sesuai; lebar teks responsif vs frame fixed 280.
- SyncIndicator I3YmrS/ARosk: tersimpan/offline cocok padding 4/8, ikon 12, pill; glyph berbeda. Menyimpan/gagal belum memiliki frame terverifikasi, memakai chipIdle/errorTint dan ikon refresh/alert. Refresh statis, tanpa timer/provider.
- Tidak ada perubahan atom atau kebutuhan widget di luar registry. iOS/perangkat tetap belum diuji.
- Checkpoint M2: check_all SEMUA HIJAU; 67 tes, repo_map 121 berkas. Pengguna meminta AppChip tetap tanpa icon; selisih PeriodTabs dicatat pada M3.
