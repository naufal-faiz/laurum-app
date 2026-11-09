import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_auth_text_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

/// Password row of the auth frames: label (+ optional "Lupa password?") over a
/// field with lock icon and a plain eye toggle. The eye icon changes state:
/// eye = tersembunyi (ketuk untuk lihat), eye-off = terlihat (ketuk sembunyikan).
class AuthPasswordFieldSection extends StatelessWidget {
  const AuthPasswordFieldSection({
    required this.visible,
    required this.busy,
    required this.onPassword,
    required this.onToggle,
    this.onForgot,
    this.label = 'Password',
    this.hint,
    this.error,
    super.key,
  });

  final bool visible, busy;
  final String label;
  final String? hint, error;
  final ValueChanged<String> onPassword;
  final VoidCallback onToggle;
  final VoidCallback? onForgot;

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
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelStyle,
              ),
            ),
            if (onForgot != null)
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
        const SizedBox(height: 6),
        AppTextField(
          label: label,
          dense: true,
          leadingIcon: AppIcons.lock,
          obscureText: !visible,
          enabled: !busy,
          errorText: error,
          hint: hint,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          onChanged: onPassword,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              width: 32,
              height: 32,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: busy ? null : onToggle,
                child: Center(
                  child: AppIcon(
                    visible ? AppIcons.visibleOff : AppIcons.visible,
                    size: 22,
                    color: busy ? AppColors.authLabel : AppColors.authPrimaryInk,
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
