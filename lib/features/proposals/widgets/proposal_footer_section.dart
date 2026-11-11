import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/state/proposal_history.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ProposalFooterSection extends StatelessWidget {
  const ProposalFooterSection({
    required this.review,
    required this.draft,
    required this.enabled,
    required this.onReject,
    required this.onApprove,
    required this.onOpen,
    super.key,
  });
  final ProposalReview review;
  final ProposalDraft draft;
  final bool enabled;
  final VoidCallback onReject, onApprove, onOpen;
  @override
  Widget build(BuildContext context) => review.proposal.status == ProposalStatus.menunggu
      ? IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.cardGap,
            children: [
              Expanded(
                child: AppButton(
                  'Tolak',
                  variant: AppButtonVariant.destructiveOutline,
                  onPressed: enabled ? onReject : null,
                ),
              ),
              Expanded(
                child: AppButton(
                  review.proposal.cancelRequested ? 'Batalkan order' : 'Setujui jadi order',
                  onPressed: enabled && review.canApprove(draft) ? onApprove : null,
                ),
              ),
            ],
          ),
        )
      : review.proposal.orderId == null
      ? AppText(proposalStatusLabel(review.proposal.status))
      : AppButton('Buka order', onPressed: onOpen);
}
