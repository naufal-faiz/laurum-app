import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/inline_link.dart';

/// Password row of the auth frames: label (+ optional "Lupa password?") over a
/// field with lock icon and an eye toggle. The eye icon changes state:
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
    final labelStyle = AppTextStyles.label.copyWith(color: AppColors.ink3);
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
                child: InlineLink('Lupa password?', onTap: busy ? null : onForgot),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xsmall),
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
            padding: const EdgeInsets.only(right: AppSpacing.smallMedium),
            child: AppIconButton(
              variant: AppIconButtonVariant.compact,
              icon: visible ? AppIcons.visibleOff : AppIcons.visible,
              label: visible ? 'Sembunyikan password' : 'Tampilkan password',
              color: AppColors.primaryInk,
              onPressed: busy ? null : onToggle,
            ),
          ),
        ),
      ],
    );
  }
}
