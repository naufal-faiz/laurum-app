import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_auth_text_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';

/// "atau" separator of the auth frames: line, label, line.
class AuthOrSection extends StatelessWidget {
  const AuthOrSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(height: 1, thickness: 1, color: AppColors.authDivider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('atau', style: AppAuthTextStyles.meta.copyWith(color: AppColors.authLabel)),
        ),
        const Expanded(child: Divider(height: 1, thickness: 1, color: AppColors.authDivider)),
      ],
    );
  }
}
