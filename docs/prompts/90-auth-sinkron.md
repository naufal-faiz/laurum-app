# 90 - Auth, Sinkronisasi, dan Akun (dummy)
Ikuti _COMMON.md bagian A, C, D, E, F. Prasyarat: prompt 80 SELESAI. Baca: PRD A bagian 11, PRD B bagian 4 dan 7, frame "Auth - Masuk" dan varian State (offline, gagal sinkron).

- Auth - Masuk: tombol "Lanjutkan dengan Google" memakai AuthService palsu, lalu masuk. Auth - Lupa Kata Sandi TIDAK dibuat. Router redirect berdasarkan status login; akun baru melewati Info Usaha.
- Layar Sinkronisasi baru (/lainnya/sinkronisasi, tidak ada di .pen; susun dari widget registry): status dari SyncService palsu (tersimpan, menyimpan, offline, gagal), jumlah perubahan tertunda, waktu sinkron terakhir, tombol "Sinkron sekarang", satu contoh konflik. Catat sebagai layar baru di spec.
- SyncIndicator tersambung ke status palsu di AppBarRoot. Banner offline bersifat informasi: "Mode offline. Data tersimpan di HP dan disinkronkan otomatis."
- Bagian Akun di Pengaturan: email Google, "Hapus akun" dengan dua langkah ConfirmModal, "Keluar" yang memperingatkan bila ada perubahan belum tersinkron.
- Semua lewat antarmuka palsu; tidak ada Supabase atau Google Sign-In nyata.


Aturan baru (25 Okt 2026): ikuti AGENTS.md aturan 14-16. Tombol Keluar memakai pola R7 (destructiveOutline di luar kartu). Field baru wajib tes keyboard.
