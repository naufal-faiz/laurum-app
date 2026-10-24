import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/expenses/data/expense_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/expense_row.dart';
import 'package:widgetbook/widgetbook.dart';

final expenseRowUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      spacing: AppSpacing.cardGap,
      children: [
        for (final expense in expenseFixtures.take(4))
          ExpenseRow(
            category: expenseCategoryFixtures.singleWhere((c) => c.id == expense.categoryId).name,
            note: expense.note,
            amount: expense.amount,
            vendor: expense.vendor,
            timeLabel: Formatters.jam(expense.spentAt),
            onTap: expense.vendor.isEmpty ? null : () {},
          ),
      ],
    ),
  ),
);
