# Prompt 90 - Auth/sinkronisasi/akun dummy
- Baseline check_all; acuan PRD A 11, PRD B 4/7, frame Auth - Masuk.
- AuthSession Riverpod, Google palsu, route guard dan alur Info Usaha akun baru.
- SyncService metadata pending/last sync; layar Section dari registry, retry dan
  banner offline informatif. Contoh konflik adalah ilustrasi, bukan rekaman palsu.
- Akun: email fixture, Keluar R7 dengan peringatan pending, dua ConfirmModal hapus.
- Hapus sukses membersihkan repository/draf lokal melalui LocalDataService palsu;
  gagal tidak menghapus data, tidak ada Google/Supabase nyata.
- Tes route guard/login/onboarding, gagal/retry, offline, pending logout, delete
  dua langkah dan cleanup, Section, keyboard Info Usaha, 320 px/2x dan golden.
- Spec 29/30, DATA MASTER, INDEX/STATE/bukti; check_all hijau dan commit, berhenti.
