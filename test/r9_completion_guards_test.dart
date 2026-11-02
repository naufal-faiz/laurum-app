import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/antrean_controller.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';

import 'r9_checkout_host.dart';

void main() {
  test('repository and queue reject COD completion even when UI is bypassed', () async {
    final scope = r9Scope();
    addTearDown(scope.dispose);
    var data = await r9Checkout(scope, useStatus: true);
    await scope.read(orderActionsProvider.notifier).advance(data.order);
    data = (await scope.read(orderDetailProvider(data.order.id).future))!;
    final repo = scope.read(orderRepositoryProvider);
    await expectLater(repo.updateOrderStatus(data.order.id, OrderStatus.selesai), throwsStateError);
    await expectLater(repo.saveOrder(data.order.withStatus(OrderStatus.selesai)), throwsStateError);
    await scope.read(antreanActionsProvider.notifier).advance(data.order.id, OrderStatus.siap);
    expect(scope.read(antreanActionsProvider).error, isNotNull);
    expect((await repo.getOrderById(data.order.id))!.status, OrderStatus.siap);
    expect(await repo.getPaymentsByOrderId(data.order.id), isEmpty);
  });
}
