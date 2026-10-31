import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/features/expenses/state/expense_category_controller.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

class ExpenseCategorySheet extends ConsumerWidget {
  const ExpenseCategorySheet({super.key});
  static Future<void> show(BuildContext context, WidgetRef ref) {
    ref.invalidate(expenseCategoryProvider);
    return AppBottomSheet.show<void>(
      context: context,
      title: 'Kategori baru',
      child: const ExpenseCategorySheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(expenseCategoryProvider);
    final actions = ref.read(expenseCategoryProvider.notifier);
    return SheetScaffold(
      footer: AppButton(
        'Simpan kategori',
        onPressed: draft.busy
            ? null
            : () async {
                if (await actions.save() && context.mounted) Navigator.of(context).pop();
              },
      ),
      child: LabeledField(
        label: 'Nama kategori',
        child: AppTextField(
          label: 'Nama kategori',
          value: draft.name,
          errorText: draft.error,
          enabled: !draft.busy,
          onChanged: actions.name,
        ),
      ),
    );
  }
}
