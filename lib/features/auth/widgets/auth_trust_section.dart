import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

/// Static "data aman & terenkripsi" line of the auth frames.
class AuthTrustSection extends StatelessWidget {
  const AuthTrustSection({this.text = 'Data usaha kamu aman & terenkripsi', super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
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
}
