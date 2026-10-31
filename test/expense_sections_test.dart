import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/expenses/data/expense_fixtures.dart';
import 'package:laurum/features/expenses/state/expense_directory.dart';
import 'package:laurum/features/expenses/state/expense_draft.dart';
import 'package:laurum/features/expenses/widgets/expense_amount_section.dart';
import 'package:laurum/features/expenses/widgets/expense_details_section.dart';
import 'package:laurum/features/expenses/widgets/expense_list_section.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
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
          ),
        ),
      ),
    );
    expect(find.text('Belum ada pengeluaran'), findsOneWidget);
    expect(find.text('Oktober 2026'), findsOneWidget);
    await tester.tap(find.descendant(of: find.byType(ChipBar), matching: find.text('Bahan cuci')));
    expect(selected, 'cat-001');
  });
  testWidgets('ExpenseAmountSection blank amount and keypad callback', (tester) async {
    var digits = '';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ExpenseAmountSection(
            draft: ExpenseDraft(date: DateTime(2026, 10, 16)),
            onNominal: (_) {},
            onKey: (key) => digits = key.label,
          ),
        ),
      ),
    );
    expect(tester.widget<AppTextField>(find.byType(AppTextField)).value, '');
    expect(tester.widget<AppTextField>(find.byType(AppTextField)).hint, '0');
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
}
