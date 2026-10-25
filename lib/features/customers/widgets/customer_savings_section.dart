import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/pages/customer_detail_data.dart';
import 'package:laurum/features/customers/pages/customer_savings_data.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/molecules/stat_tile.dart';
import 'package:laurum/shared/widgets/organisms/savings_row.dart';

class CustomerSavingsPage extends StatelessWidget {
  const CustomerSavingsPage({required this.data, super.key});
  final CustomerDetailData data;
  @override
  Widget build(BuildContext context) {
    final id = data.summary.customer.id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        StatTile(label: 'Saldo tabungan laundry', value: Formatters.rupiah(data.summary.savings)),
        AppButton(
          'Setor tabungan',
          onPressed: data.summary.customer.isActive
              ? () => context.push('/pelanggan/$id/setor')
              : null,
        ),
        AppButton(
          'Lihat riwayat mutasi',
          variant: AppButtonVariant.actionOutline,
          onPressed: () => context.push('/pelanggan/$id/tabungan'),
        ),
        const SectionHeader(title: 'Riwayat mutasi terkini', subtitle: '3 terakhir'),
        if (data.movements.isEmpty)
          const EmptyState(title: 'Belum ada mutasi tabungan', icon: AppIcons.wallet),
        for (final row in data.movements)
          SavingsRow(
            label: savingsLabel(
              row.entry,
              data.history.orders.where((o) => o.id == row.entry.orderId).firstOrNull?.orderNo,
            ),
            timeLabel:
                '${Formatters.tanggal(row.entry.createdAt, ringkas: true)} ${Formatters.jam(row.entry.createdAt)}',
            kind: row.entry.kind,
            amount: row.entry.amount,
            balance: row.balance,
          ),
      ],
    );
  }
}
