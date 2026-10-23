import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/features/orders/data/order_fixture_factory.dart';

final orderHistoryFixtures = <Order>[
  fixtureOrder(
    'ord-0115',
    'A-0115',
    'cust-001',
    OrderStatus.selesai,
    DateTime(2026, 10, 2, 14, 20),
    DateTime(2026, 10, 5, 17),
    25000,
  ),
  // Piutang riwayat selesai (3)
  fixtureOrder(
    'ord-0128',
    'A-0128',
    'cust-008',
    OrderStatus.selesai,
    DateTime(2026, 10, 11, 10),
    DateTime(2026, 10, 14, 17),
    250000,
  ),
  fixtureOrder(
    'ord-0136',
    'A-0136',
    'cust-006',
    OrderStatus.selesai,
    DateTime(2026, 10, 14, 13),
    DateTime(2026, 10, 16, 17),
    162000,
  ),
  fixtureOrder(
    'ord-0138',
    'A-0138',
    'cust-007',
    OrderStatus.selesai,
    DateTime(2026, 10, 15, 15),
    DateTime(2026, 10, 16, 17),
    42000,
  ),
];
