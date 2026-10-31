import 'package:flutter/material.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/state/proposal_history.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

class ProposalHistorySection extends StatelessWidget {
  const ProposalHistorySection({
    required this.history,
    required this.filter,
    required this.onFilter,
    required this.onOpen,
    super.key,
  });
  final ProposalHistory history;
  final int filter;
  final ValueChanged<int> onFilter;
  final ValueChanged<Proposal> onOpen;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding)
        .add(const EdgeInsets.only(bottom: AppDimensions.navCreateSize / 2)),
    children: [
      ChipBar(labels: history.chips, selectedIndex: filter, onSelected: onFilter),
      const SizedBox(height: AppSpacing.cardGap),
      BannerMessage(message: history.historicalSummary),
      if (history.visible(filter).isEmpty)
        const EmptyState(
          title: 'Belum ada rincian usulan',
          description: 'Usulan terbaru yang sesuai filter akan tampil di sini.',
          icon: AppIcons.chat,
        ),
      for (final p in history.visible(filter))
        MenuRow(
          label: p.customerName,
          subtitle:
              '${proposalStatusLabel(p.status)} · ${Formatters.jam(p.createdAt)}\n${p.sourceText}',
          icon: AppIcons.chat,
          onTap: () => onOpen(p),
        ),
    ],
  );
}
