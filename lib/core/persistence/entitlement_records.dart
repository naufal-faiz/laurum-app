import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/record_columns.dart';

@DataClassName('EntitlementRow')
class EntitlementRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'entitlements';
  TextColumn get plan => text().withDefault(const Constant('free'))();
  DateTimeColumn get validUntil => dateTime().nullable()();
  TextColumn get source => text().withDefault(const Constant(''))();
  @override
  List<String> get customConstraints => [
    "CHECK (sync_state IN ('synced', 'pending', 'conflict'))",
    "CHECK (\"plan\" IN ('free', 'pro'))",
  ];
}
