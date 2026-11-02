import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class CheckEmailPage extends ConsumerWidget {
  const CheckEmailPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    return FormScaffold(
      title: 'Cek email Anda',
      backLabel: 'Kembali ke Masuk',
      onBack: () => context.go('/masuk'),
      footer: AppButton(
        'Lanjut',
        onPressed: session.busy
            ? null
            : () => ref.read(authSessionProvider.notifier).confirmEmail(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          const AppText('Cek email Anda', variant: AppTextVariant.section),
          const AppText('Periksa kotak masuk dan folder spam untuk melanjutkan pendaftaran.'),
          if (session.error != null)
            BannerMessage(message: session.error!, variant: BannerMessageVariant.error),
          AppButton(
            'Kembali ke Masuk',
            variant: AppButtonVariant.actionOutline,
            onPressed: session.busy ? null : () => context.go('/masuk'),
          ),
        ],
      ),
    );
  }
}
