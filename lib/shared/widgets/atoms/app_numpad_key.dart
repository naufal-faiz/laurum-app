import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_input_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

enum AppNumpadKeyValue {
  zero('0'),
  one('1'),
  two('2'),
  three('3'),
  four('4'),
  five('5'),
  six('6'),
  seven('7'),
  eight('8'),
  nine('9'),
  tripleZero('000'),
  decimal(','),
  backspace('');

  const AppNumpadKeyValue(this.label);
  final String label;
}

class AppNumpadKey extends StatelessWidget {
  const AppNumpadKey(this.value, {super.key, this.onPressed, this.semanticLabel})
    : assert(value != AppNumpadKeyValue.backspace || semanticLabel != null);
  final AppNumpadKeyValue value;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel ?? value.label,
    button: true,
    enabled: onPressed != null,
    onTap: onPressed,
    child: ExcludeSemantics(
      child: TextButton(
        onPressed: onPressed,
        style: AppInputStyles.numpad,
        child: value == AppNumpadKeyValue.backspace
            ? AppIcon(AppIcons.backspace, color: onPressed == null ? AppColors.ink3 : AppColors.ink)
            : AppText(
                value.label,
                variant: AppTextVariant.numpad,
                color: onPressed == null ? AppColors.ink3 : AppColors.ink,
              ),
      ),
    ),
  );
}
