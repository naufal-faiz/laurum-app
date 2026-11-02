import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/reports/state/outstanding_data.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/piutang_card.dart';

class OutstandingListSection extends StatelessWidget {
  const OutstandingListSection({
    required this.data,
    required this.filter,
    required this.now,
    required this.onFilter,
    required this.onPay,
    super.key,
  });
  final OutstandingListData data;
  final int filter;
  final DateTime now;
  final ValueChanged<int> onFilter;
  final ValueChanged<OutstandingRow> onPay;
  @override
  Widget build(BuildContext context) {
    final visible = filterOutstanding(data.rows, filter);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        SectionHeader(
          title: 'Piutang',
          subtitle:
              'Total piutang usaha ${Formatters.rupiah(data.totalOutstanding)} / ${data.rows.length} nota belum lunas - ${data.customerCount} pelanggan',
        ),
        ChipBar(
          labels: [
            'Semua ${data.rows.length}',
            'COD ${data.codCount}',
            'Sebagian ${data.rows.length - data.codCount}',
          ],
          selectedIndex: filter,
          onSelected: onFilter,
        ),
        if (visible.isEmpty)
          const EmptyState(
            title: 'Tidak ada piutang',
            icon: AppIcons.wallet,
            description: 'Semua nota sudah lunas.',
          )
        else
          for (final row in visible)
            PiutangCard(
              orderNo: row.order.orderNo,
              customerName: row.customer.name,
              summary: 'Total tagihan',
              total: row.order.total,
              paid: row.paid,
              paymentLabel: row.statusLabel,
              dateLabel: Formatters.tanggal(row.order.createdAt, ringkas: true),
              ageLabel: now.difference(row.order.createdAt).inDays == 0
                  ? 'hari ini'
                  : '${now.difference(row.order.createdAt).inDays} hari lalu',
              onPay: () => onPay(row),
            ),
        const AppText(
          'Piutang tidak dapat dihapus; catat pembayaran untuk mengurangi sisa tagihan.',
          variant: AppTextVariant.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
