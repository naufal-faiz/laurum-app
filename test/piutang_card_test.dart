import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/organisms/piutang_card.dart';

import '../widgetbook/organisms/piutang_card_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('PiutangCard shows balance, neutral age and independent actions', (tester) async {
    var payments = 0, reminders = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: PiutangCard(
            customerName: 'Mas Rian',
            orderNo: 'A-0128',
            summary: 'Cuci kiloan',
            total: 250000,
            paid: 50000,
            ageLabel: '5 hari lalu',
            onPay: () => payments++,
            onRemind: () => reminders++,
          ),
        ),
      ),
    );
    expect(find.text('Rp200.000'), findsOneWidget);
    expect(find.text('DP Rp50.000'), findsOneWidget);
    final age = tester.widget<AppText>(
      find.ancestor(of: find.text('5 hari lalu'), matching: find.byType(AppText)),
    );
    expect(age.color, AppColors.ink3);
    await tester.tap(find.text('Catat bayar'));
    await tester.tap(find.text('Ingatkan'));
    expect(payments, 1);
    expect(reminders, 1);
  });
  registerOrganismGallery('piutang_card', piutangCardUseCase.builder, height: 1600);
}
