import 'package:drift/drift.dart';

@DataClassName('SyncCursorRow')
class SyncCursorRecords extends Table {
  @override
  String get tableName => 'sync_cursors';
  TextColumn get targetTable => text().named('table_name')();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get lastId => text().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {targetTable};
}
