import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/record_columns.dart';

@DataClassName('ExpenseCategoryRow')
class ExpenseCategoryRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'expense_categories';
  TextColumn get name => text()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}
