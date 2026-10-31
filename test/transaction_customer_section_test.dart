import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/features/transactions/widgets/transaction_customer_section.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

void main() {
  for (final selected in [false, true]) {
    testWidgets('customer section selected=$selected delegates actions', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var chooses = 0;
      var creates = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: TransactionCustomerSection(
                customer: selected ? customerFixtures.first : null,
                balance: 0,
                onChoose: () => chooses++,
                onCreate: () => creates++,
              ),
            ),
          ),
        ),
      );
      if (selected) {
        expect(find.text('Baru'), findsNothing);
        expect(find.text('Pilih pelanggan'), findsNothing);
        await tester.tap(find.byType(MenuRow));
      } else {
        expect(
          tester.getTopLeft(find.text('Baru')).dx,
          greaterThan(tester.getTopLeft(find.text('Pilih pelanggan')).dx),
        );
        await tester.tap(find.text('Baru'));
        expect(creates, 1);
        await tester.tap(find.text('Pilih pelanggan'));
      }
      expect(chooses, 1);
      expect(tester.takeException(), isNull);
    });
  }
}
