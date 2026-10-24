import 'package:flutter/material.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/savings_rules.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/features/customers/data/customer_history_fixtures.dart';
import 'package:laurum/features/customers/data/savings_fixtures.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/customer_row.dart';
import 'package:widgetbook/widgetbook.dart';

final customerRowUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      spacing: AppSpacing.cardGap,
      children: [
        for (final c in [
          customerFixtures[0],
          customerFixtures[1],
          customerFixtures[2],
          customerFixtures[3],
        ])
          CustomerRow(
            name: c.name,
            phone: c.phone,
            initials: c.id == 'cust-004' ? null : c.name[0],
            orderCount: customerHistoryFixtures[c.id]?.orderCount ?? 0,
            historyTotal: customerHistoryFixtures[c.id]?.revenue ?? 0,
            savings: savingsBalance(savingsFixtures, customerId: c.id),
            outstanding: outstanding(
              orderFixtures.where((o) => o.customerId == c.id),
              paymentFixtures,
            ),
            paid: c.id == 'cust-003' ? paidAmount(paymentFixtures, orderId: 'ord-0140') : 0,
            onTap: () {},
            onContact: c.id == 'cust-004' ? null : () {},
          ),
      ],
    ),
  ),
);
