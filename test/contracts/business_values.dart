import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/domain/service_item.dart';

// All business fields; storage/sync metadata is verified separately.
Object businessValue(BusinessProfile b) => (
  b.id,
  b.ownerId,
  b.createdAt,
  b.name,
  b.address,
  b.phone,
  b.receiptFooter,
  b.receiptNote,
  b.useOrderStatus,
  b.deletedAt,
);
Object receiptValue(ReceiptSettings r) => (
  r.id,
  r.ownerId,
  r.createdAt,
  r.paperMm,
  r.fontSize,
  r.showAddress,
  r.showCustomer,
  r.showSavings,
  r.showNote,
  r.deletedAt,
);
Object? serviceValue(ServiceItem? s) => s == null
    ? null
    : (
        s.id,
        s.ownerId,
        s.createdAt,
        s.name,
        s.kind,
        s.price,
        s.durationDays,
        s.isActive,
        s.sortOrder,
        s.deletedAt,
      );
