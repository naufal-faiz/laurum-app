import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/record_columns.dart';

@DataClassName('ReceiptSettingRow')
class ReceiptSettingRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'receipt_settings';
  IntColumn get paperMm => integer().withDefault(const Constant(58))();
  IntColumn get fontSize => integer().withDefault(const Constant(11))();
  BoolColumn get showAddress => boolean().withDefault(const Constant(true))();
  BoolColumn get showCustomer => boolean().withDefault(const Constant(true))();
  BoolColumn get showSavings => boolean().withDefault(const Constant(true))();
  BoolColumn get showNote => boolean().withDefault(const Constant(true))();
  @override
  List<String> get customConstraints => [
    "CHECK (sync_state IN ('synced', 'pending', 'conflict'))",
    'CHECK (paper_mm IN (58, 80))',
    'CHECK (font_size > 0)',
  ];
}
