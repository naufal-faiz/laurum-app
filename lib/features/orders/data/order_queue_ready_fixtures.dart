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

final orderQueueReadyFixtures = <Order>[
  _o(
    'ord-0127',
    'A-0127',
    'cust-005',
    OrderStatus.siap,
    DateTime(2026, 10, 14, 10),
    DateTime(2026, 10, 17, 17),
    50000,
  ),
  _o(
    'ord-0129',
    'A-0129',
    'cust-011',
    OrderStatus.siap,
    DateTime(2026, 10, 14, 15),
    DateTime(2026, 10, 15, 17),
    36000,
  ),
  _o(
    'ord-0130',
    'A-0130',
    'cust-013',
    OrderStatus.siap,
    DateTime(2026, 10, 15, 9),
    DateTime(2026, 10, 17, 17),
    27000,
  ),
  _o(
    'ord-0141',
    'A-0141',
    'cust-002',
    OrderStatus.siap,
    DateTime(2026, 10, 16, 9, 50),
    DateTime(2026, 10, 18, 17),
    31500,
  ),
];
