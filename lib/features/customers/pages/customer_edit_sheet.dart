import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/state/customer_edit_controller.dart';
import 'package:laurum/features/customers/widgets/customer_edit_form_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

class CustomerEditSheet extends ConsumerWidget {
  const CustomerEditSheet({super.key});
  static Future<void> show(BuildContext context, WidgetRef ref, Customer customer) async {
    ref.read(customerEditProvider.notifier).start(customer);
    await AppBottomSheet.show<void>(
      context: Navigator.of(context, rootNavigator: true).context,
      title: 'Edit pelanggan',
      child: const CustomerEditSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(customerEditProvider).busy;
    return SizedBox(
      height: 500,
      child: SheetScaffold(
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [
            AppButton(
              'Simpan perubahan',
              onPressed: busy
                  ? null
                  : () async {
                      if (await ref.read(customerEditProvider.notifier).save() && context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
            ),
            AppButton(
              'Nonaktifkan pelanggan',
              variant: AppButtonVariant.destructiveOutline,
              onPressed: busy ? null : () => _deactivate(context, ref),
            ),
          ],
        ),
        child: const CustomerEditFormSection(),
      ),
    );
  }

  Future<void> _deactivate(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmModal.show(
      context: context,
      title: 'Nonaktifkan pelanggan?',
      message: 'Pelanggan tidak lagi muncul di daftar aktif. Riwayat nota, piutang, dan tabungan tetap tersimpan.',
      confirmLabel: 'Ya, nonaktifkan',
      destructive: true,
    );
    if (confirmed != true || !context.mounted) return;
    if (await ref.read(customerEditProvider.notifier).deactivate() && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
