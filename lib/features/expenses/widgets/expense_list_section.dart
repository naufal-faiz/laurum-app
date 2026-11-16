import 'package:flutter/material.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/expenses/state/expense_directory.dart';
import 'package:laurum/features/expenses/widgets/expense_report_link_section.dart';
import 'package:laurum/features/expenses/widgets/expense_summary_section.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/date_group_header.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/organisms/expense_row.dart';

class ExpenseListSection extends StatelessWidget {
  const ExpenseListSection({
    required this.data,
    required this.filter,
    required this.onFilter,
    required this.onOpen,
    required this.onOpenReport,
    super.key,
  });
  final ExpenseDirectory data;
  final String filter;
  final ValueChanged<String> onFilter;
  final ValueChanged<Expense> onOpen;
  final VoidCallback onOpenReport;
  @override
  Widget build(BuildContext context) {
    final rows = data.visible(filter);
    final days = {for (final e in rows) DateTime(e.spentAt.year, e.spentAt.month, e.spentAt.day)};
    final breakdown = {
      for (final category in data.categories)
        if (data.expenses.any((e) => e.categoryId == category.id))
          category.name: data.expenses
              .where((e) => e.categoryId == category.id)
              .fold(0, (sum, e) => sum + e.amount),
    };
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        ExpenseSummarySection(
          month: Formatters.bulan(data.month),
          count: data.expenses.length,
          total: data.total,
          breakdown: breakdown,
        ),
        const SizedBox(height: AppSpacing.cardGap),
        ExpenseReportLinkSection(onOpen: onOpenReport),
        const SizedBox(height: AppSpacing.cardGap),
        ChipBar(
          labels: ['Semua', ...data.categories.map((c) => c.name)],
          selectedIndex: [
            '',
            ...data.categories.map((c) => c.id),
          ].indexOf(filter).clamp(0, data.categories.length),
          onSelected: (i) => onFilter(i == 0 ? '' : data.categories[i - 1].id),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        if (rows.isEmpty)
          const EmptyState(
            title: 'Belum ada pengeluaran',
            description: 'Pengeluaran yang dicatat akan tampil di sini.',
            icon: AppIcons.wallet,
          ),
        for (final day in days) ...[
          DateGroupHeader(
            label: Formatters.tanggal(day),
            summary: Formatters.rupiah(
              -rows
                  .where((e) => DateUtils.isSameDay(e.spentAt, day))
                  .fold(0, (s, e) => s + e.amount),
            ),
          ),
          const SizedBox(height: AppSpacing.cardGap),
          for (final e in rows.where((e) => DateUtils.isSameDay(e.spentAt, day)))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
              child: ExpenseRow(
                category: data.category(e.categoryId),
                note: e.note,
                vendor: e.vendor,
                amount: e.amount,
                timeLabel: Formatters.jam(e.spentAt),
                onTap: () => onOpen(e),
              ),
            ),
        ],
      ],
    );
  }
}
