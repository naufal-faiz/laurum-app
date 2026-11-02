import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/state/auth_form.dart';
import 'package:laurum/features/auth/state/auth_form_view.dart';
import 'package:laurum/features/auth/widgets/auth_passwords_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

class ChangePasswordSheet extends ConsumerWidget {
  const ChangePasswordSheet({super.key});
  static Future<void> show(BuildContext context) => AppBottomSheet.show<void>(
    context: context,
    title: 'Ganti password',
    child: const ChangePasswordSheet(),
  );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(authFormProvider(AuthFormKind.password));
    final controller = ref.read(authFormProvider(AuthFormKind.password).notifier);
    return SheetScaffold(
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          if (form.error != null)
            BannerMessage(message: form.error!, variant: BannerMessageVariant.error),
          AppButton(
            'Simpan password',
            onPressed: form.busy
                ? null
                : () async {
                    if (await controller.submit() && context.mounted) Navigator.of(context).pop();
                  },
          ),
        ],
      ),
      child: AuthPasswordsSection(
        visible: form.visible,
        busy: form.busy,
        errors: form.errors,
        onPassword: (value) => controller.secret(AuthSecret.password, value),
        onCurrent: (value) => controller.secret(AuthSecret.current, value),
        onConfirmation: (value) => controller.secret(AuthSecret.confirmation, value),
        onToggle: controller.toggleVisible,
      ),
    );
  }
}
