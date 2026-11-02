import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/widgets/auth_secret_field_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

class AuthPasswordsSection extends StatelessWidget {
  const AuthPasswordsSection({
    required this.visible,
    required this.busy,
    required this.onPassword,
    required this.onToggle,
    this.onCurrent,
    this.onConfirmation,
    this.errors = const {},
    super.key,
  });
  final bool visible, busy;
  final ValueChanged<String> onPassword;
  final ValueChanged<String>? onCurrent, onConfirmation;
  final VoidCallback onToggle;
  final Map<String, String> errors;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      if (onCurrent != null)
        AuthSecretFieldSection(
          label: 'Password lama',
          visible: visible,
          busy: busy,
          error: errors['current'],
          onChanged: onCurrent!,
        ),
      AuthSecretFieldSection(
        label: onCurrent == null ? 'Password' : 'Password baru',
        visible: visible,
        busy: busy,
        error: errors['password'],
        onChanged: onPassword,
      ),
      if (onConfirmation != null)
        AuthSecretFieldSection(
          label: 'Konfirmasi password',
          visible: visible,
          busy: busy,
          error: errors['confirmation'],
          onChanged: onConfirmation!,
        ),
      AppButton(
        visible ? 'Sembunyikan password' : 'Tampilkan password',
        icon: AppIcons.visible,
        variant: AppButtonVariant.actionOutline,
        onPressed: busy ? null : onToggle,
      ),
    ],
  );
}
