import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/receipt_formatter.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';

// Source: DATA MASTER A-0143; not part of the dummy order snapshot.
final demoAt = DateTime(2026, 10, 16, 10, 45);

Order demoOrder() => Order(
  id: 'ord-a0143',
  ownerId: dummyOwnerId,
  createdAt: demoAt,
  orderNo: 'A-0143',
  customerId: 'cust-001',
  status: OrderStatus.diproses,
  source: OrderSource.kasir,
  discount: 0,
  enteredAt: demoAt,
  estimatedAt: DateTime(2026, 10, 19, 17),
  subtotal: 56500,
  total: 56500,
  note: 'pewangi lavender, jangan dicampur pakaian putih',
);

final demoItems = [
  demoItem('i1', 'Cuci setrika', 'kg', 3500, 9000, 31500),
  demoItem('i2', 'Bed cover', 'pcs', 1000, 25000, 25000),
];

final demoPayments = [
  demoPayment('p1', PayMethod.tabungan, 50000),
  demoPayment('p2', PayMethod.tunai, 6500),
];

OrderItem demoItem(String id, String name, String unit, int qty, int price, int total) => OrderItem(
  id: id,
  ownerId: dummyOwnerId,
  createdAt: demoAt,
  orderId: 'ord-a0143',
  serviceId: 'srv-$id',
  serviceName: name,
  unit: unit,
  qtyMilli: qty,
  unitPrice: price,
  lineTotal: total,
);

Payment demoPayment(String id, PayMethod method, int amount) => Payment(
  id: id,
  ownerId: dummyOwnerId,
  createdAt: demoAt,
  orderId: 'ord-a0143',
  method: method,
  amount: amount,
  received: amount,
  paidAt: demoAt,
);

List<String> demoReceiptLines({
  required BusinessProfile business,
  required ReceiptSettings settings,
}) => receiptLines(
  business: business,
  order: demoOrder(),
  items: demoItems,
  payments: demoPayments,
  customerName: 'Pak Dedi',
  settings: settings,
  savingsBalance: 50000,
);
