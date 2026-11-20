# STATE Laurum
Diperbarui: 2026-11-20 | Cabang ai-whatsapp. Mode Integrasi AI WhatsApp.

## Sesi aktif
Uji percakapan B7d di Android lulus; temuan berat dari chat belum diimplementasikan.
Menunggu persetujuan docs/plans/B7d-berat-usulan.md. Kode aplikasi ccfbc38.
Kode worker tetap 18e5105. Tidak memulai B7e, mengubah skema, atau mengakses cloud.

## Status irisan
- B7c GATE usulan menjadi antrean sudah dikonfirmasi pengguna pada sesi sebelumnya.
- Merge newdesign 7dd054f ke ai-whatsapp selesai, UI/refresh 1.0.3+4 sudah terpasang.
- Salinan Android com.cashier.laurum.b7dlocal, label Laurum B7d Uji; data asli terpisah.
- Login fixture lokal tetap aktif; akun cloud tidak berlaku di lingkungan lokal ini.
- Android via adb reverse tcp:54321 tcp:54321; pulihkan setelah debug terputus.
- Worker sementara b7d-test-b2772820a381 masih aktif, model LLM yang sudah ada.
  Worker utama cloud tetap versi lama; migrasi B7d cloud belum diterapkan.
- Pesan belum jelas: pending=0; order awal: Ani, Jalan Uji B7D nomor 1, pending=1.
  ID awal f6e21432-0425-4a3f-9c31-d22955f98f08; tampil di Android dikonfirmasi pengguna.
- Update nomor 2: ID sama, pending=1; refresh/kolom Alamat dikonfirmasi pengguna.
- Duplikat order awal: RPC duplicate, ID/alamat nomor 2 tidak berubah, pending=1.
- Pembatalan: ID awal ditutup_otomatis, pending=0; pengguna mengonfirmasi di Android.
- Order baru dari nomor sama: ID cf8f67c1-8116-4894-a67f-8b06dd4058fc,
  alamat nomor 3, pending=1; pengguna mengonfirmasi di Android. Kedua order_id null.
- Pembatalan lama diulang: RPC duplicate mengarah ID lama; usulan baru tetap Menunggu.
- Temuan pengguna: chat 2 kg belum mengisi berat. Prompt/Proposal/Drift tidak punya field
  perkiraan berat; ProposalDraftController memulai weight kosong. Tidak diubah dulu.

## Keputusan pengguna terbaru
- Izin merge newdesign dan update debug untuk uji tarik-refresh sudah dilaksanakan.
- Pengguna mengonfirmasi Ani awal, alamat nomor 2, penarikan, dan usulan baru nomor 3.
- Pengguna menanyakan auto-isi perkiraan berat; persetujuan tambahan skema masih diminta.
- AI hanya membaca; keputusan order tetap pemilik. APK hanya bila diminta/diperlukan.

## Belum di-commit
Tidak ada setelah commit catatan sesi ini; kode produksi dan database tidak berubah.

## Langkah berikutnya
1. Tunggu keputusan proposal berat (kolom nullable gram, kontrak worker dan Drift).
2. Jika disetujui, implementasi dan tes lokal sesuai proposal, lalu uji Android 2 kg.
3. Pertahankan fixture selama review; setelah rangkaian selesai: finish harness.
4. Adopsi cloud oleh pemilik dan GATE B7d mendahului B7e/B7f.

## Blocker
Auto-isi berat memerlukan izin BE-7/AI-9/AI-12 dan pengecualian AI-2 untuk ADD COLUMN.
Chat WhatsApp asli belum diuji; fixture sintetis bukan angka akurasi.

## Bukti terakhir
- check_all hasil merge: SEMUA HIJAU, 1394 lulus/4 skip, REPO_MAP 1283 berkas.
- Keempat integrasi lokal lulus; baseline DB 375, Edge 6, unit worker 26, smoke 9 lulus.
- Build debug 1m3s; install Success, versionName=1.0.3 versionCode=4.
- Rangkaian manual: awal/update/penarikan/baru dikonfirmasi pengguna; duplikat diverifikasi RPC.
- Harness exec 20240: status/update/duplicate/cancel/fresh/finish; jangan ulang fresh untuk berat
  karena ID pesan tetap. Gunakan pesan baru setelah implementasi berat disetujui dan diuji.
- Skrip %TEMP%/laurum-b7d-android-test/{android-harness.js,android-manual.js}.
  Jangan gunakan ui bawaan harness; baca hanya elemen paket uji dan sembunyikan input.
