import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/features/orders/data/order_fixture_factory.dart';

final orderQueueReadyFixtures = <Order>[
  fixtureOrder(
    'ord-0127',
    'A-0127',
    'cust-005',
    OrderStatus.siap,
    DateTime(2026, 10, 14, 10),
    DateTime(2026, 10, 17, 17),
    50000,
  ),
  fixtureOrder(
    'ord-0129',
    'A-0129',
    'cust-011',
    OrderStatus.siap,
    DateTime(2026, 10, 14, 15),
    DateTime(2026, 10, 15, 17),
    36000,
  ),
  fixtureOrder(
    'ord-0130',
    'A-0130',
    'cust-013',
    OrderStatus.siap,
    DateTime(2026, 10, 15, 9),
    DateTime(2026, 10, 17, 17),
    27000,
  ),
  fixtureOrder(
    'ord-0141',
    'A-0141',
    'cust-002',
    OrderStatus.siap,
    DateTime(2026, 10, 16, 9, 50),
    DateTime(2026, 10, 18, 17),
    31500,
  ),
];
