import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/app_database.dart';

/// v6 adds the two AI WhatsApp tables. Both are new, so nothing existing moves.
Future<void> migrateAiTables(AppDatabase db, Migrator m) async {
  await m.createTable(db.aiProposalRecords);
  await m.createTable(db.waConnectionRecords);
  await m.createIndex(db.aiProposalsOwnerUpdated);
  await m.createIndex(db.aiProposalsOwnerStatus);
  await m.createIndex(db.waConnectionsOwnerUpdated);
}
