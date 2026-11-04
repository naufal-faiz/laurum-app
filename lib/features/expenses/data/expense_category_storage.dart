import 'package:drift/drift.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/persistence/app_database.dart';

ExpenseCategory categoryFromRow(ExpenseCategoryRow r) => ExpenseCategory(
  id: r.id,
  ownerId: r.ownerId,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
  syncState: RecordSyncState.values.byName(r.syncState),
  name: r.name,
  isDefault: r.isDefault,
  deletedAt: r.deletedAt,
);
ExpenseCategoryRecordsCompanion categoryToRow(ExpenseCategory c, DateTime at) =>
    ExpenseCategoryRecordsCompanion.insert(
      id: c.id,
      ownerId: c.ownerId,
      createdAt: c.createdAt,
      updatedAt: Value(at),
      syncState: const Value('pending'),
      name: c.name,
      isDefault: Value(c.isDefault),
      deletedAt: Value(c.deletedAt),
    );
Map<String, Object?> categoryPayload(ExpenseCategory c, DateTime at) => {
  'id': c.id,
  'owner_id': c.ownerId,
  'created_at': c.createdAt.toUtc().toIso8601String(),
  'updated_at': at.toUtc().toIso8601String(),
  'deleted_at': c.deletedAt?.toUtc().toIso8601String(),
  'name': c.name,
  'is_default': c.isDefault,
};
