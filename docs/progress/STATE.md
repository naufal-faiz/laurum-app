# STATE Laurum
Diperbarui: 2026-11-12 | Cabang backend-newdesign

## Sesi aktif
Perbaikan tes lama (diminta pengguna) selesai: tes akun memakai jalur tab Lainnya dan
golden `goldens/lainnya.png` diperbarui. check_all kembali hijau.
Backend B3b irisan state/data selesai: sesi Auth dari deep link `laurum://auth-callback`
disegarkan ke AuthSession, dan "Lanjut" pada Cek email memeriksa sesi server.
Dasar bbb0125; dua commit sesi ini ada di `git log -2`. Jangan push/merge.

## Status irisan
Golden hanya bergeser pada posisi subpiksel label "OPERASIONAL" (644 px); tidak ada
regresi tampilan. Tes "Account opens Lainnya" tidak dilemahkan: assertion rute, indeks
tab, dan tooltip akun di Lainnya tetap ada, mengikuti keputusan avatar Pelanggan dihapus.
Irisan backend tanpa perubahan tampilan: token, shared/widgets, Section, router tidak disentuh.
AuthGateway/AuthService menambah `sessionChanges` + `refreshUser`; mode dummy memakai
stream kosong sehingga perilaku dummy tidak berubah.
SupabaseAuthGateway memakai `onAuthStateChange` dan `getUser`; galat jaringan jatuh ke
identitas cache (tidak mengaku terkonfirmasi, sesi tidak dihapus).
AuthSession berlangganan stream lalu menyegarkan state + accountIdentity; router refresh
dan gerbang penyimpanan ikut bereaksi.
PARITY.md: lima baris titik awal diverifikasi diganti fakta + lima baris perilaku baru
dari daftar diff; tidak ada kasus BE-7 pada daftar itu.

## Keputusan pengguna terbaru
Mode Backend BE-1..BE-9 aktif; Mode Redesign UI dijeda.
Satu tugas backend per sesi, tanpa push/merge, tanpa Figma.

## Belum di-commit
AGENTS.md dan docs/design/new-design-laurum.figcraft milik pengguna, dikecualikan.

## Langkah berikutnya
1. B3b bagian UI: layar "Buat password baru" untuk sesi recovery; butuh keputusan
   penempatan/tampilan (BE-7) sebelum dikerjakan.
2. B2e unggah foto pengeluaran: butuh keputusan antrean/migrasi dan kompresi (BE-7).
3. B5 printer nyata (butuh printer 58 mm fisik).
4. Uji perangkat: konfirmasi email/deep link ujung-ke-ujung dengan akun uji dan SMTP.
5. Jangan push/merge tanpa izin.

## Blocker
Tidak ada. Dua tes lama (golden Lainnya dan tes akun) sudah diperbaiki dengan izin
pengguna pada commit fix(ui) sesi ini.

## Bukti terakhir
- flutter test test/r2_navigation_test.dart test/settings_redesign_test.dart: 13 lulus.
- dart run tool/check_all.dart: SEMUA HIJAU, 1138 lulus/1 skip, format/analyze/Riverpod/
  check_arch bersih, REPO_MAP 1119 berkas, exit 0.
