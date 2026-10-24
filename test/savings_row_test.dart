import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/customers/data/savings_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/savings_row.dart';

import '../widgetbook/organisms/savings_row_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('SavingsRow shows withdrawal and balance without editable action', (tester) async {
    final entry = savingsFixtures[1];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SavingsRow(
            label: entry.note,
            timeLabel: '',
            kind: SavingsKind.pakai,
            amount: entry.amount,
            balance: 0,
          ),
        ),
      ),
    );
    expect(find.text('-Rp25.000'), findsOneWidget);
    expect(find.text('Saldo: Rp0'), findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
  });
  registerOrganismGallery('savings_row', savingsRowUseCase.builder);
}
