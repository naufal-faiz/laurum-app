import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
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
    this.compact = false,
    this.accuracyLabel,
  });
  final String customerName, summary, timeLabel, reviewText;
  final String? accuracyLabel;
  final bool needsReview, compact;
  final VoidCallback? onApprove, onReject;
  @override
  Widget build(BuildContext context) => AppCard(
    rail: needsReview ? (compact ? AppCardRail.info : AppCardRail.warning) : AppCardRail.none,
    padding: EdgeInsets.all(compact ? AppSpacing.medium : AppSpacing.cardPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: compact ? AppSpacing.xxsmall : AppMoleculeTokens.gap,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: AppMoleculeTokens.gap,
          children: [
            Wrap(
              spacing: compact ? AppSpacing.xxsmall : AppMoleculeTokens.gap,
              children: [
                if (compact) const AppIcon(AppIcons.chat, size: 16, color: AppColors.illustration),
                AppText(
                  compact ? 'WhatsApp' : 'Dari WhatsApp',
                  variant: AppTextVariant.caption,
                  color: AppColors.ink3,
                ),
                if (timeLabel.isNotEmpty)
                  AppText(timeLabel, variant: AppTextVariant.monoLabel, color: AppColors.ink3),
              ],
            ),
            if (accuracyLabel != null) AppBadge(accuracyLabel!, variant: AppBadgeVariant.siap),
          ],
        ),
        AppText(
          customerName,
          variant: compact ? AppTextVariant.label : AppTextVariant.section,
        ),
        if (compact)
          AppCard(
            style: AppCardStyle.muted,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: AppSpacing.xxsmall,
            ),
            child: AppText(
              summary,
              variant: AppTextVariant.caption,
              color: AppColors.ink2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        else
          AppText(summary, color: AppColors.ink2),
        if (needsReview && reviewText.isNotEmpty) CalloutAi(message: reviewText),
        Row(
          spacing: AppMoleculeTokens.gap,
          children: [
            Expanded(
              child: AppButton(
                'Tolak',
                variant: compact
                    ? AppButtonVariant.actionOutline
                    : AppButtonVariant.destructiveOutline,
                size: compact ? AppButtonSize.small : null,
                onPressed: onReject,
              ),
            ),
            Expanded(
              child: AppButton(
                needsReview ? 'Periksa' : 'Setujui',
                variant: AppButtonVariant.action,
                size: compact ? AppButtonSize.small : null,
                onPressed: onApprove,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
