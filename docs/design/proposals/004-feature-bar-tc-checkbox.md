# 004 - Feature Bar & T&C Checkbox (Redesign UI, tampilan saja)

**Izin pengguna:** 9 Nov 2026 (redesign branch)

## Keputusan pengguna (9 Nov 2026)

1. **Feature bar** ("Antrean rapi", "Struk otomatis", "Laporan harian") —
   dibuat sebagai **tampilan saja** (fasilitas visual, tanpa aksi/data).
   Diterapkan di `SignInFeatureBarSection` (Masuk). Tidak ada provider,
   tidak ada navigasi, tidak ada data baru.
2. **Trust bar** ("Data usaha kamu aman & terenkripsi") — teks statis,
   diterapkan di `SignInTrustSection`.
3. **Checkbox Syarat & Ketentuan (halaman Daftar)** — TIDAK dibuat sekarang.
   Masuk proposal ini sebagai pengingat: implementasikan saat aplikasi
   mencapai 95% (butuh alur T&C backend + penerimaan versi dokumen).

## Sisa pekerjaan saat 95%

- Endpoint/versi dokumen T&C, penyimpanan penerimaan per akun, layar T&C,
  validasi wajib centang saat daftar.
- Ganti teks statis trust bar bila ada kebijakan privasi resmi.
