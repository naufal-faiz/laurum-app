import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/app_database.dart';

// v4 rows never guess a business group from timestamps. They stay blocked until an
// explicit recovery plan assigns a group id and sequence.
Future<void> migrateSyncGroups(AppDatabase db, Migrator m, int from, int to) async {
  if (from != 4 || to != 5) {
    throw UnsupportedError('Migration required from $from to $to');
  }
  await db.transaction(() async {
    await m.addColumn(db.outboxRecords, db.outboxRecords.groupId);
    await m.addColumn(db.outboxRecords, db.outboxRecords.groupSeq);
    await m.addColumn(db.outboxRecords, db.outboxRecords.requiresRecovery);
    await m.addColumn(db.outboxRecords, db.outboxRecords.conflictCode);
    await db.customStatement('UPDATE outbox SET requires_recovery = 1');
    await m.createIndex(db.outboxGroup);
  });
}
