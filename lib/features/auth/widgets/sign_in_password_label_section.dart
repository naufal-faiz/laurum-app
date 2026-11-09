import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_text_styles.dart';

class SignInPasswordLabelSection extends StatelessWidget {
  const SignInPasswordLabelSection({
    required this.busy,
    required this.onForgot,
    super.key,
  });

  final bool busy;
  final VoidCallback onForgot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Password',
            style: AppTextStyles.label.copyWith(color: AppColors.ink3),
          ),
          GestureDetector(
            onTap: busy ? null : onForgot,
            child: Text(
              'Lupa password?',
              style: AppTextStyles.body.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
