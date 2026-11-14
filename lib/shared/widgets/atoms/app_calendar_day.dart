import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_calendar_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class AppCalendarDay extends StatelessWidget {
  const AppCalendarDay({
    required this.day,
    required this.onPressed,
    super.key,
    this.selected = false,
    this.inRange = false,
    this.enabled = true,
    this.outside = false,
  });
  final DateTime day;
  final VoidCallback onPressed;
  final bool selected, inRange, enabled, outside;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    child: TextButton(
      onPressed: enabled ? onPressed : null,
      style: AppCalendarStyles.day(selected: selected, inRange: inRange),
      child: AppText(
        Formatters.tanggal(day, ringkas: true).split(' ').first,
        variant: AppTextVariant.label,
        semanticsLabel: Formatters.tanggal(day),
        color: !enabled
            ? AppColors.ink3
            : selected
            ? AppColors.onPrimary
            : outside
            ? AppColors.ink3
            : AppColors.ink,
      ),
    ),
  );
}
