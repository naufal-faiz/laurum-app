import 'package:flutter/material.dart';
import 'package:laurum/core/services/receipt_document_data.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
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
        for (final rows in data.groups) ...[
          const AppDivider(),
          ReceiptRows(rows: rows),
        ],
        const AppDivider(),
        AppCard(
          style: AppCardStyle.muted,
          child: AppText(
            data.status,
            variant: AppTextVariant.label,
            color: data.settled ? AppColors.successInk : AppColors.warningInk,
          ),
        ),
        for (final line in data.footer)
          AppText(line, variant: AppTextVariant.caption, textAlign: TextAlign.center),
      ],
    ),
  );
}
