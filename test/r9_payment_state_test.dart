import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/state/order_completion_controller.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/orders/state/order_payment_controller.dart';

import 'r9_checkout_host.dart';

void main() {
  for (final useStatus in [false, true]) {
    test('COD payment releases hold and completes only via correct mode $useStatus', () async {
      final scope = r9Scope();
      addTearDown(scope.dispose);
      var data = await r9Checkout(scope, useStatus: useStatus);
      final id = data.order.id;
      final actions = scope.read(orderActionsProvider.notifier);
      if (useStatus) {
        expect(await actions.advance(data.order), isTrue);
        data = (await scope.read(orderDetailProvider(id).future))!;
        expect(await actions.advance(data.order), isFalse);
      } else {
        expect(await scope.read(orderCompletionProvider(id).notifier).complete(), isFalse);
      }
      expect((await scope.read(antreanDataProvider.future)).orders.any((o) => o.id == id), isTrue);
      expect(
        await scope
            .read(orderPaymentProvider.notifier)
            .record(
              data,
              amount: 25000,
              method: PayMethod.tunai,
              received: 30000,
              saveExcess: true,
              completeOnPayment: useStatus,
            ),
        isTrue,
      );
      data = (await scope.read(orderDetailProvider(id).future))!;
      expect(data.order.status, OrderStatus.selesai);
      expect(data.paid, 25000);
      expect(await scope.read(savingsRepositoryProvider).getBalance('cust-001'), 55000);
      expect(data.events.where((e) => e.toStatus == OrderStatus.selesai), hasLength(1));
      expect((await scope.read(antreanDataProvider.future)).orders.any((o) => o.id == id), isFalse);
    });
  }
  test('COD regular payment in active mode releases hold without changing ready status', () async {
    final scope = r9Scope();
    addTearDown(scope.dispose);
    var data = await r9Checkout(scope, useStatus: true);
    await scope.read(orderActionsProvider.notifier).advance(data.order);
    data = (await scope.read(orderDetailProvider(data.order.id).future))!;
    expect(
      await scope
          .read(orderPaymentProvider.notifier)
          .record(data, amount: 25000, method: PayMethod.tunai, received: 25000),
      isTrue,
    );
    data = (await scope.read(orderDetailProvider(data.order.id).future))!;
    expect(data.order.status, OrderStatus.siap);
    expect(await scope.read(orderActionsProvider.notifier).advance(data.order), isTrue);
  });
  test('non-COD partial payment may finish and receive payment after completion', () async {
    final scope = r9Scope();
    addTearDown(scope.dispose);
    var data = await r9Checkout(scope, useStatus: true, term: PayTerm.sekarang, received: 10000);
    final actions = scope.read(orderActionsProvider.notifier);
    await actions.advance(data.order);
    data = (await scope.read(orderDetailProvider(data.order.id).future))!;
    await actions.advance(data.order);
    data = (await scope.read(orderDetailProvider(data.order.id).future))!;
    expect(data.order.status, OrderStatus.selesai);
    expect(
      await scope
          .read(orderPaymentProvider.notifier)
          .record(data, amount: 15000, method: PayMethod.tunai, received: 20000),
      isTrue,
    );
    expect(await scope.read(savingsRepositoryProvider).getBalance('cust-001'), 50000);
    expect((await scope.read(orderDetailProvider(data.order.id).future))!.paid, 25000);
  });
}
