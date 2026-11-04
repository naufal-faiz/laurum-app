import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/order_records.dart';
import 'package:laurum/core/persistence/record_columns.dart';

@DataClassName('OrderEventRow')
@TableIndex.sql('CREATE INDEX events_order_time ON order_events (order_id, occurred_at);')
class OrderEventRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'order_events';
  TextColumn get orderId => text().references(OrderRecords, #id)();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get kind => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get fromStatus => text().nullable()();
  TextColumn get toStatus => text().nullable()();
}
