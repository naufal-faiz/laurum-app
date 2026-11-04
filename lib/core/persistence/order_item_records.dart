import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/order_records.dart';
import 'package:laurum/core/persistence/record_columns.dart';
import 'package:laurum/core/persistence/service_records.dart';

@DataClassName('OrderItemRow')
@TableIndex.sql('CREATE INDEX items_order ON order_items (order_id);')
class OrderItemRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'order_items';
  TextColumn get orderId => text().references(OrderRecords, #id)();
  TextColumn get serviceId => text().references(ServiceRecords, #id)();
  TextColumn get serviceName => text()();
  TextColumn get unit => text()();
  IntColumn get qtyMilli => integer()();
  IntColumn get unitPrice => integer()();
  IntColumn get lineTotal => integer()();
  @override
  List<String> get customConstraints => [
    "CHECK (sync_state IN ('synced', 'pending', 'conflict'))",
    'CHECK (qty_milli >= 0 AND unit_price >= 0 AND line_total >= 0)',
  ];
}
