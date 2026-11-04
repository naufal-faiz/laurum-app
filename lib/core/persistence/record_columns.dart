import 'package:drift/drift.dart';

mixin RecordColumns on Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get syncState => text().withDefault(const Constant('pending'))();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<String> get customConstraints => ["CHECK (sync_state IN ('synced', 'pending', 'conflict'))"];
}

mixin SoftDeleteColumns on Table {
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
