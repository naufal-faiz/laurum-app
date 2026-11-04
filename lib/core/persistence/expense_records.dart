import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/expense_category_records.dart';
import 'package:laurum/core/persistence/record_columns.dart';

@DataClassName('ExpenseRow')
@TableIndex.sql('CREATE INDEX expenses_spent ON expenses (spent_at);')
class ExpenseRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'expenses';
  TextColumn get categoryId => text().references(ExpenseCategoryRecords, #id)();
  IntColumn get amount => integer()();
  TextColumn get vendor => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get spentAt => dateTime()();
  TextColumn get photoPath => text().nullable()();
  @override
  List<String> get customConstraints => [
    "CHECK (sync_state IN ('synced', 'pending', 'conflict'))",
    'CHECK (amount >= 0)',
  ];
}
