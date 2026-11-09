# B2d — pemicu sinkron, retry, dan status koneksi

SELESAI (9 Nov 2026). Bukti: docs/progress/b2d.md. Rencana:
docs/plans/B2d-trigger-sinkron.md.
Prasyarat: B2a, B2b, B2c SELESAI. Izin dependensi: B2 butir 4 (`connectivity_plus`,
`workmanager`).

## Hasil yang diminta
1. Debounce 2 detik setelah penulisan lokal; satu siklus pada satu waktu.
2. Retry backoff eksponensial berhenti di 15 menit; sukses mengulang dari awal.
3. Pemicu: login/manual (`syncNow`), foreground, koneksi pulih, periodik 15 menit
   saat aplikasi aktif.
4. Status `offline` saat koneksi hilang, `gagal` saat siklus gagal, `tersimpan` saat
   outbox kosong dan siklus terakhir sukses; `lastSyncedAt` bertahan setelah restart
   lewat `local_settings`.
5. Nonaktif saat sesi Auth masih stub: tanpa koordinator nyata tidak ada timer,
   retry, atau panggilan jaringan; `syncNow` hanya menyegarkan hitungan outbox.
6. Tes unit untuk timing/scheduler/gerbang dan tes provider untuk binding koneksi;
   check_all hijau, STATE/INDEX dan commit.

## Batas
- Tanpa UI baru, Auth nyata, upload foto, atau cloud. `workmanager` (sinkron latar
  isolate) ditunda ke B3 karena butuh sesi Auth dan bootstrap database di isolate.
- Indikator/halaman Sinkronisasi yang ada tetap; hanya statusnya yang kini nyata.
