import 'package:drift/drift.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/repositories/expense_repository.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/features/expenses/data/expense_category_storage.dart';
import 'package:laurum/features/expenses/data/expense_queries.dart';

abstract class DriftExpenseReader implements ExpenseRepository {
  DriftExpenseReader(this.db, this.ownerId);
  final AppDatabase db;
  final String ownerId;
  @override
  Future<List<ExpenseCategory>> getCategories() async => List.unmodifiable(
    (await (db.select(db.expenseCategoryRecords)
              ..where((r) => r.ownerId.equals(ownerId) & r.deletedAt.isNull())
              ..orderBy([(r) => OrderingTerm.asc(r.rowId)]))
            .get())
        .map(categoryFromRow),
  );
  @override
  Future<List<Expense>> getExpenses({DateTime? from, DateTime? to}) =>
      readExpenses(db, ownerId, from: from, to: to);
  @override
  Future<List<Expense>> getExpensesInRange(ReportRange range) =>
      getExpenses(from: range.start, to: range.end);
}
