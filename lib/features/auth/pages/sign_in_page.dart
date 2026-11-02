import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/state/auth_form.dart';
import 'package:laurum/features/auth/state/auth_form_view.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/auth/widgets/auth_identity_section.dart';
import 'package:laurum/features/auth/widgets/auth_passwords_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final form = ref.watch(authFormProvider(AuthFormKind.signIn));
    final controller = ref.read(authFormProvider(AuthFormKind.signIn).notifier);
    final busy = form.busy || session.busy;
    final error = form.error ?? session.error;
    return FormScaffold(
      title: 'Masuk',
      backLabel: 'Kembali',
      summary: error == null
          ? null
          : BannerMessage(message: error, variant: BannerMessageVariant.error),
      footer: AppButton('Masuk', onPressed: busy ? null : controller.submit),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          const AppText('Laurum', variant: AppTextVariant.figure),
          const AppText('Kasir laundry untuk usaha rumahan'),
          AuthIdentitySection(
            email: form.email,
            busy: busy,
            errors: form.errors,
            onEmail: controller.email,
          ),
          AuthPasswordsSection(
            visible: form.visible,
            busy: busy,
            errors: form.errors,
            onPassword: (value) => controller.secret(AuthSecret.password, value),
            onToggle: controller.toggleVisible,
          ),
          AppButton(
            'Lupa password?',
            variant: AppButtonVariant.actionOutline,
            onPressed: busy ? null : () => context.go('/lupa-password'),
          ),
          const AppText('atau', textAlign: TextAlign.center),
          SignInSection(
            busy: busy,
            restoring: session.signedIn,
            onGoogle: () {
              controller.clearError();
              ref.read(authSessionProvider.notifier).signIn();
            },
          ),
          AppButton(
            'Belum punya akun? Daftar',
            variant: AppButtonVariant.actionOutline,
            onPressed: busy ? null : () => context.go('/daftar'),
          ),
        ],
      ),
    );
  }
}
