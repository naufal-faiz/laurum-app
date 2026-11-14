import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/reports/state/report_range_controller.dart';
import 'package:laurum/features/reports/widgets/report_range_summary_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/organisms/app_range_calendar.dart';
import 'package:laurum/shared/widgets/templates/modal_scaffold.dart';

class ReportRangeSheet extends ConsumerWidget {
  const ReportRangeSheet({super.key});

  static Future<DateTimeRange?> show(
    BuildContext context,
    WidgetRef ref, {
    required DateTime firstDate,
    required DateTime lastDate,
    required DateTime start,
    required DateTime end,
  }) {
    ref
        .read(reportRangeDraftProvider.notifier)
        .begin(firstDate: firstDate, lastDate: lastDate, start: start, end: end);
    return ModalScaffold.show<DateTimeRange>(context: context, child: const ReportRangeSheet());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(reportRangeDraftProvider)!;
    final controller = ref.read(reportRangeDraftProvider.notifier);
    final buttons = [
      AppButton(
        'Reset',
        size: AppButtonSize.small,
        variant: AppButtonVariant.actionOutline,
        onPressed: controller.reset,
      ),
      AppButton(
        'Terapkan',
        icon: AppIcons.check,
        size: AppButtonSize.small,
        variant: AppButtonVariant.action,
        onPressed: draft.canApply
            ? () => Navigator.of(context).pop(DateTimeRange(start: draft.start!, end: draft.end!))
            : null,
      ),
    ];
    return ModalScaffold(
      title: 'Pilih tanggal',
      subtitle: 'Rentang laporan kustom',
      onClose: () => Navigator.of(context).pop(),
      footer: LayoutBuilder(
        builder: (context, constraints) =>
            constraints.maxWidth < AppSpacing.touchTarget * 5 ||
                MediaQuery.textScalerOf(context).scale(1) > 1.2
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.small,
                children: buttons,
              )
            : Row(
                spacing: AppSpacing.small,
                children: [for (final button in buttons) Expanded(child: button)],
              ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.medium,
        children: [
          ReportRangeSummarySection(start: draft.start, end: draft.end),
          AppRangeCalendar(
            month: draft.month,
            firstDate: draft.firstDate,
            lastDate: draft.lastDate,
            start: draft.start,
            end: draft.end,
            onDay: controller.selectDay,
            onMonth: controller.moveMonth,
          ),
        ],
      ),
    );
  }
}
