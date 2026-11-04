import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/record_columns.dart';

@DataClassName('BusinessRow')
class BusinessRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'businesses';
  TextColumn get name => text()();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get receiptFooter => text().withDefault(const Constant(''))();
  TextColumn get receiptNote => text().withDefault(const Constant(''))();
  BoolColumn get useOrderStatus => boolean().withDefault(const Constant(true))();
}
