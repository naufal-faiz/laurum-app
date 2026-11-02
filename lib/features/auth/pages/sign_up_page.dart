import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/state/auth_form.dart';
import 'package:laurum/features/auth/state/auth_form_view.dart';
import 'package:laurum/features/auth/widgets/auth_identity_section.dart';
import 'package:laurum/features/auth/widgets/auth_passwords_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(authFormProvider(AuthFormKind.signUp));
    final controller = ref.read(authFormProvider(AuthFormKind.signUp).notifier);
    return FormScaffold(
      title: 'Daftar',
      backLabel: 'Kembali ke Masuk',
      onBack: () => context.go('/masuk'),
      summary: form.error == null
          ? null
          : BannerMessage(message: form.error!, variant: BannerMessageVariant.error),
      footer: AppButton(
        'Daftar',
        onPressed: form.busy
            ? null
            : () async {
                if (await controller.submit() && context.mounted) context.go('/cek-email');
              },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          AuthIdentitySection(
            name: form.name,
            email: form.email,
            busy: form.busy,
            errors: form.errors,
            onName: controller.name,
            onEmail: controller.email,
          ),
          AuthPasswordsSection(
            visible: form.visible,
            busy: form.busy,
            errors: form.errors,
            onPassword: (value) => controller.secret(AuthSecret.password, value),
            onConfirmation: (value) => controller.secret(AuthSecret.confirmation, value),
            onToggle: controller.toggleVisible,
          ),
        ],
      ),
    );
  }
}
