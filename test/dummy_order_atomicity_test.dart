import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  late ProviderContainer container;
  setUp(() => container = ProviderContainer(overrides: dummyRepositoryOverrides));
  tearDown(() => container.dispose());

  test('failed transition does not append an event', () async {
    final repo = container.read(orderRepositoryProvider);
    final at = DateTime(2026, 10, 16, 11);
    final event = OrderEvent(
      id: 'bad-event',
      ownerId: dummyOwnerId,
      createdAt: at,
      occurredAt: at,
      orderId: 'ord-0142',
      kind: 'status',
      toStatus: OrderStatus.menungguJemput,
    );
    final before = await repo.getEventsByOrderId('ord-0142');
    await expectLater(
      repo.updateOrderStatus('ord-0142', OrderStatus.menungguJemput, event: event),
      throwsStateError,
    );
    expect(await repo.getEventsByOrderId('ord-0142'), before);
  });

  test('conflicting payment ID rolls back the whole save', () async {
    final repo = container.read(orderRepositoryProvider);
    final old = (await repo.getOrderById('ord-0141'))!;
    final original = (await repo.getPaymentsByOrderId(old.id)).single;
    final conflicting = Payment(
      id: original.id,
      ownerId: original.ownerId,
      createdAt: original.createdAt,
      orderId: old.id,
      method: original.method,
      amount: 1,
      received: 1,
      paidAt: original.paidAt,
    );
    await expectLater(
      repo.saveOrder(old.withStatus(OrderStatus.selesai), payments: [conflicting]),
      throwsStateError,
    );
    expect(await repo.getOrderById(old.id), old);
    expect(await repo.getPaymentsByOrderId(old.id), [original]);
  });

  test('events notify interface subscribers and survive another write', () async {
    var notifications = 0;
    final sub = container.listen(orderRepositoryProvider, (_, _) => notifications++);
    final repo = container.read(orderRepositoryProvider);
    final at = DateTime(2026, 10, 16, 11);
    final event = OrderEvent(
      id: 'note-event',
      ownerId: dummyOwnerId,
      createdAt: at,
      occurredAt: at,
      orderId: 'ord-0142',
      kind: 'note',
      note: 'Pisahkan pakaian putih',
    );
    await repo.addEvent(event);
    await container.pump();
    expect(notifications, 1);
    expect(await repo.getEventsByOrderId('ord-0142'), contains(event));
    sub.close();
  });
}
