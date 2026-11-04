# Prompt 100 - Penyelesaian UI dummy

1. Verifikasi Git/prasyarat R0-R10; baseline check_all sebelum perubahan.
2. Audit registry 60/60, batas baris, widget/lapisan, literal angka/teks terlarang,
   state kosong/loading/error, sinkron/offline dan daftar utang Section.
3. Audit input/keyboard, Semantics/target sentuh dan skala teks 1,3; pakai tes yang
   ada dan tambah tes alur akhir lintas fitur jika belum mencakup penerimaan global.
4. Bandingkan spec layar dengan frame .pen terkait; dokumentasikan semua perbedaan
   yang disengaja dan temuan tersisa di docs/progress/fase-ui.md.
5. Periksa Android SDK/perangkat, build APK debug dummy dan jalankan bila tersedia.
   Catat batas nyata; jangan menandai selesai tanpa APK berjalan.
6. Perbaiki temuan dalam izin yang ada; widget bersama/token/registry baru butuh
   izin terpisah. Lanjutkan pekerjaan mandiri yang tidak bergantung pada izin itu.
7. Perbarui README, katalog, seluruh spec layar, INDEX dan STATE dengan bukti.
8. check_all hijau, commit (wip jika masih belum lolos syarat perangkat), berhenti.

Tidak membuat tag, push/merge, backend, dependensi, atau subagen.
