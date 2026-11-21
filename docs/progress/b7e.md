# B7e - Backend penautan WhatsApp

Isi: Edge Function `wa-connect` dan `wa-status` (Supabase) yang memakai Evolution API.
Tidak ada migrasi baru. UI belum berubah (B7f).

## Yang dibuat

- `wa-connect` (POST, JWT pemilik):
  - Membuat instance `laurum-<8 hex owner>` bila akun belum punya baris `wa_connections`,
    lalu menyisipkan baris `status=menunggu` dengan service role.
  - Tanpa `number`: mengembalikan QR base64.
  - Dengan `number` (0 di depan -> 62): menutup sesi QR yang belum terpindai, meminta
    sesi baru, lalu mengembalikan QR **dan** kode pasangan 8 karakter sekaligus.
  - Kode jawaban: `qr`, `pairing`, `already_connected`, `invalid_number`, `not_ready`, `unavailable`.
- `wa-status` (POST, JWT pemilik): membaca `connectionState` dari Evolution, memetakan
  open/connecting/close -> terhubung/menunggu/terputus, menulis lewat RPC
  `set_wa_connection_status` hanya bila status berubah (connected_at tidak bergeser).

Rahasia (tidak masuk repo): `EVOLUTION_URL`, `EVOLUTION_API_KEY`.

## Uji lokal yang sudah dijalankan (agen)

```powershell
npm test --prefix supabase
# 17/17 lulus (delete-account 6, wa-connect 6, wa-status 5)
```

Bukti langsung ke Evolution v2.3.7 lokal: QR 13.334 byte; dengan nomor uji keluar
`pairing=...` + QR 13.282 byte; `wa-status` menyimpan `menunggu`; `connected_at` tetap
saat status dipanggil berulang; instance uji dihapus setelahnya.

Stub Supabase dipakai di bukti ini, jadi `supabase functions serve` belum dijalankan.

## Langkah cloud (PEMILIK yang menjalankan, bukan agen)

1. Nyalakan Evolution dan tunnel (Quick Tunnel berubah tiap restart):

```powershell
cloudflared tunnel --url http://127.0.0.1:8080
```

2. Simpan secret fungsi (nilai tidak lewat chat; tempel di terminal sendiri):

```powershell
supabase secrets set EVOLUTION_URL=https://<tunnel-yang-aktif> EVOLUTION_API_KEY=<kunci-evolution>
```

3. Deploy dua fungsi dari root repo:

```powershell
supabase functions deploy wa-connect
supabase functions deploy wa-status
```

4. Verifikasi (token sesi milik sendiri, jangan tempel ke chat):

```powershell
$env:TOKEN = "<access token akun pemilik>"
curl.exe -s -X POST "https://<project>.supabase.co/functions/v1/wa-status" `
  -H "Authorization: Bearer $env:TOKEN"
# harap: {"code":"no_connection","status":"belum","connectedAt":null}

curl.exe -s -X POST "https://<project>.supabase.co/functions/v1/wa-connect" `
  -H "Authorization: Bearer $env:TOKEN"
# harap: {"code":"qr",...,"qr":"data:image/png;base64,..."}
```

5. Bila QR sudah dipindai, `wa-status` harus berubah menjadi `terhubung` dan
   `connected_at` terisi.

## Membatalkan

```powershell
supabase functions delete wa-connect
supabase functions delete wa-status
```

Tidak ada perubahan skema, jadi tidak ada rollback basis data. Instance Evolution uji
dihapus lewat `DELETE /instance/delete/<instance>`.
