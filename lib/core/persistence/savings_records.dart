import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/customer_records.dart';
import 'package:laurum/core/persistence/order_records.dart';
import 'package:laurum/core/persistence/record_columns.dart';

@DataClassName('SavingsRow')
@TableIndex.sql('CREATE INDEX savings_owner_updated ON savings_entries (owner_id, updated_at);')
@TableIndex.sql(
  'CREATE INDEX savings_customer_created ON savings_entries (customer_id, created_at);',
)
class SavingsRecords extends Table with RecordColumns {
  @override
  String get tableName => 'savings_entries';
  TextColumn get customerId => text().references(CustomerRecords, #id)();
  TextColumn get kind => text()();
  IntColumn get amount => integer()();
  TextColumn get method => text()();
  TextColumn get orderId => text().nullable().references(OrderRecords, #id)();
  TextColumn get note => text().withDefault(const Constant(''))();
  @override
  List<String> get customConstraints => [
    "CHECK (sync_state IN ('synced', 'pending', 'conflict'))",
    "CHECK (kind IN ('setor', 'pakai', 'penyesuaian'))",
    "CHECK (method IN ('tunai', 'qris', 'transfer', 'tabungan'))",
    "CHECK (kind = 'penyesuaian' OR amount > 0)",
  ];
}
