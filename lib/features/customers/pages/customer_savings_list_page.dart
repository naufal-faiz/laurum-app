import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/pages/customer_savings_controller.dart';
import 'package:laurum/features/customers/pages/customer_savings_data.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/organisms/savings_row.dart';

class CustomerSavingsListPage extends ConsumerWidget {
  const CustomerSavingsListPage({required this.data, super.key});
  final CustomerSavingsData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = data.summary.customer.id;
    final filter = ref.watch(customerSavingsFilterProvider(id));
    final rows = filterSavings(data.movements, filter);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        ChipBar(
          labels: [
            'Semua (${data.movements.length})',
            'Setoran (${data.deposits})',
            'Terpakai (${data.spendings})',
          ],
          selectedIndex: filter,
          onSelected: ref.read(customerSavingsFilterProvider(id).notifier).select,
        ),
        if (rows.isEmpty)
          const EmptyState(title: 'Tidak ada mutasi pada filter ini', icon: AppIcons.wallet)
        else
          for (final row in rows)
            SavingsRow(
              label: savingsLabel(row.entry, data.orderNumber(row.entry.orderId)),
              timeLabel:
                  '${Formatters.tanggal(row.entry.createdAt, ringkas: true)} ${Formatters.jam(row.entry.createdAt)} WIB',
              kind: row.entry.kind,
              amount: row.entry.amount,
              balance: row.balance,
              methodLabel: savingsMethodLabel(row.entry.method),
              reference: data.orderNumber(row.entry.orderId),
              note: savingsNote(row.entry),
            ),
        const AppText(
          'Riwayat mutasi tidak dapat diubah atau dihapus.',
          variant: AppTextVariant.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
