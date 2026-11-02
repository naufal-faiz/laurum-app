import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

import 'r9_checkout_host.dart';

void main() {
  for (final save in [false, true]) {
    test('checkout cash excess affects savings only when selected $save', () async {
      final scope = r9Scope();
      addTearDown(scope.dispose);
      final data = await r9Checkout(
        scope,
        term: PayTerm.sekarang,
        received: 30000,
        saveExcess: save,
      );
      expect(data.paid, 25000);
      expect(data.payments.single.received, 30000);
      expect(
        await scope.read(savingsRepositoryProvider).getBalance('cust-001'),
        save ? 55000 : 50000,
      );
    });
  }
  test('zero is rejected without writes; COD may use partial savings', () async {
    final scope = r9Scope();
    addTearDown(scope.dispose);
    scope.read(transactionDraftProvider.notifier)
      ..selectCustomer('cust-002')
      ..add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    final checkout = scope.read(checkoutControllerProvider.notifier)..setReceived(0);
    final repo = scope.read(orderRepositoryProvider);
    final count = (await repo.getOrders()).length;
    expect(await checkout.save(), isNull);
    expect((await repo.getOrders()).length, count);
    checkout
      ..setTerm(PayTerm.cod)
      ..setSavings(value: true);
    final id = (await checkout.save())!;
    final data = (await scope.read(orderDetailProvider(id).future))!;
    expect(data.paid, 18500);
    expect(data.outstanding, 6500);
    expect(data.completionHeld, isTrue);
    expect(data.payments.single.method, PayMethod.tabungan);
    expect(await scope.read(savingsRepositoryProvider).getBalance('cust-002'), 0);
  });
}
