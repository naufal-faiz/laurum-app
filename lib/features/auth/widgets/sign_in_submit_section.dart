import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_auth_text_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

/// Blue "Masuk" button of frame `LAURUM · Masuk` (50 dp, radius 14, arrow).
class SignInSubmitSection extends StatelessWidget {
  const SignInSubmitSection({required this.busy, required this.onSubmit, super.key});

  final bool busy;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final foreground = busy ? AppColors.authLabel : AppColors.onPrimary;
    return SizedBox(
      height: 50,
      child: Material(
        color: busy ? AppColors.chipIdle : AppColors.authPrimary,
        borderRadius: AppRadius.cta,
        child: InkWell(
          borderRadius: AppRadius.cta,
          onTap: busy ? null : onSubmit,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Masuk',
                  style: AppAuthTextStyles.button.copyWith(color: foreground),
                ),
                const SizedBox(width: 8),
                AppIcon(AppIcons.arrowForward, size: 14, color: foreground),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
