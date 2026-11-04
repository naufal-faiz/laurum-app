import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/business_records.dart';
import 'package:laurum/core/persistence/customer_records.dart';
import 'package:laurum/core/persistence/device_records.dart';
import 'package:laurum/core/persistence/entitlement_records.dart';
import 'package:laurum/core/persistence/expense_category_records.dart';
import 'package:laurum/core/persistence/expense_records.dart';
import 'package:laurum/core/persistence/local_setting_records.dart';
import 'package:laurum/core/persistence/order_event_records.dart';
import 'package:laurum/core/persistence/order_item_records.dart';
import 'package:laurum/core/persistence/order_records.dart';
import 'package:laurum/core/persistence/outbox_records.dart';
import 'package:laurum/core/persistence/payment_records.dart';
import 'package:laurum/core/persistence/receipt_setting_records.dart';
import 'package:laurum/core/persistence/savings_records.dart';
import 'package:laurum/core/persistence/service_records.dart';
import 'package:laurum/core/persistence/sync_cursor_records.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    BusinessRecords,
    DeviceRecords,
    CustomerRecords,
    ServiceRecords,
    OrderRecords,
    OrderItemRecords,
    PaymentRecords,
    SavingsRecords,
    ExpenseCategoryRecords,
    ExpenseRecords,
    ReceiptSettingRecords,
    EntitlementRecords,
    OrderEventRecords,
    OutboxRecords,
    LocalSettingRecords,
    SyncCursorRecords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);
  @override
  int get schemaVersion => 1;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      throw UnsupportedError('Migration required from $from to $to');
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
