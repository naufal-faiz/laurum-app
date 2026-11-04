import 'package:drift/drift.dart';

@DataClassName('OutboxEntry')
@TableIndex(name: 'outbox_created', columns: {#createdAt})
class OutboxRecords extends Table {
  @override
  String get tableName => 'outbox';
  TextColumn get id => text()();
  TextColumn get targetTable => text().named('table_name')();
  TextColumn get rowId => text()();
  TextColumn get op => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    "CHECK (op IN ('upsert', 'delete'))",
    'CHECK (attempts >= 0)',
  ];
}
