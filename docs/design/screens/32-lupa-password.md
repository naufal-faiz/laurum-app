# 32 - Lupa password
Rute: /lupa-password. Fase: R10. Frame .pen: Auth - Lupa Kata Sandi.
Template: FormScaffold.

## Komposisi
- AppBarSub Lupa password, kembali ke Masuk.
- PasswordResetSection: AppText instruksi, LabeledField Email + AppTextField,
  BannerMessage sukses/error.
- Footer AppButton Kirim tautan reset / Kirim ulang (N dtk), disabled saat busy/cooldown.

## Data dan provider
passwordResetProvider, AuthService.sendPasswordReset, businessClockProvider.
State email/busy/sent/remaining/error tidak mengandung password/token.
Cooldown dipertahankan saat berpindah rute; timer berhenti saat provider dibersihkan.
Hapus akun menghapus draf reset dan cooldown bersama cleanup data akun.

## Interaksi
Email wajib valid. Sukses selalu Jika email terdaftar, tautan dikirim, baik akun ada
maupun tidak. Tidak ada pesan yang membocorkan keberadaan akun. Kirim ulang dibatasi
60 detik; jam bisnis dapat diatur untuk tes, dan tick elapsed menjaga demo tetap
berjalan meskipun jam fixture tetap. Reload form tidak melewati cooldown.
Request limit memberi Terlalu banyak percobaan. Coba lagi nanti; error lain generik.

## State, format, verifikasi
Kosong, email tidak valid, busy, respons generik, cooldown, error/retry.
Email trim/lowercase; detik ditampilkan sebagai hitungan, bukan jam kalender.
Email tersimpan memakai selectAllOnFocus saat form dibuka kembali.
Tes known/unknown memiliki respons sama, cooldown lintas navigasi/clock/tick,
field dan footer di atas keyboard 300 dp, 320 px/2x dan golden.
Selisih .pen: pesan Tautan sudah dikirim diganti pesan kondisional generik; cooldown
60 detik ditambahkan. Pengiriman email sebenarnya belum ada (dummy in-memory).
Android/iOS dan SMTP nyata belum diuji manual.
