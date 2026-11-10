import 'package:flutter/material.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/proposal_card.dart';

class AntreanProposalsSection extends StatelessWidget {
  const AntreanProposalsSection({
    required this.data,
    required this.proposals,
    required this.pending,
    required this.onSeeAll,
    required this.onOpen,
    required this.onReject,
    this.demoAccuracy = const {},
    super.key,
  });
  final AntreanData data;
  final List<Proposal> proposals;
  final Set<String> pending;
  final Map<String, int> demoAccuracy;
  final VoidCallback onSeeAll;
  final ValueChanged<Proposal> onOpen, onReject;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SectionHeader(
        title: 'Rekomendasi AI',
        titleColor: AppColors.primary,
        icon: AppIcons.sparkles,
        subtitle: 'Usulan dari WhatsApp',
        actionLabel: 'Lihat semua (${data.proposals.length})',
        onAction: onSeeAll,
      ),
      const SizedBox(height: AppSpacing.small),
      for (final proposal in proposals)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
          child: ProposalCard(
            customerName: proposal.customerId == null
                ? proposal.customerName
                : data.customer(proposal.customerId),
            summary: proposal.sourceText,
            timeLabel: Formatters.jam(proposal.createdAt),
            needsReview: true,
            compact: true,
            accuracyLabel: demoAccuracy[proposal.id] == null
                ? null
                : 'AI ${demoAccuracy[proposal.id]}% · contoh',
            onApprove: () => onOpen(proposal),
            onReject: pending.contains(proposal.id) ? null : () => onReject(proposal),
          ),
        ),
    ],
  );
}
