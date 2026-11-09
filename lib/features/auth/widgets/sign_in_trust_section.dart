import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_auth_text_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

/// Static "Data usaha kamu aman & terenkripsi" line of frame `LAURUM · Masuk`.
class SignInTrustSection extends StatelessWidget {
  const SignInTrustSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AppIcon(AppIcons.privacy, size: 12, color: AppColors.authLabel),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            'Data usaha kamu aman & terenkripsi',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppAuthTextStyles.meta.copyWith(color: AppColors.authLabel),
          ),
        ),
      ],
    );
  }
}
