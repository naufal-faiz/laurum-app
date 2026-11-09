import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_auth_text_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

/// Blue primary button of the auth frames (50 dp, radius 14, trailing icon).
class AuthSubmitSection extends StatelessWidget {
  const AuthSubmitSection({
    required this.busy,
    required this.onSubmit,
    this.label = 'Masuk',
    this.icon = AppIcons.arrowForward,
    super.key,
  });

  final bool busy;
  final String label;
  final AppIcons icon;
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
                Text(label, style: AppAuthTextStyles.button.copyWith(color: foreground)),
                const SizedBox(width: 8),
                AppIcon(icon, size: 16, color: foreground),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
