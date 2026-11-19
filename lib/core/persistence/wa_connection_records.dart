import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/record_columns.dart';

/// Wire table `wa_connections` (B7b). Pull-only: pairing and settings travel
/// through the Edge Function and `set_ai_settings`, never through sync_push.
@DataClassName('WaConnectionRow')
@TableIndex.sql(
  'CREATE INDEX wa_connections_owner_updated ON wa_connections (owner_id, updated_at);',
)
class WaConnectionRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'wa_connections';
  TextColumn get instanceId => text()();
  TextColumn get status => text().withDefault(const Constant('belum'))();
  DateTimeColumn get connectedAt => dateTime().nullable()();
  BoolColumn get readMessages => boolean().withDefault(const Constant(true))();
  BoolColumn get ignoreGroups => boolean().withDefault(const Constant(true))();
  BoolColumn get detectCancellation => boolean().withDefault(const Constant(true))();
}
