import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/customers/data/in_memory_savings_repository.dart';
import 'package:laurum/features/orders/data/in_memory_order_repository.dart';
import 'package:laurum/features/orders/state/order_payment_controller.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/main_dummy.dart';

import 'r9_checkout_host.dart';

class FailingExcessSavings extends InMemorySavingsRepository {
  @override
  Future<void> addEntry(SavingsEntry entry) async {
    await super.addEntry(entry);
    throw StateError('after deposit');
  }
}

void main() {
  late ProviderContainer scope;
  setUp(() {
    scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        inMemorySavingsRepositoryProvider.overrideWith(FailingExcessSavings.new),
      ],
    );
    addTearDown(scope.dispose);
  });
  test('COD payment failure rolls back completion, payment, savings and pending', () async {
    final data = await r9Checkout(scope);
    final orders = scope.read(inMemoryOrderRepositoryProvider);
    final savings = scope.read(inMemorySavingsRepositoryProvider);
    final pending = scope.read(syncServiceProvider).pendingChanges;
    expect(
      await scope
          .read(orderPaymentProvider.notifier)
          .record(data, amount: 25000, received: 30000, method: PayMethod.tunai, saveExcess: true),
      isFalse,
    );
    expect(scope.read(inMemoryOrderRepositoryProvider), same(orders));
    expect(scope.read(inMemorySavingsRepositoryProvider), same(savings));
    expect(scope.read(syncServiceProvider).pendingChanges, pending);
  });
  test('checkout excess deposit failure restores the whole new invoice', () async {
    scope.read(transactionDraftProvider.notifier)
      ..selectCustomer('cust-001')
      ..add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    final checkout = scope.read(checkoutControllerProvider.notifier)
      ..setReceived(30000)
      ..setExcess(save: true);
    await scope.read(transactionRunnerProvider).run(() async {});
    final orders = scope.read(inMemoryOrderRepositoryProvider);
    final savings = scope.read(inMemorySavingsRepositoryProvider);
    final pending = scope.read(syncServiceProvider).pendingChanges;
    expect(await checkout.save(), isNull);
    expect(scope.read(inMemoryOrderRepositoryProvider), same(orders));
    expect(scope.read(inMemorySavingsRepositoryProvider), same(savings));
    expect(scope.read(syncServiceProvider).pendingChanges, pending);
    expect(scope.read(transactionDraftProvider).lines, isNotEmpty);
  });
}
