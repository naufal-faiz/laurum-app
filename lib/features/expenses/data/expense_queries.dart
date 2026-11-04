import 'package:drift/drift.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';
import 'package:laurum/features/expenses/data/expense_storage.dart';

Future<List<Expense>> readExpenses(
  AppDatabase db,
  String owner, {
  DateTime? from,
  DateTime? to,
}) async {
  final conditions = ['owner_id = ?', 'deleted_at IS NULL'];
  final values = [owner];
  if (from != null) {
    conditions.add('spent_at >= ?');
    values.add(sqlTimestamp(from));
  }
  if (to != null) {
    conditions.add('spent_at < ?');
    values.add(sqlTimestamp(to));
  }
  final rows = await db
      .customSelect(
        'SELECT * FROM expenses WHERE ${conditions.join(' AND ')} ORDER BY rowid',
        variables: values.map(Variable<String>.new).toList(),
        readsFrom: {db.expenseRecords},
      )
      .get();
  return List.unmodifiable(rows.map((r) => expenseFromRow(db.expenseRecords.map(r.data))));
}
