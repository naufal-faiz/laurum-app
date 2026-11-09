import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

/// Blue circle + white shirt outline of frame `LAURUM · Masuk` (118x118).
class SignInIllustrationSection extends StatelessWidget {
  const SignInIllustrationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.authIllustration,
        borderRadius: AppRadius.chip,
      ),
      child: SizedBox(
        width: 118,
        height: 118,
        child: Center(
          child: AppIcon(AppIcons.service, size: 44, color: AppColors.surface),
        ),
      ),
    );
  }
}
