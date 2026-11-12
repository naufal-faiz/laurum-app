import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/receipt_document_data.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/receipt_rows.dart';

class ReceiptDocument extends StatelessWidget {
  const ReceiptDocument({required this.data, super.key});
  final ReceiptDocumentData data;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.medium,
      children: [
        Column(
          spacing: AppSpacing.xxsmall,
          children: [
            AppText(
              data.title,
              variant: AppTextVariant.section,
              color: AppColors.primaryInk,
              textAlign: TextAlign.center,
            ),
            for (final line in data.header)
              AppText(
                line,
                variant: AppTextVariant.caption,
                color: AppColors.ink3,
                textAlign: TextAlign.center,
              ),
          ],
        ),
        for (final rows in data.groups) ...[
          const AppDivider(),
          ReceiptRows(rows: rows),
        ],
        const AppDivider(),
        AppCard(
          style: data.settled ? AppCardStyle.success : AppCardStyle.muted,
          padding: const EdgeInsets.all(AppSpacing.small),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: AppSpacing.small,
            children: [
              if (data.settled)
                const AppIcon(AppIcons.check, size: AppSpacing.large, color: AppColors.successInk),
              Expanded(
                child: AppText(
                  data.status,
                  variant: AppTextVariant.label,
                  color: data.settled ? AppColors.successInk : AppColors.warningInk,
                ),
              ),
              Flexible(
                child: AppText(
                  data.statusDetail,
                  variant: AppTextVariant.label,
                  color: data.settled ? AppColors.successInk : AppColors.warningInk,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        Column(
          spacing: AppSpacing.xxsmall,
          children: [
            for (final line in data.footer)
              AppText(
                line,
                variant: line == data.footerTitle ? AppTextVariant.label : AppTextVariant.caption,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ],
    ),
  );
}
