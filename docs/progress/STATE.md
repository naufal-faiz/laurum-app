# STATE Laurum
Ringkasan aktif; jejak rinci ada di docs/progress/fase-N.md. Maksimal sekitar 60 baris.

Diperbarui: 2026-10-22 oleh Codex | Cabang: dev1
Commit implementasi terakhir: 0495481 (enam atom pertama). Commit sinkronisasi: 529f0eb. Perbaikan generator: lihat git log -1.

## Posisi
Fase 1: kelompok atom pertama selesai, menunggu tinjauan pengguna.
Fondasi Fase 0 selesai; verifikasi build/perangkat Android masih tertunda.

## Selesai
- Fase 0: application ID com.cashier.laurum, dependensi, font lokal, tema, Formatters, AppIcons, LaurumApp/main_dummy, skeleton Widgetbook.
- Lint Riverpod ditutup: dart analyze mendeteksi missing_provider_scope dan avoid_public_notifier_properties pada probe sengaja; probe sudah dihapus. Bukti dicatat di PRD A bagian 13.
- AppText (64 baris), AppIcon (27), AppGap (19), AppDivider (16), AppCard (47), AppSvg (29).
- Lima use-case Widgetbook, enam tes atom, lima golden, katalog komponen dan perbandingan Pencil tersedia.
- AppSvg belum memiliki aset produksi: konstanta path kosong dan use-case ditunda.
- Bundle Widgetbook berhasil dikompilasi pada pekerjaan sebelumnya.

## Sedang dikerjakan
- Sinkronisasi panduan/progres dan REPO_MAP selesai; generator merapikan whitespace. Menunggu tinjauan kelompok pertama.
- Langkah berikutnya: tinjau kelompok pertama, lalu mulai kelompok pada docs/prompts/fase-1.md setelah pengguna mengizinkan.

## Antrean
1. Tahap berikutnya: verifikasi SDK Android yang sudah dipasang pengguna, build APK dan jalankan main_dummy jika perangkat tersedia.
2. Kelompok berikutnya: AppButton, AppIconButton, AppChip, AppBadge, AppStatusText, AppAvatar, AppSwitch.
3. Perbarui katalog/progres, jalankan check_all, lalu berhenti untuk tinjauan.

## Keputusan berlaku
- custom_lint dilepas; riverpod_lint 3.1.9 dipertahankan melalui plugin native dan dart analyze. Tidak ada override/downgrade.
- Progress selalu di docs/progress; prompt hanya instruksi. REPO_MAP dihasilkan otomatis lewat check_all.
- Token tambahan ukuran ikon 16/20/24 dan garis/border 1 diizinkan; token lama tidak diubah.
- Batas file 100 baris (keras 110); satu kelompok per tinjauan.
- Selisih visual terdokumentasi: glyph Ionicons, warna divider generik, bobot monoLabel.
- Bayangan footer 0 -4 14 #131B2E14; modal tanpa bayangan.
- Formatter menerima waktu WIB lokal; konversi UTC/WIB di satu titik saat Drift masuk.

## Pemeriksaan dan batas
- check_all sinkronisasi: SEMUA HIJAU (format, flutter analyze, dart analyze, check_arch, 16 tes, repo_map 39 berkas).
- SDK Android sudah dipasang menurut pengguna; belum diverifikasi, pengujian ditunda ke tahap berikutnya sesuai permintaan.
- iOS belum diuji (Windows tanpa Xcode).
- package-lock.json muncul sebagai berkas untracked pengguna; tidak diubah atau dimasukkan dalam commit tugas ini.
- Akses visual Pencil sebelumnya berhasil lewat MCP visual_studio_code; konektor desktop pernah gagal.

## Lingkungan
Flutter 3.47.7, Dart 3.13.5. Paket: flutter_riverpod 3.4.3, go_router 18.1.1, equatable 3.0.0, intl 0.20.3, ionicons 0.2.3, flutter_svg 2.3.0, widgetbook 3.25.0, riverpod_lint 3.1.9.
