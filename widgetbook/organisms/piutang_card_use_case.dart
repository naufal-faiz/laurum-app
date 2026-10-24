import 'package:flutter/material.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/piutang_card.dart';
import 'package:widgetbook/widgetbook.dart';

import 'fixture_labels.dart';

final piutangCardUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      spacing: AppSpacing.cardGap,
      children: [
        for (final id in ['ord-0128', 'ord-0136', 'ord-0138', 'ord-0140', 'ord-0142'])
          for (final order in orderFixtures.where((o) => o.id == id))
            PiutangCard(
              customerName: customerFixtures.singleWhere((c) => c.id == order.customerId).name,
              orderNo: order.orderNo,
              summary: fixtureOrderSummary(id),
              total: order.total,
              paid: paidAmount(paymentFixtures, orderId: id),
              dateLabel: Formatters.tanggal(order.enteredAt, ringkas: true),
              ageLabel:
                  '${DateTime(2026, 10, 16).difference(DateTime(order.enteredAt.year, order.enteredAt.month, order.enteredAt.day)).inDays} hari lalu',
              onPay: id == 'ord-0142' ? null : () {},
              onRemind: id == 'ord-0142' ? null : () {},
            ),
      ],
    ),
  ),
);
