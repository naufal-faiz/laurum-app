import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/state/customer_detail_data.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/nota_card.dart';

class CustomerOrdersSection extends StatelessWidget {
  const CustomerOrdersSection({required this.data, super.key});
  final CustomerDetailData data;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(title: 'Riwayat order terakhir'),
      if (data.orders.isEmpty) const EmptyState(title: 'Belum ada nota', icon: AppIcons.receipt),
      for (final order in data.orders)
        NotaCard(
          orderNo: order.orderNo,
          customerName: data.summary.customer.name,
          summary: data.history.summary(order),
          total: order.total,
          status: order.status,
          payStatus: data.history.paymentStatus(order),
          paid: data.history.paid(order),
          timeLabel:
              '${Formatters.tanggal(order.enteredAt, ringkas: true)} ${Formatters.jam(order.enteredAt)}',
          onTap: () => context.push('/order/${order.id}'),
        ),
    ],
  );
}
