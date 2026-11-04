import 'package:drift/drift.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/persistence/app_database.dart';

ServiceItem serviceFromRow(ServiceRow r) => ServiceItem(
  id: r.id,
  ownerId: r.ownerId,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
  syncState: RecordSyncState.values.byName(r.syncState),
  name: r.name,
  kind: ServiceKind.values.byName(r.kind),
  price: r.price,
  durationDays: r.durationDays,
  isActive: r.isActive,
  sortOrder: r.sortOrder,
  deletedAt: r.deletedAt,
);
ServiceRecordsCompanion serviceToRow(ServiceItem s, DateTime at) => ServiceRecordsCompanion.insert(
  id: s.id,
  ownerId: s.ownerId,
  createdAt: s.createdAt,
  updatedAt: Value(at),
  syncState: const Value('pending'),
  name: s.name,
  kind: s.kind.name,
  price: s.price,
  durationDays: s.durationDays,
  isActive: Value(s.isActive),
  sortOrder: Value(s.sortOrder),
  deletedAt: Value(s.deletedAt),
);
Map<String, Object?> servicePayload(ServiceItem s, DateTime at) => {
  'id': s.id,
  'owner_id': s.ownerId,
  'created_at': s.createdAt.toUtc().toIso8601String(),
  'updated_at': at.toUtc().toIso8601String(),
  'deleted_at': s.deletedAt?.toUtc().toIso8601String(),
  'name': s.name,
  'kind': s.kind.name,
  'price': s.price,
  'duration_days': s.durationDays,
  'is_active': s.isActive,
  'sort_order': s.sortOrder,
};
ServiceItem deletedService(ServiceItem s, DateTime at) => ServiceItem(
  id: s.id,
  ownerId: s.ownerId,
  createdAt: s.createdAt,
  name: s.name,
  kind: s.kind,
  price: s.price,
  durationDays: s.durationDays,
  isActive: false,
  sortOrder: s.sortOrder,
  deletedAt: at,
);
