import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/domain/service_item.dart';

final day = DateTime(2026, 10, 16, 10);
Order order(
  String id, {
  int total = 100,
  OrderStatus status = OrderStatus.diproses,
  DateTime? enteredAt,
  int discount = 0,
}) => Order(
  id: id,
  ownerId: 'owner',
  createdAt: day,
  orderNo: id,
  customerId: 'c',
  status: status,
  source: OrderSource.kasir,
  discount: discount,
  enteredAt: enteredAt ?? day,
  estimatedAt: DateTime(2026, 10, 18, 17),
  subtotal: total + discount,
  total: total,
);
OrderItem item(
  String id, {
  String orderId = 'o',
  String serviceId = 's',
  int amount = 1000,
  int qtyMilli = 1000,
}) => OrderItem(
  id: id,
  ownerId: 'owner',
  createdAt: day,
  orderId: orderId,
  serviceId: serviceId,
  serviceName: serviceId,
  unit: 'pcs',
  qtyMilli: qtyMilli,
  unitPrice: amount,
  lineTotal: amount,
);
Payment payment(
  String id, {
  String orderId = 'o',
  int amount = 100,
  int? received,
  PayMethod method = PayMethod.tunai,
  DateTime? paidAt,
}) => Payment(
  id: id,
  ownerId: 'owner',
  createdAt: day,
  orderId: orderId,
  method: method,
  amount: amount,
  received: received ?? amount,
  paidAt: paidAt ?? day,
);
SavingsEntry saving(
  String id, {
  String customerId = 'c',
  String? orderId,
  int amount = 100,
  SavingsKind kind = SavingsKind.setor,
  DateTime? createdAt,
}) => SavingsEntry(
  id: id,
  ownerId: 'owner',
  createdAt: createdAt ?? day,
  customerId: customerId,
  kind: kind,
  amount: amount,
  method: PayMethod.tunai,
  orderId: orderId,
);
ServiceItem service(String id, {int days = 1}) => ServiceItem(
  id: id,
  ownerId: 'owner',
  createdAt: day,
  name: id,
  kind: ServiceKind.kiloan,
  price: 1000,
  durationDays: days,
);
