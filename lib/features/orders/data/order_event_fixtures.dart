import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';

final orderEventFixtures = [
  OrderEvent(
    id: 'event-142-process',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 10, 16, 10, 30),
    orderId: 'ord-0142',
    occurredAt: DateTime(2026, 10, 16, 10, 30),
    kind: 'status',
    fromStatus: OrderStatus.menungguJemput,
    toStatus: OrderStatus.diproses,
  ),
  OrderEvent(
    id: 'event-141-ready',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 10, 16, 9, 50),
    orderId: 'ord-0141',
    occurredAt: DateTime(2026, 10, 16, 9, 50),
    kind: 'status',
    fromStatus: OrderStatus.diproses,
    toStatus: OrderStatus.siap,
  ),
];
