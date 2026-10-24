import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/organisms/customer_row.dart';

import '../widgetbook/organisms/customer_row_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('CustomerRow shows balances and separates contact from opening', (tester) async {
    final c = customerFixtures.first;
    var opened = 0, contacted = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: CustomerRow(
            name: c.name,
            phone: c.phone,
            outstanding: 31500,
            savings: 50000,
            onTap: () => opened++,
            onContact: () => contacted++,
          ),
        ),
      ),
    );
    expect(find.text('Belum bayar Rp31.500'), findsOneWidget);
    expect(find.text('Tabungan Rp50.000'), findsOneWidget);
    await tester.tap(find.byType(AppIconButton));
    expect(contacted, 1);
    expect(opened, 0);
    await tester.tap(find.text(c.name));
    expect(opened, 1);
  });
  registerMoleculeGolden('customer_row', customerRowUseCase.builder);
}
