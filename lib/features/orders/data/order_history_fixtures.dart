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
  int tot, {
  String note = '',
}) => Order(
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
  note: note,
);

final orderHistoryFixtures = <Order>[
  // Piutang riwayat selesai (3)
  _o(
    'ord-0128',
    'A-0128',
    'cust-008',
    OrderStatus.selesai,
    DateTime(2026, 10, 11, 10),
    DateTime(2026, 10, 14, 17),
    250000,
  ),
  _o(
    'ord-0136',
    'A-0136',
    'cust-006',
    OrderStatus.selesai,
    DateTime(2026, 10, 14, 13),
    DateTime(2026, 10, 16, 17),
    162000,
  ),
  _o(
    'ord-0138',
    'A-0138',
    'cust-007',
    OrderStatus.selesai,
    DateTime(2026, 10, 15, 15),
    DateTime(2026, 10, 16, 17),
    42000,
  ),

  // Dibatalkan (1)
  _o(
    'ord-0139',
    'A-0139',
    'cust-009',
    OrderStatus.dibatalkan,
    DateTime(2026, 10, 16, 8, 45),
    DateTime(2026, 10, 19, 17),
    25000,
    note: 'Usulan batal A-0139 Pak Rudi',
  ),
];
