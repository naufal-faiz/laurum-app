import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ExpenseAttachmentSection extends StatelessWidget {
  const ExpenseAttachmentSection({
    required this.photoPath,
    required this.busy,
    required this.onPhoto,
    super.key,
  });
  final String? photoPath;
  final bool busy;
  final VoidCallback onPhoto;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.cardPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.small,
      children: [
        const AppText(
          'Foto struk / nota toko',
          variant: AppTextVariant.label,
          color: AppColors.ink3,
        ),
        Row(
          children: [
            const AppIcon(
              AppIcons.receipt,
              size: AppDimensions.iconSmall,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: AppText(
                photoPath == null ? 'Belum dilampirkan (opsional)' : 'Foto dilampirkan',
                variant: AppTextVariant.caption,
              ),
            ),
            AppButton(
              'Lampirkan',
              variant: AppButtonVariant.actionOutline,
              size: AppButtonSize.small,
              onPressed: busy ? null : onPhoto,
            ),
          ],
        ),
      ],
    ),
  );
}
