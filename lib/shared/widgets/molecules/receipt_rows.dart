import 'package:flutter/material.dart';
import 'package:laurum/core/services/receipt_document_data.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ReceiptRows extends StatelessWidget {
  const ReceiptRows({required this.rows, super.key});
  final List<ReceiptDocumentRow> rows;
  @override
  Widget build(BuildContext context) => Column(
    spacing: AppSpacing.small,
    children: [
      for (final row in rows)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.small,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    row.label,
                    variant: row.emphasis ? AppTextVariant.bodyStrong : AppTextVariant.caption,
                    color: row.emphasis ? AppColors.primaryInk : AppColors.ink2,
                  ),
                  if (row.detail != null)
                    AppText(row.detail!, variant: AppTextVariant.caption, color: AppColors.ink3),
                ],
              ),
            ),
            Expanded(
              child: AppText(
                row.value,
                variant: row.emphasis ? AppTextVariant.bodyStrong : AppTextVariant.caption,
                color: row.emphasis ? AppColors.primaryInk : AppColors.ink,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
    ],
  );
}
