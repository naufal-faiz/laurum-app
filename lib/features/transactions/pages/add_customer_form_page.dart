import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/pages/add_customer_form.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';

class AddCustomerFormPage extends ConsumerWidget {
  const AddCustomerFormPage({super.key, this.forOrder = true});
  final bool forOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(addCustomerFormProvider);
    final notifier = ref.read(addCustomerFormProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.screenPadding,
      children: [
        BannerMessage(
          message: forOrder
              ? 'Pelanggan yang disimpan langsung dipilih untuk nota ini.'
              : 'Pelanggan yang disimpan akan muncul di daftar pelanggan.',
        ),
        LabeledField(
          label: 'Nama pelanggan',
          errorText: form.nameError,
          child: AppTextField(
            label: 'Nama pelanggan',
            hint: 'Nama lengkap',
            value: form.name,
            onChanged: notifier.setName,
          ),
        ),
        LabeledField(
          label: 'Nomor WhatsApp',
          errorText: form.phoneError,
          helperText: 'Format nomor otomatis dinormalkan ke 0...',
          child: AppTextField(
            label: 'Nomor WhatsApp',
            hint: '0812-3456-7890',
            value: form.phone,
            keyboardType: TextInputType.phone,
            onChanged: notifier.setPhone,
          ),
        ),
        if (form.duplicate != null)
          AppButton(
            'Pakai pelanggan ini',
            variant: AppButtonVariant.actionOutline,
            onPressed: () => Navigator.of(context).pop(form.duplicate),
          ),
        LabeledField(
          label: 'Alamat (opsional)',
          child: AppTextField(
            label: 'Alamat',
            hint: 'Alamat penjemputan',
            value: form.address,
            maxLines: 2,
            onChanged: notifier.setAddress,
          ),
        ),
        LabeledField(
          label: 'Catatan (opsional)',
          child: AppTextField(
            label: 'Catatan pelanggan',
            hint: 'Misal: titip satpam, langganan kos',
            value: form.notes,
            onChanged: notifier.setNotes,
          ),
        ),
      ],
    );
  }
}
