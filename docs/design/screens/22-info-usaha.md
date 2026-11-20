# 22 - Info Usaha
Rute: /lainnya/info-usaha   Prompt: 70
Frame .pen: "Lainnya - Info Usaha".
Template: FormScaffold.

Komposisi:
- AppBarSub 'Info usaha'; FooterBar AppButton 'Simpan'.
- LabeledField Nama usaha, Alamat (2 baris), Nomor telepon
  (helper 'Nomor telepon ditampilkan di struk.'), Catatan kaki struk (2 baris).
- BannerMessage 'Info usaha disimpan.' setelah simpan.

Data dan provider:
- businessInfoProvider memuat BusinessProfile dari BusinessRepository.
- Pemulihan Supabase dicoba saat akun dibuka sebelum setup diputuskan. Profil
  yang diterima dari HP lain dipakai kembali; retry pull menuntaskan setup tanpa relogin.
- Profil legacy ganda tetap dapat dibaca/diedit melalui ID aktif tertua yang stabil;
  baris lain dipertahankan. Metadata conflict juga tetap dapat dipetakan ke model.
- Simpan menulis name, address, phone, receiptFooter, updatedAt jam usaha.
- businessRepositoryProvider yang reaktif memperbarui businessProfileProvider
  (judul AppBarRoot) dan ReceiptView/printer settings (struk).

Validasi dan state:
- Setelah login, gate lokal menunggu pembukaan penyimpanan akun selesai sebelum
  form setup dibangun. Nilai storage sebelumnya tidak dianggap siap saat loading/error.
  Gagal membuka storage memakai Coba lagi dengan sesi tetap aktif, tanpa login ulang.
- Nama kosong -> 'Nama usaha wajib diisi.' dan tidak menyimpan.
- Busy menandai tombol 'Menyimpan...'; gagal simpan memakai BannerMessage.

Selisih terhadap .pen:
- Hanya receiptFooter yang diedit di sini; receiptNote ('Pakaian bersih, wangi &
  rapi') tetap di layar Printer dan struk karena keduanya field terpisah.
- Helper catatan kaki menjelaskan pembagian field tersebut.
- Tanpa foto/logo usaha (tidak ada di registry maupun PRD).

Prompt 90 - onboarding:
- Akun baru diarahkan paksa ke rute ini dengan query onboarding=1; draf awal
  nama/alamat/telepon/footer kosong. Nama wajib sebelum setup dianggap selesai.
- Simpan sukses menuntaskan metadata setup AuthService, mencoba sinkron lalu
  router ke Antrean. Kembali membuka konfirmasi keluar dengan peringatan pending.
- Field awal nonkosong memakai selectAllOnFocus; keyboard 300 dp diuji juga
  dalam mode onboarding. Tidak ada Google atau penyimpanan kredensial nyata.


## Redesign 17 Nov 2026 (frame `LAURUM · Info Usaha`, ID 4294968909)
AppBarSub varian detail + subjudul 'Data toko di struk & profil'. Komposisi baru:
BusinessPreviewSection (label PRATINJAU STRUK: pratinjau struk reaktif berisi nama
kapital, alamat, telepon lewat Formatters.telepon, catatan kaki),
BusinessFormSection (label DETAIL USAHA: empat LabeledField/AppTextField yang sama
dengan helper lama), BusinessNoteSection (BannerMessage info). Footer Simpan tetap.

### Paritas redesign
| Butir | Sumber lama | Di UI baru |
|---|---|---|
| Nama usaha + validasi wajib | businessInfoProvider/name | field di kartu Detail Usaha |
| Alamat 2 baris | address | field di kartu Detail Usaha |
| Nomor telepon + helper | phone | field + helper di kartu Detail Usaha |
| Catatan kaki struk + helper | receiptFooter | field + helper di kartu Detail Usaha |
| Banner 'Info usaha disimpan.' | notice | BannerMessage di atas pratinjau |
| Simpan / Menyimpan... | save() | footer FormScaffold |
| Loading dan gagal muat | async.when | AppSkeleton / EmptyState |
| Pratinjau struk | tidak ada | tampilan dari nilai draf yang sama |

### Selisih desain
- Pratinjau struk menampilkan nilai draf (belum disimpan) agar perubahan langsung
  terlihat; bukan data baru dan tidak menulis repository.
- Teks banner 'Perubahan tampil di struk dan nota setelah disimpan.' adalah teks
  rancangan redesign ini.
- Tanpa baris navigasi 'Struk & Printer' dari frame agar tidak menambah perilaku baru.
- Tidak ada token, atom, atau molecule baru; banner memakai BannerMessage info.


Rute terkait diperiksa pada 320 px dan skala teks 1,3; sheet input tetap melalui tes keyboard 300 dp.
State relevan dan selisih terakhir terhadap .pen dirangkum pada [audit akhir UI](../../progress/fase-ui.md).
APK Android menjalani smoke perangkat; ini tidak menyatakan semua alur layar diuji manual. iOS dan integrasi produksi belum diuji.
