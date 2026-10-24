import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/receipt_formatter.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/receipt_preview.dart';
import 'package:widgetbook/widgetbook.dart';

// A-0143 values come from DATA MASTER; it is not part of the dummy snapshot.
final _at = DateTime(2026, 10, 16, 10, 45);

Order _order() => Order(
  id: 'ord-a0143',
  ownerId: dummyOwnerId,
  createdAt: _at,
  orderNo: 'A-0143',
  customerId: 'cust-001',
  status: OrderStatus.diproses,
  source: OrderSource.kasir,
  discount: 0,
  enteredAt: _at,
  estimatedAt: DateTime(2026, 10, 19, 17),
  subtotal: 56500,
  total: 56500,
  note: 'pewangi lavender, jangan dicampur pakaian putih',
);

OrderItem _item(String id, String name, String unit, int qty, int price, int total) => OrderItem(
  id: id,
  ownerId: dummyOwnerId,
  createdAt: _at,
  orderId: 'ord-a0143',
  serviceId: 'srv-$id',
  serviceName: name,
  unit: unit,
  qtyMilli: qty,
  unitPrice: price,
  lineTotal: total,
);

Payment _payment(String id, PayMethod method, int amount) => Payment(
  id: id,
  ownerId: dummyOwnerId,
  createdAt: _at,
  orderId: 'ord-a0143',
  method: method,
  amount: amount,
  received: amount,
  paidAt: _at,
);

final _items = [
  _item('i1', 'Cuci setrika', 'kg', 3500, 9000, 31500),
  _item('i2', 'Bed cover', 'pcs', 1000, 25000, 25000),
];

final _payments = [
  _payment('p1', PayMethod.tabungan, 50000),
  _payment('p2', PayMethod.tunai, 6500),
];

final receiptPreviewUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      spacing: AppSpacing.cardGap,
      children: [
        ReceiptPreview(
          lines: receiptLines(
            business: businessProfileFixture,
            order: _order(),
            items: _items,
            payments: _payments,
            customerName: 'Pak Dedi',
            settings: receiptSettingsFixture,
            savingsBalance: 50000,
          ),
        ),
        ReceiptPreview(
          lines: receiptLines(
            business: businessProfileFixture,
            order: _order(),
            items: _items,
            payments: _payments,
            customerName: 'Pak Dedi',
            settings: ReceiptSettings(
              id: 'rcpt-002',
              ownerId: dummyOwnerId,
              createdAt: _at,
              showAddress: false,
              showCustomer: false,
              showSavings: false,
              showNote: false,
            ),
            savingsBalance: 50000,
          ),
        ),
      ],
    ),
  ),
);
