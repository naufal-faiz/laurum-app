import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';

/// "atau" separator of the auth frames: line, label, line.
class AuthOrSection extends StatelessWidget {
  const AuthOrSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(height: 1, thickness: 1, color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smallMedium),
          child: Text('atau', style: AppTextStyles.meta.copyWith(color: AppColors.ink3)),
        ),
        const Expanded(child: Divider(height: 1, thickness: 1, color: AppColors.border)),
      ],
    );
  }
}
