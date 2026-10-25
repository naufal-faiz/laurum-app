import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/pages/customer_edit_controller.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';

class CustomerEditFormPage extends ConsumerWidget {
  const CustomerEditFormPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customerEditProvider);
    final form = state.form;
    final editor = ref.read(customerEditProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        if (state.error != null)
          BannerMessage(message: state.error!, variant: BannerMessageVariant.error),
        LabeledField(
          label: 'Nama pelanggan',
          errorText: form.nameError,
          child: AppTextField(
            label: 'Nama pelanggan',
            value: form.name,
            enabled: !state.busy,
            onChanged: editor.setName,
          ),
        ),
        LabeledField(
          label: 'Nomor WhatsApp',
          errorText: form.phoneError,
          child: AppTextField(
            label: 'Nomor WhatsApp',
            value: form.phone,
            enabled: !state.busy,
            keyboardType: TextInputType.phone,
            onChanged: editor.setPhone,
          ),
        ),
        LabeledField(
          label: 'Alamat (opsional)',
          child: AppTextField(
            label: 'Alamat',
            value: form.address,
            enabled: !state.busy,
            maxLines: 2,
            onChanged: editor.setAddress,
          ),
        ),
        LabeledField(
          label: 'Catatan (opsional)',
          child: AppTextField(
            label: 'Catatan',
            value: form.notes,
            enabled: !state.busy,
            onChanged: editor.setNotes,
          ),
        ),
      ],
    );
  }
}
