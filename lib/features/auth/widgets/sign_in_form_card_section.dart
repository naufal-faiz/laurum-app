import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_shadows.dart';
import 'package:laurum/features/auth/widgets/auth_email_field_section.dart';
import 'package:laurum/features/auth/widgets/auth_or_section.dart';
import 'package:laurum/features/auth/widgets/auth_password_field_section.dart';
import 'package:laurum/features/auth/widgets/auth_submit_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_signup_link_section.dart';

/// White 342x348 card that overlaps the hero of frame `LAURUM · Masuk`.
class SignInFormCardSection extends StatelessWidget {
  const SignInFormCardSection({
    required this.email,
    required this.visible,
    required this.busy,
    required this.restoring,
    required this.onEmail,
    required this.onPassword,
    required this.onToggle,
    required this.onForgot,
    required this.onSubmit,
    required this.onGoogle,
    required this.onSignUp,
    this.errors = const {},
    this.error,
    super.key,
  });

  final String email;
  final bool visible, busy, restoring;
  final String? error;
  final Map<String, String> errors;
  final ValueChanged<String> onEmail, onPassword;
  final VoidCallback onToggle, onForgot, onSubmit, onGoogle, onSignUp;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.authCard,
        boxShadow: AppShadows.authCard,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthEmailFieldSection(
            email: email,
            busy: busy,
            error: errors['email'],
            onEmail: onEmail,
          ),
          const SizedBox(height: 12),
          AuthPasswordFieldSection(
            visible: visible,
            busy: busy,
            error: errors['password'],
            onPassword: onPassword,
            onToggle: onToggle,
            onForgot: onForgot,
          ),
          const SizedBox(height: 12),
          AuthSubmitSection(busy: busy, onSubmit: onSubmit),
          const SizedBox(height: 12),
          const AuthOrSection(),
          const SizedBox(height: 12),
          SignInSection(
            busy: busy,
            restoring: restoring,
            error: error,
            onGoogle: onGoogle,
          ),
          const SizedBox(height: 12),
          SignInSignupLinkSection(busy: busy, onSignUp: onSignUp),
        ],
      ),
    );
  }
}
