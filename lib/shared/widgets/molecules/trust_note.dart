import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

/// Centred privacy icon + security note (display only).
class TrustNote extends StatelessWidget {
  const TrustNote({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const AppIcon(AppIcons.privacy, size: 14, color: AppColors.ink3),
      const SizedBox(width: AppSpacing.xsmall),
      Flexible(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.meta.copyWith(color: AppColors.ink3),
        ),
      ),
    ],
  );
}
