import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_auth_text_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

/// Email label + field of frame `LAURUM · Masuk` (label 8.5/600, field 48).
class AuthEmailFieldSection extends StatelessWidget {
  const AuthEmailFieldSection({
    required this.email,
    required this.busy,
    required this.onEmail,
    this.error,
    super.key,
  });

  final String email;
  final bool busy;
  final String? error;
  final ValueChanged<String> onEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Email', style: AppAuthTextStyles.label.copyWith(color: AppColors.authLabel)),
        const SizedBox(height: 4),
        AppTextField(
          label: 'Email',
          value: email,
          hint: 'nama@email.com',
          dense: true,
          leadingIcon: AppIcons.mail,
          selectAllOnFocus: true,
          enabled: !busy,
          errorText: error,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: onEmail,
        ),
      ],
    );
  }
}
