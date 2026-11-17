# STATE Laurum
Diperbarui: 2026-11-17 | Cabang newdesign

## Sesi aktif
APK harian Laurum1.0.3+4 selesai; seluruh pembaruan masuk commit rilis sesi ini.
Dasar31a3b12; sumber sudah lulus check_all dan dipakai untuk build release.

## Status irisan
- Nama launcher Android: Laurum; paket tetap com.cashier.laurum, versi1.0.3+4.
- APK: build/app/outputs/flutter-apk/Laurum-1.0.3-release.apk (82.398.407byte).
- Release lib/main.dart, Drift/data asli, Supabase cloud dan Google login dari .env.local.
- DEMO_SEED=false; sertifikat sama dengan APK harian1.0.2+3; APK tidak debuggable.
- Universal APK mencakup arm64-v8a,armeabi-v7a,x86_64; minimum Android API24.
- Kelola akun: logo Google kartu identitas dihapus; teks badge tetap.
- Profil lebih lega/sejajar; dua baris keamanan sama tinggi dan menyesuaikan font besar.
- Zona berbahaya: badge merah, deskripsi dan tombol Hapus akun lebih kecil.
- AccountPasswordSection menjaga keterangan akun Google baca-saja; aksi akun email tetap.
- AppTextField mempertahankan kursor/seleksi/IME saat echo teks identik dari state.
- Numpad nominal pembayaran tidak diubah; revisi Info usaha agent lain dipertahankan.
- Varian compact/token baru Info usaha tidak dibuat (ditolak pengguna).

## Keputusan pengguna terbaru
- Buat APK terbaru untuk harian, nama Laurum (L besar); commit semua pembaruan.
- Tidak ada izin push/merge ke branch lain; tidak memasang atau uninstall aplikasi HP.
- Semua sumber/desain/golden masuk commit; .env/kredensial dan artefak build tetap lokal.

## Belum di-commit
Semua pembaruan sumber disertakan dalam commit rilis sesi ini.
android/build dan test/failures berisi artefak lokal yang tidak dimasukkan.
APK dan checksum berada di folder build yang diabaikan Git.

## Langkah berikutnya
1. Pengguna memasang APK sebagai pembaruan1.0.2, tanpa menghapus aplikasi lama.
2. Uji harian: login/sync cloud, antrean/impor kontak, tarik-refresh, akun dan printer.
3. Jangan push/merge tanpa izin pengguna.

## Blocker
Tidak ada; APK belum diuji langsung pada HP dalam sesi ini.

## Bukti terakhir
- dart run tool/check_all.dart: SEMUA HIJAU,1376tes lulus/2skip Supabase lokal,exit0.
- Regresi akun Google diperbaiki tanpa mengubah tes lama:13tes akun+8tes visual lulus.
- Golden Info usaha diselaraskan dengan subtitle/pesan/ikon Simpan yang sudah ada.
- flutter build apk --release -t lib/main.dart --dart-define-from-file=.env.local
  --dart-define=LAURUM_STORE=drift --dart-define=DEMO_SEED=false:exit0.
- aapt:label Laurum,paket com.cashier.laurum,versi1.0.3+4; apksigner verify:OK.
- SHA256:F4886CEAC3D3531B4DFE3EE3E842487D078B389441D72ADBC51DD61A6827634F.
