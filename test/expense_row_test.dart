import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/expenses/data/expense_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/expense_row.dart';

import '../widgetbook/organisms/expense_row_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('ExpenseRow shows negative amount and opens through callback', (tester) async {
    var calls = 0;
    final e = expenseFixtures.first;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ExpenseRow(
            category: expenseCategoryFixtures.first.name,
            note: e.note,
            amount: e.amount,
            timeLabel: '',
            vendor: e.vendor,
            onTap: () => calls++,
          ),
        ),
      ),
    );
    expect(find.text('-Rp110.000'), findsOneWidget);
    await tester.tap(find.text(e.note));
    expect(calls, 1);
  });
  registerOrganismGallery('expense_row', expenseRowUseCase.builder);
}
