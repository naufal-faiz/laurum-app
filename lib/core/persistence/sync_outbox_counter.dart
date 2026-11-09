import 'package:laurum/core/persistence/app_database.dart';

/// Counts pending outbox rows and watches the count as rows are written or
/// acknowledged.
class SyncOutboxCounter {
  SyncOutboxCounter(this.db);
  final AppDatabase db;

  Future<int> count() async =>
      (await db.customSelect('SELECT COUNT(*) AS n FROM outbox').getSingle()).read<int>('n');

  Stream<int> watch() => db
      .customSelect(
        'SELECT COUNT(*) AS n FROM outbox',
        readsFrom: {db.outboxRecords},
      )
      .watchSingle()
      .map((row) => row.read<int>('n'));
}
