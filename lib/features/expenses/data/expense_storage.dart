import 'package:drift/drift.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/persistence/app_database.dart';

Expense expenseFromRow(ExpenseRow r) => Expense(
  id: r.id,
  ownerId: r.ownerId,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
  syncState: RecordSyncState.values.byName(r.syncState),
  categoryId: r.categoryId,
  amount: r.amount,
  spentAt: r.spentAt.toLocal(),
  vendor: r.vendor,
  note: r.note,
  photoPath: r.photoPath,
  deletedAt: r.deletedAt,
);
ExpenseRecordsCompanion expenseToRow(Expense e, DateTime at) => ExpenseRecordsCompanion.insert(
  id: e.id,
  ownerId: e.ownerId,
  createdAt: e.createdAt,
  updatedAt: Value(at),
  syncState: const Value('pending'),
  categoryId: e.categoryId,
  amount: e.amount,
  spentAt: e.spentAt,
  vendor: Value(e.vendor),
  note: Value(e.note),
  photoPath: Value(e.photoPath),
  deletedAt: Value(e.deletedAt),
);
Map<String, Object?> expensePayload(Expense e, DateTime at) => {
  'id': e.id,
  'owner_id': e.ownerId,
  'created_at': e.createdAt.toUtc().toIso8601String(),
  'updated_at': at.toUtc().toIso8601String(),
  'deleted_at': e.deletedAt?.toUtc().toIso8601String(),
  'category_id': e.categoryId,
  'amount': e.amount,
  'spent_at': e.spentAt.toUtc().toIso8601String(),
  'vendor': e.vendor,
  'note': e.note,
  'photo_path': e.photoPath,
};
Expense expenseCopy(Expense e, {String? photo, DateTime? deletedAt}) => Expense(
  id: e.id,
  ownerId: e.ownerId,
  createdAt: e.createdAt,
  updatedAt: e.updatedAt,
  syncState: e.syncState,
  categoryId: e.categoryId,
  amount: e.amount,
  spentAt: e.spentAt,
  vendor: e.vendor,
  note: e.note,
  photoPath: photo,
  deletedAt: deletedAt ?? e.deletedAt,
);
