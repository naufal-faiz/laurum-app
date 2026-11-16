import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/period_tabs.dart';

class ReportHeaderSection extends StatelessWidget {
  const ReportHeaderSection({
    required this.labels,
    required this.selectedIndex,
    required this.onExport,
    required this.onPeriod,
    super.key,
    this.message,
    this.failed = false,
  });
  final List<String> labels;
  final int selectedIndex;
  final VoidCallback? onExport;
  final ValueChanged<int>? onPeriod;
  final String? message;
  final bool failed;
  @override
  Widget build(BuildContext context) {
    final exportButton = AppButton(
      'Excel',
      icon: AppIcons.download,
      size: AppButtonSize.small,
      variant: AppButtonVariant.actionOutline,
      onPressed: onExport,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow =
            constraints.maxWidth < AppSpacing.touchTarget * 7 ||
            MediaQuery.textScalerOf(context).scale(1) > 1.2;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xlarge,
                vertical: AppSpacing.medium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.cardGap,
                children: [
                  if (narrow) Align(alignment: Alignment.centerRight, child: exportButton),
                  if (message != null)
                    BannerMessage(
                      message: message!,
                      variant: failed ? BannerMessageVariant.error : BannerMessageVariant.info,
                    ),
                  PeriodTabs(labels: labels, selectedIndex: selectedIndex, onSelected: onPeriod),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
