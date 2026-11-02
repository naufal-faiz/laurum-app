import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';

Order r9Order({
  PayTerm term = PayTerm.sekarang,
  int total = 10000,
  OrderStatus status = OrderStatus.diproses,
}) => Order(
  id: 'ord-r9',
  ownerId: 'owner-r9',
  createdAt: DateTime(2026, 10, 16),
  orderNo: 'A-9000',
  customerId: 'cust-r9',
  status: status,
  source: OrderSource.kasir,
  discount: 0,
  enteredAt: DateTime(2026, 10, 16),
  estimatedAt: DateTime(2026, 10, 17),
  subtotal: total,
  total: total,
  payTerm: term,
);
