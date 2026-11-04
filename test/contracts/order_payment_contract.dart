import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/repositories/order_repository.dart';

import '../domain_samples.dart';
import 'repository_factory.dart';

void runOrderPaymentContract(RepositoryFactory<OrderRepository> factory) {
  for (final useStatus in [false, true]) {
    test('COD cannot finish with outstanding balance, mode=$useStatus', () async {
      final repo = await factory();
      final row = Order(
        id: 'o',
        ownerId: 'owner',
        createdAt: day,
        orderNo: 'A-0001',
        customerId: 'c',
        status: OrderStatus.siap,
        source: OrderSource.kasir,
        payTerm: PayTerm.cod,
        discount: 0,
        enteredAt: day,
        estimatedAt: day,
        subtotal: 1000,
        total: 1000,
      );
      await repo.saveOrder(row, items: [item('i')]);
      await expectLater(
        repo.updateOrderStatus('o', OrderStatus.selesai, useOrderStatus: useStatus),
        throwsStateError,
      );
      final finished = row.withStatus(OrderStatus.selesai);
      await expectLater(repo.saveOrder(finished, useOrderStatus: useStatus), throwsStateError);
      expect((await repo.getOrderById('o'))!.status, OrderStatus.siap);
      await repo.saveOrder(
        finished,
        payments: [payment('p', amount: 1000)],
        useOrderStatus: useStatus,
      );
      expect((await repo.getOrderById('o'))!.status, OrderStatus.selesai);
    });
  }
}
