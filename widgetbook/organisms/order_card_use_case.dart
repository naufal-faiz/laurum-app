import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/order_card.dart';
import 'package:widgetbook/widgetbook.dart';

import 'fixture_labels.dart';

final orderCardUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      spacing: AppSpacing.cardGap,
      children: [
        for (final id in ['ord-0142', 'ord-0141', 'ord-0140', 'ord-0136', 'ord-0139'])
          for (final order in orderFixtures.where((o) => o.id == id))
            OrderCard(
              orderNo: order.orderNo,
              customerName: customerFixtures.singleWhere((c) => c.id == order.customerId).name,
              summary: fixtureOrderSummary(id),
              total: order.total,
              status: order.status,
              payStatus: payStatus(
                total: order.total,
                paid: paidAmount(paymentFixtures, orderId: id),
              ),
              paid: paidAmount(paymentFixtures, orderId: id),
              timeLabel: Formatters.jam(order.enteredAt),
              detail: Formatters.tanggal(order.estimatedAt, ringkas: true),
              needsReview: id == 'ord-0140',
              cancelRequested: id == 'ord-0139',
              onTap: () {},
              onAction: () {},
            ),
        for (final order in orderFixtures.where((o) => o.id == 'ord-0142'))
          OrderCard(
            orderNo: order.orderNo,
            customerName: customerFixtures.singleWhere((c) => c.id == order.customerId).name,
            summary: fixtureOrderSummary(order.id),
            total: order.total,
            status: order.status,
            payStatus: PayStatus.belumBayar,
            showAction: false,
            statusLabel: 'Sedang dikerjakan',
            onTap: () {},
          ),
        OrderCard(
          orderNo: orderFixtures.first.orderNo,
          customerName: customerFixtures
              .singleWhere((c) => c.id == orderFixtures.first.customerId)
              .name,
          summary: fixtureOrderSummary(orderFixtures.first.id),
          total: orderFixtures.first.total,
          status: OrderStatus.dibatalkan,
          payStatus: PayStatus.belumBayar,
          compact: true,
        ),
      ],
    ),
  ),
);
