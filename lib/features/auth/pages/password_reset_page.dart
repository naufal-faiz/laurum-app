import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/features/auth/state/password_reset.dart';
import 'package:laurum/features/auth/widgets/password_reset_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class PasswordResetPage extends ConsumerWidget {
  const PasswordResetPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(passwordResetProvider);
    final controller = ref.read(passwordResetProvider.notifier);
    return FormScaffold(
      title: 'Lupa password',
      backLabel: 'Kembali ke Masuk',
      onBack: () => context.go('/masuk'),
      footer: AppButton(
        data.remaining > 0 ? 'Kirim ulang (${data.remaining} dtk)' : 'Kirim tautan reset',
        onPressed: data.busy || data.remaining > 0 ? null : controller.submit,
      ),
      body: PasswordResetSection(data: data, onEmail: controller.email),
    );
  }
}
