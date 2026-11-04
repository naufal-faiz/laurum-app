import 'package:drift/drift.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/customer_search.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/persistence/app_database.dart';

Customer customerFromRow(CustomerRow r) => Customer(
  id: r.id,
  ownerId: r.ownerId,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
  syncState: RecordSyncState.values.byName(r.syncState),
  name: r.name,
  phone: r.phone,
  address: r.address,
  notes: r.notes,
  isActive: r.isActive,
  deletedAt: r.deletedAt,
);
CustomerRecordsCompanion customerToRow(Customer c, DateTime at) => CustomerRecordsCompanion.insert(
  id: c.id,
  ownerId: c.ownerId,
  createdAt: c.createdAt,
  updatedAt: Value(at),
  syncState: const Value('pending'),
  name: c.name,
  phone: Value(c.phone),
  nameKey: Value(customerNameKey(c.name)),
  phoneKey: Value(customerPhoneKey(c.phone)),
  address: Value(c.address),
  notes: Value(c.notes),
  isActive: Value(c.isActive),
  deletedAt: Value(c.deletedAt),
);
Map<String, Object?> customerPayload(Customer c, DateTime at) => {
  'id': c.id,
  'owner_id': c.ownerId,
  'created_at': c.createdAt.toUtc().toIso8601String(),
  'updated_at': at.toUtc().toIso8601String(),
  'deleted_at': c.deletedAt?.toUtc().toIso8601String(),
  'name': c.name,
  'phone': c.phone,
  'address': c.address,
  'notes': c.notes,
  'is_active': c.isActive,
};
Customer deletedCustomer(Customer c, DateTime at) => Customer(
  id: c.id,
  ownerId: c.ownerId,
  createdAt: c.createdAt,
  name: c.name,
  phone: c.phone,
  address: c.address,
  notes: c.notes,
  isActive: false,
  deletedAt: at,
);
