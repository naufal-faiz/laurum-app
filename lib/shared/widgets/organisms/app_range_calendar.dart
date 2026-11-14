import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_calendar_day.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class AppRangeCalendar extends StatelessWidget {
  const AppRangeCalendar({
    required this.month,
    required this.firstDate,
    required this.lastDate,
    required this.onDay,
    required this.onMonth,
    this.start,
    this.end,
    super.key,
  });
  final DateTime month, firstDate, lastDate;
  final DateTime? start, end;
  final ValueChanged<DateTime> onDay, onMonth;
  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month);
    final gridStart = first.subtract(Duration(days: first.weekday - 1));
    final days = List.generate(42, (index) => gridStart.add(Duration(days: index)));
    final previous = DateTime(month.year, month.month - 1);
    final next = DateTime(month.year, month.month + 1);
    final hasPrevious = previous.compareTo(DateTime(firstDate.year, firstDate.month)) >= 0;
    final hasNext = next.compareTo(DateTime(lastDate.year, lastDate.month)) <= 0;
    final a = start, b = end;
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.small,
      children: [
        Row(
          children: [
            AppIconButton(
              icon: AppIcons.back,
              label: 'Bulan sebelumnya',
              onPressed: hasPrevious ? () => onMonth(previous) : null,
            ),
            Expanded(
              child: AppText(
                Formatters.bulan(first),
                variant: AppTextVariant.section,
                textAlign: TextAlign.center,
              ),
            ),
            AppIconButton(
              icon: AppIcons.next,
              label: 'Bulan berikutnya',
              onPressed: hasNext ? () => onMonth(next) : null,
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final minimum =
                AppSpacing.minTouchTarget * MediaQuery.textScalerOf(context).scale(1).clamp(1, 2);
            final cell = constraints.maxWidth / 7 < minimum ? minimum : constraints.maxWidth / 7;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: cell * 7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        for (final label in const ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'])
                          SizedBox(
                            width: cell,
                            child: AppText(
                              label,
                              variant: AppTextVariant.caption,
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Wrap(
                      children: [
                        for (final day in days)
                          SizedBox(
                            width: cell,
                            height: cell,
                            child: AppCalendarDay(
                              key: ValueKey(day),
                              day: day,
                              selected: day == start || day == end,
                              inRange: a != null && b != null && day.isAfter(a) && day.isBefore(b),
                              enabled: !day.isBefore(firstDate) && !day.isAfter(lastDate),
                              outside: day.month != first.month,
                              onPressed: () => onDay(day),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
