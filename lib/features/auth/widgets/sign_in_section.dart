import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class SignInSection extends StatelessWidget {
  const SignInSection({
    required this.busy,
    required this.restoring,
    required this.onGoogle,
    this.error,
    super.key,
  });
  final bool busy, restoring;
  final String? error;
  final VoidCallback onGoogle;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.screenPadding,
    children: [
      const AppText('Laurum', variant: AppTextVariant.figure),
      const AppText('Kasir laundry untuk usaha rumahan'),
      const AppText('Masuk', variant: AppTextVariant.section),
      if (error != null) BannerMessage(message: error!, variant: BannerMessageVariant.error),
      if (busy) AppText(restoring ? 'Memulihkan data...' : 'Menghubungkan akun Google...'),
      AppButton(
        'Lanjutkan dengan Google',
        icon: AppIcons.person,
        onPressed: busy ? null : onGoogle,
      ),
    ],
  );
}
