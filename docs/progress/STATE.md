# STATE Laurum
Diperbarui: 2026-11-12 | Cabang backend-newdesign

## Sesi aktif
Backend B3b irisan state/data selesai: sesi Auth dari deep link `laurum://auth-callback`
disegarkan ke AuthSession, dan "Lanjut" pada Cek email memeriksa sesi server.
Dasar commit bbb0125; satu commit untuk tugas ini ada di `git log -1`. Jangan push/merge.

## Status irisan
Tanpa perubahan tampilan: token, shared/widgets, Section, golden, router tidak disentuh.
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
Dua tes lama sudah gagal di bbb0125 (dibuktikan dengan men-stash perubahan sesi ini):
- test/settings_redesign_test.dart: golden goldens/lainnya.png beda 0,20% (644 px).
- test/r2_navigation_test.dart "Account opens Lainnya": widget yang dicari tidak ada.
Keduanya zona tampilan/golden; BE-1 melarang perbaikan di sesi backend. Menunggu keputusan.

## Bukti terakhir
- flutter test test/auth/auth_session_refresh_test.dart test/auth/supabase_auth_service_test.dart: 12 lulus.
- flutter analyze lib/features/auth lib/core/services test/auth: tanpa isu.
- dart run tool/check_all.dart: format 1041 berkas (0 ubah), analyze + Riverpod bersih,
  check_arch OK, tes 1136 lulus/1 skip/2 gagal (dua blocker di atas, pra-ada), exit 1.
