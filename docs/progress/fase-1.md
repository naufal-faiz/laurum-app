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
