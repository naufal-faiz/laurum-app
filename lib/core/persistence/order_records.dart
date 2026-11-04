import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/customer_records.dart';
import 'package:laurum/core/persistence/record_columns.dart';

@DataClassName('OrderRow')
@TableIndex.sql('CREATE UNIQUE INDEX orders_owner_number ON orders (owner_id, order_no);')
@TableIndex.sql('CREATE INDEX orders_entered ON orders (entered_at);')
@TableIndex.sql('CREATE INDEX orders_status_entered ON orders (status, entered_at);')
@TableIndex.sql('CREATE INDEX orders_owner_status ON orders (owner_id, status);')
@TableIndex.sql('CREATE INDEX orders_owner_entered ON orders (owner_id, entered_at);')
class OrderRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'orders';
  TextColumn get orderNo => text()();
  TextColumn get customerId => text().references(CustomerRecords, #id)();
  TextColumn get status => text()();
  TextColumn get source => text()();
  TextColumn get payTerm => text().withDefault(const Constant('sekarang'))();
  TextColumn get proposalId => text().nullable()();
  IntColumn get discount => integer().withDefault(const Constant(0))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get enteredAt => dateTime()();
  DateTimeColumn get estimatedAt => dateTime()();
  IntColumn get subtotal => integer()();
  IntColumn get total => integer()();
  @override
  List<String> get customConstraints => [
    "CHECK (sync_state IN ('synced', 'pending', 'conflict'))",
    "CHECK (status IN ('menunggu_jemput', 'diproses', 'siap', 'selesai', 'dibatalkan'))",
    "CHECK (source IN ('kasir', 'whatsapp_ai'))",
    "CHECK (pay_term IN ('sekarang', 'cod'))",
    'CHECK (discount >= 0 AND subtotal >= 0 AND total >= 0)',
  ];
}
