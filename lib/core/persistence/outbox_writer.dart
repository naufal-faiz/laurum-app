import 'dart:convert';

import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';

class OutboxWriter {
  OutboxWriter(this.db, this.runner, {this.ids = const IdGenerator(), DateTime Function()? clock})
    : clock = clock ?? DateTime.now {
    if (!identical(db, runner.db)) throw ArgumentError('Runner belongs to another database');
  }
  final AppDatabase db;
  final DriftTransactionRunner runner;
  final IdGenerator ids;
  final DateTime Function() clock;

  // Repositories must mutate this database inside the callback, never external services.
  Future<T> write<T>({
    required String table,
    required String rowId,
    required Map<String, Object?> payload,
    required Future<T> Function() mutate,
    String op = 'upsert',
  }) async {
    final target = db.allTables.where((t) => t.actualTableName == table).firstOrNull;
    if (target == null ||
        !target.$columns.any((c) => c.$name == 'owner_id') ||
        !const {'upsert', 'delete'}.contains(op)) {
      throw ArgumentError('Invalid outbox target or operation');
    }
    final encoded = jsonEncode(payload);
    return runner.run(() async {
      final result = await mutate();
      await db
          .into(db.outboxRecords)
          .insert(
            OutboxRecordsCompanion.insert(
              id: ids.newId(),
              targetTable: table,
              rowId: rowId,
              op: op,
              payload: encoded,
              createdAt: clock(),
            ),
          );
      return result;
    });
  }
}
