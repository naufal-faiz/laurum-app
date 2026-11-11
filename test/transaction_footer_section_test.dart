import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/widgets/transaction_footer_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'test_fonts.dart';

void main() {
  for (final enabled in [false, true]) {
    testWidgets('transaction footer 320dp 2x enabled=$enabled preserves payment', (tester) async {
      await loadTestFonts();
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var pays = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: TransactionFooterSection(
                total: serviceFixtures.first.price,
                itemCount: 1,
                onPay: enabled ? () => pays++ : null,
              ),
            ),
          ),
        ),
      );
      expect(find.text(Formatters.rupiah(serviceFixtures.first.price)), findsOneWidget);
      expect(find.text('Total tagihan (1 item)'), findsOneWidget);
      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.onPressed != null, enabled);
      if (enabled) await tester.tap(find.text('Bayar'));
      expect(pays, enabled ? 1 : 0);
      expect(tester.takeException(), isNull);
    });
  }
}
