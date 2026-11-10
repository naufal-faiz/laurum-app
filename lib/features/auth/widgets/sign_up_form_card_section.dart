import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/widgets/auth_email_field_section.dart';
import 'package:laurum/features/auth/widgets/auth_name_field_section.dart';
import 'package:laurum/features/auth/widgets/auth_or_section.dart';
import 'package:laurum/features/auth/widgets/auth_password_field_section.dart';
import 'package:laurum/features/auth/widgets/auth_submit_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_section.dart';
import 'package:laurum/features/auth/widgets/sign_up_signin_link_section.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

/// White card of frame `LAURUM · Daftar` (342 wide, radius 24, padding 18,
/// gap 12). Persetujuan Syarat & Ketentuan sengaja belum dibuat (proposal 004).
class SignUpFormCardSection extends StatelessWidget {
  const SignUpFormCardSection({
    required this.name,
    required this.email,
    required this.visible,
    required this.busy,
    required this.restoring,
    required this.onName,
    required this.onEmail,
    required this.onPassword,
    required this.onConfirmation,
    required this.onToggle,
    required this.onSubmit,
    required this.onGoogle,
    required this.onSignIn,
    this.errors = const {},
    this.error,
    super.key,
  });

  final String name, email;
  final bool visible, busy, restoring;
  final String? error;
  final Map<String, String> errors;
  final ValueChanged<String> onName, onEmail, onPassword, onConfirmation;
  final VoidCallback onToggle, onSubmit, onGoogle, onSignIn;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      style: AppCardStyle.elevated,
      padding: const EdgeInsets.all(AppSpacing.largeX),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.medium,
        children: [
          if (error != null) BannerMessage(message: error!, variant: BannerMessageVariant.error),
          AuthNameFieldSection(
            name: name,
            busy: busy,
            error: errors['name'],
            onName: onName,
          ),
          AuthEmailFieldSection(
            email: email,
            busy: busy,
            error: errors['email'],
            onEmail: onEmail,
          ),
          AuthPasswordFieldSection(
            visible: visible,
            busy: busy,
            hint: 'Minimal 8 karakter',
            error: errors['password'],
            onPassword: onPassword,
            onToggle: onToggle,
          ),
          AuthPasswordFieldSection(
            visible: visible,
            busy: busy,
            label: 'Konfirmasi password',
            hint: 'Ulangi password',
            error: errors['confirmation'],
            onPassword: onConfirmation,
            onToggle: onToggle,
          ),
          AuthSubmitSection(
            label: 'Daftar',
            icon: AppIcons.check,
            busy: busy,
            onSubmit: onSubmit,
          ),
          const AuthOrSection(),
          SignInSection(
            busy: busy,
            restoring: restoring,
            onGoogle: onGoogle,
          ),
          SignUpSignInLinkSection(busy: busy, onSignIn: onSignIn),
        ],
      ),
    );
  }
}
