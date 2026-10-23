# Audit dan penyelesaian prompt 11

1. Simpan baseline agen sebelumnya; uji awal 132 tes hijau, tetapi kontrak mutasi belum diuji.
2. Tambah regresi: notifikasi provider publik, snapshot immutable, retry ledger,
   kegagalan atomik, pelunasan nota lama, edit/hapus pengeluaran, laporan reaktif.
3. Pisahkan provider Riverpod dari antarmuka domain. Gunakan snapshot Notifier
   dan notifikasi eksplisit pada provider antarmuka; Pages tetap bergantung antarmuka.
4. Rebuild baseline laporan dengan selisih snapshot fixture saat ini terhadap
   snapshot awal, lalu gunakan buildReport; hindari menghitung fixture dua kali.
5. Perbaiki fixture dan fake platform; data tambahan di luar izin prompt menunggu pengguna.
6. Rapikan batas 100 baris, uji seluruh check_all, perbarui INDEX/STATE/progress, commit.
7. Berhenti sebelum prompt 12; tidak mengerjakan layar atau build perangkat.
