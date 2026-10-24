import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/callout_ai.dart';

class ProposalCard extends StatelessWidget {
  const ProposalCard({
    required this.customerName,
    required this.summary,
    super.key,
    this.timeLabel = '',
    this.needsReview = false,
    this.reviewText = '',
    this.onApprove,
    this.onReject,
  });
  final String customerName, summary, timeLabel, reviewText;
  final bool needsReview;
  final VoidCallback? onApprove, onReject;
  @override
  Widget build(BuildContext context) => AppCard(
    rail: needsReview ? AppCardRail.warning : AppCardRail.none,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppMoleculeTokens.gap,
      children: [
        Wrap(
          spacing: AppMoleculeTokens.gap,
          children: [
            const AppText('Dari WhatsApp', variant: AppTextVariant.caption, color: AppColors.ink3),
            if (timeLabel.isNotEmpty)
              AppText(timeLabel, variant: AppTextVariant.monoLabel, color: AppColors.ink3),
          ],
        ),
        AppText(customerName, variant: AppTextVariant.section),
        AppText(summary, color: AppColors.ink2),
        if (needsReview && reviewText.isNotEmpty) CalloutAi(message: reviewText),
        Row(
          spacing: AppMoleculeTokens.gap,
          children: [
            Expanded(
              child: AppButton(
                'Tolak',
                variant: AppButtonVariant.destructiveOutline,
                onPressed: onReject,
              ),
            ),
            Expanded(
              child: AppButton(
                needsReview ? 'Periksa' : 'Setujui',
                variant: AppButtonVariant.action,
                onPressed: onApprove,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
