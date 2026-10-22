# STATE Laurum
Ringkasan aktif; jejak rinci ada di docs/progress/fase-N.md.

Diperbarui: 2026-10-23 oleh Codex | Cabang: dev1
Commit sebelumnya: cbd3678 (atom kontrol). Commit kelompok input: lihat git log -1.

## Posisi
Fase 1: semua 17 atom registry sudah diimplementasikan (17/60 widget total).
Kelompok input selesai dan menunggu tinjauan pengguna; jangan mulai molecules.

## Selesai
- Fondasi Fase 0: app dummy, dependensi/font, tema/formatter/ikon, application ID com.cashier.laurum.
- Kelompok pertama enam atom dan kelompok kontrol tujuh atom selesai.
- Kelompok input: AppTextField (88), AppSearchField (88), AppSkeleton (25), AppNumpadKey (54 baris).
- Empat use-case/berkas tes/golden baru, katalog dan screenshot Pencil tersedia.
- Varian AppText.numpad memakai token baru 18/24 w700; token lama tetap.
- Controller field dimiliki/dispose oleh widget; tidak ada setState/provider pada atom.
- Bundle Widgetbook berhasil; check_all SEMUA HIJAU: kedua analyzer, check_arch, 39 tes, repo_map 75 berkas.
- AppSvg siap, tetapi belum ada SVG produksi; path kosong dan use-case ditunda.

## Sedang dikerjakan
- Tidak ada implementasi aktif; kelompok input ditutup untuk tinjauan pengguna.
- Langkah berikutnya setelah persetujuan: kerjakan kelompok molecules yang ditentukan pengguna.

## Keputusan berlaku
- custom_lint dilepas; riverpod_lint 3.1.9 lewat dart analyze, tanpa override/downgrade.
- Progress di docs/progress; prompt hanya instruksi; REPO_MAP otomatis lewat check_all.
- Batas 100 baris (keras 110); satu kelompok per tinjauan. Tidak mengubah registry/aturan lint.
- Field default tinggi 48 sesuai token, beberapa frame 44; skeleton statis sesuai desain.
- Placeholder search satu baris; clear muncul saat berisi. Numpad hanya mengirim callback.
- Field password menerima obscureText; toggle mata belum disediakan.
- Frame khusus focus/error/disabled field belum terverifikasi, warna memakai token.
- Glyph Ionicons menggantikan Lucide sesuai Kit Agen.
- Formatter menerima WIB lokal; konversi UTC/WIB di satu titik saat Drift masuk.

## Antrean dan batas
1. Tinjau kelompok input melalui Widgetbook; jangan melanjutkan kelompok lain otomatis.
2. APK tetap ditunda. NDK 28.2.13676358 belum selesai diunduh (dihentikan atas permintaan pengguna).
3. Saat APK dilanjutkan: sdkmanager --install "ndk/28.2.13676358", lalu build APK dummy.
- Android SDK/JDK/lisensi terdeteksi; belum ada verifikasi runtime pada HP/emulator.
- iOS dan keyboard/IME/aksesibilitas pada perangkat belum diuji.
- package-lock.json untracked tidak terkait tugas, tidak diubah atau dimasukkan commit.

## Lingkungan
Flutter 3.47.7 / Dart 3.13.5, Windows. Tidak menambah dependensi dalam kelompok input.
