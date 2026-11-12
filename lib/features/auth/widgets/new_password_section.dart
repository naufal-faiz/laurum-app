import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/state/auth_form_view.dart';
import 'package:laurum/features/auth/widgets/auth_passwords_section.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class NewPasswordSection extends StatelessWidget {
  const NewPasswordSection({
    required this.data,
    required this.onPassword,
    required this.onConfirmation,
    required this.onToggle,
    super.key,
  });
  final AuthFormView data;
  final ValueChanged<String> onPassword, onConfirmation;
  final VoidCallback onToggle;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const AppText('Buat password baru', variant: AppTextVariant.section),
      if (data.done)
        const BannerMessage(message: 'Password berhasil diperbarui')
      else ...[
        const AppText('Masukkan password baru minimal 8 karakter.'),
        AuthPasswordsSection(
          visible: data.visible,
          busy: data.busy,
          passwordLabel: 'Password baru',
          onPassword: onPassword,
          onConfirmation: onConfirmation,
          onToggle: onToggle,
          errors: data.errors,
        ),
        if (data.error != null)
          BannerMessage(message: data.error!, variant: BannerMessageVariant.error),
      ],
    ],
  );
}
