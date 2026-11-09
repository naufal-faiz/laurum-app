import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_auth_text_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';

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
            style: AppAuthTextStyles.body.copyWith(color: AppColors.authLabel),
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
              style: AppAuthTextStyles.bodyStrong.copyWith(color: AppColors.authPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
