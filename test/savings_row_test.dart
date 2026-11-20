import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/customers/data/savings_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/savings_row.dart';

import '../widgetbook/organisms/savings_row_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('compact movement aligns amounts right and limits the title at font1x and2x', (
    tester,
  ) async {
    const title = 'Judul mutasi yang sangat panjang sampai melebihi dua baris teks';
    for (final scale in [1.0, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: const SizedBox(
                width: 272,
                child: SavingsRow(
                  label: title,
                  timeLabel: '10 Okt 09.10 WIB',
                  kind: SavingsKind.setor,
                  amount: 50000,
                  balance: 50000,
                  compact: true,
                ),
              ),
            ),
          ),
        ),
      );
      final right = tester.getRect(find.byType(SavingsRow)).right - AppSpacing.medium;
      expect(tester.getRect(find.text('+Rp50.000')).right, closeTo(right, 0.1));
      expect(tester.getRect(find.text('Saldo: Rp50.000')).right, closeTo(right, 0.1));
      expect(tester.widget<Text>(find.text(title)).maxLines, 2);
      expect(tester.widget<Text>(find.text(title)).overflow, TextOverflow.ellipsis);
      expect(tester.takeException(), isNull);
    }
  });
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
