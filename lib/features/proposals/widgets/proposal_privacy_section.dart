import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/notice_ai.dart';

class ProposalPrivacySection extends StatelessWidget {
  const ProposalPrivacySection({super.key});
  @override
  Widget build(BuildContext context) => const AppCard(
    style: AppCardStyle.muted,
    child: Row(
      spacing: AppSpacing.small,
      children: [
        AppIcon(AppIcons.privacy, color: AppColors.primary),
        Expanded(
          child: AppText(NoticeAi.message, variant: AppTextVariant.caption, color: AppColors.ink3),
        ),
      ],
    ),
  );
}
