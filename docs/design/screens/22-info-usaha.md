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
- Simpan menulis name, address, phone, receiptFooter, updatedAt jam usaha.
- businessRepositoryProvider yang reaktif memperbarui businessProfileProvider
  (judul AppBarRoot) dan ReceiptView/printer settings (struk).

Validasi dan state:
- Nama kosong -> 'Nama usaha wajib diisi.' dan tidak menyimpan.
- Busy menandai tombol 'Menyimpan...'; gagal simpan memakai BannerMessage.

Selisih terhadap .pen:
- Hanya receiptFooter yang diedit di sini; receiptNote ('Pakaian bersih, wangi &
  rapi') tetap di layar Printer dan struk karena keduanya field terpisah.
- Helper catatan kaki menjelaskan pembagian field tersebut.
- Tanpa foto/logo usaha (tidak ada di registry maupun PRD).
