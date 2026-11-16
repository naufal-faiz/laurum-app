import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/expenses/data/expense_fixtures.dart';
import 'package:laurum/features/expenses/state/expense_directory.dart';
import 'package:laurum/features/expenses/state/expense_draft.dart';
import 'package:laurum/features/expenses/widgets/expense_amount_section.dart';
import 'package:laurum/features/expenses/widgets/expense_attachment_section.dart';
import 'package:laurum/features/expenses/widgets/expense_category_section.dart';
import 'package:laurum/features/expenses/widgets/expense_details_section.dart';
import 'package:laurum/features/expenses/widgets/expense_list_section.dart';
import 'package:laurum/features/expenses/widgets/expense_report_link_section.dart';
import 'package:laurum/features/expenses/widgets/expense_summary_section.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('ExpenseListSection renders empty filter and delegates selection', (tester) async {
    var selected = '';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ExpenseListSection(
            data: ExpenseDirectory(DateTime(2026, 10), expenseCategoryFixtures, []),
            filter: '',
            onFilter: (id) => selected = id,
            onOpen: (_) {},
            onOpenReport: () {},
          ),
        ),
      ),
    );
    expect(find.text('Belum ada pengeluaran'), findsOneWidget);
    expect(find.text('Oktober 2026'), findsOneWidget);
    await tester.tap(find.descendant(of: find.byType(ChipBar), matching: find.text('Bahan cuci')));
    expect(selected, 'cat-001');
  });
  testWidgets('ExpenseSummarySection shows month, total, count and breakdown', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: ExpenseSummarySection(
            month: 'Oktober 2026',
            count: 18,
            total: 1850000,
            breakdown: {'Bahan cuci': 850000},
          ),
        ),
      ),
    );
    expect(find.text('Oktober 2026'), findsOneWidget);
    expect(find.text('Rp1.850.000'), findsOneWidget);
    expect(find.text('18 transaksi'), findsOneWidget);
    expect(find.text('Bahan cuci'), findsOneWidget);
    expect(find.text('Rp850.000'), findsOneWidget);
  });
  testWidgets('ExpenseAmountSection blank amount and keypad callback', (tester) async {
    var digits = '';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ExpenseAmountSection(
            draft: ExpenseDraft(date: DateTime(2026, 10, 16)),
            onKey: (key) => digits = key.label,
          ),
        ),
      ),
    );
    final nominal = tester.widget<AppText>(find.byKey(const ValueKey('expense-nominal')));
    expect(nominal.data, '0');
    expect(find.byType(EditableText), findsNothing);
    await tester.tap(find.text('5'));
    expect(digits, '5');
    expect(find.text('C'), findsNothing);
  });
  testWidgets('ExpenseDetailsSection category, calendar and photo callbacks', (tester) async {
    var category = '';
    var dates = 0;
    var photos = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ExpenseDetailsSection(
              draft: ExpenseDraft(date: DateTime(2026, 10, 16)),
              categories: expenseCategoryFixtures,
              onCategory: (id) => category = id,
              onNewCategory: () {},
              onDate: () => dates++,
              onVendor: (_) {},
              onNote: (_) {},
              onPhoto: () => photos++,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Bahan cuci'));
    expect(category, 'cat-001');
    await tester.tap(find.text('Jumat, 16 Okt 2026'));
    expect(dates, 1);
    await tester.ensureVisible(find.text('Lampirkan'));
    await tester.tap(find.text('Lampirkan'));
    expect(photos, 1);
  });
  testWidgets('ExpenseReportLinkSection delegates the open action', (tester) async {
    var opened = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: ExpenseReportLinkSection(onOpen: () => opened++)),
      ),
    );
    await tester.tap(find.text('Lihat semua pengeluaran di Laporan'));
    expect(opened, 1);
  });
  testWidgets('ExpenseCategorySection selects a chip and opens a new category', (tester) async {
    var category = '';
    var created = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ExpenseCategorySection(
            categories: expenseCategoryFixtures,
            selectedId: 'cat-001',
            busy: false,
            onCategory: (id) => category = id,
            onNewCategory: () => created++,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Listrik & air'));
    expect(category, 'cat-002');
    await tester.tap(find.text('Kategori baru'));
    expect(created, 1);
  });
  testWidgets('ExpenseAttachmentSection shows status and opens the picker', (tester) async {
    var photos = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ExpenseAttachmentSection(
            photoPath: null,
            busy: false,
            onPhoto: () => photos++,
          ),
        ),
      ),
    );
    expect(find.text('Belum dilampirkan (opsional)'), findsOneWidget);
    await tester.tap(find.text('Lampirkan'));
    expect(photos, 1);
  });
}
