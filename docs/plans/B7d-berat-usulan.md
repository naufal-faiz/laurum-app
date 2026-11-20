# B7d - Usulan pengisian perkiraan berat dari chat
Status: DISETUJUI pengguna 20 Nov 2026; hanya jika berat ditulis di chat, selain itu kosong.

## Masalah dan hasil yang diminta
Pesan order menyebut 2 kg, tetapi kontrak worker, Proposal dan Drift belum menyimpan berat.
Draf aplikasi memulai berat kosong. Tambahan ini mengisi kolom berat yang sudah ada.

## Perilaku yang diusulkan
- Angka dan satuan jelas: 2 kg -> 2000 gram, 2,5 kg -> 2500 gram, 500 gram -> 500 gram.
- Berlaku sebagai perkiraan pelanggan untuk layanan kiloan; pemilik dapat mengoreksi.
- Tidak ada berat atau ambigu seperti 1-2 kg: kosong, tanpa mengarang titik tengah.
- Koreksi berat dalam percakapan memperbarui usulan Menunggu yang sama.
- Nilai awal diambil dari data AI; input yang sudah diedit pemilik tidak ditimpa saat refresh.
- Validasi minimum yang ada tetap; nilai kecil tidak dibulatkan diam-diam menjadi 0,5 kg.
- Persetujuan tetap eksplisit lewat TransactionRunner; perhitungan memakai alur lama.
  Tidak ada persetujuan, penagihan, pembayaran atau pembatalan order otomatis oleh AI.

## Perubahan teknis yang memerlukan izin
- Satu kolom nullable estimated_weight_grams integer pada ai_proposals (gram, positif).
  Migrasi baru hanya ADD COLUMN; data lama tetap null, tanpa DROP atau pengisian tebak-tebakan.
- Ini izin spesifik perubahan tabel lama (pengecualian AI-2) dan perluasan skema AI-12.
- Tambahkan field ke ringkasan, validasi/RPC/guard dan worker; owner/nomor tetap dari server/webhook.
  Kontrak resmi B7 utama diperbarui hanya setelah persetujuan (AI-9).
- Domain/repository/sinkron dan tabel Drift ditambah field opsional; migrasi Drift maju + tes.
- Isi draf berat yang sudah ada, tanpa widget/token/dependensi baru atau perubahan pembayaran.
- Server hanya Supabase lokal; adopsi cloud tetap dilakukan pemilik.

## Bukti penerimaan yang direncanakan
RPC/isolasi/duplikat/koreksi berat; kontrak InMemory dan Drift; migrasi mempertahankan data lama;
prefill 2 kg, kosong/ambigu, koreksi manual tidak hilang, persetujuan offline dan rollback.
check_all + pgTAP + tes worker, lalu pesan 2 kg melalui worker -> refresh Android -> berat 2.
