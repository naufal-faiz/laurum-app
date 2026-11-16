import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/expenses/data/drift_expense_repository.dart';
import 'package:laurum/features/expenses/state/expense_directory.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

import '../contracts/expense_contract.dart';

void main() {
  late AppDatabase db;
  late DriftExpenseRepository repository;
  late ProviderContainer scope;
  final now = DateTime(2026, 11, 16);
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = DriftExpenseRepository(db, 'owner', OutboxWriter(db, DriftTransactionRunner(db)));
    scope = ProviderContainer(
      overrides: [
        expenseRepositoryProvider.overrideWithValue(repository),
        businessClockProvider.overrideWithValue(() => now),
      ],
    );
  });
  tearDown(() async {
    scope.dispose();
    await db.close();
  });
  test('expense directory loads an empty local database', () async {
    final directory = await scope.read(expenseDirectoryProvider.future);
    expect(directory.expenses, isEmpty);
    expect(directory.total, 0);
    expect(directory.month, DateTime(2026, 11));
  });
  test('expense directory sorts a copy of immutable local expenses within the month', () async {
    await repository.saveCategory(
      ExpenseCategory(
        id: 'cat',
        ownerId: 'owner',
        createdAt: now,
        name: 'Sabun',
      ),
    );
    for (final (id, at) in [
      ('early', DateTime(2026, 11, 2)),
      ('late', DateTime(2026, 11, 15)),
      ('outside', DateTime(2026, 10, 31)),
    ]) {
      await repository.saveExpense(contractExpense(id, at));
    }
    final source = await repository.getExpenses(from: DateTime(2026, 11), to: DateTime(2026, 12));
    expect(() => source.sort((a, b) => b.spentAt.compareTo(a.spentAt)), throwsUnsupportedError);
    final directory = await scope.read(expenseDirectoryProvider.future);
    expect(directory.expenses.map((e) => e.id), ['late', 'early']);
    expect(directory.total, 200);
    expect(directory.category('cat'), 'Sabun');
    expect(source.map((e) => e.id), ['early', 'late']);
  });
}
