import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';

Order _o(
  String id,
  String no,
  String cId,
  OrderStatus st,
  DateTime enter,
  DateTime est,
  int tot,
) => Order(
  id: id,
  ownerId: dummyOwnerId,
  createdAt: enter,
  orderNo: no,
  customerId: cId,
  status: st,
  source: OrderSource.kasir,
  discount: 0,
  enteredAt: enter,
  estimatedAt: est,
  subtotal: tot,
  total: tot,
);

final orderQueueProcessFixtures = <Order>[
  // Menunggu jemput (3)
  _o(
    'ord-0131',
    'A-0131',
    'cust-004',
    OrderStatus.menungguJemput,
    DateTime(2026, 10, 16, 8),
    DateTime(2026, 10, 18, 17),
    21000,
  ),
  _o(
    'ord-0132',
    'A-0132',
    'cust-005',
    OrderStatus.menungguJemput,
    DateTime(2026, 10, 16, 8, 30),
    DateTime(2026, 10, 18, 17),
    36000,
  ),
  _o(
    'ord-0140',
    'A-0140',
    'cust-003',
    OrderStatus.menungguJemput,
    DateTime(2026, 10, 16, 9, 15),
    DateTime(2026, 10, 19, 17),
    25000,
  ),

  // Diproses (5)
  _o(
    'ord-0133',
    'A-0133',
    'cust-006',
    OrderStatus.diproses,
    DateTime(2026, 10, 15, 11),
    DateTime(2026, 10, 16, 17),
    30000,
  ),
  _o(
    'ord-0134',
    'A-0134',
    'cust-007',
    OrderStatus.diproses,
    DateTime(2026, 10, 15, 14),
    DateTime(2026, 10, 18, 17),
    20000,
  ),
  _o(
    'ord-0135',
    'A-0135',
    'cust-008',
    OrderStatus.diproses,
    DateTime(2026, 10, 15, 16),
    DateTime(2026, 10, 17, 17),
    45000,
  ),
  _o(
    'ord-0137',
    'A-0137',
    'cust-010',
    OrderStatus.diproses,
    DateTime(2026, 10, 16, 7, 45),
    DateTime(2026, 10, 18, 17),
    28000,
  ),
  _o(
    'ord-0142',
    'A-0142',
    'cust-001',
    OrderStatus.diproses,
    DateTime(2026, 10, 16, 10, 15),
    DateTime(2026, 10, 18, 17),
    31500,
  ),
];
