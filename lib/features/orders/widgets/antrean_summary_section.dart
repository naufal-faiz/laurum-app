import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';

class AntreanSummarySection extends StatelessWidget {
  const AntreanSummarySection({
    required this.total,
    required this.reviewCount,
    required this.syncState,
    super.key,
  });
  final int total, reviewCount;
  final SyncState syncState;
  @override
  Widget build(BuildContext context) {
    final counts = Wrap(
      spacing: AppSpacing.xxsmall,
      children: [
        AppText('$total order aktif', variant: AppTextVariant.caption, color: AppColors.ink3),
        AppText(
          '· $reviewCount perlu dicek',
          variant: AppTextVariant.caption,
          color: AppColors.ink3,
        ),
      ],
    );
    final indicator = SyncIndicator(state: syncState);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
      ),
      child: MediaQuery.textScalerOf(context).scale(1) > 1.3
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.small,
              children: [counts, indicator],
            )
          : Row(
              spacing: AppSpacing.small,
              children: [
                Expanded(child: counts),
                indicator,
              ],
            ),
    );
  }
}
