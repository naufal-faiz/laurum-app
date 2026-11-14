import 'package:flutter/material.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/state/customer_detail_data.dart';
import 'package:laurum/features/orders/state/payment_label.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/nota_card.dart';

class CustomerOrdersSection extends StatelessWidget {
  const CustomerOrdersSection({
    required this.data,
    required this.onOpen,
    required this.showAll,
    required this.onShowAll,
    super.key,
  });
  final CustomerDetailData data;
  final ValueChanged<Order> onOpen;
  final bool showAll;
  final VoidCallback onShowAll;
  @override
  Widget build(BuildContext context) {
    final all = data.history.orders
        .where((o) => o.customerId == data.summary.customer.id && o.deletedAt == null)
        .toList();
    final orders = showAll ? all : data.orders;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        SectionHeader(
          title: 'Riwayat order terakhir',
          actionLabel: !showAll && all.length > orders.length ? 'Lihat semua' : null,
          onAction: !showAll && all.length > orders.length ? onShowAll : null,
        ),
        if (orders.isEmpty) const EmptyState(title: 'Belum ada nota', icon: AppIcons.receipt),
        for (final order in orders)
          NotaCard(
            compact: true,
            orderNo: order.orderNo,
            customerName: data.summary.customer.name,
            summary: data.history.summary(order),
            total: order.total,
            status: order.status,
            payStatus: data.history.paymentStatus(order),
            paymentLabel: paymentLabel(order, data.history.paid(order)),
            paid: data.history.paid(order),
            timeLabel:
                '${Formatters.tanggal(order.enteredAt, ringkas: true)} ${Formatters.jam(order.enteredAt)}',
            onTap: () => onOpen(order),
          ),
      ],
    );
  }
}
