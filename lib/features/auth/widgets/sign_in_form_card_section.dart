import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_shadows.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/features/auth/state/auth_form.dart';
import 'package:laurum/features/auth/state/auth_form_view.dart';
import 'package:laurum/features/auth/widgets/auth_identity_section.dart';
import 'package:laurum/features/auth/widgets/auth_password_inline_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_password_label_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class SignInFormCardSection extends StatelessWidget {
  const SignInFormCardSection({
    required this.form,
    required this.busy,
    required this.onEmail,
    required this.onPassword,
    required this.onTogglePassword,
    required this.onForgotPassword,
    required this.onSignIn,
    required this.onGoogle,
    required this.onSignUp,
    required this.sessionBusy,
    required this.sessionSignedIn,
    super.key,
  });

  final AuthFormView form;
  final bool busy;
  final ValueChanged<String> onEmail;
  final ValueChanged<String> onPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignIn;
  final VoidCallback onGoogle;
  final VoidCallback onSignUp;
  final bool sessionBusy;
  final bool sessionSignedIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.authCard,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          AuthIdentitySection(
            email: form.email,
            busy: busy,
            errors: form.errors,
            onEmail: onEmail,
          ),
          SignInPasswordLabelSection(
            busy: busy,
            onForgot: onForgotPassword,
          ),
          AuthPasswordInlineSection(
            visible: form.visible,
            busy: busy,
            error: form.errors['password'],
            onPassword: onPassword,
            onToggle: onTogglePassword,
          ),
          const SizedBox(height: 4),
          AppButton(
            'Masuk',
            onPressed: busy ? null : onSignIn,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: AppText('atau', textAlign: TextAlign.center),
          ),
          SignInSection(
            busy: busy,
            restoring: sessionSignedIn,
            onGoogle: onGoogle,
          ),
          Center(
            child: Wrap(
              spacing: 4,
              children: [
                Text(
                  'Belum punya akun?',
                  style: AppTextStyles.body.copyWith(color: AppColors.ink3),
                ),
                GestureDetector(
                  onTap: busy ? null : onSignUp,
                  child: Text(
                    'Daftar',
                    style: AppTextStyles.body.copyWith(color: AppColors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
