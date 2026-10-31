import 'package:flutter/material.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/shared/widgets/organisms/order_card.dart';

class AntreanOrdersSection extends StatelessWidget {
  const AntreanOrdersSection({
    required this.data,
    required this.orders,
    required this.pending,
    required this.useOrderStatus,
    required this.onOpen,
    required this.onAdvance,
    super.key,
  });
  final AntreanData data;
  final List<Order> orders;
  final Set<String> pending;
  final bool useOrderStatus;
  final ValueChanged<Order> onOpen, onAdvance;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final order in orders)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
          child: OrderCard(
            key: ValueKey(order.id),
            orderNo: order.orderNo,
            customerName: data.customer(order.customerId),
            summary: data.summary(order),
            total: order.total,
            status: order.status,
            statusLabel: orderStatusLabel(order.status, useOrderStatus: useOrderStatus),
            payStatus: data.paymentStatus(order),
            paid: data.paid(order),
            timeLabel: Formatters.jam(order.enteredAt),
            detail: data.detail(order),
            showAction: useOrderStatus,
            onTap: () => onOpen(order),
            onAction: !useOrderStatus || pending.contains(order.id) ? null : () => onAdvance(order),
          ),
        ),
    ],
  );
}
