import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/customers/data/in_memory_savings_repository.dart';
import 'package:laurum/features/orders/data/in_memory_order_repository.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/main_dummy.dart';

class FailingSavings extends InMemorySavingsRepository {
  bool _fail = true;
  void setFailure({required bool value}) => _fail = value;
  @override
  Future<void> addEntry(SavingsEntry entry) async {
    await super.addEntry(entry);
    if (_fail) throw Exception('after savings write');
  }
}

void main() {
  late ProviderContainer scope;
  setUp(() {
    scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        inMemorySavingsRepositoryProvider.overrideWith(FailingSavings.new),
      ],
    );
    addTearDown(scope.dispose);
  });
  Future<void> prepare() async {
    final draft = scope.read(transactionDraftProvider.notifier);
    draft.selectCustomer('cust-001');
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    scope.read(checkoutControllerProvider.notifier).setSavings(value: true, due: 0);
    await scope.read(transactionRunnerProvider).run(() async {});
  }

  test('checkout failure restores order/items/payments/events, savings and sync', () async {
    await prepare();
    final orders = scope.read(inMemoryOrderRepositoryProvider);
    final savings = scope.read(inMemorySavingsRepositoryProvider);
    final pending = scope.read(syncServiceProvider).pendingChanges;
    expect(await scope.read(checkoutControllerProvider.notifier).save(), isNull);
    expect(scope.read(inMemoryOrderRepositoryProvider), same(orders));
    expect(scope.read(inMemorySavingsRepositoryProvider), same(savings));
    expect(scope.read(syncServiceProvider).pendingChanges, pending);
    expect(scope.read(transactionDraftProvider).lines, isNotEmpty);
    (scope.read(inMemorySavingsRepositoryProvider.notifier) as FailingSavings).setFailure(
      value: false,
    );
    expect(await scope.read(checkoutControllerProvider.notifier).save(), 'ord-0143');
  });
  test('cancel failure rolls back payment corrections, status, event and savings', () async {
    await prepare();
    final repo = scope.read(inMemorySavingsRepositoryProvider.notifier) as FailingSavings;
    repo.setFailure(value: false);
    final id = (await scope.read(checkoutControllerProvider.notifier).save())!;
    final data = (await scope.read(orderDetailProvider(id).future))!;
    final orders = scope.read(inMemoryOrderRepositoryProvider);
    final savings = scope.read(inMemorySavingsRepositoryProvider);
    final pending = scope.read(syncServiceProvider).pendingChanges;
    repo.setFailure(value: true);
    expect(await scope.read(orderActionsProvider.notifier).cancel(data), isFalse);
    expect(scope.read(inMemoryOrderRepositoryProvider), same(orders));
    expect(scope.read(inMemorySavingsRepositoryProvider), same(savings));
    expect(scope.read(syncServiceProvider).pendingChanges, pending);
    repo.setFailure(value: false);
    expect(await scope.read(orderActionsProvider.notifier).cancel(data), isTrue);
    expect(await scope.read(savingsRepositoryProvider).getBalance('cust-001'), 50000);
  });
}
