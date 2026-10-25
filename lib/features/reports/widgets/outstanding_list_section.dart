import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/reports/state/outstanding_data.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/piutang_card.dart';

String _ageLabel(DateTime createdAt, DateTime now) {
  final diff = now.difference(createdAt).inDays;
  return diff == 0 ? 'hari ini' : '$diff hari lalu';
}

class OutstandingListSection extends ConsumerWidget {
  const OutstandingListSection({required this.data, super.key});
  final OutstandingListData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(outstandingFilterProvider);
    final visible = filterOutstanding(data.rows, filter);
    final now = ref.watch(businessClockProvider)();
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
            'Belum bayar ${data.unpaidCount}',
            'DP ${data.dpCount}',
          ],
          selectedIndex: filter,
          onSelected: ref.read(outstandingFilterProvider.notifier).select,
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
              summary: 'Sisa ${Formatters.rupiah(row.outstandingAmount)}',
              total: row.order.total,
              paid: row.paid,
              dateLabel: Formatters.tanggal(row.order.createdAt, ringkas: true),
              ageLabel: _ageLabel(row.order.createdAt, now),
              onPay: () {
                // TODO(payment): open sheet Numpad to record payment
              },
              onRemind: () {
                // TODO(whatsapp): open ExternalLauncher WhatsApp
              },
            ),
        const AppText(
          'Piutang tidak dapat dihapus; catat bayar atau tandai lunas di kasir.',
          variant: AppTextVariant.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
