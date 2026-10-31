import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/features/expenses/data/in_memory_expense_repository.dart';
import 'package:laurum/features/expenses/state/expense_delete_controller.dart';
import 'package:laurum/features/expenses/state/expense_directory.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

class FailingExpenseRepository extends InMemoryExpenseRepository {
  @override
  Future<void> saveExpense(Expense expense) async => throw StateError('save failed');
  @override
  Future<void> deleteExpense(String id) async => throw StateError('delete failed');
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  test('failed writes keep draft, release busy state and preserve totals', () async {
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        inMemoryExpenseRepositoryProvider.overrideWith(FailingExpenseRepository.new),
      ],
    );
    addTearDown(scope.dispose);
    final form = scope.read(expenseFormProvider.notifier);
    form.category('cat-001');
    form.nominal('5000');
    expect(await form.save(), isFalse);
    expect(scope.read(expenseFormProvider).amount, 5000);
    expect(scope.read(expenseFormProvider).busy, isFalse);
    expect(scope.read(expenseFormProvider).error, contains('gagal disimpan'));
    expect(await scope.read(expenseDeleteProvider('exp-001').notifier).delete(), isFalse);
    expect(scope.read(expenseDeleteProvider('exp-001')).hasError, isTrue);
    expect((await scope.read(expenseDirectoryProvider.future)).total, 1850000);
  });
  testWidgets('loading resolves to empty month with CTA', (tester) async {
    final pending = Completer<ExpenseDirectory>();
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        expenseDirectoryProvider.overrideWith((ref) => pending.future),
      ],
    );
    await pumpAntrean(tester, container: scope, location: '/lainnya/pengeluaran');
    expect(find.text('Memuat pengeluaran...'), findsOneWidget);
    pending.complete(ExpenseDirectory(DateTime(2026, 10), [], []));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada pengeluaran'), findsOneWidget);
    expect(find.text('Catat pengeluaran').hitTestable(), findsOneWidget);
  });
  testWidgets('directory load failure can retry successfully', (tester) async {
    var calls = 0;
    final scope = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        ...dummyRepositoryOverrides,
        expenseDirectoryProvider.overrideWith((ref) async {
          if (calls++ == 0) throw StateError('offline');
          return ExpenseDirectory(DateTime(2026, 10), [], []);
        }),
      ],
    );
    await pumpAntrean(tester, container: scope, location: '/lainnya/pengeluaran');
    expect(find.text('Gagal memuat pengeluaran'), findsOneWidget);
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada pengeluaran'), findsOneWidget);
  });
}
