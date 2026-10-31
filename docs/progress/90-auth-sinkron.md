# Prompt 90 - Auth, Sinkronisasi dan Akun dummy
Tanggal: 31 Oktober 2026 | Cabang dev1rev.
- AuthSession + router guard, Masuk Google palsu, pemulihan dan onboarding Info Usaha.
- Akun menampilkan email fixture; Keluar R7 memperingatkan pending dan tetap menjaga
  data HP. Hapus akun dua ConfirmModal, gagal tidak menghapus data; offline dibatasi.
- LocalDataService dummy membersihkan repository, draf dan ringkasan historis;
  laporan/usulan lama tidak muncul kembali setelah penghapusan.
- SyncService memiliki pending/last sync, menerima mutasi repository, manual retry
  dan percobaan pascalogin. Root indikator memakai service sama, banner offline informatif.
- Layar sinkronisasi baru dari registry, contoh konflik hanya ilustrasi aturan.
- Tanpa dependensi/tema/registry/lint/PRD baru. DATA MASTER memuat email/timestamp/
  contoh konflik dummy. Tidak ada Google, secure storage, Supabase atau sinkron nyata.
- Spec 19/22/29/30 dan golden mencatat penyimpangan .pen; tes alur, Section,
  keyboard onboarding dan 320 px/teks 2x. Perangkat/layanan nyata belum diuji.
- Router memakai adaptor Listenable dari provider, bukan provider di widget akar;
  lifecycle adaptor mengikuti container dan tetap reaktif di semua rute.
- Ukuran UI baru: SignInPage 21, SyncPage 33, SignInSection 36,
  SyncStatusSection 61; SettingsAccountSection yang diperbarui 61 baris.
- Baseline 510 tes hijau; 25 tes baru. Seluruh 535 tes/golden lulus. Bukti akhir:
```text
dart run tool/check_all.dart
Formatted 561 files (0 changed)
flutter analyze: No issues found!
dart analyze: No issues found!
check_arch: OK
+535: All tests passed!
REPO_MAP diperbarui: 629 berkas
check_all: SEMUA HIJAU
```
- Berikutnya docs/prompts/100-penyelesaian.md. Tinjau di perangkat Android;
  iOS/Google/secure storage/backend/sinkronisasi nyata belum diuji.
