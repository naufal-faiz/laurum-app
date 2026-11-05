import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/services/local_data_service.dart';

// Clear rows atomically; closing/removing the account file belongs after commit.
class DriftLocalDataService implements LocalDataService {
  DriftLocalDataService(this.db, this.ownerId, this.runner, {this.clearMemory}) {
    if (!identical(db, runner.db)) throw ArgumentError('Runner belongs to another database');
  }
  final AppDatabase db;
  final String ownerId;
  final DriftTransactionRunner runner;
  final Future<void> Function()? clearMemory;
  @override
  Future<void> finishDelete() async {}
  @override
  Future<void> deleteLocalData() => runner.run(() async {
    for (final table in db.allTables.where((t) => t.$columns.any((c) => c.$name == 'owner_id'))) {
      final foreign = await db
          .customSelect(
            'SELECT 1 FROM ${table.actualTableName} WHERE owner_id != ? LIMIT 1',
            variables: [Variable<String>(ownerId)],
          )
          .get();
      if (foreign.isNotEmpty) throw StateError('Account database contains foreign data');
    }
    for (final name in [
      'savings_entries',
      'payments',
      'order_events',
      'order_items',
      'orders',
      'expenses',
      'expense_categories',
      'customers',
      'services',
      'businesses',
      'receipt_settings',
      'devices',
      'entitlements',
      'outbox',
      'local_settings',
      'sync_cursors',
    ]) {
      await db.delete(db.allTables.singleWhere((t) => t.actualTableName == name)).go();
    }
    await clearMemory?.call();
  });
}
