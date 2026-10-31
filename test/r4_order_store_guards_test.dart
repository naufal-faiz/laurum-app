import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/repositories/order_repository.dart';
import 'package:laurum/features/orders/data/in_memory_order_repository.dart';

void main() {
  late ProviderContainer container;
  late OrderRepository repository;
  setUp(() {
    container = ProviderContainer();
    repository = container.read(inMemoryOrderRepositoryProvider.notifier);
  });
  tearDown(() => container.dispose());

  test('simplified mode cannot complete cancelled orders through either write path', () async {
    final original = (await repository.getOrderById('ord-0142'))!;
    await repository.updateOrderStatus(original.id, OrderStatus.dibatalkan);
    await expectLater(
      repository.updateOrderStatus(
        original.id,
        OrderStatus.selesai,
        useOrderStatus: false,
      ),
      throwsStateError,
    );
    await expectLater(
      repository.saveOrder(
        original.withStatus(OrderStatus.selesai, useOrderStatus: false),
        useOrderStatus: false,
      ),
      throwsStateError,
    );
    expect((await repository.getOrderById(original.id))!.status, OrderStatus.dibatalkan);
  });

  test('invalid snapshot items still fail atomically in simplified mode', () async {
    final original = (await repository.getOrderById('ord-0142'))!;
    final before = container.read(inMemoryOrderRepositoryProvider);
    await expectLater(
      repository.saveOrder(
        original.withStatus(OrderStatus.selesai, useOrderStatus: false),
        items: [],
        useOrderStatus: false,
      ),
      throwsArgumentError,
    );
    expect(container.read(inMemoryOrderRepositoryProvider), same(before));
  });

  test('simplified mode cannot cancel a paid order without ledger corrections', () async {
    final order = (await repository.getOrderById('ord-0140'))!;
    final payments = await repository.getPaymentsByOrderId(order.id);
    expect(payments.fold<int>(0, (sum, p) => sum + p.amount), greaterThan(0));
    final before = container.read(inMemoryOrderRepositoryProvider);
    await expectLater(
      repository.saveOrder(
        order.withStatus(OrderStatus.dibatalkan),
        useOrderStatus: false,
      ),
      throwsStateError,
    );
    expect(container.read(inMemoryOrderRepositoryProvider), same(before));
    expect(await repository.getPaymentsByOrderId(order.id), orderedEquals(payments));
  });
}
