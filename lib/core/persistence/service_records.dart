import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/record_columns.dart';

@DataClassName('ServiceRow')
class ServiceRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'services';
  TextColumn get name => text()();
  TextColumn get kind => text()();
  IntColumn get price => integer()();
  IntColumn get durationDays => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  @override
  List<String> get customConstraints => [
    "CHECK (sync_state IN ('synced', 'pending', 'conflict'))",
    "CHECK (kind IN ('kiloan', 'satuan'))",
    'CHECK (price >= 0)',
    'CHECK (duration_days >= 0)',
  ];
}
