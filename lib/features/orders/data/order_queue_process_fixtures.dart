import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/features/orders/data/order_fixture_factory.dart';

final orderQueueProcessFixtures = <Order>[
  // Menunggu jemput (3)
  fixtureOrder(
    'ord-0139',
    'A-0139',
    'cust-009',
    OrderStatus.menungguJemput,
    DateTime(2026, 10, 16, 8, 30),
    DateTime(2026, 10, 19, 17),
    25000,
  ),
  fixtureOrder(
    'ord-0132',
    'A-0132',
    'cust-005',
    OrderStatus.menungguJemput,
    DateTime(2026, 10, 16, 8, 30),
    DateTime(2026, 10, 18, 17),
    36000,
  ),
  fixtureOrder(
    'ord-0140',
    'A-0140',
    'cust-003',
    OrderStatus.menungguJemput,
    DateTime(2026, 10, 16, 9, 15),
    DateTime(2026, 10, 19, 17),
    25000,
  ),

  // Diproses (5)
  fixtureOrder(
    'ord-0133',
    'A-0133',
    'cust-006',
    OrderStatus.diproses,
    DateTime(2026, 10, 15, 11),
    DateTime(2026, 10, 16, 17),
    30000,
  ),
  fixtureOrder(
    'ord-0134',
    'A-0134',
    'cust-007',
    OrderStatus.diproses,
    DateTime(2026, 10, 15, 14),
    DateTime(2026, 10, 18, 17),
    20000,
  ),
  fixtureOrder(
    'ord-0135',
    'A-0135',
    'cust-008',
    OrderStatus.diproses,
    DateTime(2026, 10, 15, 16),
    DateTime(2026, 10, 17, 17),
    45000,
  ),
  fixtureOrder(
    'ord-0137',
    'A-0137',
    'cust-010',
    OrderStatus.diproses,
    DateTime(2026, 10, 16, 7, 45),
    DateTime(2026, 10, 18, 17),
    28000,
  ),
  fixtureOrder(
    'ord-0142',
    'A-0142',
    'cust-001',
    OrderStatus.diproses,
    DateTime(2026, 10, 16, 10, 15),
    DateTime(2026, 10, 18, 17),
    31500,
  ),
];
