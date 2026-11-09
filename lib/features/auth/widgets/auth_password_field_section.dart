import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_auth_text_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

/// Password row of frame `LAURUM · Masuk`: label + "Lupa password?" over a
/// 48 dp field with lock icon and an in-field 28x28 eye button.
class AuthPasswordFieldSection extends StatelessWidget {
  const AuthPasswordFieldSection({
    required this.visible,
    required this.busy,
    required this.onPassword,
    required this.onToggle,
    required this.onForgot,
    this.error,
    super.key,
  });

  final bool visible, busy;
  final String? error;
  final ValueChanged<String> onPassword;
  final VoidCallback onToggle, onForgot;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppAuthTextStyles.label.copyWith(color: AppColors.authLabel);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Password',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelStyle,
              ),
            ),
            Flexible(
              child: GestureDetector(
                onTap: busy ? null : onForgot,
                child: Text(
                  'Lupa password?',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppAuthTextStyles.label.copyWith(color: AppColors.authPrimary),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        AppTextField(
          label: 'Password',
          dense: true,
          leadingIcon: AppIcons.lock,
          obscureText: !visible,
          enabled: !busy,
          errorText: error,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          onChanged: onPassword,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              width: 28,
              height: 28,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.authChipBg,
                  borderRadius: AppRadius.authEye,
                ),
                child: InkWell(
                  borderRadius: AppRadius.authEye,
                  onTap: busy ? null : onToggle,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.authEye,
                      border: Border.all(color: AppColors.authEyeBorder),
                    ),
                    child: Center(
                      child: AppIcon(
                        AppIcons.visible,
                        size: 15,
                        color: busy ? AppColors.authLabel : AppColors.authPrimaryInk,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
