import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_text_styles.dart';

/// "Sudah punya akun? Masuk" of frame `LAURUM · Daftar`.
class SignUpSignInLinkSection extends StatelessWidget {
  const SignUpSignInLinkSection({required this.busy, required this.onSignIn, super.key});

  final bool busy;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            'Sudah punya akun?',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.ink3),
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: GestureDetector(
            onTap: busy ? null : onSignIn,
            child: Text(
              'Masuk',
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
