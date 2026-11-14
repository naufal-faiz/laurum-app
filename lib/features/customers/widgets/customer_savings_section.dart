import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/state/customer_detail_data.dart';
import 'package:laurum/features/customers/state/customer_savings_data.dart';
import 'package:laurum/features/customers/widgets/customer_detail_actions_section.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/savings_row.dart';

class CustomerSavingsSection extends StatelessWidget {
  const CustomerSavingsSection({
    required this.data,
    required this.onDeposit,
    required this.onHistory,
    super.key,
  });
  final CustomerDetailData data;
  final VoidCallback onDeposit, onHistory;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      CustomerDetailActionsSection(
        primaryLabel: 'Setor tabungan',
        secondaryLabel: 'Lihat riwayat mutasi',
        primaryIcon: AppIcons.add,
        secondaryIcon: AppIcons.time,
        onPrimary: data.summary.customer.isActive ? onDeposit : null,
        onSecondary: onHistory,
      ),
      SectionHeader(
        title: 'Riwayat mutasi terkini',
        subtitle: '3 terakhir',
        actionLabel: 'Lihat semua',
        onAction: onHistory,
      ),
      if (data.movements.isEmpty)
        const EmptyState(title: 'Belum ada mutasi tabungan', icon: AppIcons.wallet),
      for (final row in data.movements)
        SavingsRow(
          compact: true,
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
