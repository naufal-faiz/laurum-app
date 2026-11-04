import 'package:drift/drift.dart';
import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/persistence/app_database.dart';

BusinessProfile businessFromRow(BusinessRow r) => BusinessProfile(
  id: r.id,
  ownerId: r.ownerId,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
  syncState: RecordSyncState.values.byName(r.syncState),
  name: r.name,
  address: r.address,
  phone: r.phone,
  receiptFooter: r.receiptFooter,
  receiptNote: r.receiptNote,
  useOrderStatus: r.useOrderStatus,
  deletedAt: r.deletedAt,
);
BusinessRecordsCompanion businessToRow(BusinessProfile b, DateTime at) =>
    BusinessRecordsCompanion.insert(
      id: b.id,
      ownerId: b.ownerId,
      createdAt: b.createdAt,
      updatedAt: Value(at),
      syncState: const Value('pending'),
      name: b.name,
      address: Value(b.address),
      phone: Value(b.phone),
      receiptFooter: Value(b.receiptFooter),
      receiptNote: Value(b.receiptNote),
      useOrderStatus: Value(b.useOrderStatus),
      deletedAt: Value(b.deletedAt),
    );
Map<String, Object?> businessPayload(BusinessProfile b, DateTime at) => {
  'id': b.id,
  'owner_id': b.ownerId,
  'created_at': b.createdAt.toUtc().toIso8601String(),
  'updated_at': at.toUtc().toIso8601String(),
  'deleted_at': b.deletedAt?.toUtc().toIso8601String(),
  'name': b.name,
  'address': b.address,
  'phone': b.phone,
  'receipt_footer': b.receiptFooter,
  'receipt_note': b.receiptNote,
  'use_order_status': b.useOrderStatus,
};
