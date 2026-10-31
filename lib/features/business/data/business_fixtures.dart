import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/receipt_settings.dart';

const dummyOwnerId = 'owner-001';

final businessProfileFixture = BusinessProfile(
  id: 'biz-001',
  ownerId: dummyOwnerId,
  createdAt: DateTime(2026),
  name: 'Berkah Laundry',
  address: 'Jl. Melati No. 4, Sukajadi, Bandung',
  phone: '0812-3456-7890',
  receiptFooter: 'Terima kasih atas kepercayaan Anda',
  receiptNote: 'Pakaian bersih, wangi & rapi',
);

final receiptSettingsFixture = ReceiptSettings(
  id: 'rcpt-001',
  ownerId: dummyOwnerId,
  createdAt: DateTime(2026),
);
