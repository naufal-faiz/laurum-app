import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/business/data/in_memory_business_repository.dart';
import 'package:laurum/features/customers/data/in_memory_customer_repository.dart';
import 'package:laurum/features/customers/data/in_memory_savings_repository.dart';
import 'package:laurum/features/expenses/data/in_memory_expense_repository.dart';
import 'package:laurum/features/orders/data/in_memory_order_repository.dart';
import 'package:laurum/features/services/data/in_memory_service_repository.dart';

import 'contracts/business_contract.dart';
import 'contracts/customer_contract.dart';
import 'contracts/expense_contract.dart';
import 'contracts/order_contract.dart';
import 'contracts/savings_contract.dart';
import 'contracts/service_contract.dart';

void main() {
  late ProviderContainer scope;
  setUp(() {
    scope = ProviderContainer(
      overrides: [
        inMemoryCustomerRepositoryProvider.overrideWith(InMemoryCustomerRepository.empty),
        inMemorySavingsRepositoryProvider.overrideWith(InMemorySavingsRepository.empty),
        inMemoryServiceRepositoryProvider.overrideWith(InMemoryServiceRepository.empty),
        inMemoryOrderRepositoryProvider.overrideWith(InMemoryOrderRepository.empty),
        inMemoryExpenseRepositoryProvider.overrideWith(InMemoryExpenseRepository.empty),
      ],
    );
  });
  tearDown(() => scope.dispose());
  group(
    'Customer contract',
    () => runCustomerRepositoryContract(
      () => scope.read(inMemoryCustomerRepositoryProvider.notifier),
    ),
  );
  group(
    'Service contract',
    () =>
        runServiceRepositoryContract(() => scope.read(inMemoryServiceRepositoryProvider.notifier)),
  );
  group(
    'Savings contract',
    () =>
        runSavingsRepositoryContract(() => scope.read(inMemorySavingsRepositoryProvider.notifier)),
  );
  group(
    'Business contract',
    () => runBusinessRepositoryContract(
      () => scope.read(inMemoryBusinessRepositoryProvider.notifier),
    ),
  );
  group(
    'Order contract',
    () => runOrderRepositoryContract(() => scope.read(inMemoryOrderRepositoryProvider.notifier)),
  );
  group(
    'Expense contract',
    () =>
        runExpenseRepositoryContract(() => scope.read(inMemoryExpenseRepositoryProvider.notifier)),
  );
}
