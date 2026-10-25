# Verifikasi R0 - 25 Oktober 2026

Baseline: d7aeb83; implementasi R0: 9f78398 sampai 4088cbe, cabang dev1rev.

## Cakupan migrasi

| Fitur | Page menjadi Section | Berkas state setelah migrasi |
| --- | ---: | ---: |
| orders | 12 | 11 |
| transactions | 7 | 12 |
| customers | 9 | 11 |
| reports | 2 | 5 |
| services | 3 | 5 |
| settings | 2 | 0 |
| business | 0 | 2 |
| printer | 3 | 3 |
| shell | 0 | 1 |
| Total | 38 | 50 |

48 berkas non-UI dipindahkan ke state/; cash_input dan discount_input
diekstrak dari sheet menjadi dua berkas state tambahan. Dua fungsi pembuka
menjadi order_cancel_flow.dart dan transaction_leave_flow.dart.

## Nama kelas yang berubah

| Lama | Baru |
| --- | --- |
| CustomerDepositFormPage | CustomerDepositFormSection |
| CustomerDirectoryListPage | CustomerDirectoryListSection |
| CustomerEditFormPage | CustomerEditFormSection |
| CustomerImportListPage | CustomerImportListSection |
| CustomerOrdersPage | CustomerOrdersSection |
| CustomerProfilePage | CustomerProfileSection |
| CustomerSavingsHeaderPage | CustomerSavingsHeaderSection |
| CustomerSavingsListPage | CustomerSavingsListSection |
| CustomerSavingsPage | CustomerSavingsSection |
| AntreanStatusPage | AntreanStatusSection |
| NotaHistoryListPage | NotaHistoryListSection |
| OrderCustomerPage | OrderCustomerSection |
| OrderDetailBodyPage | OrderDetailBodySection |
| OrderDetailContentPage | OrderDetailContentSection |
| OrderDetailFooterPage | OrderDetailFooterSection |
| OrderEditBodyPage | OrderEditBodySection |
| OrderEditCustomerPage | OrderEditCustomerSection |
| OrderItemsPage | OrderItemsSection |
| OrderPaymentPage | OrderPaymentSection |
| OrderSummaryPage | OrderSummarySection |
| OrderTimelinePage | OrderTimelineSection |
| PrinterConnectionPage | PrinterConnectionSection |
| PrinterPreviewPage | PrinterPreviewSection |
| PrinterSettingsPage | PrinterSettingsSection |
| OutstandingListPage | OutstandingListSection |
| ReportBodyPage | ReportBodySection |
| ServiceDirectoryContentPage | ServiceDirectoryContentSection |
| ServiceDirectoryListPage | ServiceDirectoryListSection |
| ServiceEditFieldsPage | ServiceEditFieldsSection |
| SettingsAccountPage | SettingsAccountSection |
| SettingsMenuPage | SettingsMenuSection |
| AddCustomerFormPage | AddCustomerFormSection |
| PaymentMethodPage | PaymentMethodSection |
| PaymentSavingsPage | PaymentSavingsSection |
| PaymentSummaryPage | PaymentSummarySection |
| ReceiptStatusPage | ReceiptStatusSection |
| TransactionCustomerPage | TransactionCustomerSection |
| TransactionDetailsPage | TransactionDetailsSection |

## Temuan

- Daftar utang tepat 26 berkas (22 ConsumerWidget); cocok dengan pemindaian impor Riverpod/go_router dan kelas. Migrasi bertahap R1-R7 sesuai izin R0.
- Perubahan tes lama hanya impor dan satu rename berkas; ekspektasi tetap. Tujuh tes check_arch ditambahkan. Tidak ada perubahan berkas PNG golden.
- showModalBottomSheet hanya dipanggil AppBottomSheet; seluruh Page tersisa disebut builder router.
- OrderEditPage memasok TransactionDetailsSection melalui slot details; keputusan komposisi lama ini sudah tercatat di STATE.md.
- Pecahan Section tetap dipertahankan sesuai R0 langkah 4; tidak digabung. Tidak ada perubahan shared widgets, tema, atau dependensi pada rentang R0.

## Batas verifikasi

Audit ini memeriksa struktur, diff migrasi, dan suite otomatis. Uji perangkat
Android/iOS dan pemeriksaan visual .pen baru tidak dilakukan.
Prompt berikutnya: R1-input-keyboard.md.

## Bukti verifikasi ulang

Perintah: dart run tool/check_all.dart (25 Oktober 2026).

```text
Formatted 429 files (0 changed)
flutter analyze: No issues found!
dart analyze: No issues found!
check_arch: OK
+317: All tests passed!
REPO_MAP diperbarui: 496 berkas
check_all: SEMUA HIJAU
```

R0 selesai sesuai cakupan prompt. R1 belum dimulai dalam audit ini.
