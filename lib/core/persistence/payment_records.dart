import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/order_records.dart';
import 'package:laurum/core/persistence/record_columns.dart';

@DataClassName('PaymentRow')
@TableIndex.sql('CREATE INDEX payments_order ON payments (order_id);')
@TableIndex.sql('CREATE INDEX payments_paid ON payments (paid_at);')
class PaymentRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'payments';
  TextColumn get orderId => text().references(OrderRecords, #id)();
  TextColumn get method => text()();
  IntColumn get amount => integer()();
  IntColumn get received => integer()();
  DateTimeColumn get paidAt => dateTime()();
  TextColumn get note => text().withDefault(const Constant(''))();
  @override
  List<String> get customConstraints => [
    "CHECK (sync_state IN ('synced', 'pending', 'conflict'))",
    "CHECK (method IN ('tunai', 'qris', 'transfer', 'tabungan'))",
  ];
}
