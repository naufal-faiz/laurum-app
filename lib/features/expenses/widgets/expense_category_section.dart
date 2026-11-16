import 'package:flutter/material.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ExpenseCategorySection extends StatelessWidget {
  const ExpenseCategorySection({
    required this.categories,
    required this.selectedId,
    required this.busy,
    required this.onCategory,
    required this.onNewCategory,
    super.key,
  });
  final List<ExpenseCategory> categories;
  final String selectedId;
  final bool busy;
  final ValueChanged<String> onCategory;
  final VoidCallback onNewCategory;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.small,
      children: [
        const AppText('Kategori', variant: AppTextVariant.label, color: AppColors.ink3),
        Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          children: [
            for (final category in categories)
              AppChip(
                category.name,
                selected: category.id == selectedId,
                onPressed: busy ? null : () => onCategory(category.id),
              ),
          ],
        ),
        Row(
          children: [
            AppChip('Kategori baru', onPressed: busy ? null : onNewCategory),
          ],
        ),
      ],
    ),
  );
}
