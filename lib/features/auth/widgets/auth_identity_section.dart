import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';

class AuthIdentitySection extends StatelessWidget {
  const AuthIdentitySection({
    required this.email,
    required this.busy,
    required this.onEmail,
    this.name,
    this.onName,
    this.errors = const {},
    super.key,
  });
  final String email;
  final String? name;
  final bool busy;
  final ValueChanged<String> onEmail;
  final ValueChanged<String>? onName;
  final Map<String, String> errors;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      if (name != null)
        LabeledField(
          label: 'Nama',
          errorText: errors['name'],
          child: AppTextField(
            label: 'Nama',
            value: name!,
            selectAllOnFocus: true,
            enabled: !busy,
            textInputAction: TextInputAction.next,
            onChanged: onName,
          ),
        ),
      LabeledField(
        label: 'Email',
        errorText: errors['email'],
        child: AppTextField(
          label: 'Email',
          value: email,
          selectAllOnFocus: true,
          enabled: !busy,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: onEmail,
        ),
      ),
    ],
  );
}
