import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_text_styles.dart';

/// "Belum punya akun? Daftar" of frame `LAURUM · Masuk`.
class SignInSignupLinkSection extends StatelessWidget {
  const SignInSignupLinkSection({required this.busy, required this.onSignUp, super.key});

  final bool busy;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            'Belum punya akun?',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.ink3),
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: GestureDetector(
            onTap: busy ? null : onSignUp,
            child: Text(
              'Daftar',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label.copyWith(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
