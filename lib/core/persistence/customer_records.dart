import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/record_columns.dart';

@DataClassName('CustomerRow')
@TableIndex.sql(
  "CREATE UNIQUE INDEX customers_active_phone ON customers (owner_id, phone) WHERE is_active = 1 AND deleted_at IS NULL AND phone <> '';",
)
class CustomerRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'customers';
  TextColumn get name => text()();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
