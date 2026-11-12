import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/features/auth/state/auth_form.dart';
import 'package:laurum/features/auth/state/auth_form_view.dart';
import 'package:laurum/features/auth/widgets/new_password_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class NewPasswordPage extends ConsumerWidget {
  const NewPasswordPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(authFormProvider(AuthFormKind.recovery));
    final controller = ref.read(authFormProvider(AuthFormKind.recovery).notifier);
    return FormScaffold(
      title: 'Buat password baru',
      backLabel: 'Kembali ke Masuk',
      onBack: form.busy ? null : () => context.go('/masuk'),
      footer: AppButton(
        form.done ? 'Lanjut' : 'Simpan password',
        onPressed: form.busy
            ? null
            : form.done
            ? () => context.go('/beranda')
            : controller.submit,
      ),
      body: NewPasswordSection(
        data: form,
        onPassword: (value) => controller.secret(AuthSecret.password, value),
        onConfirmation: (value) => controller.secret(AuthSecret.confirmation, value),
        onToggle: controller.toggleVisible,
      ),
    );
  }
}
