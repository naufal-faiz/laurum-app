import 'package:flutter/material.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';

class AuthSecretFieldSection extends StatelessWidget {
  const AuthSecretFieldSection({
    required this.label,
    required this.visible,
    required this.busy,
    required this.onChanged,
    this.error,
    super.key,
  });
  final String label;
  final bool visible, busy;
  final String? error;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => LabeledField(
    label: label,
    errorText: error,
    child: AppTextField(
      label: label,
      obscureText: !visible,
      enabled: !busy,
      onChanged: onChanged,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
    ),
  );
}
