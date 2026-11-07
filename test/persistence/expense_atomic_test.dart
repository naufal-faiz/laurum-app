import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';
import 'package:laurum/features/expenses/data/drift_expense_repository.dart';
import 'package:laurum/features/expenses/data/expense_storage.dart';

import '../contracts/expense_contract.dart';
import '../domain_samples.dart';

void main() {
  late AppDatabase db;
  late DriftExpenseRepository repo;
  late OutboxWriter writer;
  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    writer = OutboxWriter(db, DriftTransactionRunner(db));
    repo = DriftExpenseRepository(db, 'owner', writer, clock: () => day);
    await repo.saveCategory(
      ExpenseCategory(id: 'cat', ownerId: 'owner', createdAt: day, name: 'Sabun'),
    );
  });
  tearDown(() => db.close());
  test('category/expense updates and deletion roll back together with outbox', () async {
    await repo.saveExpense(contractExpense('e', day));
    final before = await repo.getExpenses();
    await db.customStatement(
      "CREATE TRIGGER fault BEFORE INSERT ON outbox BEGIN SELECT RAISE(ABORT, 'injected'); END",
    );
    await expectLater(
      repo.saveCategory(ExpenseCategory(id: 'new', ownerId: 'owner', createdAt: day, name: 'Baru')),
      throwsA(anything),
    );
    await expectLater(repo.saveExpense(contractExpense('e', day, amount: 200)), throwsA(anything));
    await expectLater(repo.deleteExpense('e'), throwsA(anything));
    expect(await repo.getExpenses(), before);
    expect(await repo.getCategories(), hasLength(1));
    expect(await db.select(db.outboxRecords).get(), hasLength(2));
    await db.customStatement('DROP TRIGGER fault');
    await repo.deleteExpense('e');
    final row = await db.select(db.expenseRecords).getSingle();
    expect(row.deletedAt, day);
    final wire = (await db.select(db.outboxRecords).get()).last;
    expect(
      (jsonDecode(wire.payload) as Map<String, dynamic>)['deleted_at'],
      day.toUtc().toIso8601String(),
    );
    expect(wire.op, 'upsert');
  });
  test(
    'expense metadata, null photo and exact timestamp persist; foreign owner cannot mutate',
    () async {
      await repo.saveExpense(contractExpense('e', day));
      final e = (await repo.getExpenses()).single;
      expect(e.updatedAt, day);
      expect(e.syncState, RecordSyncState.pending);
      expect(e.photoPath, isNull);
      final raw = await db.customSelect('SELECT spent_at FROM expenses').getSingle();
      expect(raw.read<String>('spent_at'), sqlTimestamp(day));
      final other = DriftExpenseRepository(db, 'other', writer);
      expect(await other.getCategories(), isEmpty);
      expect(await other.getExpenses(), isEmpty);
      await expectLater(other.saveExpense(contractExpense('e', day)), throwsStateError);
      await other.deleteExpense('e');
      expect(await repo.getExpenses(), hasLength(1));
    },
  );
  test('a device-local photo path never enters the wire payload', () {
    final expense = Expense(
      id: 'e',
      ownerId: 'owner',
      createdAt: day,
      categoryId: 'cat',
      amount: 100,
      spentAt: day,
      photoPath: r'C:\photos\receipt.jpg',
    );
    final payload = expensePayload(expense, day);
    expect(payload.containsKey('photo_path'), isFalse);
    expect(payload['amount'], 100);
  });
}
