# STATE Laurum
Diperbarui: 2026-11-12 | Cabang backend-newdesign

## Sesi aktif
Backend B3b selesai: sesi Auth dari deep link, "Lanjut" Cek email memakai sesi server,
dan layar "Buat password baru" untuk tautan pemulihan. Tampilan layar baru sementara
(tanpa Figma) dari widget registry; frame `LAURUM · Password Baru` (4294969106) sudah
terdaftar di figma_map.md. Dasar commit: lihat `git log -3`. Jangan push/merge.

## Status irisan
- Deep link: `AuthGateway.sessionChanges` + `refreshUser`; AuthSession menyegarkan state
  dan accountIdentity. Mode dummy memakai stream kosong.
- Cek email: `confirmEmail` membaca sesi server; galat jaringan jatuh ke cache.
- Pemulihan: `isRecoveryUri` + `recoveryLinkAtStartup` (cold), `recoveryEvents` (warm),
  `AuthService.recovering`, guard router `/password-baru`.
- Layar: `NewPasswordPage` + `NewPasswordSection`, `AuthFormKind.recovery` (password +
  konfirmasi, min 8, error di bawah field, tombol nonaktif saat busy, sukses + "Lanjut").
  Tanpa password lama. Pesan sukses/gagal seragam dan aman.
- Tes: config recovery, service recovery/tautan kedaluwarsa, Section, flow rute,
  keyboard 300 dp.
- PARITY.md: baris "Buat password baru" ditambahkan dan terverifikasi.

## Keputusan pengguna terbaru
Mode Backend BE-1..BE-9 aktif; Mode Redesign UI dijeda. Satu tugas backend per sesi,
tanpa push/merge, tanpa Figma. Tampilan sementara diizinkan bila layar belum ada.

## Belum di-commit
AGENTS.md dan docs/design/new-design-laurum.figcraft milik pengguna, dikecualikan.

## Langkah berikutnya
1. Verifikasi manual di perangkat: tautan pemulihan cold/warm, password baru, Cek email.
2. B2e unggah foto pengeluaran: butuh keputusan antrean/migrasi dan kompresi (BE-7).
3. B5 printer nyata (butuh printer 58 mm fisik).
4. Uji perangkat: konfirmasi email/deep link ujung-ke-ujung dengan akun uji dan SMTP.
5. Jangan push/merge tanpa izin.

## Blocker
Tidak ada. Demo ujung-ke-ujung menunggu akun uji, SMTP, dan perangkat pemilik proyek.

## Bukti terakhir
- flutter test (config, service, Section, flow, keyboard): 21 lulus.
- dart run tool/check_all.dart: SEMUA HIJAU, 1144 lulus/1 skip, format/analyze/
  check_arch bersih, REPO_MAP 1125 berkas, exit 0.
