import 'package:flutter/material.dart';
import 'package:laurum/features/auth/widgets/auth_email_field_section.dart';
import 'package:laurum/features/auth/widgets/auth_password_field_section.dart';
import 'package:laurum/features/auth/widgets/auth_submit_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_section.dart';
import 'package:laurum/shared/widgets/molecules/inline_link_row.dart';
import 'package:laurum/shared/widgets/molecules/labeled_divider.dart';
import 'package:laurum/shared/widgets/organisms/auth_card.dart';

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
    return AuthCard(
      children: [
        AuthEmailFieldSection(
          email: email,
          busy: busy,
          error: errors['email'],
          onEmail: onEmail,
        ),
        AuthPasswordFieldSection(
          visible: visible,
          busy: busy,
          error: errors['password'],
          onPassword: onPassword,
          onToggle: onToggle,
          onForgot: onForgot,
        ),
        AuthSubmitSection(busy: busy, onSubmit: onSubmit),
        const LabeledDivider('atau'),
        SignInSection(
          busy: busy,
          restoring: restoring,
          error: error,
          onGoogle: onGoogle,
        ),
        InlineLinkRow(
          question: 'Belum punya akun?',
          action: 'Daftar',
          onTap: busy ? null : onSignUp,
        ),
      ],
    );
  }
}
