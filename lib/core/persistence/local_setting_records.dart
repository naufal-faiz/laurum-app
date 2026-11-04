import 'package:drift/drift.dart';

@DataClassName('LocalSettingRow')
class LocalSettingRecords extends Table {
  @override
  String get tableName => 'local_settings';
  TextColumn get key => text()();
  TextColumn get stringValue => text().nullable()();
  IntColumn get intValue => integer().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {key};
  @override
  List<String> get customConstraints => [
    'CHECK ((string_value IS NOT NULL) != (int_value IS NOT NULL))',
  ];
}
