import 'package:flutter/material.dart';
import 'package:laurum/features/auth/state/account_edit.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';

class AccountEditFieldSection extends StatelessWidget {
  const AccountEditFieldSection({
    required this.field,
    required this.data,
    required this.onChanged,
    super.key,
  });
  final AccountField field;
  final AccountEditView data;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    final phone = field == AccountField.phone;
    final label = phone ? 'No. telp' : 'Nama';
    return LabeledField(
      label: label,
      errorText: data.error,
      helperText: phone ? 'Opsional, tanpa OTP. Gunakan 08xx atau +62.' : null,
      child: AppTextField(
        label: label,
        value: data.value,
        enabled: !data.busy,
        selectAllOnFocus: true,
        keyboardType: phone ? TextInputType.phone : TextInputType.name,
        onChanged: onChanged,
      ),
    );
  }
}
