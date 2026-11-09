import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_svgs.dart';
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
      if (error != null) BannerMessage(message: error!, variant: BannerMessageVariant.error),
      if (busy) AppText(restoring ? 'Memulihkan data...' : 'Memproses permintaan...'),
      AppButton(
        'Lanjutkan dengan Google',
        iconAsset: AppSvgs.google,
        onPressed: busy ? null : onGoogle,
      ),
    ],
  );
}
