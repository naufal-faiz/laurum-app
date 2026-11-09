# B3b — konfirmasi email dan pemulihan

Ikuti _COMMON.md. Rencana: docs/plans/B3-auth.md. Prasyarat: B3a SELESAI.
Bukti B3a: docs/progress/b3a.md.

## Hasil yang diminta
1. Deep link `laurum://auth-callback` yang tiba saat aplikasi berjalan menyegarkan
   `authSessionProvider` (dan `accountIdentityProvider`) tanpa menutup aplikasi;
   tanpa token/kode di state UI atau log.
2. "Lanjut" pada Cek email memeriksa sesi nyata yang sudah terkonfirmasi; bila
   belum, tetap di layar dengan pesan aman (tanpa membocorkan keberadaan akun).
3. Layar "Buat password baru" untuk tautan pemulihan (rute baru, Section baru
   sesuai registry/aturan 14): password + konfirmasi, minimal 8 karakter, pesan
   galat di bawah field, tombol nonaktif saat busy, tes keyboard viewInsets 300 dp.
4. Ganti password dari Kelola akun tetap memakai password lama; alur pemulihan
   tidak menanyakan password lama. Pesan sukses/gagal seragam dan aman.
5. Tes: deep link menyegarkan state, konfirmasi dari sesi nyata, pemulihan sukses,
   tautan kedaluwarsa, keyboard; check_all hijau; docs/progress/b3b.md, INDEX,
   STATE, commit, berhenti.

## Batas
- Tanpa hapus akun Edge, tanpa `SyncCoordinator`/gerbang sinkron, tanpa
  `workmanager` (B3c). Jangan mengubah PRD, registry, tema, atau lint.
- Tanpa uji jaringan di `flutter test`; butuh akun uji/peti surat dari pemilik
  proyek untuk verifikasi manual (catat bila belum tersedia).
