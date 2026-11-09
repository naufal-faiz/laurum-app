import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

/// Nama label + field of frame `LAURUM · Daftar`.
class AuthNameFieldSection extends StatelessWidget {
  const AuthNameFieldSection({
    required this.name,
    required this.busy,
    required this.onName,
    this.error,
    super.key,
  });

  final String name;
  final bool busy;
  final String? error;
  final ValueChanged<String> onName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Nama', style: AppTextStyles.label.copyWith(color: AppColors.ink3)),
        const SizedBox(height: AppSpacing.xsmall),
        AppTextField(
          label: 'Nama',
          value: name,
          hint: 'Nama lengkap kamu',
          dense: true,
          leadingIcon: AppIcons.person,
          selectAllOnFocus: true,
          enabled: !busy,
          errorText: error,
          textInputAction: TextInputAction.next,
          onChanged: onName,
        ),
      ],
    );
  }
}
