import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/features/transactions/widgets/transaction_customer_section.dart';

import 'test_fonts.dart';

void main() {
  for (final selected in [false, true]) {
    testWidgets('customer section selected=$selected delegates actions', (tester) async {
      await loadTestFonts();
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var chooses = 0;
      var creates = 0;
      var imports = 0;
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
                onImport: () => imports++,
              ),
            ),
          ),
        ),
      );
      if (selected) {
        await tester.tap(find.text('Ganti'));
      } else {
        expect(
          tester.getTopLeft(find.text('Pelanggan baru')).dx,
          greaterThan(tester.getTopLeft(find.text('Impor kontak')).dx),
        );
        await tester.tapAt(
          tester.getTopLeft(find.text('Belum ada pelanggan')) - const Offset(30, 0),
        );
      }
      await tester.tap(find.text('Pelanggan baru'));
      expect(creates, 1);
      await tester.tap(find.text('Impor kontak'));
      expect(imports, 1);
      expect(chooses, 1);
      expect(tester.takeException(), isNull);
    });
  }
}
