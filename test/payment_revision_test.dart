import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/checkout_data.dart';
import 'package:laurum/features/transactions/state/payment_quote.dart';
import 'package:laurum/features/transactions/state/transaction_line.dart';
import 'package:laurum/features/transactions/widgets/payment_change_section.dart';
import 'package:laurum/features/transactions/widgets/payment_method_section.dart';
import 'package:laurum/features/transactions/widgets/payment_summary_section.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';

import 'r9_section_host.dart';

void main() {
  testWidgets('change section preserves excess allocation callback', (tester) async {
    var deposit = false;
    await pumpR9Section(
      tester,
      PaymentChangeSection(amount: 5000, saveExcess: false, onExcess: (value) => deposit = value),
    );
    await tester.tap(find.text('Simpan ke tabungan'));
    expect(deposit, isTrue);
    expect(find.text('Rp5.000'), findsOneWidget);
  });
  testWidgets('total banner includes bubble, real weight and discount', (tester) async {
    await pumpR9Section(
      tester,
      PaymentSummarySection(
        customerName: 'Dedi',
        itemCount: 2,
        total: 56000,
        discount: 500,
        term: PayTerm.sekarang,
        onTerm: (_) {},
        lines: [
          DraftLine(serviceFixtures.firstWhere((s) => s.id == 'srv-003'), 3500),
          DraftLine(serviceFixtures.firstWhere((s) => s.id == 'srv-004'), 1000),
        ],
      ),
    );
    expect(find.text('2 layanan · 3,5 kg · diskon Rp500'), findsOneWidget);
    final banner = find.byWidgetPredicate((w) => w is AppCard && w.style == AppCardStyle.primary);
    expect(tester.widget<AppCard>(banner).bubble, isTrue);
    expect(find.descendant(of: banner, matching: find.byType(Positioned)), findsOneWidget);
  });
  testWidgets('methods have descriptions and change has a green wrapper', (tester) async {
    const checkout = CheckoutState(received: 30000);
    await pumpR9Section(
      tester,
      PaymentMethodSection(
        checkout: checkout,
        quote: quotePayment(total: 25000, balance: 0, state: checkout),
        onMethod: (_) {},
        onAmount: () {},
        onExcess: (_) {},
      ),
    );
    for (final description in [
      'Uang diterima langsung',
      'Scan semua e-wallet & bank',
      'BCA · Mandiri · BRI · DLL',
    ]) {
      expect(find.text(description), findsOneWidget);
    }
    final change = find.byWidgetPredicate((w) => w is AppCard && w.style == AppCardStyle.success);
    final box = tester.widget<DecoratedBox>(
      find.descendant(of: change, matching: find.byType(DecoratedBox)).first,
    );
    expect((box.decoration as BoxDecoration).color, AppColors.successTint);
    expect(find.descendant(of: change, matching: find.text('Rp5.000')), findsOneWidget);
  });
}
