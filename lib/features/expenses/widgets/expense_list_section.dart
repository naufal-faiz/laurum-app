import 'package:flutter/material.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/expenses/state/expense_directory.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/date_group_header.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/expense_row.dart';

class ExpenseListSection extends StatelessWidget {
  const ExpenseListSection({
    required this.data,
    required this.filter,
    required this.onFilter,
    required this.onOpen,
    super.key,
  });
  final ExpenseDirectory data;
  final String filter;
  final ValueChanged<String> onFilter;
  final ValueChanged<Expense> onOpen;
  @override
  Widget build(BuildContext context) {
    final rows = data.visible(filter);
    final days = {for (final e in rows) DateTime(e.spentAt.year, e.spentAt.month, e.spentAt.day)};
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        SectionHeader(
          title: 'Pengeluaran',
          subtitle: Formatters.bulan(data.month),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.cardGap,
            children: [
              const AppText('Total pengeluaran bulan ini', variant: AppTextVariant.label),
              AppText(Formatters.rupiah(data.total), variant: AppTextVariant.figure),
              AppText('${data.expenses.length} transaksi'),
              for (final category in data.categories)
                if (data.expenses.any((e) => e.categoryId == category.id))
                  AppText(
                    '${category.name} ${Formatters.rupiah(data.expenses.where((e) => e.categoryId == category.id).fold(0, (s, e) => s + e.amount))}',
                  ),
            ],
          ),
        ),
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
