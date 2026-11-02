import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/features/auth/state/account_edit.dart';
import 'package:laurum/features/auth/widgets/account_edit_field_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

class AccountEditSheet extends ConsumerWidget {
  const AccountEditSheet({required this.field, super.key});
  final AccountField field;
  static Future<void> show(BuildContext context, AccountField field) => AppBottomSheet.show<void>(
    context: context,
    title: field == AccountField.name ? 'Ubah nama' : 'Ubah no. telp',
    child: AccountEditSheet(field: field),
  );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(accountEditProvider(field));
    final controller = ref.read(accountEditProvider(field).notifier);
    return SheetScaffold(
      footer: AppButton(
        'Simpan profil',
        onPressed: data.busy
            ? null
            : () async {
                if (await controller.save() && context.mounted) Navigator.of(context).pop();
              },
      ),
      child: AccountEditFieldSection(field: field, data: data, onChanged: controller.edit),
    );
  }
}
