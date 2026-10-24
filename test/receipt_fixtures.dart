import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/receipt_settings.dart';

const receiptOwner = 'owner-001';
final receiptAt = DateTime(2026, 10, 16, 10, 45);

BusinessProfile receiptBusiness() => BusinessProfile(
  id: 'biz-001',
  ownerId: receiptOwner,
  createdAt: receiptAt,
  name: 'Berkah Laundry',
  address: 'Jl. Melati No. 4, Sukajadi',
  phone: '0812-3456-7890',
  receiptFooter: 'Terima kasih atas kepercayaan Anda',
  receiptNote: 'Pakaian bersih, wangi & rapi',
);

ReceiptSettings receiptSettings({
  bool showAddress = true,
  bool showCustomer = true,
  bool showSavings = true,
  bool showNote = true,
}) => ReceiptSettings(
  id: 'rcpt-001',
  ownerId: receiptOwner,
  createdAt: receiptAt,
  showAddress: showAddress,
  showCustomer: showCustomer,
  showSavings: showSavings,
  showNote: showNote,
);

Order receiptOrder({String note = 'pewangi lavender, jangan dicampur pakaian putih'}) => Order(
  id: 'ord-a0143',
  ownerId: receiptOwner,
  createdAt: receiptAt,
  orderNo: 'A-0143',
  customerId: 'cust-001',
  status: OrderStatus.diproses,
  source: OrderSource.kasir,
  discount: 0,
  enteredAt: receiptAt,
  estimatedAt: DateTime(2026, 10, 19, 17),
  subtotal: 56500,
  total: 56500,
  note: note,
);

final receiptItems = [
  receiptItem('i1', 'Cuci setrika', 'kg', 3500, 9000, 31500),
  receiptItem('i2', 'Bed cover', 'pcs', 1000, 25000, 25000),
];

OrderItem receiptItem(String id, String name, String unit, int qty, int price, int total) =>
    OrderItem(
      id: id,
      ownerId: receiptOwner,
      createdAt: receiptAt,
      orderId: 'ord-a0143',
      serviceId: 'srv-$id',
      serviceName: name,
      unit: unit,
      qtyMilli: qty,
      unitPrice: price,
      lineTotal: total,
    );

List<Payment> receiptPayments() => [
  receiptPayment('p1', PayMethod.tabungan, 50000),
  receiptPayment('p2', PayMethod.tunai, 6500),
];

Payment receiptPayment(String id, PayMethod method, int amount) => Payment(
  id: id,
  ownerId: receiptOwner,
  createdAt: receiptAt,
  orderId: 'ord-a0143',
  method: method,
  amount: amount,
  received: amount,
  paidAt: receiptAt,
);
