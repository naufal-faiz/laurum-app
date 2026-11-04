import 'package:drift/drift.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';
import 'package:laurum/features/expenses/data/drift_expense_reader.dart';
import 'package:laurum/features/expenses/data/expense_category_storage.dart';
import 'package:laurum/features/expenses/data/expense_photo_store.dart';
import 'package:laurum/features/expenses/data/expense_storage.dart';

class DriftExpenseRepository extends DriftExpenseReader {
  DriftExpenseRepository(
    super.db,
    super.ownerId,
    this.writer, {
    DateTime Function()? clock,
    ExpensePhotoStore? photos,
  }) : clock = clock ?? DateTime.now,
       photos = photos ?? ExpensePhotoStore(ownerId) {
    if (!identical(db, writer.db)) throw ArgumentError('Outbox belongs to another database');
  }
  final OutboxWriter writer;
  final DateTime Function() clock;
  final ExpensePhotoStore photos;
  @override
  Future<void> saveCategory(ExpenseCategory c) => writer.runner.run(() async {
    if (c.ownerId != ownerId) throw StateError('Category belongs to another account');
    final old = await (db.select(
      db.expenseCategoryRecords,
    )..where((r) => r.id.equals(c.id))).getSingleOrNull();
    if (old != null && old.ownerId != ownerId) {
      throw StateError('Category belongs to another account');
    }
    final at = clock();
    await writer.write(
      table: 'expense_categories',
      rowId: c.id,
      payload: categoryPayload(c, at),
      mutate: () async {
        await db.into(db.expenseCategoryRecords).insertOnConflictUpdate(categoryToRow(c, at));
        await db.customStatement(
          'UPDATE expense_categories SET rowid = (SELECT MAX(rowid)+1 FROM expense_categories) WHERE id = ?',
          [c.id],
        );
      },
    );
  });
  @override
  Future<void> saveExpense(Expense input) => writer.runner.run(() async {
    if (input.ownerId != ownerId) throw StateError('Expense belongs to another account');
    final old = await (db.select(
      db.expenseRecords,
    )..where((r) => r.id.equals(input.id))).getSingleOrNull();
    if (old != null && old.ownerId != ownerId) {
      throw StateError('Expense belongs to another account');
    }
    final category = await (db.select(
      db.expenseCategoryRecords,
    )..where((r) => r.id.equals(input.categoryId))).getSingleOrNull();
    if (category == null || category.ownerId != ownerId) {
      throw StateError('Category is missing or foreign');
    }
    final path = input.deletedAt == null
        ? await photos.stage(input.photoPath, writer.runner)
        : input.photoPath;
    final e = expenseCopy(input, photo: path);
    final at = clock();
    await writer.write(
      table: 'expenses',
      rowId: e.id,
      payload: expensePayload(e, at),
      mutate: () async {
        await db.into(db.expenseRecords).insertOnConflictUpdate(expenseToRow(e, at));
        await db.customStatement('UPDATE expenses SET spent_at = ? WHERE id = ?', [
          sqlTimestamp(e.spentAt),
          e.id,
        ]);
      },
    );
  });
  @override
  Future<void> deleteExpense(String id) => writer.runner.run(() async {
    final row =
        await (db.select(db.expenseRecords)
              ..where((r) => r.id.equals(id) & r.ownerId.equals(ownerId) & r.deletedAt.isNull()))
            .getSingleOrNull();
    if (row != null) {
      await saveExpense(expenseCopy(expenseFromRow(row), photo: row.photoPath, deletedAt: clock()));
    }
  });
}
