import 'package:drift/drift.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/repositories/savings_repository.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/customers/data/savings_entry_content.dart';
import 'package:laurum/features/customers/data/savings_history.dart';
import 'package:laurum/features/customers/data/savings_storage_mapping.dart';
import 'package:laurum/features/customers/data/validate_savings_parent.dart';

class DriftSavingsRepository implements SavingsRepository {
  DriftSavingsRepository(this.db, this.ownerId, this.writer, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now {
    if (!identical(db, writer.db)) throw ArgumentError('Outbox belongs to another database');
  }
  final AppDatabase db;
  final String ownerId;
  final OutboxWriter writer;
  final DateTime Function() clock;
  @override
  Future<List<SavingsEntry>> getAllEntries() async {
    final query = db.select(db.savingsRecords)
      ..where((r) => r.ownerId.equals(ownerId))
      ..orderBy([(r) => OrderingTerm.asc(r.rowId)]);
    return List.unmodifiable((await query.get()).map(savingsFromRow));
  }

  @override
  Future<List<SavingsEntry>> getEntriesByCustomerId(String customerId) async {
    final query = db.select(db.savingsRecords)
      ..where((r) => r.ownerId.equals(ownerId) & r.customerId.equals(customerId))
      ..orderBy([(r) => OrderingTerm.asc(r.rowId)]);
    return savingsHistory((await query.get()).map(savingsFromRow));
  }

  @override
  Future<int> getBalance(String customerId) async {
    final row = await db
        .customSelect(
          '''SELECT COALESCE(SUM(
      CASE WHEN kind = 'pakai' THEN -amount ELSE amount END), 0) AS balance
      FROM savings_entries WHERE owner_id = ? AND customer_id = ?''',
          variables: [Variable<String>(ownerId), Variable<String>(customerId)],
          readsFrom: {db.savingsRecords},
        )
        .getSingle();
    return row.read<int>('balance');
  }

  @override
  Future<void> addEntry(SavingsEntry entry) => writer.runner.run(() async {
    if (entry.ownerId != ownerId) throw StateError('Savings belongs to another account');
    final existing = await (db.select(
      db.savingsRecords,
    )..where((r) => r.id.equals(entry.id))).getSingleOrNull();
    if (existing != null) {
      if (!sameSavingsContent(savingsFromRow(existing), entry)) {
        throw StateError('Savings entries are immutable');
      }
      return;
    }
    if (entry.kind != SavingsKind.penyesuaian && entry.amount <= 0) {
      throw ArgumentError('Deposit or withdrawal must be positive');
    }
    await validateSavingsParent(db, entry);
    final delta = entry.kind == SavingsKind.pakai ? -entry.amount : entry.amount;
    if (await getBalance(entry.customerId) + delta < 0) {
      throw StateError('Insufficient savings balance');
    }
    final at = clock();
    await writer.write(
      table: 'savings_entries',
      rowId: entry.id,
      payload: savingsPayload(entry, at),
      mutate: () async {
        await db.into(db.savingsRecords).insert(savingsToRow(entry, at));
      },
    );
  });
}
