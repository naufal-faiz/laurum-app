import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/record_columns.dart';

@DataClassName('DeviceRow')
@TableIndex.sql('CREATE UNIQUE INDEX devices_owner_code ON devices (owner_id, code);')
class DeviceRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'devices';
  TextColumn get code => text()();
  TextColumn get name => text()();
  DateTimeColumn get lastSeenAt => dateTime().nullable()();
}
