import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/record_columns.dart';

/// Wire table `ai_proposals` (B7b). Deliberately has no `decided_at`: the server
/// stamps decisions, so a retried sync payload stays byte-identical.
@DataClassName('AiProposalRow')
@TableIndex.sql(
  'CREATE INDEX ai_proposals_owner_updated ON ai_proposals (owner_id, updated_at);',
)
@TableIndex.sql('CREATE INDEX ai_proposals_owner_status ON ai_proposals (owner_id, status);')
class AiProposalRecords extends Table with RecordColumns, SoftDeleteColumns {
  @override
  String get tableName => 'ai_proposals';
  TextColumn get status => text().withDefault(const Constant('menunggu'))();
  TextColumn get sourceText => text().nullable()();
  TextColumn get customerName => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get serviceId => text().nullable()();
  BoolColumn get cancelRequested => boolean().withDefault(const Constant(false))();
  BoolColumn get uncertainAddress => boolean().withDefault(const Constant(false))();
  TextColumn get customerId => text().nullable()();
  TextColumn get orderId => text().nullable()();
  TextColumn get waMessageId => text().nullable()();
  TextColumn get chatId => text().nullable()();
  RealColumn get confidence => real().nullable()();
  DateTimeColumn get receivedAt => dateTime().nullable()();
}
