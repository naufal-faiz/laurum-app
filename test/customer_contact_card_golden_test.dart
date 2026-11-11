import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/customer_contact_card.dart';

import 'test_fonts.dart';

void main() {
  testWidgets('customer contact card golden', (tester) async {
    await loadTestFonts();
    tester.view.physicalSize = const Size(390, 220);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final person = customerFixtures.first;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: RepaintBoundary(
          key: const ValueKey('contact-card'),
          child: Scaffold(
            body: CustomerContactCard(
              name: person.name,
              phone: person.phone,
              address: person.address,
              onContact: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(CustomerContactCard)).height, lessThan(180));
    await expectLater(
      find.byKey(const ValueKey('contact-card')),
      matchesGoldenFile('goldens/customer_contact_card.png'),
    );
  });
}
