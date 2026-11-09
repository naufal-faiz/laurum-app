import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_input_styles.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';

class AuthPasswordInlineSection extends StatelessWidget {
  const AuthPasswordInlineSection({
    required this.visible,
    required this.busy,
    required this.onPassword,
    required this.onToggle,
    this.error,
    this.value = '',
    super.key,
  });

  final bool visible, busy;
  final String? error;
  final String value;
  final ValueChanged<String> onPassword;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      label: 'Password',
      errorText: error,
      child: TextField(
        enabled: !busy,
        obscureText: !visible,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.next,
        onChanged: onPassword,
        style: AppTextStyles.input.copyWith(
          color: busy ? AppColors.ink3 : AppColors.ink,
        ),
        cursorColor: AppColors.primary,
        decoration:
            AppInputStyles.decoration(
              hint: 'Minimal 8 karakter',
              error: error,
              enabled: !busy,
            ).copyWith(
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    icon: AppIcon(AppIcons.visible, size: 20),
                    onPressed: busy ? null : onToggle,
                    tooltip: visible ? 'Sembunyikan' : 'Tampilkan',
                  ),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
      ),
    );
  }
}
