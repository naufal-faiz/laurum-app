import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/customers/data/in_memory_savings_repository.dart';
import 'package:laurum/features/expenses/data/in_memory_expense_repository.dart';
import 'package:laurum/features/orders/data/in_memory_order_repository.dart';
import 'package:laurum/features/reports/data/in_memory_report_repository.dart';

import 'contracts/report_contract.dart';

void main() {
  group(
    'Memory report contract',
    () => runReportRepositoryContract(({required bool seeded}) async {
      final scope = ProviderContainer(
        overrides: [
          if (!seeded) ...[
            inMemoryOrderRepositoryProvider.overrideWith(InMemoryOrderRepository.empty),
            inMemoryExpenseRepositoryProvider.overrideWith(InMemoryExpenseRepository.empty),
            inMemorySavingsRepositoryProvider.overrideWith(InMemorySavingsRepository.empty),
          ],
        ],
      );
      addTearDown(scope.dispose);
      return (
        reports: scope.read(inMemoryReportRepositoryProvider.notifier),
        orders: scope.read(inMemoryOrderRepositoryProvider.notifier),
        expenses: scope.read(inMemoryExpenseRepositoryProvider.notifier),
        savings: scope.read(inMemorySavingsRepositoryProvider.notifier),
      );
    }),
  );
}
