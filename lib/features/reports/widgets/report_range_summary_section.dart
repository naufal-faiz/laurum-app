import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ReportRangeSummarySection extends StatelessWidget {
  const ReportRangeSummarySection({this.start, this.end, super.key});
  final DateTime? start, end;
  @override
  Widget build(BuildContext context) {
    final boxes = [
      for (final (label, date) in [('Dari', start), ('Ke', end)])
        AppCard(
          style: AppCardStyle.muted,
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xxsmall,
            children: [
              AppText(label, variant: AppTextVariant.caption, color: AppColors.ink3),
              AppText(
                date == null ? '—' : Formatters.tanggalStruk(date),
                variant: AppTextVariant.label,
                color: AppColors.primaryInk,
              ),
            ],
          ),
        ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth < AppSpacing.touchTarget * 6 ||
              MediaQuery.textScalerOf(context).scale(1) > 1.2
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.small,
              children: boxes,
            )
          : Row(
              spacing: AppSpacing.small,
              children: [for (final box in boxes) Expanded(child: box)],
            ),
    );
  }
}
