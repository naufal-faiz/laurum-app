import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/pages/add_customer_form.dart';
import 'package:laurum/features/transactions/pages/add_customer_form_page.dart';
import 'package:laurum/features/transactions/pages/contact_picker_sheet.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

class AddCustomerSheet extends ConsumerWidget {
  const AddCustomerSheet({super.key});

  static Future<Customer?> show(BuildContext context, WidgetRef ref) {
    ref.read(addCustomerFormProvider.notifier).reset();
    return AppBottomSheet.show<Customer>(
      context: context,
      title: 'Tambah pelanggan cepat',
      subtitle: 'Tersimpan ke kontak usaha. Nota tetap utuh.',
      child: const AddCustomerSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
    height: 500,
    child: SheetScaffold(
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          AppButton(
            'Simpan pelanggan',
            onPressed: () async {
              final customer = await ref.read(addCustomerFormProvider.notifier).save();
              if (customer != null && context.mounted) Navigator.of(context).pop(customer);
            },
          ),
          AppButton(
            'Ambil dari kontak HP',
            variant: AppButtonVariant.secondary,
            onPressed: () => ContactPickerSheet.show(context, ref),
          ),
        ],
      ),
      child: const AddCustomerFormPage(),
    ),
  );
}
